//
//  FavouritesHeader.swift
//  BarHelper
//
//  Created by Владислав Пермяков on 23.09.2024.
//

import SwiftUI

struct FavouritesHeader: View {
    private let twoRows = [
        GridItem(.flexible(minimum: 100)),
        GridItem(.flexible(minimum: 100))
    ]
    
    let favourites: [DBCocktail] = MockData.mockCocktails(5)
    
    var body: some View {
        VStack(alignment: .leading) {
            title
                .padding(.horizontal)
            ScrollView(.horizontal) {
                LazyHGrid(rows: favourites.count > 3 ? twoRows : [GridItem(.flexible(minimum: 100))]) {
                    ForEach(favourites, id: \.id) { cocktail in
                        NavigationLink(value: Destination.CocktailView(.constant(cocktail))) {
                            CocktailTile(cocktail)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 8)
            }
    
        }
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
//    @Previewable @State var count: Int = 5
    ScrollView {
//        Slider(value: .init(get: {
//            Float(count)
//        }, set: { float in
//            count = Int(float)
//        }), in: 0...10) {
//            Text("Count")
//        }
        FavouritesHeader()
    }
}






