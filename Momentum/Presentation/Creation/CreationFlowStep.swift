//
//  CreationFlowStep.swift
//  Momentum
//
//  Represents where the user is in the AI task-creation flow:
//  Paste Message -> AI Extracting -> Review Task -> Task Created.
//
//  This is pure presentation/navigation state — it holds no business
//  logic and does not affect how tasks are parsed, validated, or saved.
//

import Foundation

enum CreationFlowStep: Identifiable, Equatable {
    case pasteMessage
    case extracting
    case review(Task)
    case created

    var id: String {
        switch self {
        case .pasteMessage: return "pasteMessage"
        case .extracting: return "extracting"
        case .review(let task): return "review-\(task.id.uuidString)"
        case .created: return "created"
        }
    }

    static func == (lhs: CreationFlowStep, rhs: CreationFlowStep) -> Bool {
        lhs.id == rhs.id
    }
}
