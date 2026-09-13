//
//  PasteMessageView.swift
//  Momentum
//
//  The "Paste a message" creation surface. Presented full-screen (via
//  TaskCreationCoordinator + fullScreenCover) so it never has to fight
//  with the bottom tab bar, and so the surface can size itself freely
//  around the keyboard without any fixed-height sheet detents.
//
//  Responsive behavior:
//  - No fixed heights: the card sizes to its content between two Spacers.
//  - Long pasted text scrolls inside a bounded ScrollView instead of
//    growing the card past the screen.
//  - Standard SwiftUI keyboard avoidance (no `.ignoresSafeArea(.keyboard)`
//    is used on the interactive content) keeps the Extract Task button
//    above the keyboard.
//  - Dynamic Type is respected; nothing here hardcodes point sizes for text.
//

import SwiftUI

struct PasteMessageView: View {
    @EnvironmentObject private var taskViewModel: TaskViewModel
    @Environment(\.dismiss) private var dismiss
    @FocusState private var isEditorFocused: Bool

    let onExtract: (String) -> Void

    private let maxLength = 1000

    var body: some View {
        ZStack {
            MomentumBackground().ignoresSafeArea()

            VStack {
                Spacer(minLength: 12)
                card
                Spacer(minLength: 12)
            }
            .padding(.horizontal, MomentumMetrics.screenPadding)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .onAppear {
            // Give the keyboard a beat so the presentation animation isn't
            // fighting the keyboard animation.
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                isEditorFocused = true
            }
        }
    }

    private var card: some View {
        VStack(alignment: .leading, spacing: 16) {
            header

            ScrollView {
                textEditor
            }
            .frame(maxHeight: 220)

            HStack {
                Spacer()
                Text("\(taskViewModel.message.count)/\(maxLength)")
                    .font(.caption2)
                    .foregroundStyle(MomentumColor.textSecondary)
            }

            Button {
                isEditorFocused = false
                onExtract(taskViewModel.message)
            } label: {
                Label("Extract Task", systemImage: "sparkles")
            }
            .buttonStyle(MomentumPrimaryButtonStyle(isEnabled: canExtract))
            .disabled(!canExtract)

            if let errorMessage = taskViewModel.errorMessage {
                Text(errorMessage)
                    .font(.footnote)
                    .foregroundStyle(.red)
                    .accessibilityLabel("Error: \(errorMessage)")
            }
        }
        .padding(20)
        .glassCard(cornerRadius: 28)
        .frame(maxWidth: 480)
    }

    private var header: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Paste a message")
                    .font(MomentumFont.title3)
                    .foregroundStyle(MomentumColor.textPrimary)
                Text("Paste a WhatsApp message, email, or any text containing something you need to do.")
                    .font(.footnote)
                    .foregroundStyle(MomentumColor.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer(minLength: 12)
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(MomentumColor.textPrimary)
                    .frame(width: 30, height: 30)
                    .background(.thinMaterial, in: Circle())
            }
            .accessibilityLabel("Close")
        }
    }

    private var textEditor: some View {
        ZStack(alignment: .topLeading) {
            if taskViewModel.message.isEmpty {
                Text("Hey, don't forget to submit the assignment by Friday at 6 PM...")
                    .font(.body)
                    .foregroundStyle(MomentumColor.textSecondary.opacity(0.7))
                    .padding(.horizontal, 14)
                    .padding(.vertical, 16)
                    .allowsHitTesting(false)
            }

            TextEditor(text: Binding(
                get: { taskViewModel.message },
                set: { taskViewModel.message = String($0.prefix(maxLength)) }
            ))
            .font(.body)
            .foregroundStyle(MomentumColor.textPrimary)
            .focused($isEditorFocused)
            .scrollContentBackground(.hidden)
            .padding(10)
            .frame(minHeight: 130)
        }
        .background(Color.white.opacity(0.06), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(MomentumColor.glassStroke, lineWidth: 1)
        )
        .accessibilityLabel("Message text")
    }

    private var canExtract: Bool {
        !taskViewModel.message.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}

#Preview {
    PasteMessageView(onExtract: { _ in })
        .environmentObject(AppDIContainer.preview.taskViewModel)
}
