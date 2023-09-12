//
//  IngredientsViewMoel.swift
//  BarHelper
//
//  Created by Владислав Пермяков on 09.05.2023.
//

import Foundation
import SwiftUI
import Combine

class IngredientsViewModel: ObservableObject{
    let db = DBManager.shared
    
    @Published var ingredients: [DBIngredient] = []
    @Published var showIngredientCreate: Bool = false
    @Published var ingredientToEdit: DBIngredient? = nil
    @Published var ingredientToDelete: DBIngredient? = nil
    @Published var ingredientToAddAlternative: DBIngredient? = nil
    @Binding var selectedIngredients: [DBIngredient: Int]
    @Published var localSelected: [DBIngredient: Int]
    
    @Published var scrollViewProxy: ScrollViewProxy? = nil
    
    @Published var search = ""
    let selectable: Bool
    let canInputNumber: Bool
    
    private var cancellable = Set<AnyCancellable>()
    
    init(selectedIngredients: Binding<[DBIngredient: Int]>, canInputNumber: Bool = true){
        self.canInputNumber = canInputNumber
        selectable = true
        self._selectedIngredients = selectedIngredients
        self._localSelected = .init(initialValue: selectedIngredients.wrappedValue)
        Task{
            await fetchIngredients()
        }
        $search
            .dropFirst()
            .sink { newSearch in
            Task{
                let searchText: String? = newSearch.isEmpty ? nil : newSearch
                await self.fetchIngredients(search: searchText)
            }
        }
        .store(in: &cancellable)
    }
    
    init(){
        self.canInputNumber = false
        selectable = false
        self._localSelected = .init(initialValue: [:])
        self._selectedIngredients = .init(get: {return [:]}, set: { ing in
        })
        Task{
            await fetchIngredients()
        }
        $search
            .dropFirst()
            .sink { newSearch in
            Task{
                let searchText: String? = newSearch.isEmpty ? nil : newSearch
                await self.fetchIngredients(search: searchText)
            }
        }
        .store(in: &cancellable)
    }
    
    
    func didSelect(_ ingr: DBIngredient){
        if localSelected[ingr] != nil{
            localSelected.removeValue(forKey: ingr)
        }else{
            localSelected[ingr] = 0
        }
        self.selectedIngredients = localSelected
    }
    
    
    func onAdd(_ newIngredient: DBIngredient){
        Task{
            await self.fetchIngredients()
            self.didSelect(newIngredient)
            let parent = newIngredient.parentIngredient ?? newIngredient
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                withAnimation{
                    self.scrollViewProxy?.scrollTo(parent.id, anchor: .center)
                }
            }
        }
    }

    
    func deleteIngredient(ingredient: DBIngredient){
        Task{
            await db.deleteIngredient(ingredient: ingredient)
            await fetchIngredients()
        }
    }
    
    func setNewNameIngredient(ingredient: DBIngredient, newName: String){
        Task{
            ingredient.name = newName
            await db.saveContext()
            await fetchIngredients()
        }
    }
    
    func createSuccess(){
        showIngredientCreate = false
        search = ""
        Task{
            await fetchIngredients()
        }
    }
    
    
    private func fetchIngredients(search: String? = nil) async{
        let ingrds = await db.fetchIngredients(search: search)
        DispatchQueue.main.async {
            self.ingredients = ingrds
        }
    }
}
