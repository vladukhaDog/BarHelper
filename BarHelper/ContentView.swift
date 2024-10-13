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
    /// Navigation class
    @EnvironmentObject var router: Router
    
    var body: some View {
        VStack(spacing: 0) {
            NavigationStack(path: $router.path){
                MainScreenView()
                .routePath()
            }
            .navigationBarTitleTextColor(.white)
            buttomControl
        }
        .tint(.mint)
    }
    
    private let buttonFrameSize: CGFloat = 50
    @ViewBuilder
    private var buttomControl: some View {
        HStack {
            Color.clear
                .overlay {
                    if !router.path.isEmpty {
                        Button {
                            router.back()
                        } label: {
                            Image("backButton")
                                .resizable()
                                .scaledToFit()
                        }
                        .padding(8)
                        .transition(.opacity)
                    }
                }
                .animation(.default, value: router.path.isEmpty)
            Color.clear
                .overlay {
                    Button {
                        router.backToRoot()
                    } label: {
                        Image("home")
                            .resizable()
                            .scaledToFit()
                    }
                    .padding(8)
                }
            Color.clear
                .overlay {
                    if let toolbar = router.toolbar.last {
                        Button(toolbar.text) {
                            let name = Notification.Name("\(toolbar.id)_toolbar_pressed")
                            NotificationCenter.default.post(name: name,object: nil)
                        }
                        .cyberpunkFont(.title)
                        .foregroundStyle(.white)
                        .padding(8)
                        .transition(.opacity)
                        .minimumScaleFactor(0.2)
                    }
                }
                .animation(.default, value: router.toolbar.count)
                
        }
        .frame(maxWidth: .infinity)
        .frame(height: buttonFrameSize)
        .background(Color.black.ignoresSafeArea())
    }
}

#Preview {
    ContentView()
        .environmentObject(Router.init())
}
