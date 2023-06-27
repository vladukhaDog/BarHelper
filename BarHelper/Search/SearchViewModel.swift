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
    @Published var searchMode: SearchMode = .ingredientsContainCocktails
    @Published var allCocktails: [DBCocktail] = []
    
    init(){
        
        Task{
            await fetchCocktails()
        }
    }
    
    func startSearch(){
        switch searchMode{
        case .cocktailContainsAnyIngredient:
            Router.shared.push(
                .CocktailsList(
                    findCocktailsWhichContain()
                )
            )
        case .ingredientsContainCocktails:
            Router.shared.push(
                .CocktailsList(
                    findCocktailsWhichCanBeMadeUsing()
                )
            )
        }
    }
    
    private func findCocktailsWhichCanBeMadeUsing() -> [DBCocktail]{
        let ingredientRecords = selectedIngredients.flatMap { ingr in
            ingr.records as! Set<DBIngredientRecord>
        }
        return allCocktails.filter { cocktail in
            let recipe = (cocktail.recipe as! Set<DBIngredientRecord>)
            return Set(ingredientRecords).isSuperset(of: recipe)
        }
    }
    
    
    private func findCocktailsWhichContain() -> [DBCocktail]{
        return selectedIngredients.flatMap { ingr in
            let records = ingr.records as! Set<DBIngredientRecord>
            return records.compactMap { rec in
                rec.cocktail
            }
        }
        
    }

    private func fetchCocktails() async{
        let cocktails = await db.fetchCocktails()
        DispatchQueue.main.async {
            self.allCocktails = cocktails
        }
    }
}
