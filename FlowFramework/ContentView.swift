//
//  ContentView.swift
//  FlowFramework
//
//  Created by Kelly Morales on 8/13/24.
//

import SwiftUI

struct ContentView: View {

    @StateObject
    private var coordinator: FlowCoordinator = .init()

    var body: some View {
        NavigationStack(path: $coordinator.navigationPath) {
            VStack(alignment: .center, spacing: 16) {
                Spacer()

                Text("Start Flow")

                Spacer()

                Button(action: {
                    coordinator.start(flow: flowWithOptionToUpdateLater(), completion: {
                        Task { @MainActor in
                        coordinator.dismiss()
                        }
                    })
                }) {
                    HStack {
                        Spacer()
                        Text("Start")
                            .tint(.white)
                        Spacer()
                    }
                    .padding(.vertical, 12)
                }
                .background(.gray)
                .clipShape(.capsule)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
            .navigationDestination(for: WrappedFlowStep.self, destination: { step in
                AnyView(step.view())
                    .navigationTitle(step.name)
                    .navigationBarTitleDisplayMode(.inline)
            })
        }
    }

    // MARK: - Flow Examples

    private func flow() -> Flow {
        .init(steps: [
            Step(name: "Step 1", coordinator: self.coordinator),
            Step(name: "Step 2", coordinator: self.coordinator),
            Step(name: "Step 3", coordinator: self.coordinator),
        ])
    }

    private func flowWithOptionToUpdatePrevious() -> Flow {
        .init(steps: [
            Step(name: "Step 1", coordinator: self.coordinator),
            Step(name: "Step 2", coordinator: self.coordinator),
            otherStep(insertSubflowAtIndex: 1),
            Step(name: "Step 3", coordinator: self.coordinator),
        ])
    }

    private func flowWithOptionToUpdateLater() -> Flow {
        .init(steps: [
            Step(name: "Step 1", coordinator: self.coordinator),
            otherStep(insertSubflowAtIndex: 3),
            Step(name: "Step 2", coordinator: self.coordinator),
            Step(name: "Step 3", coordinator: self.coordinator),
        ])
    }

    private func otherStep(insertSubflowAtIndex index: Int) -> OtherStep {
        OtherStep(
            name: "Another Step",
            coordinator: self.coordinator,
            buttonTitle: "Change flow",
            buttonAction: {
                self.coordinator.updateFlow(with: subflow(), atIndex: index, animated: false)
            })
    }

    private func subflow() -> Flow {
        .init(steps: [
            Step(name: "Subflow step 1", coordinator: self.coordinator),
            Step(name: "Subflow step 2", coordinator: self.coordinator)
        ])
    }
}

#Preview {
    ContentView()
}
