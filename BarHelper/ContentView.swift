//
//  ContentView.swift
//  BarHelper
//
//  Created by Владислав Пермяков on 08.05.2023.
//

import SwiftUI
import Combine

/// Main View wrapping the main screen with navigation
struct ContentView: View {
    @EnvironmentObject var router: Router
    
    var body: some View {
        NavigationStack(path: $router.path){
            MainScreenView()
            .routePath()
        }
        .tint(.mint)
    }
}

#Preview {
    ContentView()
        .environmentObject(Router.init())
}
