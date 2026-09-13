//
//  MainTabView.swift
//  Momentum
//
//  Hosts Home / List / Calendar behind the custom MomentumTabBar and the
//  single shared AI task-creation flow (fullScreenCover), reused
//  identically no matter which tab the + button was tapped from.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: AppTab = .home
    @EnvironmentObject private var creationCoordinator: TaskCreationCoordinator
    @EnvironmentObject private var taskViewModel: TaskViewModel

    var body: some View {
        ZStack(alignment: .bottom) {
            MomentumBackground().ignoresSafeArea()

            Group {
                switch selectedTab {
                case .home:
                    HomeScreen(onSeeAll: { switchTab(to: .calendar) })
                case .list:
                    ListScreen()
                case .calendar:
                    CalendarScreen()
                }
            }

            MomentumTabBar(selectedTab: $selectedTab) {
                creationCoordinator.start(from: selectedTab)
            }
            .padding(.bottom, 8)
        }
        .fullScreenCover(item: $creationCoordinator.step) { step in
            creationFlowContent(for: step)
                .environmentObject(taskViewModel)
        }
        .task {
            taskViewModel.fetchTasks()
        }
    }

    @ViewBuilder
    private func creationFlowContent(for step: CreationFlowStep) -> some View {
        switch step {
        case .pasteMessage:
            PasteMessageView { message in
                creationCoordinator.beginExtraction(message: message, taskViewModel: taskViewModel)
            }
        case .extracting:
            ExtractingView()
        case .review(let pendingTask):
            ReviewTaskView(
                pendingTask: pendingTask,
                onConfirmed: { creationCoordinator.advanceToCreated() },
                onDiscarded: { creationCoordinator.cancel() }
            )
        case .created:
            TaskCreatedView {
                let destinationTab = creationCoordinator.finish()
                switchTab(to: destinationTab)
            }
        }
    }

    private func switchTab(to tab: AppTab) {
        withAnimation(MomentumAnimation.quickSpring) {
            selectedTab = tab
        }
    }
}

#Preview {
    MainTabView()
        .environmentObject(AppDIContainer.preview.taskViewModel)
        .environmentObject(TaskCreationCoordinator())
}
