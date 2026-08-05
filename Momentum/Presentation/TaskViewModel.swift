//
//  TaskViewModel.swift
//  Momentum
//
//  Created by Shashank Yadav on 03/08/26.
//

import Foundation
import Combine

final class TaskViewModel: ObservableObject {
    
    private let createTaskUseCase:CreateTaskUseCase
    @Published var title = ""
    @Published var description = ""
    @Published var dueDate:Date?
    @Published var linkText = ""
    @Published var errorMessage:String?
    
    init(createTaskUseCase: CreateTaskUseCase) {
        self.createTaskUseCase = createTaskUseCase
    }
    
    func addTask() {
        
        //        guard !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
        //            errorMessage =  "Title Not Found "
        //            return
        //        }
        guard let task = createTaskFromInput() else {
            return
        }
        
        do {
            try createTaskUseCase.execute(task: task)
            clearForm()
            
        } catch {
            errorMessage = error.localizedDescription
        }
        
        
    }
    
    private func createTaskFromInput() -> Task? {
        
        
        //       let link  = linkText.isEmpty ? nil: URL(string: linkText)
        var link:URL?
        
        // url scheme i would be using as i want the urls that looks like web Url
        if !linkText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            guard let url = URL(string: linkText),
                  url.scheme == "https" || url.scheme == "http"
            else {
                errorMessage = "PLease enter a Valid Url"
                return nil
            }
            link = url
        }
        
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedTitle.isEmpty else {
            errorMessage = "Title Not Found"
            return nil
        }
        let trimmedDescription = description.trimmingCharacters(in: .whitespacesAndNewlines)
        let finalDescription = trimmedDescription.isEmpty ? nil : trimmedDescription
        let task = Task(title: trimmedTitle, description: finalDescription, dueDate: dueDate, link: link)
        return task
        
        
    }
    
    private func clearForm() {
        title = ""
        description = ""
        dueDate = nil
        linkText = ""
        errorMessage  = nil
    }
}
