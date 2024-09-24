//
//  FavouritesHeader.swift
//  BarHelper
//
//  Created by Владислав Пермяков on 23.09.2024.
//

import SwiftUI

/// Section with a grid of favourite cocktails
struct FavouritesHeader: View {
    static private let gridRow = GridItem(.flexible(minimum: 100))
    private let twoRows = [
        FavouritesHeader.gridRow,
        FavouritesHeader.gridRow
    ]
    private let oneRow = [FavouritesHeader.gridRow]
    
    let favourites: [DBCocktail] = MockData.mockCocktails(5)
    
    var body: some View {
        VStack(alignment: .leading) {
            title
                .padding(.horizontal)
            ScrollView(.horizontal) {
                grid
            }
    
        }
    }
    
    private var grid: some View {
        LazyHGrid(rows: favourites.count > 3 ? twoRows : oneRow) {
            ForEach(favourites, id: \.id) { cocktail in
                NavigationLink(value: Destination.CocktailView(.constant(cocktail))) {
                    CocktailTile(cocktail)
                }
            }
        }
        .padding(.horizontal)
        .padding(.bottom, 8)
    }
    
    private var title: some View {
        HStack {
            Image(systemName: "star.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30, alignment: .center)
                .foregroundStyle(Color.yellow)
            Text("Favourites")
                .font(.title)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    ScrollView {
        FavouritesHeader()
    }
}






