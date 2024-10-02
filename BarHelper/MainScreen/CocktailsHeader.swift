//
//  CocktailsHeader.swift
//  BarHelper
//
//  Created by Владислав Пермяков on 23.09.2024.
//

import SwiftUI

struct CocktailsHeader: View {
    var body: some View {
        VStack {
            HStack{
                leftCocktails
                title
                rightCocktails
            }
            .frame(height: 90)
            existingList
        }
        .frame(maxWidth: .infinity)
        .background(Color.darkPurple)
    }
    
    private var title: some View {
        Text("Cocktails")
            .cyberpunkFont(.smallTitle)
            .lineLimit(1)
            .foregroundColor(.white)
            .minimumScaleFactor(0.1)
    }
    
    private var rightCocktails: some View {
        HStack(spacing: 0){
            Image("6")
                .resizable()
                .scaledToFit()
            Image("1")
                .resizable()
                .scaledToFit()
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 10)
        .padding(.top, 20)
    }
    
    private var leftCocktails: some View {
        HStack(spacing: 0){
            Image("5")
                .resizable()
                .scaledToFit()
            Image("8")
                .resizable()
                .scaledToFit()
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 10)
    }
    
    private var existingList: some View {
        ScrollView(.horizontal) {
            HStack {
                addButton
                ForEach(0..<2) { ai in
                    let cocktail = MockData.mockCocktail()
                    NavigationLink(value: Destination.CocktailView(.constant(cocktail))) {
                        CocktailTile(cocktail)
                    }
                }
            }
            .padding(8)
        }
        .frame(height: 100)
        .background(Color.black)
        .padding(5)
        .depthBorder()
        .padding(10)
    }
    
    private var addButton: some View {
        Button{
            
        } label: {
            PlusView()
        }
        .padding(10)
    }
}

#Preview {
    CocktailsHeader()
}
