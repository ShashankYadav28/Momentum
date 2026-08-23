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
    private let fetchTaskUseCase:FetchTaskUseCase
    private let deleteTaskuseCase:DeleteTaskUseCase
    private let updateTaskusecase:UpdateTaskUseCase
    
    @Published var title = ""
    @Published var description = ""
    @Published var dueDate:Date?
    @Published var linkText = ""
    @Published var errorMessage:String?
    @Published var tasks:[Task] = []
    @Published var taskToedit:Task?

//    @Published var taskBeingEdited: Task?
    
    init(createTaskUseCase: CreateTaskUseCase,fetchTaskUseCase:FetchTaskUseCase,deleteTaskUsecase : DeleteTaskUseCase ,updateTaskUsecase: UpdateTaskUseCase) {
        
        self.createTaskUseCase = createTaskUseCase
        self.fetchTaskUseCase = fetchTaskUseCase
        self.deleteTaskuseCase = deleteTaskUsecase
        self.updateTaskusecase = updateTaskUsecase
        
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
            print("Tasks saved",task.title)
            fetchTasks()
            clearForm()
            
        } catch {
            errorMessage = error.localizedDescription
        }

    }
    
    func fetchTasks() {
        do  {
            let fetchedTasks = try fetchTaskUseCase.fetch()
            print("fetched Task: \(fetchedTasks.count)")
            tasks = fetchedTasks
            
        } catch {
            print(" Fetch Error: ", error)
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
    
    func deleteTask( _ task:Task) {
        do {
            try deleteTaskuseCase.delete(task: task)
            fetchTasks()
        }
        catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func updateTask(_ task:Task) {
        
        var updatedTask = task
        updatedTask.title = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedDescription = description.trimmingCharacters(in: .whitespacesAndNewlines)
        updatedTask.description = trimmedDescription.isEmpty ? nil : trimmedDescription
        updatedTask.dueDate = dueDate
        
        if linkText.isEmpty {
            updatedTask.link = nil
        } else {
            updatedTask.link = URL(string: linkText)
        }
        
        do {
            try updateTaskusecase.update(task: updatedTask)
            fetchTasks()
        } catch  {
            errorMessage = error.localizedDescription
        }
    }
    private func clearForm() {
        
        title = ""
        description = ""
        dueDate = nil
        linkText = ""
        errorMessage  = nil
        
    }
    
    func toggleTaskCompletion(_ task:Task) {
        var updatedTask = task
        updatedTask.isCompleted.toggle()
        
        do {
            try updateTaskusecase.update(task: updatedTask)
            fetchTasks()
        } catch {
            errorMessage = error.localizedDescription
        }
//        updateTaskusecase.update(task: updatedTask)
        
    }
}
