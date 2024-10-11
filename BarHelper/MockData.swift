//
//  MockData.swift
//  BarHelper
//
//  Created by Владислав Пермяков on 23.09.2024.
//

import Foundation
import SwiftUI

/// Class that generates mock data from CoreData
final class MockData {
    private init(){}
    /// Creates a ``CookingMethod`` with unique id and filled out name and description
    static func mockCookingMethod() -> CookingMethod {
        let method: CookingMethod
        method = .init(context: DBManager.shared.backgroundContext)
        method.id = UUID().uuidString
        method.name = "Mock Method"
        method.desc = "Mock Description of a cooking method for a bar helper"
        return method
    }
    
    /// Creates an array of identical Cooking methods with unique identifiers
    static func mockCookingMethods(_ count: Int) -> [CookingMethod] {
        var array: [CookingMethod] = []
        for _ in 0..<count {
            array.append(mockCookingMethod())
        }
        return array
    }
    
    static func mockIngredient(_ name: String = "Ingredient name") -> DBIngredient {
        let ingredient = DBIngredient(context: DBManager.shared.backgroundContext)
        ingredient.id = UUID()
        ingredient.name = name
        return ingredient
    }
    
    static func mockIngredients(_ names: [String]) -> [DBIngredient] {
        var array: [DBIngredient] = []
        for name in names {
            array.append(mockIngredient(name))
        }
        return array
    }
    
    static func mockIngredients(_ count: Int) -> [DBIngredient] {
        var array: [DBIngredient] = []
        for _ in 0..<count {
            array.append(mockIngredient())
        }
        return array
    }
    
    /// Creates an array of identical cocktails with uniquie identifiers
    static func mockCocktails(_ count: Int) -> [DBCocktail] {
        var array: [DBCocktail] = []
        for _ in 0..<count {
            array.append(mockCocktail())
        }
        return array
    }
    
    /// Creates a ``DBCocktail`` with filled out data, including an image
    static func mockCocktail() -> DBCocktail {
        let cocktail: DBCocktail
        cocktail = .init(context: DBManager.shared.backgroundContext)
        cocktail.id = .init()
        cocktail.name = "Cocktail name"
        cocktail.desc = "Description lognga nfksjelfnajck nbjfkaewljndkvsjernva ejk"
        let ingredientRecord = DBIngredientRecord(context: DBManager.shared.backgroundContext)
        ingredientRecord.ingredient = Self.mockIngredient()
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
