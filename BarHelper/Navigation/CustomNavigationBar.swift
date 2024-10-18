//
//  CustomNavigationBar.swift
//  BarHelper
//
//  Created by Владислав Пермяков on 14.10.2024.
//

import SwiftUI

struct CustomNavigationBar: View {
    @EnvironmentObject var router: Router
    
    private let buttonFrameSize: CGFloat = 50
    
    var body: some View {
        HStack {
            Color.clear
                .overlay {
                        Button {
                            router.back()
                        } label: {
                            Image("backButton")
                                .resizable()
                                .scaledToFit()
                        }
                        .padding(8)
                        .transition(.opacity)
                        .disabled(router.path.isEmpty)
                        .opacity(router.path.isEmpty ? 0.8 : 1)
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
                    if let toolbar = router.toolbar {
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
                .animation(.default, value: router.toolbar?.id)
                
        }
        .frame(maxWidth: .infinity)
        .frame(height: buttonFrameSize)
        .background(Color.black.ignoresSafeArea())
    }
}

#Preview {
    CustomNavigationBar()
}
