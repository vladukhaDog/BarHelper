//
//  MockData.swift
//  BarHelper
//
//  Created by Владислав Пермяков on 23.09.2024.
//

import Foundation
import SwiftUI

final class MockData {
    private init(){}
    
    static func mockCocktails(_ count: Int) -> [DBCocktail] {
        var array: [DBCocktail] = []
        for _ in 0..<count {
            array.append(mockCocktail())
        }
        return array
    }
    
    static func mockCocktail() -> DBCocktail {
        let cocktail: DBCocktail
        cocktail = .init(context: DBManager.shared.backgroundContext)
        cocktail.id = .init()
        cocktail.name = "Cocktail name"
        cocktail.desc = "Description lognga nfksjelfnajck nbjfkaewljndkvsjernva ejk"
        let ingredientRecord = DBIngredientRecord(context: DBManager.shared.backgroundContext)
        let ingredient = DBIngredient(context: DBManager.shared.backgroundContext)
        ingredient.name = "Ingredient name"
        ingredientRecord.ingredient = ingredient
        ingredientRecord.ingredientValue = 30
        cocktail.addToRecipe(ingredientRecord)
        let image = ImageEntry(context: DBManager.shared.backgroundContext)
        image.fileName = "mockImage.png"
        cocktail.image = image
        if let data = UIImage(named: "mockImage.png")?.jpegData(compressionQuality: 1.0) {
            
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileURL = documentsURL.appendingPathComponent("mockImage.png")
            
            do {
                try data.write(to: fileURL)
            } catch {
                print("Error saving image: \(error)")
            }
        }
        return cocktail
    }
}
