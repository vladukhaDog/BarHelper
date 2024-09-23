//
//  IngredientsHeader.swift
//  BarHelper
//
//  Created by Владислав Пермяков on 23.09.2024.
//

import SwiftUI

struct IngredientsHeader: View {
    var body: some View {
        HStack(alignment: .center) {
            title
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundStyle(Color.primary)
                .bold()
        }
        .padding(8)
        .background(Color.purple.opacity(0.15))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
    
    private var title: some View {
        HStack {
            Image("lemon")
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30, alignment: .center)
                .foregroundStyle(Color.primary)
            Text("Ingredients")
                .font(.title)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    IngredientsHeader()
}
