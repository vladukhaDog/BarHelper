//
//  CBButtonView.swift
//  BarHelper
//
//  Created by Владислав Пермяков on 11.05.2023.
//

import SwiftUI



struct CBButtonView: View {
    let color: Color
    let text: String
    let enabled: Bool
    let action: () -> ()
    
    @State private var lineSize = 0.0
    var body: some View {
        VStack{
            Button {
                action()
            } label: {
                ZStack{
                    border
                    ZStack{
                        border
                        currentColor
                            .overlay(
                                Text(text)
                                    .foregroundColor(enabled ? .white : .black)
                                    .font(.custom("CyberpunkWaifus", size: 200))
                                    .minimumScaleFactor(0.01)
                                    .padding(4)
                                    .padding(.horizontal, 5)
                            )
                            .padding(lineSize * 2)
                    }
                    .padding(.vertical ,lineSize * 2)
                    .padding(.horizontal ,lineSize * 4)
                    
                }
                .aspectRatio(3.5, contentMode: .fit)
                .background(
                    GeometryReader(content: { proxy in
                        Color.clear
                            .onAppear{
                                lineSize = proxy.size.width/100
                            }
                            .onChange(of: proxy.size.width) { newValue in
                                lineSize = proxy.size.width/100
                            }
                    })
                )
            }
            .disabled(!enabled)
            
           
        }
    }
    
    private var currentColor: some View{
        Group{
            if enabled{
                color
            }else{
                Color.gray
            }
        }
    }
    
    private var border: some View{
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
    
    private var verticalLine: some View{
        
        VStack(spacing: 0){
                Color.clear
                    .aspectRatio(1.0, contentMode: .fit)
            currentColor
                Color.clear
                    .aspectRatio(1.0, contentMode: .fit)
            }
            .frame(width: lineSize)
        
    }
    
    private var horizontalLine: some View{
        
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

struct CBButtonView_Previews: PreviewProvider {
    static var previews: some View {
        VStack{
            CBButtonView(color: .green, text: "Test", enabled: true, action: {})
                .frame(width: 100)
            CBButtonView(color: .red, text: "Test", enabled: false, action: {})
        }
        .backgroundWithoutSafeSpace(.darkPurple)
    }
}
