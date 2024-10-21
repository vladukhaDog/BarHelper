//
//  CocktailCellView.swift
//  BarHelper
//
//  Created by Владислав Пермяков on 14.05.2023.
//

import SwiftUI

struct CocktailCellView: View {
    let cocktail: DBCocktail
    var body: some View {
        
        HStack(alignment: .center) {
            image
                .overlay(alignment: .topLeading) {
                    fav
                        .id(cocktail.isFavourite)
                }
            VStack(alignment: .leading) {
                Text(cocktail.name ?? "No Name")
                    .cyberpunkFont(30)
                if let method = cocktail.cookingMethod?.name {
                    Text(method)
                        .cyberpunkFont(25)
                        .opacity(0.8)
                }
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(10)
        .background(Color.black)
        .padding(5)
        .depthBorder()
        .frame(height: 150)
        
    }
    
    @ViewBuilder
    private var fav: some View {
        if cocktail.isFavourite {
            Image("star-filled")
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
        }
    }
    
    private var image: some View{
        HStack{
            if let image = cocktail.image?.getImage() {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            }else{
                Color.gray
            }

        }
        .clipShape(Rectangle())
        .frame(width: 100)
    }
}

#Preview {
    ZStack{
        Color.darkPurple
            .ignoresSafeArea()
        VStack {
            CocktailCellView(cocktail: MockData.mockCocktail())
                .padding()
            let co = MockData.mockCocktail()
            let _ = co.isFavourite = true
            CocktailCellView(cocktail: co)
                .padding()
        }
    }
        
}
