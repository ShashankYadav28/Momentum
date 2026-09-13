//
//  MomentumTabBar.swift
//  Momentum
//
//  The final approved navigation: Home | List | Calendar | +.
//  The + is part of the main bar but stays visually distinct as the
//  primary creation action. There is no Profile tab.
//

import SwiftUI

struct MomentumTabBar: View {
    @Binding var selectedTab: AppTab
    let onCreate: () -> Void

    var body: some View {
        HStack(spacing: 4) {
            tabButton(.home, systemImage: "house.fill", label: "Home")
            tabButton(.list, systemImage: "list.bullet", label: "List")
            tabButton(.calendar, systemImage: "calendar", label: "Calendar")
            createButton
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 28, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .stroke(MomentumColor.glassStroke, lineWidth: 1)
        )
        .padding(.horizontal, 20)
    }

    private func tabButton(_ tab: AppTab, systemImage: String, label: String) -> some View {
        Button {
            guard selectedTab != tab else { return }
            withAnimation(MomentumAnimation.quickSpring) { selectedTab = tab }
        } label: {
            VStack(spacing: 4) {
                Image(systemName: systemImage)
                    .font(.system(size: 19, weight: selectedTab == tab ? .semibold : .regular))
                Text(label)
                    .font(.system(size: 10, weight: .medium, design: .rounded))
            }
            .foregroundStyle(selectedTab == tab ? MomentumColor.amber : MomentumColor.textSecondary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 4)
            .contentShape(Rectangle())
        }
        .accessibilityLabel(label)
        .accessibilityAddTraits(selectedTab == tab ? [.isSelected] : [])
    }

    private var createButton: some View {
        Button {
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
            onCreate()
        } label: {
            Image(systemName: "plus")
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(.black)
                .frame(width: 46, height: 46)
                .background(
                    LinearGradient(colors: [MomentumColor.amber, MomentumColor.amberDeep], startPoint: .top, endPoint: .bottom),
                    in: Circle()
                )
                .shadow(color: MomentumColor.amber.opacity(0.5), radius: 10, y: 4)
        }
        .accessibilityLabel("Create task")
        .padding(.leading, 4)
    }
}

#Preview {
    ZStack {
        MomentumBackground().ignoresSafeArea()
        VStack {
            Spacer()
            MomentumTabBar(selectedTab: .constant(.home), onCreate: {})
        }
    }
}
