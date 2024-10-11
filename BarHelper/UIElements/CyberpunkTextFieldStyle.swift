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
    init(state: FocusState<Bool>.Binding) {
        self.state = state
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

private struct CyberpunkTextFieldWithOwnFocus<Label>: View where Label: View {
    @FocusState var focusState: Bool
    let textField: TextField<Label>
    var body: some View {
        textField
            .textFieldStyle(CyberpunkTextFieldStyle(state: $focusState))
    }
}

extension TextField {
    /// Cyberpunk textfield style
    @ViewBuilder
    func cyberpunkStyle(focusState: FocusState<Bool>.Binding? = nil) -> some View {
        if let focusState {
            self
                .textFieldStyle(CyberpunkTextFieldStyle(state: focusState))
        } else {
            CyberpunkTextFieldWithOwnFocus(textField: self)
        }
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
