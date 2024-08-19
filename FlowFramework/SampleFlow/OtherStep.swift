//
//  OtherStep.swift
//  FlowFramework
//
//  Created by Kelly Morales on 8/13/24.
//

import SwiftUI

/// Test flow step example
class OtherStep: FlowStep {

    // MARK: Properties

    let id = UUID()
    let name: String

    @ObservedObject
    private var coordinator: FlowCoordinator

    let buttonTitle: String
    let buttonAction: () -> Void

    // MARK: Intitializer

    init(name: String, coordinator: FlowCoordinator, buttonTitle: String, buttonAction: @escaping () -> Void) {
        self.name = name
        self.coordinator = coordinator
        self.buttonTitle = buttonTitle
        self.buttonAction = buttonAction
    }

    func view() -> OtherStepView {
        OtherStepView(
            buttonTitle: buttonTitle,
            buttonAction: buttonAction,
            navigateFoward: { self.coordinator.navigateForward() })
    }

    private func subflow() -> Flow {
        .init(steps: [
            Step(name: "Subflow step 1", coordinator: self.coordinator),
            Step(name: "Subflow step 2", coordinator: self.coordinator)
        ])
    }
}
