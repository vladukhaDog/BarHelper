//
//  IngredientsHeader.swift
//  BarHelper
//
//  Created by Владислав Пермяков on 23.09.2024.
//

import SwiftUI

struct IngredientsHeader: View {
    var body: some View {
        Rectangle()
            .fill(Color.softBlue)
            .overlay(
                HStack {
//                    icon
//                    Spacer()
                    title
//                    Spacer()
                }
            )
            .frame(height: 90)
    }
    
    private var title: some View {
        Text("Ingredients")
            .cyberpunkFont(.smallTitle)
            .lineLimit(1)
            .foregroundColor(.white)
    }
    
    private var icon: some View {
        Image("rum_spr")
            .resizable()
            .scaledToFit()
            .aspectRatio(0.4, contentMode: .fit)
            .minimumScaleFactor(0.5)
    }

}

#Preview {
    HStack {
        IngredientsHeader()
        IngredientsHeader()
    }
}
