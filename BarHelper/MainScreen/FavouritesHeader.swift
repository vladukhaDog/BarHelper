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
    
    let favourites: [DBCocktail]
    
    var body: some View {
        VStack(alignment: .leading) {
            title
                .padding(.horizontal)
            ScrollView(.horizontal) {
                LazyHGrid(rows: favourites.count > 3 ? twoRows : [GridItem(.flexible(minimum: 100))]) {
                    ForEach(favourites, id: \.id) { cocktail in
                        cocktailTile(cocktail)
                            .frame(height: 150)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 8)
            }
    
        }
    }
    
    private func cocktailTile(_ cocktail: DBCocktail) -> some View {
        VStack(spacing: 2) {
            Group {
                if let imageName = cocktail.image?.fileName,
                   let imageData = try? Data(contentsOf: FileManager.default.temporaryDirectory.appendingPathComponent(imageName)),
                   let image = UIImage(data: imageData){
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                    
                }else{
                    Color.red
                }
            }
            .aspectRatio(1.0, contentMode: .fit)
            Text(cocktail.name ?? "noname")
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
    @Previewable @State var count: Int = 5
    ScrollView {
        Slider(value: .init(get: {
            Float(count)
        }, set: { float in
            count = Int(float)
        }), in: 0...10) {
            Text("Count")
        }
        FavouritesHeader(favourites: MockData.mockCocktails(count))
    }
}






