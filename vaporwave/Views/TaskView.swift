//
//  TaskView.swift
//  vaporwave
//
//  Created by Kevin Bernfeld on 4/6/23.
//

import SwiftUI

struct TaskView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @EnvironmentObject var tasks: TaskViewModel
    @EnvironmentObject var navModel: NavigationModel
    
    var body: some View {
        NavigationSplitView {
            if tasks.tasks.count == 0 {
                Text("No tasks!")
            } else {
                List(tasks.tasks, selection: $navModel.selectedTask) { task in
                    NavigationLink(task.task, value: task)
                }
            }
        } detail: {
            NavigationStack(path: $navModel.taskPath) {
                TaskDetail(task: navModel.selectedTask)
            }
        }.toolbar {
            ToolbarItemGroup {
                Button {
                    tasks.newTask()
                } label: {
                    Label("Add", systemImage: "plus")
                }
            }
        }.onAppear {
            Task {
                await tasks.getTasks()
            }
        }
    }
}

struct TaskView_Previews: PreviewProvider {
    static var previews: some View {
        TaskView()
    }
}
