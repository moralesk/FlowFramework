//
//  FlowStep.swift
//  FlowFramework
//
//  Created by Kelly Morales on 8/13/24.
//

import Foundation
import SwiftUI

/// Defines a step within a flow that corresponds to a view
public protocol FlowStep: Identifiable, Sendable {
    associatedtype ContentView: View

    var id: UUID { get }

    /// Used for Analytics
    var name: String { get }

    /// Builds the View associated with this step
    func view() -> ContentView
}
