//
//  CookingMethodsHeader.swift
//  BarHelper
//
//  Created by Владислав Пермяков on 23.09.2024.
//

import SwiftUI

struct CookingMethodsHeader: View {
    var body: some View {
        Rectangle()
            .fill(Color.softPink)
            .overlay(
                HStack{
                    icon
                    Spacer()
                    title
                    Spacer()
                }
            )
            .frame(height: 90)
    }
    
    private var title: some View {
        Text("Methods")
            .cyberpunkFont(.smallTitle)
            .lineLimit(1)
            .foregroundColor(.white)
    }
    
    private var icon: some View {
        ZStack(alignment: .bottomTrailing) {
            shaker
                .padding(.horizontal)
            Image("icesprite")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 35)
        }
    }
    
    private var shaker: some View {
        VStack(spacing: 0){
            Image("shaker_top")
                .resizable()
                .scaledToFit()
            Image("shaker_bottom")
                .resizable()
                .scaledToFit()
        }
        .aspectRatio(0.5, contentMode: .fit)
    }
}

#Preview {
    CookingMethodsHeader()
        .padding()
}
