//
//  TestFlow.swift
//  FlowFrameworkTests
//
//  Created by Kelly Morales on 8/13/24.
//

import SwiftUI
import FlowFramework

public struct TestFlow {

    public static let defaultFlow: Flow = .init(steps: [step, otherStep])
    public static let multiTypeFlow: Flow = .init(steps: [step, otherStep, step, otherStep, step])

    static let step = TestStep()
    static let otherStep = OtherTestStep()
}

struct TestStep: FlowStep, Sendable {
    var id = UUID()
    var name = "Step"

    func view() -> EmptyView {
        EmptyView()
    }
}

public struct OtherTestStep: FlowStep, Sendable {
    public var id = UUID()
    public var name = "Another Step"

    public func view() -> EmptyView {
        EmptyView()
    }
}
