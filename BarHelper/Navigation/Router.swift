//
//  NavigationUtils.swift
//  BarHelper
//
//  Created by Владислав Пермяков on 29.06.2023.
//

import Foundation
import SwiftUI
import Combine

@MainActor
/// Class that controls the path for the navigationView
final class Router: ObservableObject {
    /// path with navigation
    @Published var path = [Destination]() {
        willSet {
            self.toolbar = nil
        }
    }
    
    @MainActor @Published private(set) var toolbar: (id: String, text: String)? = nil
    private var cancellable = Set<AnyCancellable>()
    
    func setToolBar(id: String, text: String) {
        self.toolbar = (id, text)
    }
    
    /// Add a destination to a path at the end of the list
    func push(_ destination: Destination){
        path.append(destination)
    }
    
    /// Removes all destinations from path, pushing navigtation to the root screen
    func backToRoot() {
        path.removeAll()
    }
    
    /// Removes the last destination from the path, going back one screen
    func back() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }
}
