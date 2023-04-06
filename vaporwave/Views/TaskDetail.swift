//
//  TaskDetail.swift
//  vaporwave
//
//  Created by Kevin Bernfeld on 4/6/23.
//

import SwiftUI

struct TaskDetail: View {
    var task: VaporwaveTask?
    
    var body: some View {
        VStack {
            Text("Task name")
            Text(task?.task ?? "")
        }
    }
}

struct TaskDetail_Previews: PreviewProvider {
    static var previews: some View {
        TaskDetail(task: VaporwaveTask())
    }
}
