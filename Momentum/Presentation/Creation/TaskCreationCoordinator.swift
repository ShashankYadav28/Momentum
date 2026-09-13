//
//  TaskCreationCoordinator.swift
//  Momentum
//
//  Coordinates the SAME AI task-creation flow regardless of whether it was
//  started from onboarding, Home, List, or Calendar. It never duplicates
//  AI/business logic — it only calls the existing TaskViewModel methods
//  (executeParse / confirmReviewedTask / discardReviewedTask) and tracks
//  which screen should be shown next and which tab to return to.
//
//  This is presentation/navigation state only.
//

import Foundation
import Combine

@MainActor
final class TaskCreationCoordinator: ObservableObject {

    @Published var step: CreationFlowStep?

    /// Whether the flow currently running is the very first (onboarding)
    /// task-creation flow, kept only in case the presentation ever needs
    /// to special-case that first run (e.g. different copy).
    private(set) var isFirstLaunchFlow: Bool = false

    /// The tab the flow was started from, so we can return there after
    /// "Continue" — see requirement 15 (return to the appropriate screen).
    private(set) var originTab: AppTab = .home

    func start(from tab: AppTab, isFirstLaunch: Bool = false) {
        originTab = tab
        isFirstLaunchFlow = isFirstLaunch
        step = .pasteMessage
    }

    func cancel() {
        step = nil
    }

    /// Moves to the AI Extracting screen and drives the existing, real
    /// TaskParsingService via TaskViewModel.executeParse. No fake progress
    /// or fake extraction is introduced here.
    func beginExtraction(message: String, taskViewModel: TaskViewModel) {
        guard !message.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        step = .extracting

        _Concurrency.Task {
            await taskViewModel.executeParse(message: message)
            if let pendingTask = taskViewModel.taskBeingreviewed {
                step = .review(pendingTask)
            } else {
                // Extraction failed (taskViewModel.errorMessage is set).
                // Send the user back to Paste Message so they can see the
                // error and retry, rather than getting stuck on a dead end.
                step = .pasteMessage
            }
        }
    }

    /// Called after ReviewTaskView has already persisted the task through
    /// the existing TaskViewModel/CreateTaskUseCase pipeline.
    func advanceToCreated() {
        step = .created
    }

    /// Ends the flow and reports which tab the caller should switch back to.
    @discardableResult
    func finish() -> AppTab {
        let tab = originTab
        step = nil
        return tab
    }
}
