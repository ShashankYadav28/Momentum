//
//  MomentumTheme.swift
//  Momentum
//
//  Centralized presentation-layer design system for the approved
//  "dark atmospheric / warm amber" Momentum visual identity.
//
//  This file intentionally contains ONLY presentation constants and
//  view helpers. No business/domain logic lives here.
//

import SwiftUI

// MARK: - Colors

enum MomentumColor {
    /// Deep near-black used at the top of every atmospheric background.
    static let backgroundTop = Color(light: UIColor(red: 0.98, green: 0.97, blue: 0.95, alpha: 1),
                                      dark: UIColor(red: 0.06, green: 0.05, blue: 0.05, alpha: 1))
    /// Warm, near-black brown used at the bottom of the background gradient.
    static let backgroundBottom = Color(light: UIColor(red: 0.93, green: 0.90, blue: 0.86, alpha: 1),
                                         dark: UIColor(red: 0.01, green: 0.01, blue: 0.01, alpha: 1))

    /// Primary warm amber accent — the single defining color of Momentum.
    static let amber = Color(red: 1.0, green: 0.58, blue: 0.20)
    /// Deeper amber/orange used for gradients alongside `amber`.
    static let amberDeep = Color(red: 0.86, green: 0.38, blue: 0.11)

    /// Hairline stroke used on all glass surfaces.
    static let glassStroke = Color.white.opacity(0.14)

    static let textPrimary = Color(light: UIColor(red: 0.09, green: 0.08, blue: 0.07, alpha: 1),
                                    dark: UIColor.white)
    static let textSecondary = Color(light: UIColor(red: 0.35, green: 0.32, blue: 0.30, alpha: 1),
                                      dark: UIColor.white.withAlphaComponent(0.62))
}

private extension Color {
    /// Convenience initializer so design-system colors adapt automatically
    /// between Light and Dark Mode while keeping the approved identity.
    init(light: UIColor, dark: UIColor) {
        self = Color(UIColor { traits in
            traits.userInterfaceStyle == .dark ? dark : light
        })
    }
}

// MARK: - Typography

enum MomentumFont {
    static let largeTitle = Font.system(size: 34, weight: .bold, design: .rounded)
    static let title2 = Font.system(size: 22, weight: .bold, design: .rounded)
    static let title3 = Font.system(size: 18, weight: .semibold, design: .rounded)
    static let body = Font.system(size: 16, weight: .regular, design: .rounded)
    static let caption = Font.system(size: 12, weight: .medium, design: .rounded)
}

// MARK: - Metrics

enum MomentumMetrics {
    static let cardCornerRadius: CGFloat = 22
    static let smallCornerRadius: CGFloat = 14
    static let screenPadding: CGFloat = 20
    static let sectionSpacing: CGFloat = 20
    /// Reserved bottom space so scrollable content never sits behind the
    /// floating bottom navigation bar.
    static let tabBarReservedHeight: CGFloat = 110
}

// MARK: - Animation constants

enum MomentumAnimation {
    static let springy = Animation.spring(response: 0.45, dampingFraction: 0.72)
    static let quickSpring = Animation.spring(response: 0.32, dampingFraction: 0.68)
    static let smooth = Animation.easeInOut(duration: 0.25)
}

// MARK: - Glass surface

private struct GlassCardModifier: ViewModifier {
    var cornerRadius: CGFloat = MomentumMetrics.cardCornerRadius

    func body(content: Content) -> some View {
        content
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(MomentumColor.glassStroke, lineWidth: 1)
            )
    }
}

extension View {
    /// Applies the standard frosted "glass" surface used throughout Momentum.
    func glassCard(cornerRadius: CGFloat = MomentumMetrics.cardCornerRadius) -> some View {
        modifier(GlassCardModifier(cornerRadius: cornerRadius))
    }
}

// MARK: - Buttons

/// The single primary call-to-action style: warm amber gradient fill with a
/// tactile press animation. Used for Extract Task, Confirm, Continue, etc.
struct MomentumPrimaryButtonStyle: ButtonStyle {
    var isEnabled: Bool = true

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 16, weight: .semibold, design: .rounded))
            .foregroundStyle(.black)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 15)
            .background(
                LinearGradient(
                    colors: isEnabled ? [MomentumColor.amber, MomentumColor.amberDeep] : [Color.gray.opacity(0.4), Color.gray.opacity(0.3)],
                    startPoint: .leading,
                    endPoint: .trailing
                ),
                in: RoundedRectangle(cornerRadius: 18, style: .continuous)
            )
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(MomentumAnimation.quickSpring, value: configuration.isPressed)
    }
}

/// Secondary/neutral action style used for Discard-style buttons.
struct MomentumSecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 16, weight: .semibold, design: .rounded))
            .foregroundStyle(MomentumColor.textPrimary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 15)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(MomentumColor.glassStroke, lineWidth: 1)
            )
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(MomentumAnimation.quickSpring, value: configuration.isPressed)
    }
}
