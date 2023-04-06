//
//  ContentView.swift
//  vaporwave
//
//  Created by Kevin Bernfeld on 4/6/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var authVM = AuthViewModel()
    @StateObject private var navModel = NavigationModel()
    
    var body: some View {
        if authVM.token == nil {
            LoginView().environmentObject(authVM)
        } else {
            TaskView()
                .environmentObject(authVM)
                .environmentObject(TaskViewModel(token: authVM.token!))
                .environmentObject(navModel)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
