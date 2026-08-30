//
//  AppDIContainer.swift
//  Momentum
//
//  Created by Shashank Yadav on 03/08/26.
//

import Foundation
import SwiftData


struct AppDIContainer {
    
    let taskRepositry:TaskRepository
    let modelContainer:ModelContainer
    let modelContext:ModelContext
    
    let createTaskUseCase:CreateTaskUseCase
    let fetchTaskUseCase:FetchTaskUseCase
    let deleteTaskUseCase:DeleteTaskUseCase
    let updateTaskUseCase:UpdateTaskUseCase
    
    let taskViewModel:TaskViewModel
    let taskParsingService:TaskParsingService
    
    init() throws {
        
        let container = try ModelContainer(for: SwiftDataTaskModel.self)
        let context  = ModelContext(container)
        let apiClient = UrlSessionAPIClient()
        self.taskParsingService = AITaskParsingService(apiClient: apiClient)
        self.modelContainer = container
        self.modelContext = context
        self.taskRepositry = SwiftDataTaskRepository(modelContext: context)
        
        self.createTaskUseCase = CreateTaskUseCase(repository: taskRepositry)
        self.fetchTaskUseCase = FetchTaskUseCase(repository: taskRepositry)
        self.deleteTaskUseCase = DeleteTaskUseCase(repository: taskRepositry)
        self.updateTaskUseCase = UpdateTaskUseCase(repository: taskRepositry)
    
        self.taskViewModel = TaskViewModel(createTaskUseCase: createTaskUseCase, fetchTaskUseCase: fetchTaskUseCase, deleteTaskUsecase: deleteTaskUseCase, updateTaskUsecase: updateTaskUseCase, taskParsingService: taskParsingService)
        
    }
    
    
    
//    let taskRepositry:TaskRepository
        
}
