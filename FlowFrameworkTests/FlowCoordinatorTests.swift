//
//  FlowCoordinatorTests.swift
//  FlowFrameworkTests
//
//  Created by Kelly Morales on 8/13/24.
//

import XCTest

@testable import FlowFramework

final class FlowCoordinatorTests: XCTestCase {

    private var coordinator: FlowCoordinator!

    override func setUpWithError() throws {
        coordinator = FlowCoordinator()
    }

    func testStart() throws {
        coordinator.start(flow: TestFlow.defaultFlow, completion: {})

        XCTAssertEqual(2, coordinator.flow.steps.count)
        XCTAssertEqual(1, coordinator.navigationPath.count)

        let expectedStepIndex = 1
        let expectedStepName = "Step"
        let actualEvent = coordinator.currentStepInfo()
        XCTAssertEqual(expectedStepIndex, actualEvent.0)
        XCTAssertEqual(expectedStepName, actualEvent.1)
    }

    func testNavigateFoward() throws {
        coordinator.start(flow: TestFlow.defaultFlow, completion: {})
        XCTAssertEqual(1, coordinator.currentStepIndex)

        coordinator.navigateForward()
        XCTAssertEqual(2, coordinator.currentStepIndex)

        XCTAssertEqual(2, coordinator.flow.steps.count)
        XCTAssertEqual(2, coordinator.navigationPath.count)

        let expectedStepIndex = 2
        let expectedStepName = "Another Step"
        let actualEvent = coordinator.currentStepInfo()
        XCTAssertEqual(expectedStepIndex, actualEvent.0)
        XCTAssertEqual(expectedStepName, actualEvent.1)
    }

    func testNavigateToEnd() throws {
        coordinator.start(flow: TestFlow.defaultFlow, completion: {})
        XCTAssertEqual(1, coordinator.currentStepIndex)

        coordinator.navigateForward()
        // Nowhere else to navigate to, current step remains the same
        XCTAssertEqual(2, coordinator.currentStepIndex)

        XCTAssertEqual(2, coordinator.flow.steps.count)
        XCTAssertEqual(2, coordinator.navigationPath.count)
    }

    func testNavigateBackward() throws {
        coordinator.start(flow: TestFlow.defaultFlow, completion: {})
        coordinator.navigateForward()
        XCTAssertEqual(2, coordinator.currentStepIndex)

        coordinator.navigateBackward()
        XCTAssertEqual(1, coordinator.currentStepIndex)

        XCTAssertEqual(2, coordinator.flow.steps.count)
        XCTAssertEqual(1, coordinator.navigationPath.count)

        let expectedStepIndex = 1
        let expectedStepName = "Step"
        let actualEvent = coordinator.currentStepInfo()
        XCTAssertEqual(expectedStepIndex, actualEvent.0)
        XCTAssertEqual(expectedStepName, actualEvent.1)
    }

    func testNavigateBackwardOutOfRange() throws {
        coordinator.start(flow: TestFlow.defaultFlow, completion: {})
        XCTAssertEqual(1, coordinator.currentStepIndex)

        coordinator.navigateBackward()
        XCTAssertEqual(1, coordinator.currentStepIndex)

        XCTAssertEqual(2, coordinator.flow.steps.count)
        XCTAssertEqual(1, coordinator.navigationPath.count)
    }

    func testNavigateToDestination() throws {
        coordinator.start(flow: TestFlow.multiTypeFlow, completion: {})
        coordinator.navigateToDestination(TestFlow.otherStep)
        XCTAssertEqual(2, coordinator.currentStepIndex)

        XCTAssertEqual(5, coordinator.flow.steps.count)
        XCTAssertEqual(2, coordinator.navigationPath.count)

        let expectedStepIndex = 2
        let expectedStepName = "Another Step"
        let actualEvent = coordinator.currentStepInfo()
        XCTAssertEqual(expectedStepIndex, actualEvent.0)
        XCTAssertEqual(expectedStepName, actualEvent.1)
    }

