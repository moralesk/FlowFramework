//
//  StepView.swift
//  FlowFramework
//
//  Created by Kelly Morales on 8/13/24.
//

import SwiftUI

/// Basic Flow screen with two CTAs used for navigating
@MainActor
struct StepView: View {

    var navigateBack: () -> Void
    var navigateFoward: () -> Void

    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            Spacer()

            Text("Step")

            Spacer()

            Button(action: {
                navigateBack()
            }) {
                HStack {
                    Spacer()
                    Text("Previous")
                    Spacer()
                }
                .padding(.vertical, 12)
            }
            .background(.white)
            .clipShape(.capsule)

            Button(action: {
                navigateFoward()
            }) {
                HStack {
                    Spacer()
                    Text("Next")
                    Spacer()
                }
                .padding(.vertical, 12)
            }
            .background(.white)
            .clipShape(.capsule)
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 24)
        .background(Color.purple)
        .toolbarBackground(.visible, for: .navigationBar)
    }
}

#Preview {
    StepView(navigateBack: {}, navigateFoward: {})
}
