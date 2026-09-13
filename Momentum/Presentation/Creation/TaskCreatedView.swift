//
//  TaskCreatedView.swift
//  Momentum
//
//  The Task Created success state. No swipe gesture — the user explicitly
//  taps Continue, which the coordinator uses to return to the correct tab.
//

import SwiftUI

struct TaskCreatedView: View {
    @State private var hasAppeared = false
    let onContinue: () -> Void

    var body: some View {
        ZStack {
            MomentumBackground().ignoresSafeArea()

            VStack(spacing: 28) {
                ZStack {
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [MomentumColor.amber.opacity(0.5), .clear],
                                center: .center,
                                startRadius: 4,
                                endRadius: 120
                            )
                        )
                        .frame(width: 200, height: 200)

                    Circle()
                        .stroke(MomentumColor.amber, lineWidth: 3)
                        .frame(width: 130, height: 130)

                    Image(systemName: "checkmark")
                        .font(.system(size: 50, weight: .bold))
                        .foregroundStyle(MomentumColor.amber)
                }
                .scaleEffect(hasAppeared ? 1 : 0.6)
                .opacity(hasAppeared ? 1 : 0)

                VStack(spacing: 8) {
                    Text("Task created!")
                        .font(MomentumFont.title2)
                        .foregroundStyle(MomentumColor.textPrimary)
                    Text("You're all set. Let's keep the momentum going.")
                        .font(.subheadline)
                        .foregroundStyle(MomentumColor.textSecondary)
                        .multilineTextAlignment(.center)
                }
                .opacity(hasAppeared ? 1 : 0)

                Button("Continue", action: onContinue)
                    .buttonStyle(MomentumPrimaryButtonStyle())
                    .padding(.top, 8)
                    .opacity(hasAppeared ? 1 : 0)
            }
            .padding(.horizontal, 36)
        }
        .onAppear {
            withAnimation(MomentumAnimation.springy) {
                hasAppeared = true
            }
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        }
    }
}

#Preview {
    TaskCreatedView(onContinue: {})
}
