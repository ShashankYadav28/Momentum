//
//  HomeScreen.swift
//  Momentum
//
//  Created by Shashank Yadav on 11/08/26.
//

import SwiftUI

struct HomeScreen:View  {
    @State var showTask = false
    @EnvironmentObject var taskViewModel:TaskViewModel
    var body: some View {
        VStack(alignment: .leading, spacing:20) {
            HomeHeader()
            PasteCard()
            TodayFocus(showTask: {
                showTask = true
            })
            Statistics()
            Spacer()
//            Spacer()

        }
        .padding()
        .sheet(isPresented: $showTask) {
            AddTaskView()
        }
        .task {
            taskViewModel.fetchTasks()
        }
    }
}
#Preview {
    HomeScreen()
        .environmentObject(AppDIContainer.preview.taskViewModel)
}

struct HomeHeader:View {
    var body: some View {
        HStack {
            VStack(alignment: .leading,spacing: 2){
                Text("Good Morning")
                    .font(.title2)
                Text("Shashank 👋")
                    .font(.title2)
            }
            Spacer()
            
            Button {
                
            }label: {
                Image(systemName: "plus")
                    .font(.title2)
                    .frame(width: 44,height: 44)
                    .background(.thinMaterial,in: Circle())
                    
            }
        }

    }
}

struct PasteCard:View {
    
    @State private var message = ""
    
    var body :some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading){
                Text("+ Paste Message")
                    .font(.headline)
                Text("Turn messages into tasks")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            TextEditor(text: $message)
                .frame(height: 70)
                .overlay {
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.secondary.opacity(0.7),lineWidth: 1)
                }
            
            Button {
                
            } label: {
                Label("Extract Tasks", systemImage: "sparkles")
                    .frame(maxWidth: .infinity)
                    
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .background(.regularMaterial,in: RoundedRectangle(cornerRadius: 20))
    }
    
}

struct TodayFocus:View {
    
    @EnvironmentObject var taskViewModel:TaskViewModel
    let showTask: () -> Void
    
    var body:some View {
        VStack(alignment: .leading, spacing: 12){
            Text("Today's Focus")
                .font(.headline)
            
            VStack(spacing: 15){
                if taskViewModel.tasks.isEmpty {
                    Image(systemName: "clock")
                        .font(.system(size: 60))
                        .foregroundStyle(.secondary)
                    
                    Text("Nothing Planned yet. Add a task or paste a message ")
                        .multilineTextAlignment(.center)
    //                    .lineLimit(2)
                    
                    HStack(spacing: 12){
                        Button {
                            showTask()
                        } label: {
                            Label("Add task", systemImage: "plus")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.bordered)
                        
                        Button {
                            
                        } label: {
                            Label("Paste Message", systemImage: "sparkles")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
                else {
                    ForEach(taskViewModel.tasks) { task in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(task.title)
                                    .font(.headline)
                                if let description = task.description {
                                    Text(description)
                                        .foregroundStyle(.secondary)
                                }
                                
                                if let dueDate = task.dueDate {
                                    Text(dueDate.formatted(date: .abbreviated, time: .shortened))
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                            Spacer()
                            Button {
                                taskViewModel.toggleTaskCompletion(task)
                            } label: {
                                Image(systemName: task.isCompleted ? "circle.fill" : "circle")
                                    .font(.title2)
                            }
                        }
                        .frame(maxWidth: .infinity,alignment: .leading)
                        .padding()
                        .background(
                            .regularMaterial,in: RoundedRectangle(cornerRadius: 20)
                        )
                    }
                }
            }
            .frame(maxWidth: .infinity)
        }
        .frame(maxWidth:.infinity)
    }
}

struct Statistics:View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Statistics")
                    .font(.headline)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            VStack(spacing: 16) {
                Text("Complete a task to Start Tracking your Stats")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                
                Circle()
                    .stroke(.secondary.opacity(0.4),lineWidth: 8)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(.regularMaterial,in: RoundedRectangle(cornerRadius: 20))
        }
        .frame(maxWidth: .infinity)
    }
}
