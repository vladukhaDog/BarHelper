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
        
        HStack{
            image
            VStack{
                Text(cocktail.name ?? "No Name")
                    .font(.smallTitle)
                    .foregroundColor(.white)
                
            }
            .frame(maxWidth: .infinity)
        }
            .padding(10)
            .background(Color.black)
            .padding(5)
            .depthBorder()
        
            
    }
    
    private var image: some View{
        HStack{
            
            if let imageName = cocktail.image?.fileName,
               let imageData = try? Data(contentsOf: FileManager.default.temporaryDirectory.appendingPathComponent(imageName)),
               let image = UIImage(data: imageData){
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            }else{
                Color.gray
            }

        }
        .frame(maxWidth: 150, maxHeight: 150)
        .clipShape(Rectangle())
    }
}

struct CocktailCellView_Previews: PreviewProvider {
    static var previews: some View {
        CocktailCellView(cocktail: .init(context: DBManager.shared.backgroundContext))
    }
}
