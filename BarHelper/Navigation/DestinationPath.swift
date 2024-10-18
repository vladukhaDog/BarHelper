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
    func routePath(_ namespace: Namespace.ID) -> some View {
        self
            .navigationDestination(for: Destination.self) { route in
                switch route {
                case .CocktailsList(let cocktails):
                    CocktailsView(cocktails)
                        .navigationBarHidden(true)
                case .IngredientsSelector(_):
                    IngredientsView()
                        .navigationBarHidden(true)
                case .IngredientsList:
                    IngredientsView()
                        .navigationTransition(.zoom(sourceID: route, in: namespace))
                        .navigationBarHidden(true)
                case .CreateCocktail:
                    CreateCocktailView()
                        .navigationBarHidden(true)
                case .CookingMethodsList:
                    CookingMethodsView()
                        .navigationTransition(.zoom(sourceID: route, in: namespace))
                        .navigationBarHidden(true)
                case .EditCocktail(let cocktail):
                    CreateCocktailView(editCocktail: cocktail)
                        .navigationBarHidden(true)
                case .CocktailView(let cocktail):
                    CocktailView(cocktail: cocktail)
                        .navigationBarHidden(true)
                case .StoredCocktailsList:
                    CocktailsView()
                        .navigationTransition(.zoom(sourceID: route, in: namespace))
                        .navigationBarHidden(true)
                case .CreateIngredientView(let parent):
                    CreateIngredientView(parent)
                        .navigationBarHidden(true)
                }
            }
    }
}

