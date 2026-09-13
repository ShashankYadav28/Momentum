//
//  ExtractingView.swift
//  Momentum
//
//  Shown while the existing, real TaskParsingService is doing actual work
//  (see TaskCreationCoordinator.beginExtraction, which awaits
//  taskViewModel.executeParse). There is no fake progress bar or fake
//  percentage here — the screen simply stays up for as long as extraction
//  genuinely takes, then the coordinator advances automatically.
//

import SwiftUI

struct ExtractingView: View {
    @State private var isPulsing = false

    var body: some View {
        ZStack {
            MomentumBackground().ignoresSafeArea()

            VStack(spacing: 32) {
                ZStack {
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [MomentumColor.amber.opacity(0.55), .clear],
                                center: .center,
                                startRadius: 4,
                                endRadius: 130
                            )
                        )
                        .frame(width: 220, height: 220)
                        .scaleEffect(isPulsing ? 1.12 : 0.88)
                        .opacity(isPulsing ? 0.9 : 0.45)

                    Circle()
                        .stroke(MomentumColor.amber.opacity(0.5), lineWidth: 1.5)
                        .frame(width: 150, height: 150)
                        .scaleEffect(isPulsing ? 1.05 : 0.95)

                    Image(systemName: "sparkles")
                        .font(.system(size: 46, weight: .medium))
                        .foregroundStyle(MomentumColor.amber)
                        .scaleEffect(isPulsing ? 1.05 : 0.95)
                }

                VStack(spacing: 8) {
                    Text("Extracting\nyour task...")
                        .font(MomentumFont.title2)
                        .foregroundStyle(MomentumColor.textPrimary)
                        .multilineTextAlignment(.center)

                    Text("Finding the important details from your message.")
                        .font(.subheadline)
                        .foregroundStyle(MomentumColor.textSecondary)
                        .multilineTextAlignment(.center)
                }
            }
            .padding(.horizontal, 32)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.4).repeatForever(autoreverses: true)) {
                isPulsing = true
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Extracting your task, please wait")
    }
}

#Preview {
    ExtractingView()
}
