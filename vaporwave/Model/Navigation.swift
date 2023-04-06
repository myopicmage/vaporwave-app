//
//  Navigation.swift
//  vaporwave
//
//  Created by Kevin Bernfeld on 4/6/23.
//

import SwiftUI

final class NavigationModel: ObservableObject {
    @Published var selectedTask: VaporwaveTask?
    @Published var taskPath: [VaporwaveTask] = []
}
