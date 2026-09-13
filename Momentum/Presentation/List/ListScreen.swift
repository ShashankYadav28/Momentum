//
//  ListScreen.swift
//  Momentum
//
//  Shows the actual stored tasks in the approved dark/glass visual
//  language. No unsupported domain concepts (priority, category, team,
//  duration, etc.) are introduced — grouping and filtering are derived
//  purely from the existing Task fields (dueDate, isCompleted).
//

import SwiftUI

struct ListScreen: View {

    @EnvironmentObject private var taskViewModel: TaskViewModel
    @State private var filter: Filter = .all
    @State private var editingTask: Task?

    private enum Filter: String, CaseIterable {
        case all = "All"
        case active = "Active"
        case completed = "Completed"
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: MomentumMetrics.sectionSpacing) {
                header
                filterChips

                if groupedSections.isEmpty {
                    emptyState
                } else {
                    ForEach(groupedSections, id: \.title) { section in
                        VStack(alignment: .leading, spacing: 12) {
                            Text(section.title)
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(MomentumColor.textSecondary)

                            VStack(spacing: 12) {
                                ForEach(section.tasks) { task in
                                    TaskRowCard(
                                        task: task,
                                        onToggle: { taskViewModel.toggleTaskCompletion(task) },
                                        onEdit: { editingTask = task },
                                        onDelete: { taskViewModel.deleteTask(task) }
                                    )
                                }
                            }
                        }
                    }
                }
            }
            .padding(MomentumMetrics.screenPadding)
            .padding(.bottom, MomentumMetrics.tabBarReservedHeight)
        }
        .sheet(item: $editingTask) { task in
            AddTaskView(taskToEdit: task)
        }
    }

    private var header: some View {
        Text("All Tasks")
            .font(MomentumFont.title2)
            .foregroundStyle(MomentumColor.textPrimary)
    }

    private var filterChips: some View {
        HStack(spacing: 10) {
            ForEach(Filter.allCases, id: \.self) { option in
                Button {
                    withAnimation(MomentumAnimation.smooth) { filter = option }
                } label: {
                    Text(option.rawValue)
                        .font(.subheadline.weight(.semibold))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(
                            filter == option ? AnyShapeStyle(MomentumColor.amber) : AnyShapeStyle(.ultraThinMaterial),
                            in: Capsule()
                        )
                        .foregroundStyle(filter == option ? .black : MomentumColor.textPrimary)
                }
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "tray")
                .font(.system(size: 44))
                .foregroundStyle(MomentumColor.textSecondary)
            Text("No tasks yet")
                .foregroundStyle(MomentumColor.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 60)
    }

    // MARK: - Grouping

    private var filteredTasks: [Task] {
        switch filter {
        case .all: return taskViewModel.tasks
        case .active: return taskViewModel.tasks.filter { !$0.isCompleted }
        case .completed: return taskViewModel.tasks.filter { $0.isCompleted }
        }
    }

    private var groupedSections: [(title: String, tasks: [Task])] {
        let calendar = Calendar.current
        let now = Date()

        var overdue: [Task] = []
        var today: [Task] = []
        var upcoming: [Task] = []
        var noDate: [Task] = []
        var completed: [Task] = []

        for task in filteredTasks {
            if task.isCompleted {
                completed.append(task)
                continue
            }
            guard let due = task.dueDate else {
                noDate.append(task)
                continue
            }
            if calendar.isDateInToday(due) {
                today.append(task)
            } else if due < now {
                overdue.append(task)
            } else {
                upcoming.append(task)
            }
        }

        func sortedByDue(_ items: [Task]) -> [Task] {
            items.sorted { ($0.dueDate ?? .distantFuture) < ($1.dueDate ?? .distantFuture) }
        }

        var sections: [(String, [Task])] = []
        if !overdue.isEmpty { sections.append(("Overdue", sortedByDue(overdue))) }
        if !today.isEmpty { sections.append(("Today", sortedByDue(today))) }
        if !upcoming.isEmpty { sections.append(("Upcoming", sortedByDue(upcoming))) }
        if !noDate.isEmpty { sections.append(("No due date", noDate)) }
        if filter != .active, !completed.isEmpty {
            sections.append(("Completed", completed))
        }
        return sections
    }
}

#Preview {
    ZStack {
        MomentumBackground().ignoresSafeArea()
        ListScreen()
            .environmentObject(AppDIContainer.preview.taskViewModel)
    }
}
