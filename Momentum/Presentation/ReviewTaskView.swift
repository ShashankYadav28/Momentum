//
//  ReviewTaskView.swift
//  Momentum
//
//  Shows the task Gemini extracted so the user can review and edit it
//  before anything is saved. Nothing is persisted until "Confirm Task"
//  is pressed; "Discard" (or dismissing the sheet) abandons it.
//
//  Visual language restyled to the approved dark/glass/amber Momentum
//  identity. All original bindings, validation, and confirm/discard
//  logic are preserved unchanged.
//

import SwiftUI

struct ReviewTaskView: View {

    @EnvironmentObject private var taskViewModel: TaskViewModel
    @Environment(\.dismiss) private var dismiss
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @FocusState private var focusedField: Field?

    private enum Field: Hashable {
        case title
        case description
        case link
    }

    /// The task Gemini produced, mapped through the existing TaskMapper.
    /// This is held only in view state until the user confirms it.
    let pendingTask: Task

    /// Optional presentation-layer hooks so a parent flow (the
    /// TaskCreationCoordinator) can react to confirm/discard without this
    /// view needing to know anything about that flow. Both default to nil
    /// so existing call sites and previews keep working unchanged.
    var onConfirmed: (() -> Void)? = nil
    var onDiscarded: (() -> Void)? = nil

    @State private var title: String
    @State private var description: String
    @State private var dueDate: Date?
    @State private var linkText: String
    @State private var showTitleValidationError = false
    @State private var hasAppeared = false

    init(pendingTask: Task, onConfirmed: (() -> Void)? = nil, onDiscarded: (() -> Void)? = nil) {
        self.pendingTask = pendingTask
        self.onConfirmed = onConfirmed
        self.onDiscarded = onDiscarded
        _title = State(initialValue: pendingTask.title)
        _description = State(initialValue: pendingTask.description ?? "")
        _dueDate = State(initialValue: pendingTask.dueDate)
        _linkText = State(initialValue: pendingTask.link?.absoluteString ?? "")
    }

    private var isRegularWidth: Bool { horizontalSizeClass == .regular }
    private var contentPadding: CGFloat { isRegularWidth ? 40 : 20 }
    private var maxContentWidth: CGFloat { isRegularWidth ? 560 : .infinity }

    var body: some View {
        VStack(spacing: 0) {
            header
                .padding(.horizontal, contentPadding)
                .padding(.top, 12)
                .padding(.bottom, 20)
                .frame(maxWidth: maxContentWidth)
                .frame(maxWidth: .infinity)

            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    cascading(index: 0) { titleField }
                    cascading(index: 1) { descriptionField }
                    cascading(index: 2) { dueDateTimeField }
                    cascading(index: 3) { linkField }
                }
                .padding(.horizontal, contentPadding)
                .padding(.bottom, 24)
                .frame(maxWidth: maxContentWidth)
                .frame(maxWidth: .infinity)
            }
            .scrollDismissesKeyboard(.interactively)

