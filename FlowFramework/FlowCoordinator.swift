//
//  FlowCoordinator.swift
//  FlowFramework
//
//  Created by Kelly Morales on 8/13/24.
//

import Foundation
import SwiftUI

// MARK: - FlowUpdating

/// Used for allowing Views/ViewModels to update the coordinator's flow
public protocol FlowUpdating {
    func updateFlow(with newFlow: Flow, atIndex index: Int, animated: Bool)
    func updateFlow(with newFlow: Flow, atStep step: any FlowStep, animated: Bool)
    func updateFlow(with newFlow: Flow, atStep name: String, animated: Bool)
    func updateFlow(with newFlow: Flow, atStep id: UUID, animated: Bool)
    func startSubflow(_ flow: Flow)
}

// MARK: - FlowCoordinator

/// Handles keeping track of a flow & navigating between steps in the flow
public final class FlowCoordinator: ObservableObject {

    // MARK: Properties

    /// Propagates values to `navigationDestination`, ie. current flow state
    @Published
    public var navigationPath: NavigationPath

    /// Source of truth for all steps in the flow
    var flow: Flow

    var currentStepIndex: Int {
        navigationPath.count
    }

    private var flowCompletion: () -> Void

    // MARK: Initializer

    public init() {
        self.navigationPath = NavigationPath()
        self.flow = .init(steps: [])
        self.flowCompletion = {}
    }

    // MARK: Navigation functions

    public func start(flow: Flow, completion: @escaping () -> Void) {
        self.flow = flow
        self.flowCompletion = completion
        self.navigationPath.append(flow.steps[currentStepIndex])
    }

    public func end() {
        flowCompletion()
    }

    /// Navigates to the next screen if the flow if it exists,
    /// otherwise this ends the flow.
    public func navigateForward() {
        guard currentStepIndex < flow.steps.count else {
            // No more steps to navigate forward
            end()
            return
        }

        self.navigationPath.append(flow.steps[currentStepIndex])
    }

    /// Navigates to the previous screen in the flow if it exists.
    public func navigateBackward() {
        guard navigationPath.count > 1 else {
            return
        }

        self.navigationPath.removeLast()
    }

    /// Navigates to a specific step in the flow if it exists.
    public func navigateToDestination(_ step: any FlowStep) {
        guard let index = flow.steps.firstIndex(where: { $0.name == step.name }) else {
            assertionFailure("Step \(step.name) not found in flow.")
            return
        }

        navigateToIndex(index)
    }

    /// Navigates to a the given step index in the flow.
    public func navigateToIndex(_ index: Int) {
        guard index < flow.steps.count else {
            return
        }

        // Remove all screens from the navigation path that occur after
        // the specified step. Necessary for proper UI.
        navigationPath = .init(flow.steps.prefix(index + 1))
    }

    /// Removes all steps from the navigation path, navigates to flow presenter.
    public func dismiss() {
        navigationPath.removeLast(flow.steps.count)
    }

    /// Navigates to first step in the flow.
    public func popToRoot() {
        navigationPath.removeLast(flow.steps.count - 1)
    }

    /// Provides the name/id of the current step within the flow.
    public func currentStepInfo() -> (Int, String) {
        (currentStepIndex, flow.steps[currentStepIndex - 1].name)
    }
}

// MARK: - FlowUpdating Default

extension FlowCoordinator: FlowUpdating {

    /// Updates the existing flow & navigates to the first screen in `newFlow`
    /// if `animated` is true.
    /// - parameter newFlow: The flow to insert into the existing flow.
    /// - parameter index: The index at which to insert `newFlow`.
    /// - parameter animated: If `true`, navigates to the start of `newFlow`, otherwise
    /// simply inserts `newFlow` without navigating to the start of it.
    public func updateFlow(with newFlow: Flow, atIndex index: Int, animated: Bool) {
        guard index < flow.steps.count else {
            return
        }

        let currentIndex = currentStepIndex
        if index >= currentIndex {
            // Inserting at a point in the flow we haven't seen yet
            var tmpIndex = index
            newFlow.steps.forEach {
                flow.steps.insert($0, at: tmpIndex)
                tmpIndex += 1
            }
        } else {
            // Inserting into previous point in existing flow
            var tmpIndex = index
            newFlow.steps.forEach {
                flow.steps.insert($0, at: tmpIndex)
                tmpIndex += 1
            }

            var transaction = Transaction()
            transaction.disablesAnimations = true
            withTransaction(transaction) {
                navigationPath = .init(flow.steps.prefix(currentIndex + newFlow.steps.count))
            }
        }

        if animated {
            navigateToIndex(index)
        }
    }

    /// Updates the existing flow & navigates to the first screen in `newFlow`
    /// if `animated` is true.
    /// - parameter newFlow: The flow to insert into the existing flow.
    /// - parameter step: The `step` instance at which to insert `newFlow`.
    /// - parameter animated: If `true`, navigates to the start of `newFlow`, otherwise
    /// simply inserts `newFlow` without navigating to the start of it.
    public func updateFlow(with newFlow: Flow, atStep step: any FlowStep, animated: Bool) {
        updateFlow(with: newFlow, atStep: step.id, animated: animated)
    }

    /// Updates the existing flow & navigates to the first screen in `newFlow`
    /// if `animated` is true.
    /// - parameter newFlow: The flow to insert into the existing flow.
    /// - parameter name: The name of the step at which to insert `newFlow`.
    /// - parameter animated: If `true`, navigates to the start of `newFlow`, otherwise
    /// simply inserts `newFlow` without navigating to the start of it.
    public func updateFlow(with newFlow: Flow, atStep name: String, animated: Bool) {
        guard let index = flow.steps.firstIndex(where: { $0.name == name }) else {
            assertionFailure("Step \(name) not found in flow.")
            return
        }

        updateFlow(with: newFlow, atIndex: index, animated: animated)
    }

    /// Updates the existing flow & navigates to the first screen in `newFlow`
    /// if `animated` is true.
    /// - parameter newFlow: The flow to insert into the existing flow.
    /// - parameter id: The id of the step at which to insert `newFlow`.
    /// - parameter animated: If `true`, navigates to the start of `newFlow`, otherwise
    /// simply inserts `newFlow` without navigating to the start of it.
    public func updateFlow(with newFlow: Flow, atStep id: UUID, animated: Bool) {
        guard let index = flow.steps.firstIndex(where: { $0.id == id }) else {
            assertionFailure("Step \(id.uuidString) not found in flow.")
            return
        }

        updateFlow(with: newFlow, atIndex: index, animated: animated)
    }

    /// Navigates foward into the given subflow. Continues with the remainder of
    /// the previous flow upon completion.
    public func startSubflow(_ subflow: Flow) {
        updateFlow(with: subflow, atIndex: currentStepIndex, animated: true)
    }
}
