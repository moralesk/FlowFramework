//
//  OtherStepView.swift
//  FlowFramework
//
//  Created by Kelly Morales on 8/13/24.
//

import SwiftUI

struct OtherStepView: View {

    var buttonTitle: String
    var buttonAction: () -> Void
    var navigateFoward: () -> Void

    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            Spacer()

            Text("Other Step View")

            Spacer()

            Button(action: {
                buttonAction()
            }) {
                HStack {
                    Spacer()
                    Text(buttonTitle)
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
        .background(Color.green)
        .toolbarBackground(.visible, for: .navigationBar)
    }
}

#Preview {
    OtherStepView(buttonTitle: "Change Flow", buttonAction: {}, navigateFoward: {})
}
