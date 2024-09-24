//
//  CocktailTile.swift
//  BarHelper
//
//  Created by Владислав Пермяков on 24.09.2024.
//

import SwiftUI

/// Tile with image and a name of a cocktail for quick preview, 150 by 150
struct CocktailTile: View {
    private let cocktail: DBCocktail
    init(_ cocktail: DBCocktail) {
        self.cocktail = cocktail
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.clear.overlay {
                image
            }
            imageOverlayGradient
            Text(cocktail.name ?? "noname")
                .foregroundStyle(.white)
                .italic()
                .shadow(radius: 5)
        }
        .frame(width: 150, height: 150)
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }
    
    /// black to clear gradient as a background to read text
    private var imageOverlayGradient: some View {
        LinearGradient(colors: .init(repeating: .clear, count: 1) +
                        [.black.opacity(0.5)],
                       startPoint: .top,
                       endPoint: .bottom)
        .frame(height: 30)
        .clipShape(
            .rect(
                topLeadingRadius: 20,
                bottomLeadingRadius: 0,
                bottomTrailingRadius: 0,
                topTrailingRadius: 20
            )
        )
        .blur(radius: 4)
    }
    
    private var image: some View {
        Group {
            if let imageName = cocktail.image?.fileName,
               let imageData = try? Data(contentsOf: FileManager.default
                .urls(for: .documentDirectory, in: .userDomainMask)
                .first!
                .appendingPathComponent(imageName)),
               let image = UIImage(data: imageData){
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            }else{
                Color.blue
            }
        }
    }
}

#Preview {
    CocktailTile(MockData.mockCocktail())
        .padding(20)
        .border(.red, width: 2)
}
