//
//  Flow.swift
//  FlowFramework
//
//  Created by Kelly Morales on 8/13/24.
//

import Foundation

/// Keeps track of a Flow's ordered list of steps
public struct Flow: Sendable {

    /// Ordered list of steps in the Flow
    public var steps: [WrappedFlowStep]

    public init(steps: [any FlowStep]) {
        self.steps = steps.map { WrappedFlowStep($0) }
    }
}
