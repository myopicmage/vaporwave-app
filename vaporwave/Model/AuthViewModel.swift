//
//  AuthViewModel.swift
//  vaporwave
//
//  Created by Kevin Bernfeld on 4/6/23.
//

import Foundation

enum ApiError: Error {
    case serverError
    case urlError
    case encodeError
    case decodeError
    case unauthorized
    case badRequest
    case unknownError
}

enum AuthAction {
    case register, login
}

class AuthViewModel: ObservableObject {
    let tokenKey = "apiToken"
    
    @Published var token: String?
    
    init() {
        if let storedToken = UserDefaults.standard.string(forKey: tokenKey) {
            self.token = storedToken
        }
    }
    
    @MainActor
    func auth(username: String, password: String, action: AuthAction) async -> String? {
        do {
            try await runAuth(username: username, password: password, action: action)
        } catch ApiError.urlError {
            return "Invalid URL"
        } catch ApiError.serverError {
            return "An unknown server error occurred"
        } catch ApiError.decodeError {
            return "Unable to decode server response"
        } catch ApiError.unknownError {
            return "An unknown error occurred"
        } catch ApiError.unauthorized {
            return "Username or password is wrong"
        } catch {
            return "An unknown error occurred"
        }
        
        return nil
    }
    
    
    func runAuth(username: String, password: String, action: AuthAction) async throws {
        let url: String
        
        switch action {
        case .login: url = "http://localhost:8080/auth/login"
        case .register: url = "http://localhost:8080/auth/register"
        }
        
        guard let url = URL(string: url) else {
            throw ApiError.urlError
        }
        
        guard let body = try? JSONEncoder().encode(AuthRequest(username: username, password: password)) else {
            throw ApiError.encodeError
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = body
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw ApiError.serverError
        }
        
        switch httpResponse.statusCode {
        case 400: throw ApiError.badRequest
        case 401: throw ApiError.unauthorized
        default: break
        }
        
        do {
            let tokenResponse = try self.parse(data)
            
            await setToken(tokenResponse.token)
        } catch {
            throw ApiError.decodeError
        }
    }
    
    func parse(_ data: Data) throws -> ClientTokenResponse {
        let decoder = JSONDecoder()
        
        let decodedData = try decoder.decode(ClientTokenResponse.self, from: data)
        
        return decodedData
    }
    
    @MainActor
    private func setToken(_ token: String?) {
        if let token {
            UserDefaults.standard.set(token, forKey: tokenKey)
        } else {
            UserDefaults.standard.removeObject(forKey: tokenKey)
        }
        
        self.token = token
    }
    
    @MainActor
    func logout() {
        setToken(nil)
    }
 }