            actionArea
                .padding(.horizontal, contentPadding)
                .padding(.top, 12)
                .padding(.bottom, 8)
                .frame(maxWidth: maxContentWidth)
                .frame(maxWidth: .infinity)
        }
        .background(MomentumBackground().ignoresSafeArea())
        .onAppear {
            withAnimation(MomentumAnimation.smooth) {
                hasAppeared = true
            }
        }
    }

    /// A subtle staggered fade/slide entrance for each field, driven purely
    /// by view-appearance state — no business logic involved.
    @ViewBuilder
    private func cascading<Content: View>(index: Int, @ViewBuilder content: () -> Content) -> some View {
        content()
            .opacity(hasAppeared ? 1 : 0)
            .offset(y: hasAppeared ? 0 : 10)
            .animation(MomentumAnimation.smooth.delay(Double(index) * 0.06), value: hasAppeared)
    }

    // MARK: - Header

    private var header: some View {
        HStack(alignment: .top, spacing: 12) {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(MomentumColor.textPrimary)
                    .frame(width: 44, height: 44)
                    .contentShape(Rectangle())
            }
            .accessibilityLabel("Back")

            VStack(alignment: .leading, spacing: 2) {
                Text("Review Task")
                    .font(.title2.weight(.bold))
                    .foregroundStyle(MomentumColor.textPrimary)
                Text("Make sure everything looks right.")
                    .font(.subheadline)
                    .foregroundStyle(MomentumColor.textSecondary)
            }

            Spacer(minLength: 8)

            Label("AI extracted", systemImage: "sparkles")
                .font(.caption.weight(.semibold))
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(MomentumColor.amber.opacity(0.16), in: Capsule())
                .foregroundStyle(MomentumColor.amber)
                .accessibilityLabel("This task was extracted by AI")
        }
    }

    // MARK: - Title

    private var titleField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Title")
                .font(.subheadline)
                .foregroundStyle(MomentumColor.textSecondary)

            TextField("Task title", text: $title, axis: .vertical)
                .font(.title3.weight(.semibold))
                .foregroundStyle(MomentumColor.textPrimary)
                .textFieldStyle(.plain)
                .focused($focusedField, equals: .title)
                .onChange(of: title) { _ , _ in showTitleValidationError = false }
                .padding(14)
                .glassCard(cornerRadius: MomentumMetrics.smallCornerRadius)

            if showTitleValidationError {
                Text("Title can't be empty.")
                    .font(.footnote)
                    .foregroundStyle(.red)
                    .accessibilityLabel("Title can't be empty")
            }
        }
    }

    // MARK: - Description

    private var descriptionField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Description")
                .font(.subheadline)
                .foregroundStyle(MomentumColor.textSecondary)

            ZStack(alignment: .topLeading) {
                if description.isEmpty {
                    Text("Add more detail")
                        .font(.body)
                        .foregroundStyle(MomentumColor.textSecondary.opacity(0.7))
                        .padding(.horizontal, 18)
                        .padding(.vertical, 20)
                        .allowsHitTesting(false)
                }

                TextEditor(text: $description)
                    .font(.body)
                    .foregroundStyle(MomentumColor.textPrimary)
                    .focused($focusedField, equals: .description)
                    .scrollContentBackground(.hidden)
                    .padding(10)
                    .frame(minHeight: 110)

            }
            .glassCard(cornerRadius: MomentumMetrics.smallCornerRadius)
        }
    }

    // MARK: - Due date & time

    private var dueDateTimeField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Due date & time")
                .font(.subheadline)
                .foregroundStyle(MomentumColor.textSecondary)
            
            if let dueDate {
                HStack(spacing: 12) {
                    dueRow(icon: "calendar", accessibilityLabel: "Due date") {
                        DatePicker("Due date", selection: Binding(get: {
                            dueDate
                        }, set: { self.dueDate = $0
                        }), displayedComponents: .date)
                            .labelsHidden()
                    }

                    dueRow(icon: "clock", accessibilityLabel: "Due time") {
                        DatePicker("Due time", selection: Binding(get: {
                            dueDate
                        }, set: { self.dueDate = $0
                        }), displayedComponents: .hourAndMinute)
                            .labelsHidden()
                    }
                }
                
                Button("Remove Due date") {
                    self.dueDate = nil
                }
                .font(.footnote)
                .foregroundStyle(MomentumColor.amber)
            } else {
                HStack {

                    Image(systemName: "calendar")
                        .foregroundStyle(MomentumColor.textSecondary)

                    Text("No due date")
                        .foregroundStyle(MomentumColor.textSecondary)

                    Spacer()

                    Button("Add") {
                        dueDate = Date()
                    }
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(MomentumColor.amber)

                }
                .padding(.horizontal, 14)
                .frame(minHeight: 44)
                .glassCard(cornerRadius: MomentumMetrics.smallCornerRadius)
            }
            
        }
    }

    private func dueRow<Content: View>(
        icon: String,
        accessibilityLabel: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .foregroundStyle(MomentumColor.textSecondary)
            content()
                .accessibilityLabel(accessibilityLabel)
            Spacer(minLength: 0)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity, minHeight: 44)
        .glassCard(cornerRadius: MomentumMetrics.smallCornerRadius)
    }

    // MARK: - Link

    private var linkField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Link (optional)")
                .font(.subheadline)
                .foregroundStyle(MomentumColor.textSecondary)

            HStack(spacing: 10) {
                Image(systemName: "link")
                    .foregroundStyle(MomentumColor.textSecondary)

                TextField("Add a link", text: $linkText)
                    .foregroundStyle(MomentumColor.textPrimary)
                    .keyboardType(.URL)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .focused($focusedField, equals: .link)
                    .accessibilityLabel("Link")

                if !linkText.isEmpty {
                    Button {
                        linkText = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(MomentumColor.textSecondary)
                    }
                    .accessibilityLabel("Remove link")
                }
            }
            .padding(.horizontal, 14)
            .frame(minHeight: 44)
            .glassCard(cornerRadius: MomentumMetrics.smallCornerRadius)
        }
    }

    // MARK: - Actions

    private var actionArea: some View {
        VStack(spacing: 10) {
            Button {
                confirm()
            } label: {
                Text("Confirm")
            }
            .buttonStyle(MomentumPrimaryButtonStyle())
            .accessibilityLabel("Confirm Task")
            .accessibilityHint("Saves this task")

            Button {
                discard()
            } label: {
                Text("Discard")
            }
            .buttonStyle(MomentumSecondaryButtonStyle())
            .accessibilityLabel("Discard")
            .accessibilityHint("Discards this task without saving it")
        }
    }

    // MARK: - Actions logic

    private func confirm() {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedTitle.isEmpty else {
            showTitleValidationError = true
            focusedField = .title
            return
        }

        var confirmedTask = pendingTask
        confirmedTask.title = trimmedTitle

        let trimmedDescription = description.trimmingCharacters(in: .whitespacesAndNewlines)
        confirmedTask.description = trimmedDescription.isEmpty ? nil : trimmedDescription

        confirmedTask.dueDate = dueDate

        let trimmedLink = linkText.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedLink.isEmpty {
            confirmedTask.link = nil
        } else if let url = URL(string: trimmedLink), url.scheme == "https" || url.scheme == "http" {
            confirmedTask.link = url
        }
        // If the link text doesn't parse as a valid http(s) URL, we simply
        // keep the previously-extracted link rather than inventing a new
        // validation framework for this screen.

        taskViewModel.confirmReviewedTask(confirmedTask)
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        onConfirmed?()
    }

    private func discard() {
        taskViewModel.discardReviewedTask()
        onDiscarded?()
    }
}

#Preview("Light") {
    ReviewTaskView(
        pendingTask: Task(
            title: "Submit DSA assignment",
            description: "Submit the assignment through the course portal.",
            dueDate: nil
            ,
            link: URL(string: "https://example.com")
        )
    )
    .environmentObject(AppDIContainer.preview.taskViewModel)
}

#Preview("Dark") {
    ReviewTaskView(
        pendingTask: Task(
            title: "Submit DSA assignment",
            description: "Submit the assignment through the course portal.",
            dueDate: nil,
            link: URL(string: "https://example.com")
        )
    )
    .environmentObject(AppDIContainer.preview.taskViewModel)
    .preferredColorScheme(.dark)
}
