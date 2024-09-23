//
//  CocktailsHeader.swift
//  BarHelper
//
//  Created by Владислав Пермяков on 23.09.2024.
//

import SwiftUI

struct CocktailsHeader: View {
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                title
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundStyle(Color.primary)
                    .bold()
            }
            existingList
        }
        .padding(8)
        .background(Color.green.opacity(0.2))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
    
    private var title: some View {
        HStack {
            Image("cocktail")
                .resizable()
                .scaledToFit()
                .frame(width: 25, height: 25, alignment: .center)
                .foregroundStyle(Color.primary)
            Text("Cocktails")
                .font(.title)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    private var existingList: some View {
        ScrollView(.horizontal) {
            HStack {
                addButton
                ForEach(0..<2) { ai in
                    Color.red
                        .aspectRatio(1.0, contentMode: .fit)
                }
            }
            .padding(8)
        }
        .background(Color.primary.colorInvert())
        .frame(height: 100)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
    
    private var addButton: some View {
        Button{
            
        } label: {
            Color.clear.opacity(0.15)
                .aspectRatio(1.0, contentMode: .fit)
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .overlay {
                    Image(systemName: "plus")
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(Color.primary.opacity(0.2))
                        .padding(20)
                }
        }
    }
}

#Preview {
    CocktailsHeader()
}
