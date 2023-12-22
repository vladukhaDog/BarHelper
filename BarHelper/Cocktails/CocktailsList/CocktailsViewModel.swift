//
//  CocktailsViewModel.swift
//  BarHelper
//
//  Created by Владислав Пермяков on 09.05.2023.
//

import Foundation
import Combine

class CocktailsViewModel: ObservableObject{
    let db = DBManager.shared
    @Published var search = ""
    @Published var cocktails: [DBCocktail] = []
    @Published var searchEnabled = true
    private var cancellable = Set<AnyCancellable>()
    
    init(_ cocktails: [DBCocktail]?){
        if let cocktails{
            self.cocktails = cocktails
            self.searchEnabled = false
        }else{
            Task{
                await fetchCocktails()
            }
        }
        $search
            .debounce(for: .seconds(1), scheduler: DispatchQueue.main)
            .dropFirst()
            .sink { newSearch in
            Task{
                let searchText: String? = newSearch.isEmpty ? nil : newSearch
                await self.fetchCocktails(search: searchText)
            }
        }
        .store(in: &cancellable)
    }
    
    
    
    private func delete(_ cocktail: DBCocktail){
        Task{
            print("starting delete")
            await db.deleteCocktail(cocktail: cocktail)
            print("finished delete")
            if let index = self.cocktails.firstIndex(of: cocktail){
                DispatchQueue.main.async {
                    print("updating deleted cocktail list")
                    self.cocktails.remove(at: index)
                    self.objectWillChange.send()
                }
            }
        }
    }
    
    func didUpdate(_ cocktail: DBCocktail){
        if cocktail.deletedByUser {
            self.delete(cocktail)
        } else if let index = cocktails.firstIndex(of: cocktail){
            DispatchQueue.main.async {
                self.cocktails[index] = cocktail
            }
        }
    }
  

    private func fetchCocktails(search: String? = nil) async{
        let cocktails = await db.fetchCocktails(search: search)
        DispatchQueue.main.async {
            self.cocktails = cocktails
        }
    }
}
