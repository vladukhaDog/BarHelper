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
    @Published var up = false
    @Published var search = ""
    @Published var cocktails: [DBCocktail] = []
    
    private var cancellable = Set<AnyCancellable>()
    
    init(_ cocktails: [DBCocktail]?){
        if let cocktails{
            self.cocktails = cocktails
        }else{
            Task{
                await fetchCocktails()
            }
        }
        $search
            .debounce(for: .seconds(1), scheduler: DispatchQueue.main)
            .sink { newSearch in
            Task{
                let searchText: String? = newSearch.isEmpty ? nil : newSearch
                await self.fetchCocktails(search: searchText)
            }
        }
        .store(in: &cancellable)
    }
    
    
    
    func delete(_ cocktail: DBCocktail){
        Task{
            await db.deleteCocktail(cocktail: cocktail)
            if let index = self.cocktails.firstIndex(of: cocktail){
                DispatchQueue.main.async {
                    self.cocktails.remove(at: index)
                    self.up.toggle()
                }
            }
        }
    }
    
    func didUpdate(_ cocktail: DBCocktail){
            if let index = cocktails.firstIndex(of: cocktail){
                DispatchQueue.main.async {
                    self.cocktails[index] = cocktail
                    self.up.toggle()
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
