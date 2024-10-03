//
//  CBButtonView.swift
//  BarHelper
//
//  Created by Владислав Пермяков on 11.05.2023.
//

import SwiftUI

// Button modifier for easier reading
extension Button {
    /// Vallahala style button with color background and separate disabled design
    func cyberpunkStyle(_ mode: Color = .green) -> some View {
            self
            .buttonStyle(CyberpunkButtonStyle(mode))
        }
}

struct CyberpunkButtonStyle: ButtonStyle {
    
    private let color: Color
    init(_ color: Color) {
        self.color = color
    }
    
    func makeBody(configuration: ButtonStyle.Configuration) -> some View {
        InternalButton(configuration: configuration, color: color)
    }
    
    // Internal View for a button configuration, for acces to .disabled modifier status of a button
    private struct InternalButton: View {
        let configuration: ButtonStyle.Configuration
        let color: Color
        @Environment(\.isEnabled) private var isEnabled: Bool
        @State private var lineSize = 0.0
        
        var body: some View {
            let isPressed = configuration.isPressed
            /// Button background
            ZStack{
                border
                    .scaleEffect(isPressed ? 0.99 : 1.0, anchor: .center)
                ZStack{
                    border
                        .scaleEffect(isPressed ? 1.01 : 1.0, anchor: .center)
                    currentColor
                        .overlay(
                            configuration.label
                                .foregroundColor(isEnabled ? .white : .black)
                                .font(.custom("CyberpunkWaifus", size: 200))
                                .minimumScaleFactor(0.01)
                                .padding(4)
                                .padding(.horizontal, 5)
                        )
                        .opacity(isPressed ? 0.8 : 1.0)
                        .scaleEffect(isPressed ? 0.99 : 1.0, anchor: .center)
                        .padding(lineSize * 2)
                }
                .padding(.vertical ,lineSize * 2)
                .padding(.horizontal ,lineSize * 4)
                
            }
            .aspectRatio(3.5, contentMode: .fit)
            .background(
                geometryReader
            )
        }
        
        private var geometryReader: some View {
            GeometryReader(content: { proxy in
                Color.clear
                    .onAppear{
                        lineSize = proxy.size.width/100
                    }
                    .onChange(of: proxy.size.width, { oldValue, newValue in
                        lineSize = proxy.size.width/100
                    })
            })
        }
        
        private var currentColor: Color {
            if isEnabled {
                color
            }else{
                Color.gray
            }
        }
        
        private var border: some View {
            VStack{
                horizontalLine
                Spacer()
                horizontalLine
            }
            .overlay(HStack{
                verticalLine
                Spacer()
                verticalLine
            })
            
        }
        
        private var verticalLine: some View {
            VStack(spacing: 0){
                    Color.clear
                        .aspectRatio(1.0, contentMode: .fit)
                currentColor
                    Color.clear
                        .aspectRatio(1.0, contentMode: .fit)
                }
                .frame(width: lineSize)
            
        }
        
        private var horizontalLine: some View {
            
            HStack(spacing: 0){
                    Color.clear
                        .aspectRatio(1.0, contentMode: .fit)
                currentColor
                    Color.clear
                        .aspectRatio(1.0, contentMode: .fit)
                }
                .frame(height: lineSize)
            
        }
    }
}

#Preview {
    VStack{
        Button("Text text") {
            
        }
        .cyberpunkStyle(.green)
        HStack {
            Button("Text text") {
                
            }
            .cyberpunkStyle(.red)
            Button("Text text") {
                
            }
            .cyberpunkStyle(.orange)
        }
        Button("Text text") {
            
        }
        .cyberpunkStyle(.green)
        .disabled(true)
    }
    .backgroundWithoutSafeSpace(.darkPurple)
}
