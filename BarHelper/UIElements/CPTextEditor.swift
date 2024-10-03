//
//  CPTextEditor.swift
//  BarHelper
//
//  Created by Владислав Пермяков on 27.06.2023.
//

import SwiftUI

struct CPTextEditor: View {
    
    @Binding var text: String
    let placeholder: String
    @State private var textEditorHeight : CGFloat = 20
    @FocusState private var focused: Bool
    var body: some View {
        
        ZStack(alignment: .leading) {
            Text(text)
                .foregroundColor(.clear)
                .padding(8)
                .background(GeometryReader {
                    Color.clear.preference(key: ViewHeightKey.self,
                                           value: $0.frame(in: .local).size.height)
                })
            TextEditor(text: $text)
                .scrollContentBackground(.hidden)
                .frame(height: max(30,textEditorHeight))
                .focused($focused)
        }
        .onPreferenceChange(ViewHeightKey.self) { textEditorHeight = $0 }
        
        .cyberpunkFont(.body)
        .foregroundColor(.white)
        .tint(.white)
        .overlay(alignment: .topLeading, content: {
            if text.isEmpty{
                Text(placeholder)
                    .cyberpunkFont(.body)
                    .foregroundColor(.white)
                    .padding(5)
                    .padding(.top, 3)
                    .opacity(0.25)
                    .allowsHitTesting(false)
            }
        })
        .background(Color.black)
        .padding(5)
        .depthBorderUp()
    }
    
}


struct ViewHeightKey: PreferenceKey {
    static var defaultValue: CGFloat { 0 }
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = value + nextValue()
    }
}

struct CPTextEditor_Previews: PreviewProvider {
    static var previews: some View {
        VStack{
            CPTextEditor(text: .constant("a"), placeholder: "Placeholder")
            CPTextEditor(text: .constant(""), placeholder: "Placeholder")
        }
        .padding()
        .background(Color.darkPurple)
    }
}
