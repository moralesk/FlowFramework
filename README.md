# Flow Framework for SwiftUI
A simple, lightweight framework for creating reliable sequences of static or dynamic screens in your UI.

## Dependencies
* In order for the Flow Framework to work correctly, you will need to use a `SwiftUI.NavigationStack`, make sure your project is equipped to work with this type.

## How To Use
The FlowFramework aims to allow developers to write concise logic that allows for flexibility.
1. Define the `View`s that will be displayed in your flow.
2. Create a corresponding "step" class for each view that conforms to the `FlowStep` protocol. This will require you to create a unique ID, name, and a function that returns your `View` for the step.
3. For a predetermined UI flow, create a `Flow` instance containing an ordered array of your `FlowStep`s. For dynamic flows, you can define ordered array subsets, and add on to the flow later using helper methods.
4. Add a `@StateObject FlowCoordinator` to the `View` that will launch your flow.
5. Wrap your flow entry point `View` in a `NavigationStack`, and add the following `navigationDestination` logic:
```
    NavigationStack($coordinator.navigationPath) {
        // Flow launch screen UI
    }
    .navigationDestination(for: WrappedFlowStep.self, destination: { step in
        AnyView(step.view())
    }
```
6. Lastly, you can launch your flow by calling the `FlowCoordinator` function `.start(flow: Flow, completion:  @escaping () -> Void)`, where the completion handler will be called at the end of the flow.
