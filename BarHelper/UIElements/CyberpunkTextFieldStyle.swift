//
//  CyberpunkTextFieldStyle.swift
//  BarHelper
//
//  Created by Владислав Пермяков on 03.10.2024.
//

import SwiftUI


struct CyberpunkTextFieldStyle: TextFieldStyle {
    var state: FocusState<Bool>.Binding
    @State private var isFocused: Bool = false
    init(state: FocusState<Bool>.Binding? = nil) {
        self.state = state ?? FocusState<Bool>.init().projectedValue
    }

    func _body(configuration: TextField<Self._Label>) -> some View {
        HStack(spacing: 3) {
            Image("arrow")
                .interpolation(.none)
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .rotationEffect(.degrees(180))
                
            configuration
                .focused(state)
                .cyberpunkFont(.smallTitle)
                .foregroundColor(.white)
                .tint(.white)
                .colorScheme(.dark)
        }
            .padding(5)
            .background(Color.black)
            .padding(5)
            .depthBorderUp()
    }
}

extension TextField {
    /// Cyberpunk textfield style
    func cyberpunkStyle(focusState: FocusState<Bool>.Binding? = nil) -> some View {
        self
            .textFieldStyle(CyberpunkTextFieldStyle(state: focusState))
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
