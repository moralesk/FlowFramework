//
//  Step.swift
//  FlowFramework
//
//  Created by Kelly Morales on 8/13/24.
//

import SwiftUI

/// Test flow step example
class Step: FlowStep {

    // MARK: Properties

    let id = UUID()
    let name: String

    @ObservedObject
    private var coordinator: FlowCoordinator

    // MARK: Intitializer

    init(name: String, coordinator: FlowCoordinator) {
        self.name = name
        self.coordinator = coordinator
    }

    func view() -> StepView {
        StepView(
            navigateBack: { self.coordinator.navigateBackward() },
            navigateFoward: { self.coordinator.navigateForward() })
    }
}
