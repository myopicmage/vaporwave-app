//
//  LoginView.swift
//  vaporwave
//
//  Created by Kevin Bernfeld on 4/6/23.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authVM: AuthViewModel
    
    @State private var username: String = "testme"
    @State private var password: String = "testmetestmetestme"
    @State private var action: AuthAction = .login
    @State private var error: String?
    @State private var loading: Bool = false
    
    func runAuth() {
        guard !username.isEmpty && !password.isEmpty else {
            error = "You must enter your username and password"
            return
        }
        
        Task {
            error = await authVM.auth(
                username: username,
                password: password,
                action: .login
            )
        }
    }
    
    var body: some View {
        Spacer()
        HStack {
            Spacer()
            Form {
                if let error {
                    Text(error).foregroundColor(.red)
                }
                
                TextField("Username:", text: $username)
                    .autocorrectionDisabled(true)
                SecureField("Password:", text: $password)
                
                HStack {
                    if action == .login {
                        Button("Login", action: runAuth)
                            .disabled(loading)
                        Button("I'm new") {
                            action = .register
                        }.buttonStyle(.link)
                    }
                    
                    if action == .register {
                        Button("Register", action: runAuth)
                            .disabled(loading)
                        Button("I have an account") {
                            action = .login
                        }.buttonStyle(.link)
                    }
                }
            }.onSubmit(runAuth)
            Spacer()
        }
        Spacer()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
