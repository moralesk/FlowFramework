//
//  WrappedStep.swift
//  FlowFramework
//
//  Created by Kelly Morales on 8/13/24.
//

import Foundation
import SwiftUI

/// Type erasure wrapper for proper Flow logic and navigation
public struct WrappedStep: Identifiable, Hashable, Sendable {

    // MARK: Properties

    public let id: UUID
    public let name: String
    public let step: any FlowStep

    // MARK: Initializer

    public init<S: FlowStep>(_ step: S) {
        self.id = step.id
        self.name = step.name
        self.step = step
    }

    public func view() -> any View {
        step.view()
    }

    // MARK: Hashable

    public static func == (lhs: WrappedStep, rhs: WrappedStep) -> Bool {
        lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
