//
//  OnboardingView.swift
//  Momentum
//
//  The three approved first-launch onboarding screens. Horizontal swipe +
//  subtle haptic feedback is used ONLY here — every other flow in the app
//  (creation, review, success) is advanced with explicit button taps.
//

import SwiftUI

private struct OnboardingPageData: Identifiable {
    let id = UUID()
    let title: String
    let highlightedWord: String
    let subtitle: String
}

struct OnboardingView: View {
    @State private var page = 0

    /// Called when the user taps the final CTA — the caller is responsible
    /// for marking onboarding complete and starting the first task flow.
    let onFinish: () -> Void

    private let pages: [OnboardingPageData] = [
        OnboardingPageData(
            title: "Turn messages into action.",
            highlightedWord: "action.",
            subtitle: "Your everyday messages can do more."
        ),
        OnboardingPageData(
            title: "Momentum finds what matters.",
            highlightedWord: "matters.",
            subtitle: "Tasks. Dates. Links. Automatically."
        ),
        OnboardingPageData(
            title: "Less effort. More you.",
            highlightedWord: "you.",
            subtitle: "Paste a message and let AI handle the rest."
        )
    ]

    var body: some View {
        ZStack {
            MomentumBackground(variant: .onboarding).ignoresSafeArea()

            TabView(selection: $page) {
                ForEach(Array(pages.enumerated()), id: \.element.id) { index, page in
                    OnboardingPageView(data: page)
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .onChange(of: page) { _, _ in
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
            }

            VStack {
                Spacer()
                pageIndicator
                    .padding(.bottom, 28)
                actionButton
                    .padding(.horizontal, 24)
                    .padding(.bottom, 24)
            }
        }
    }

    private var pageIndicator: some View {
        HStack(spacing: 6) {
            ForEach(pages.indices, id: \.self) { index in
                Capsule()
                    .fill(index == page ? MomentumColor.amber : Color.white.opacity(0.25))
                    .frame(width: index == page ? 20 : 6, height: 6)
                    .animation(MomentumAnimation.smooth, value: page)
            }
        }
        .accessibilityHidden(true)
    }

    @ViewBuilder
    private var actionButton: some View {
        if page == pages.count - 1 {
            Button {
                onFinish()
            } label: {
                Label("Create your first task", systemImage: "sparkles")
            }
            .buttonStyle(MomentumPrimaryButtonStyle())
        } else {
            HStack {
                Spacer()
                Button {
                    withAnimation(MomentumAnimation.springy) { page += 1 }
                } label: {
                    Image(systemName: "arrow.right")
                        .font(.title3.weight(.semibold))
                        .foregroundStyle(.black)
                        .frame(width: 56, height: 56)
                        .background(
                            LinearGradient(colors: [MomentumColor.amber, MomentumColor.amberDeep], startPoint: .top, endPoint: .bottom),
                            in: Circle()
                        )
                }
                .accessibilityLabel("Next")
            }
        }
    }
}

private struct OnboardingPageView: View {
    let data: OnboardingPageData

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            Spacer()

            abstractArt
                .frame(maxWidth: .infinity)

            Spacer()

            VStack(alignment: .leading, spacing: 14) {
                title
                Text(data.subtitle)
                    .font(.body)
                    .foregroundStyle(MomentumColor.textSecondary)
            }

            Spacer()
            Spacer()
        }
        .padding(.horizontal, 28)
        .padding(.bottom, 140)
    }

    private var title: some View {
        let full = data.title
        let highlight = data.highlightedWord
        let base = full.replacingOccurrences(of: highlight, with: "").trimmingCharacters(in: .whitespaces)

        return (
            Text(base + " ")
                .foregroundStyle(MomentumColor.textPrimary)
            + Text(highlight)
                .foregroundStyle(MomentumColor.amber)
        )
        .font(MomentumFont.largeTitle)
        .fixedSize(horizontal: false, vertical: true)
    }

    private var abstractArt: some View {
        ZStack {
            Circle()
                .fill(
                    RadialGradient(
                        colors: [MomentumColor.amber.opacity(0.55), MomentumColor.amberDeep.opacity(0.15), .clear],
                        center: .center,
                        startRadius: 4,
                        endRadius: 160
                    )
                )
                .frame(width: 220, height: 220)

            Circle()
                .stroke(MomentumColor.amber.opacity(0.35), lineWidth: 1)
                .frame(width: 180, height: 180)
        }
        .frame(height: 220)
        .accessibilityHidden(true)
    }
}

#Preview {
    OnboardingView(onFinish: {})
}