    func testNavigateToIndex() throws {
        coordinator.start(flow: TestFlow.multiTypeFlow, completion: {})
        coordinator.navigateToIndex(2)
        XCTAssertEqual(3, coordinator.currentStepIndex)

        XCTAssertEqual(5, coordinator.flow.steps.count)
        XCTAssertEqual(3, coordinator.navigationPath.count)

        let expectedStepIndex = 3
        let expectedStepName = "Step"
        let actualEvent = coordinator.currentStepInfo()
        XCTAssertEqual(expectedStepIndex, actualEvent.0)
        XCTAssertEqual(expectedStepName, actualEvent.1)
    }

    func testUpdateEndOfFlowAndNavigate() throws {
        coordinator.start(flow: TestFlow.multiTypeFlow, completion: {})
        XCTAssertEqual(5, coordinator.flow.steps.count)

        coordinator.updateFlow(with: TestFlow.defaultFlow, atIndex: coordinator.flow.steps.count - 1, animated: true)

        XCTAssertEqual(7, coordinator.flow.steps.count)
        XCTAssertEqual(5, coordinator.navigationPath.count)
        XCTAssertEqual(5, coordinator.currentStepIndex)
    }

    func testUpdateEndOfFlowAndNotNavigate() throws {
        coordinator.start(flow: TestFlow.multiTypeFlow, completion: {})
        XCTAssertEqual(5, coordinator.flow.steps.count)

        coordinator.updateFlow(with: TestFlow.defaultFlow, atIndex: coordinator.flow.steps.count - 1, animated: false)

        XCTAssertEqual(7, coordinator.flow.steps.count)
        XCTAssertEqual(1, coordinator.navigationPath.count)
        XCTAssertEqual(1, coordinator.currentStepIndex)
    }

    func testUpdateMiddleOfFlowAndNavigate() throws {
        coordinator.start(flow: TestFlow.multiTypeFlow, completion: {})
        coordinator.navigateToIndex(2)
        coordinator.updateFlow(with: TestFlow.defaultFlow, atIndex: 1, animated: true)

        XCTAssertEqual(7, coordinator.flow.steps.count)
        XCTAssertEqual(2, coordinator.navigationPath.count)
        XCTAssertEqual(2, coordinator.currentStepIndex)
    }

    func testUpdateMiddleOfFlowAndNotNavigate() throws {
        coordinator.start(flow: TestFlow.multiTypeFlow, completion: {})
        coordinator.navigateToIndex(2)
        coordinator.updateFlow(with: TestFlow.defaultFlow, atIndex: 1, animated: false)

        XCTAssertEqual(7, coordinator.flow.steps.count)
        XCTAssertEqual(5, coordinator.navigationPath.count)
        XCTAssertEqual(5, coordinator.currentStepIndex)
    }

    func testStartSubflow() throws {
        coordinator.start(flow: TestFlow.multiTypeFlow, completion: {})
        coordinator.navigateForward()
        coordinator.startSubflow(TestFlow.defaultFlow)

        XCTAssertEqual(7, coordinator.flow.steps.count)
        XCTAssertEqual(3, coordinator.navigationPath.count)
        XCTAssertEqual(3, coordinator.currentStepIndex)
    }

    func testDismiss() throws {
        coordinator.start(flow: TestFlow.defaultFlow, completion: {})
        coordinator.navigateForward()
        coordinator.navigateForward()
        coordinator.dismiss()

        XCTAssertEqual(2, coordinator.flow.steps.count)
        XCTAssertEqual(0, coordinator.navigationPath.count)
        XCTAssertEqual(0, coordinator.currentStepIndex)
    }

    func testPopToRoot() throws {
        coordinator.start(flow: TestFlow.defaultFlow, completion: {})
        coordinator.navigateForward()
        coordinator.navigateForward()
        coordinator.popToRoot()

        XCTAssertEqual(2, coordinator.flow.steps.count)
        XCTAssertEqual(1, coordinator.navigationPath.count)
        XCTAssertEqual(1, coordinator.currentStepIndex)
    }
}
