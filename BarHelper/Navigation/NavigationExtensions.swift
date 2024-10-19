//
//  NavigationExtensions.swift
//  BarHelper
//
//  Created by Владислав Пермяков on 18.10.2024.
//

import Foundation
import SwiftUI

extension View {
    
    /// adds this button to a bottom navigation bar
    func customToolBar(id: String, text: String, router: Router, action: @escaping () -> Void) -> some View {
        self
            .onChange(of: text, {[weak router] oldValue, newValue in
                router?.setToolBar(id: id, text: text)
            })
            .onAppear(perform: { [weak router] in
                router?.setToolBar(id: id, text: text)
            })
//            .onDisappear { [weak router] in
//                router?.removeToolbarItem(id: id)
//            }
            .onReceive(NotificationCenter.default
                .publisher(for: Notification.Name("\(id)_toolbar_pressed"))) { _ in
                action()
            }
    }
    
    
    /// Wraps view in Navigation stack with mock router, adds bottom toolbar and applies all necessary modifiers like in top view
    func previewWrapper() -> some View {
        let router = Router()
        return VStack(spacing: 0) {
            NavigationStack(path: .constant([Destination.CookingMethodsList])) {
                Color.blue
                    .navigationDestination(for: Destination.self) { route in
                        self
                            .navigationBarHidden(true)
                    }
            }
            .navigationBarTitleTextColor(.white)
            .tint(.mint)
            CustomNavigationBar()
        }
        .environmentObject(router)
        .colorScheme(.dark)
    }
}
