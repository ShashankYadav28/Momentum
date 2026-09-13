//
//  CalendarScreen.swift
//  Momentum
//
//  The Calendar/Timeline screen. Tasks are positioned using Task.dueDate
//  only. The Task model has no duration, so tasks are represented as
//  point-in-time markers rather than spans — TimelineEvent is not revived
//  here since Task already carries everything the timeline needs
//  (title, description, dueDate, link) and introducing a second entity
//  would just duplicate the same data for no presentation benefit.
//

import SwiftUI

struct CalendarScreen: View {

    @EnvironmentObject private var taskViewModel: TaskViewModel
    @State private var selectedDate = Date()
    @State private var weekAnchor = Date()
    @State private var editingTask: Task?

    private let calendar = Calendar.current
    private let startHour = 7
    private let endHour = 22
    private let hourHeight: CGFloat = 64

    var body: some View {
        VStack(spacing: 20) {
            header
            weekStrip
            timeline
        }
        .padding(.top, MomentumMetrics.screenPadding)
        .sheet(item: $editingTask) { task in
            AddTaskView(taskToEdit: task)
        }
    }

    // MARK: - Header

    private var header: some View {
        HStack {
            HStack(spacing: 4) {
                Text(selectedDate.formatted(.dateTime.month(.wide).year()))
                    .font(MomentumFont.title2)
                    .foregroundStyle(MomentumColor.textPrimary)
                Image(systemName: "chevron.down")
                    .font(.caption)
                    .foregroundStyle(MomentumColor.textSecondary)
            }
            Spacer()
            HStack(spacing: 20) {
                Button { shiftWeek(by: -1) } label: {
                    Image(systemName: "chevron.left")
                }
                Button { shiftWeek(by: 1) } label: {
                    Image(systemName: "chevron.right")
                }
            }
            .font(.subheadline.weight(.semibold))
            .foregroundStyle(MomentumColor.textPrimary)
        }
        .padding(.horizontal, MomentumMetrics.screenPadding)
    }

    // MARK: - Week strip

    private var weekDates: [Date] {
        guard let weekStart = calendar.dateInterval(of: .weekOfYear, for: weekAnchor)?.start else { return [] }
        return (0..<7).compactMap { calendar.date(byAdding: .day, value: $0, to: weekStart) }
    }

    private var weekStrip: some View {
        HStack(spacing: 8) {
            ForEach(weekDates, id: \.self) { date in
                let isSelected = calendar.isDate(date, inSameDayAs: selectedDate)
                Button {
                    withAnimation(MomentumAnimation.smooth) { selectedDate = date }
                } label: {
                    VStack(spacing: 6) {
                        Text(date.formatted(.dateTime.weekday(.narrow)))
                            .font(.caption2)
                        Text(date.formatted(.dateTime.day()))
                            .font(.subheadline.weight(.semibold))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(
                        isSelected ? AnyShapeStyle(MomentumColor.amber) : AnyShapeStyle(.ultraThinMaterial),
                        in: RoundedRectangle(cornerRadius: 14, style: .continuous)
                    )
                    .foregroundStyle(isSelected ? .black : MomentumColor.textPrimary)
                }
            }
        }
        .padding(.horizontal, MomentumMetrics.screenPadding)
    }

    private func shiftWeek(by value: Int) {
        if let newAnchor = calendar.date(byAdding: .weekOfYear, value: value, to: weekAnchor) {
            withAnimation(MomentumAnimation.smooth) { weekAnchor = newAnchor }
        }
    }

    // MARK: - Timeline

    private var tasksForSelectedDay: [Task] {
        taskViewModel.tasks
            .filter { task in
                guard let due = task.dueDate else { return false }
                return calendar.isDate(due, inSameDayAs: selectedDate)
            }
            .sorted { ($0.dueDate ?? .distantPast) < ($1.dueDate ?? .distantPast) }
    }

    private var timeline: some View {
        ScrollView {
            ZStack(alignment: .topLeading) {
                VStack(spacing: 0) {
                    ForEach(Array(stride(from: startHour, through: endHour, by: 1)), id: \.self) { hour in
                        HStack(alignment: .top, spacing: 12) {
                            Text(hourLabel(hour))
                                .font(.caption2)
                                .foregroundStyle(MomentumColor.textSecondary)
                                .frame(width: 44, alignment: .leading)
                            Rectangle()
                                .fill(MomentumColor.glassStroke)
                                .frame(height: 1)
                        }
                        .frame(height: hourHeight, alignment: .top)
                    }
                }

                ForEach(tasksForSelectedDay) { task in
                    taskMarker(for: task)
                }
            }
            .padding(.horizontal, MomentumMetrics.screenPadding)
            .padding(.bottom, MomentumMetrics.tabBarReservedHeight)
        }
    }

    private func taskMarker(for task: Task) -> some View {
        Button {
            editingTask = task
        } label: {
            HStack(spacing: 8) {
                Circle().fill(MomentumColor.amber).frame(width: 8, height: 8)
                VStack(alignment: .leading, spacing: 2) {
                    Text(task.title)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(MomentumColor.textPrimary)
                        .lineLimit(1)
                    if let due = task.dueDate {
                        Text(due.formatted(date: .omitted, time: .shortened))
                            .font(.caption2)
                            .foregroundStyle(MomentumColor.textSecondary)
                    }
                }
                Spacer(minLength: 0)
            }
            .padding(10)
            .glassCard(cornerRadius: 12)
        }
        .buttonStyle(.plain)
        .padding(.leading, 56)
        .offset(y: verticalOffset(for: task.dueDate))
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func verticalOffset(for date: Date?) -> CGFloat {
        guard let date else { return 0 }
        let components = calendar.dateComponents([.hour, .minute], from: date)
        let hour = components.hour ?? startHour
        let minute = components.minute ?? 0
        let clampedHour = max(startHour, min(hour, endHour))
        let hoursFromStart = CGFloat(clampedHour - startHour) + CGFloat(minute) / 60
        return hoursFromStart * hourHeight
    }

    private func hourLabel(_ hour: Int) -> String {
        let date = calendar.date(bySettingHour: hour % 24, minute: 0, second: 0, of: Date()) ?? Date()
        return date.formatted(.dateTime.hour())
    }
}

#Preview {
    ZStack {
        MomentumBackground().ignoresSafeArea()
        CalendarScreen()
            .environmentObject(AppDIContainer.preview.taskViewModel)
    }
}
