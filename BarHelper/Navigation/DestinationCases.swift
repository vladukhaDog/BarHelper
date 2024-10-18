//
//  DestinationCases.swift
//  BarHelper
//
//  Created by Владислав Пермяков on 23.09.2024.
//

import Foundation
import SwiftUI

/// Destination cases for navigation
enum Destination: Hashable {
    /// List of all stored cocktails
    case StoredCocktailsList
    /// List of pre determined cocktails
    case CocktailsList([DBCocktail])
    /// Bindable list of ingredients to add to in parent view if ingredient is tapped or created
    case IngredientsSelector(Binding<[DBIngredient: Int]>)
    /// List of all stored ingridients
    case IngredientsList
    /// View to edit an ingredient
    case EditIngredient(DBIngredient)
    /// Screen for creating a cocktail
    case CreateCocktail
    /// Screen of cocktail Cooking methods
    case CookingMethodsList
    /// Screen for editing a cocktail
    case EditCocktail(Binding<DBCocktail>)
    /// Screen for viewing a cocktail, binding in case the cocktail was edited
    case CocktailView(Binding<DBCocktail>)
    /// Screen to add new ingredient
    ///  - Parameter DBIngredient: Родительский ингредиент
    case CreateIngredientView(DBIngredient?)
}
