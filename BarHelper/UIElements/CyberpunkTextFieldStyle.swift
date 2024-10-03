//
//  CyberpunkTextFieldStyle.swift
//  BarHelper
//
//  Created by Владислав Пермяков on 03.10.2024.
//

import SwiftUI


struct CyberpunkTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        HStack(spacing: 3) {
            Image("arrow")
                .interpolation(.none)
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .rotationEffect(.degrees(180))
                
            configuration
                .cyberpunkFont(.smallTitle)
                .foregroundColor(.white)
                .tint(.white)
        }
            .padding(5)
            .background(Color.black)
            .padding(5)
            .depthBorderUp()
    }
}

extension TextField {
    /// Cyberpunk textfield style
    func cyberpunkStyle() -> some View {
        self
            .textFieldStyle(CyberpunkTextFieldStyle())
    }
}

#Preview {
    ZStack {
        Color.darkPurple.edgesIgnoringSafeArea(.all)
        TextField("", text: .constant("Text"))
            .cyberpunkStyle()
            .padding()
    }
        
}
