//
//  TaskRowCard.swift
//  Momentum
//
//  A single reusable "glass" task row used on Home, List, and Calendar so
//  the same task presentation and interactions aren't duplicated across
//  screens (per the Momentum code-quality requirements).
//

import SwiftUI

struct TaskRowCard: View {
    let task: Task
    let onToggle: () -> Void
    let onEdit: () -> Void
    let onDelete: () -> Void

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Button(action: onToggle) {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundStyle(task.isCompleted ? MomentumColor.amber : MomentumColor.textSecondary)
                    .frame(width: 30, height: 30)
                    .contentShape(Rectangle())
            }
            .accessibilityLabel(task.isCompleted ? "Mark \(task.title) as not completed" : "Mark \(task.title) as completed")

            VStack(alignment: .leading, spacing: 4) {
                Text(task.title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(MomentumColor.textPrimary)
                    .strikethrough(task.isCompleted)
                    .lineLimit(2)

                if let description = task.description, !description.isEmpty {
                    Text(description)
                        .font(.footnote)
                        .foregroundStyle(MomentumColor.textSecondary)
                        .lineLimit(2)
                }

                if let dueDate = task.dueDate {
                    Label(dueDate.formatted(date: .abbreviated, time: .shortened), systemImage: "clock")
                        .font(.caption2.weight(.medium))
                        .foregroundStyle(MomentumColor.amber)
                }
            }

            Spacer(minLength: 0)
        }
        .padding(14)
        .glassCard(cornerRadius: MomentumMetrics.smallCornerRadius)
        .contextMenu {
            Button(action: onEdit) {
                Label("Edit", systemImage: "pencil")
            }
            Button(role: .destructive, action: onDelete) {
                Label("Delete", systemImage: "trash")
            }
        }
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    ZStack {
        MomentumBackground().ignoresSafeArea()
        TaskRowCard(
            task: Task(title: "Submit DSA assignment", description: "Upload the final solution to the course portal.", dueDate: Date(), link: nil, sourceMessageID: nil),
            onToggle: {},
            onEdit: {},
            onDelete: {}
        )
        .padding()
    }
}
