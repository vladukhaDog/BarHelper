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
    @Namespace var namespace
    /// Navigation class
    @EnvironmentObject var router: Router
    
    var body: some View {
        VStack(spacing: 0) {
            NavigationStack(path: $router.path){
                MainScreenView(namespace)
                    .routePath(namespace)
            }
            .navigationBarTitleTextColor(.white)
            CustomNavigationBar()
        }
        .alertsOverlay()
        .tint(.mint)
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}

#Preview {
    ContentView()
        .environmentObject(Router.init())
}
