//
//  SearchViewModel.swift
//  BarHelper
//
//  Created by Владислав Пермяков on 14.05.2023.
//

import Foundation

enum SearchMode{
    case cocktailContainsAnyIngredient
    case ingredientsContainCocktails
}

class SearchViewModel: ObservableObject{
    let db = DBManager.shared
    
    
    @Published var selectedIngredients: [DBIngredient] = []
    @Published var cocktails: [DBCocktail] = []
    @Published var searchMode: SearchMode = .ingredientsContainCocktails
    @Published var allCocktails: [DBCocktail] = []
    init(){
        
        Task{
            await fetchCocktails()
        }
    }
    
    func findCocktailsWhichCanBeMadeUsing(ingredients: [DBIngredient]){
        let ingredientRecords = ingredients.flatMap { ingr in
            ingr.records as! Set<DBIngredientRecord>
        }
        let cocktails = allCocktails.filter { cocktail in
            let recipe = (cocktail.recipe as! Set<DBIngredientRecord>)
            return Set(ingredientRecords).isSuperset(of: recipe)
        }
        self.cocktails = cocktails
    }
    
    
    func findCocktailsWhichContain(ingredients: [DBIngredient]){
        let cocktails = ingredients.flatMap { ingr in
            let records = ingr.records as! Set<DBIngredientRecord>
            return records.compactMap { rec in
                rec.cocktail
            }
        }
        self.cocktails = cocktails
    }

    private func fetchCocktails() async{
        let cocktails = await db.fetchCocktails()
        DispatchQueue.main.async {
            self.allCocktails = cocktails
        }
    }
}
