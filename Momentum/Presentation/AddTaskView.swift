//
//  AddTaskView.swift
//  Momentum
//
//  Created by Shashank Yadav on 14/08/26.
//

import SwiftUI

struct AddTaskView:View {
    
    @EnvironmentObject var taskViewModel:TaskViewModel
    @Environment(\.dismiss) private var dismiss
    
    let taskToEdit:Task?
    init(taskToEdit:Task? = nil) {
        self.taskToEdit = taskToEdit
    }
    
    var body:some View {
        NavigationStack {
            Form {
                Section("Task"){
                    
                    TextField("Title",text: $taskViewModel.title)
                    
                    TextField("Description", text: $taskViewModel.description)
                    
                }
                
                Section("Details") {
                    DatePicker("Due Date", selection: Binding(get: {
                        taskViewModel.dueDate ?? Date()
                    }, set: { newDate in
                        taskViewModel.dueDate = newDate
                    }))
                    
                    TextField("linkText", text: $taskViewModel.linkText)
                        .keyboardType(.URL)
                        .textInputAutocapitalization(.never)
                }
                
                Section {
                    
                    Button {
                        if let taskToEdit {
                            taskViewModel.updateTask(taskToEdit)
//                            taskViewModel.updateTask(updatedTask)
                        } else {
                            taskViewModel.addTask()
                        }
                        dismiss()
                    } label: {
                        Text( taskToEdit == nil ? "save Task" : "UpdateTask" )
                    }
                }
            }
            .navigationTitle("Add Task")
            .task {
                if let taskToEdit {
                    taskViewModel.title = taskToEdit.title
                    taskViewModel.description = taskToEdit.description ?? ""
                    taskViewModel.dueDate = taskToEdit.dueDate
                    taskViewModel.linkText = taskToEdit.link?.absoluteString ?? ""
                }
            }
        }
    }
}
#Preview {
    AddTaskView(taskToEdit: Task(title: "Meet at ", description: "i have a gooflr meet at 7pm", link: nil, sourceMessageID: nil) )
        .environmentObject(AppDIContainer.preview.taskViewModel)
}
