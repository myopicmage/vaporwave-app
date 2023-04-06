//
//  TaskViewModel.swift
//  vaporwave
//
//  Created by Kevin Bernfeld on 4/6/23.
//

import Foundation

class TaskViewModel: ObservableObject {
    @Published var tasks: [VaporwaveTask] = []
    @Published var error: String?
    
    let token: String
    
    init(token: String) {
        self.token = token
    }
    
    @MainActor
    func getTasks() async {
//        do {
//            tasks = try await _getTasks()
//        } catch {
//            self.error = error as? String
//        }
        tasks.append(VaporwaveTask(task: "Fuck"))
        tasks.append(VaporwaveTask(task: "Me"))
        tasks.append(VaporwaveTask(task: "Sideways"))
    }
    
    func newTask() {
        tasks.append(VaporwaveTask())
    }
    
    private func _getTasks() async throws -> [VaporwaveTask] {
        let url = "http://localhost:8080/tasks"
        
        guard let url = URL(string: url) else {
            throw "Unable to encode url"
        }
        
        var request = URLRequest(url: url)
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        guard let (data, response) = try? await URLSession.shared.data(for: request) else {
            throw "A server error occurred"
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw "A server error occurred"
        }
        
        switch httpResponse.statusCode {
        case 400: throw "Bad request"
        case 401: throw "Unauthorized"
        default: break
        }
        
        do {
            return try self.parse(data)
        } catch {
            throw "Unable to decode tasks"
        }
    }
    
    private func parse(_ data: Data) throws -> [VaporwaveTask] {
        let decoder = JSONDecoder()
        
        let decodedData = try decoder.decode([VaporwaveTask].self, from: data)
        
        return decodedData
    }
}
