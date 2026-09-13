//
//  MomentumBackground.swift
//  Momentum
//
//  The shared dark/warm-amber atmospheric background used behind every
//  screen so the Momentum identity feels consistent app-wide.
//

import SwiftUI

struct MomentumBackground: View {
    enum Variant {
        case standard
        case onboarding
    }

    var variant: Variant = .standard

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [MomentumColor.backgroundTop, MomentumColor.backgroundBottom],
                startPoint: .top,
                endPoint: .bottom
            )

            RadialGradient(
                colors: [MomentumColor.amberDeep.opacity(variant == .onboarding ? 0.55 : 0.32), .clear],
                center: .topTrailing,
                startRadius: 20,
                endRadius: variant == .onboarding ? 480 : 380
            )

            RadialGradient(
                colors: [MomentumColor.amber.opacity(variant == .onboarding ? 0.28 : 0.16), .clear],
                center: .bottomLeading,
                startRadius: 10,
                endRadius: 360
            )
        }
    }
}

#Preview {
    MomentumBackground(variant: .onboarding)
        .ignoresSafeArea()
}
