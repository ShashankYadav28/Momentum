//
//  HomeScreen.swift
//  Momentum
//
//  The approved Home screen: dark atmospheric background, glass surfaces,
//  warm amber accents, built from the real, persisted Momentum task data.
//

import SwiftUI

struct HomeScreen: View {

    @EnvironmentObject private var taskViewModel: TaskViewModel
    @State private var editingTask: Task?

    /// Called when the user taps "See all" — MainTabView wires this to
    /// switch to the Calendar tab (requirement: Home "See all" opens
    /// Calendar/Timeline).
    let onSeeAll: () -> Void

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: MomentumMetrics.sectionSpacing) {
                HomeHeaderView()
                UpcomingCard(tasks: taskViewModel.tasks)
                DailyProgressCard(tasks: taskViewModel.tasks)
                RecentActivityCard(
                    tasks: taskViewModel.tasks,
                    onSeeAll: onSeeAll,
                    onEdit: { task in editingTask = task },
                    onToggle: { task in taskViewModel.toggleTaskCompletion(task) },
                    onDelete: { task in taskViewModel.deleteTask(task) }
                )
            }
            .padding(MomentumMetrics.screenPadding)
            .padding(.bottom, MomentumMetrics.tabBarReservedHeight)
        }
        .sheet(item: $editingTask) { task in
            AddTaskView(taskToEdit: task)
        }
    }
}

#Preview {
    ZStack {
        MomentumBackground().ignoresSafeArea()
        HomeScreen(onSeeAll: {})
            .environmentObject(AppDIContainer.preview.taskViewModel)
    }
}

// MARK: - Header

private struct HomeHeaderView: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("Hey there!")
                    .font(MomentumFont.title2)
                    .foregroundStyle(MomentumColor.textPrimary)
                Text("Small wins matter")
                    .font(.subheadline)
                    .foregroundStyle(MomentumColor.textSecondary)
            }
            Spacer()
            Image(systemName: "gearshape.fill")
                .font(.subheadline)
                .foregroundStyle(MomentumColor.textSecondary)
                .frame(width: 36, height: 36)
                .background(.ultraThinMaterial, in: Circle())
                .accessibilityLabel("Settings")
        }
    }
}

// MARK: - Upcoming

private struct UpcomingCard: View {
    let tasks: [Task]
    private let calendar = Calendar.current

    private var nextUpcomingDay: Date? {
        tasks
            .compactMap { $0.dueDate }
            .filter { calendar.isDateInToday($0) || $0 > Date() }
            .min()
    }

    private var tasksOnThatDay: [Task] {
        guard let day = nextUpcomingDay else { return [] }
        return tasks
            .filter { task in
                guard let due = task.dueDate else { return false }
                return calendar.isDate(due, inSameDayAs: day)
            }
            .sorted { ($0.dueDate ?? .distantFuture) < ($1.dueDate ?? .distantFuture) }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if let day = nextUpcomingDay {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(day.formatted(.dateTime.month(.abbreviated).day()))
                            .font(.title2.weight(.bold))
                        Text(day.formatted(.dateTime.weekday(.wide)))
                            .font(.subheadline)
                            .foregroundStyle(MomentumColor.textSecondary)
                    }
                    Spacer()
                    VStack(alignment: .trailing, spacing: 2) {
                        Text("Upcoming")
                            .font(.caption)
                            .foregroundStyle(MomentumColor.amber)
                        Text("\(tasksOnThatDay.count) \(tasksOnThatDay.count == 1 ? "event" : "events")")
                            .font(.subheadline.weight(.semibold))
                    }
                }

                if let first = tasksOnThatDay.first {
                    Divider().overlay(MomentumColor.glassStroke)
                    Text(first.title)
                        .font(.subheadline.weight(.semibold))
                        .lineLimit(1)
                    if let due = first.dueDate {
                        Text(due.formatted(date: .omitted, time: .shortened))
                            .font(.caption)
                            .foregroundStyle(MomentumColor.textSecondary)
                    }
                }
            } else {
                HStack {
                    Image(systemName: "sparkles")
                        .foregroundStyle(MomentumColor.amber)
                    Text("Nothing scheduled yet — paste a message to get started.")
                        .font(.subheadline)
                        .foregroundStyle(MomentumColor.textSecondary)
                }
            }
        }
        .foregroundStyle(MomentumColor.textPrimary)
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .glassCard()
    }
}

// MARK: - Daily progress

private struct DailyProgressCard: View {
    let tasks: [Task]

    private var completedCount: Int { tasks.filter(\.isCompleted).count }
    private var totalCount: Int { tasks.count }
    private var progress: Double { totalCount == 0 ? 0 : Double(completedCount) / Double(totalCount) }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Daily tasks")
                    .font(.headline)
                Spacer()
                Text("\(Int(progress * 100))%")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(MomentumColor.amber)
            }

            Text("\(completedCount)/\(totalCount) tasks completed")
                .font(.footnote)
                .foregroundStyle(MomentumColor.textSecondary)

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule().fill(MomentumColor.glassStroke).frame(height: 8)
                    Capsule()
                        .fill(LinearGradient(colors: [MomentumColor.amber, MomentumColor.amberDeep], startPoint: .leading, endPoint: .trailing))
                        .frame(width: geo.size.width * progress, height: 8)
                        .animation(MomentumAnimation.smooth, value: progress)
                }
            }
            .frame(height: 8)

            if totalCount == 0 {
                Text("Add your first task to start tracking progress.")
                    .font(.caption)
                    .foregroundStyle(MomentumColor.textSecondary)
            }
        }
        .foregroundStyle(MomentumColor.textPrimary)
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .glassCard()
        .accessibilityElement(children: .combine)
    }
}

// MARK: - Recent activity

private struct RecentActivityCard: View {
    let tasks: [Task]
    let onSeeAll: () -> Void
    let onEdit: (Task) -> Void
    let onToggle: (Task) -> Void
    let onDelete: (Task) -> Void

    private var recentTasks: [Task] {
        Array(tasks.sorted { $0.createdAt > $1.createdAt }.prefix(3))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("Recent activity")
                    .font(.headline)
                    .foregroundStyle(MomentumColor.textPrimary)
                Spacer()
                Button("See all", action: onSeeAll)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(MomentumColor.amber)
            }

            if recentTasks.isEmpty {
                Text("Extracted tasks will show up here.")
                    .font(.footnote)
                    .foregroundStyle(MomentumColor.textSecondary)
            } else {
                VStack(spacing: 12) {
                    ForEach(recentTasks) { task in
                        TaskRowCard(
                            task: task,
                            onToggle: { onToggle(task) },
                            onEdit: { onEdit(task) },
                            onDelete: { onDelete(task) }
                        )
                    }
                }
            }
        }
    }
}
