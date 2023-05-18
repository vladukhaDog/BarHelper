//
//  PlusView.swift
//  BarHelper
//
//  Created by Владислав Пермяков on 12.05.2023.
//

import SwiftUI

struct PlusView: View {
    @State private var lineSize = 0.0
    var body: some View {
            VStack{
                border
                    .overlay(
                        Color.white
                            .overlay(
                                ZStack{
                                    Color.darkPurple.padding(.horizontal, lineSize * 2.5)
                                    Color.darkPurple.padding(.vertical, lineSize * 2.5)
                                }
                                    .aspectRatio(1.0, contentMode: .fit)
                                    .padding(lineSize * 3)
                            )
                            .padding(lineSize * 2)
                    )
            }
            .aspectRatio(0.9, contentMode: .fit)
            .background(
                GeometryReader(content: { proxy in
                    Color.clear
                        .onAppear{
                            lineSize = proxy.size.width/20
                        }
                        .onChange(of: proxy.size.width) { newValue in
                            lineSize = proxy.size.width/20
                        }
                })
            )
    }
    private var currentColor: some View{
        Group{
            
                Color.white
            
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

struct PlusView_Previews: PreviewProvider {
    static var previews: some View {
        PlusView()
            .backgroundWithoutSafeSpace(.darkPurple)
    }
}
