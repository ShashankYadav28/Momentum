//
//  RootView.swift
//  Momentum
//
//  Decides between first-launch Onboarding and the main tabbed app.
//  The same TaskCreationCoordinator instance is shared across both so the
//  onboarding CTA can hand off directly into the (identical) task-creation
//  flow without any duplicated navigation logic.
//

import SwiftUI

struct RootView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @StateObject private var creationCoordinator = TaskCreationCoordinator()
    @EnvironmentObject private var taskViewModel: TaskViewModel

    var body: some View {
        Group {
            if hasCompletedOnboarding {
                MainTabView()
            } else {
                OnboardingView {
                    hasCompletedOnboarding = true
                    creationCoordinator.start(from: .home, isFirstLaunch: true)
                }
            }
        }
        .environmentObject(creationCoordinator)
        .environmentObject(taskViewModel)
    }
}

#Preview {
    RootView()
        .environmentObject(AppDIContainer.preview.taskViewModel)
}
