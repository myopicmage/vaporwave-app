//
//  Task.swift
//  vaporwave
//
//  Created by Kevin Bernfeld on 4/6/23.
//

import Foundation

enum TaskStatus: String, Codable {
  case notStarted, inProgress, finished, delayed
}

enum TaskPriority: String, Codable {
  case low, medium, high, urgent
}

struct VaporwaveTask: Codable, Identifiable, Hashable {
    var id: UUID?
    var task: String = ""
    var date: Date?
    var status: TaskStatus = .notStarted
    var notes: String?
    var priority: TaskPriority = .medium
    var createdAt: Date?
    var updatedAt: Date?
    
    init(id: UUID? = nil) {
        if let id {
            self.id = id
        } else {
            self.id = UUID()
        }
    }
    
    init(id: UUID? = nil, task: String) {
        if let id {
            self.id = id
        } else {
            self.id = UUID()
        }
        
        self.task = task
    }
}
