//
//  DestinationPath.swift
//  BarHelper
//
//  Created by Владислав Пермяков on 23.09.2024.
//

import Foundation
import SwiftUI

extension View {
    /// wraps the view with navigation destination modifier and explains navigation destination views for each destination enumerator
    func routePath() -> some View {
        self
            .navigationDestination(for: Destination.self) { route in
                switch route {
                case .CocktailsList(let cocktails):
                    CocktailsView(cocktails)
                case .IngredientsSelector(let ingredientsListBinding):
                    IngredientsView(selectedIngredients: ingredientsListBinding)
                case .IngredientsList:
                    IngredientsView()
                case .CreateCocktail:
                    CreateCocktailView()
                case .CookingMethodsList:
                    CookingMethodsView()
                case .EditCocktail(let cocktail):
                    CreateCocktailView(editCocktail: cocktail)
                case .CocktailView(let cocktail):
                    CocktailView(cocktail: cocktail)
                case .StoredCocktailsList:
                    CocktailsView()
                }
            }
    }
}

