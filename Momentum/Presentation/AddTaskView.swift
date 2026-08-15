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
                        taskViewModel.addTask()
                        dismiss()
                    } label: {
                        Text("save Task")
                    }
            
                }
            }
            .navigationTitle("Add Task")
        }
    }
}
#Preview {
    AddTaskView()
        .environmentObject(AppDIContainer.preview.taskViewModel)
}
