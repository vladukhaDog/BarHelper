//
//  IngredientsViewMoel.swift
//  BarHelper
//
//  Created by Владислав Пермяков on 09.05.2023.
//

import Foundation
import SwiftUI
import Combine

protocol IngredientsViewModelProtocol: ObservableObject {
    var ingredients: [DBIngredient] {get set}
    var isEditing: Bool {get set}
    var search: String {get set}
    func deleteIngredient(_ ingredient: DBIngredient) async
}

final class IngredientsViewModel: IngredientsViewModelProtocol {
    @MainActor @Published var ingredients: [DBIngredient] = []
    @MainActor @Published var isEditing: Bool = false
    @MainActor @Published var search: String = ""
    
    private let ingredientsRepository: IngredientsRepository = .init()
    private var cancellable = Set<AnyCancellable>()
    
    init() {
        ingredientsRepository
            .getPublisher()
            .sink {[weak self] notification in
                guard let self else {return}
                guard let action = notification.object as? IngredientsRepository.Action
                else {return}
                self.updateList(action)
            }
            .store(in: &cancellable)
        
        $search
            .dropFirst()
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .sink {[weak self] search in
                guard let self else {return}
                guard !search.isEmpty else {
                    Task {
                        await self.fetchIngredients()
                    }
                    return
                }
                Task {
                    await self.fetchIngredients(search)
                }
            }
            .store(in: &cancellable)
        
        Task {
            await fetchIngredients()
        }
    }
    
    deinit {
        cancellable.removeAll()
    }
    
    private func fetchIngredients(_ search: String? = nil) async {
        do{
            let ingredients = try await ingredientsRepository.fetchIngredients(search: search)
            await MainActor.run {
                self.ingredients = ingredients
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func deleteIngredient(_ ingredient: DBIngredient) async {
        do{
            try await ingredientsRepository.deleteIngredient(ingredient: ingredient)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    internal func updateList(_ action: IngredientsRepository.Action) {
        DispatchQueue.main.async {
            withAnimation {
                switch action {
                case .deleted(let ingredient):
                    self.ingredients.removeAll(where: {$0.id == ingredient.id})
                case .added(let ingredient):
                    guard ingredient.parentIngredient == nil else {return}
                    let index = self.findAlphabeticalOrderIndex(array: self.ingredients.map({$0.name ?? ""}), for: ingredient.name ?? "")
                    self.ingredients.insert(ingredient, at: index)
                case .updated(let ingredient):
                    if let index = self.ingredients.firstIndex(where: {$0.id == ingredient.id}) {
                        self.ingredients[index] = ingredient
                    }
                }
            }
        }
    }
    
    private func findAlphabeticalOrderIndex(array: [String], for character: String) -> Int {
        var low = 0
        var high = array.count
        while low != high {
            let mid = (high+low)/2
            if array[mid] < character {
                low = array.index(after: mid)
            } else {
                high = mid
            }
        }
        return low
    }


}

//final class IngredientsViewModel: ObservableObject{
//    let db = DBManager.shared
//    
//    @Published var ingredients: [DBIngredient] = []
//    @Published var showIngredientCreate: Bool = false
//    @Published var ingredientToEdit: DBIngredient? = nil
//    @Published var ingredientToDelete: DBIngredient? = nil
//    @Published var ingredientToAddAlternative: DBIngredient? = nil
//    @Binding var selectedIngredients: [DBIngredient: Int]
//    @Published var localSelected: [DBIngredient: Int]
//    
//    @Published var scrollViewProxy: ScrollViewProxy? = nil
//    
//    @Published var search = ""
//    let selectable: Bool
//    let canInputNumber: Bool
//    
//    private var cancellable = Set<AnyCancellable>()
//    
//    init(selectedIngredients: Binding<[DBIngredient: Int]>, canInputNumber: Bool = true){
//        self.canInputNumber = canInputNumber
//        selectable = true
//        self._selectedIngredients = selectedIngredients
//        self._localSelected = .init(initialValue: selectedIngredients.wrappedValue)
//        Task{
//            await fetchIngredients()
//        }
//        $search
//            .dropFirst()
//            .sink { newSearch in
//            Task{
//                let searchText: String? = newSearch.isEmpty ? nil : newSearch
//                await self.fetchIngredients(search: searchText)
//            }
//        }
//        .store(in: &cancellable)
//    }
//    
//    init(){
//        self.canInputNumber = false
//        selectable = false
//        self._localSelected = .init(initialValue: [:])
//        self._selectedIngredients = .init(get: {return [:]}, set: { ing in
//        })
//        Task{
//            await fetchIngredients()
//        }
//        $search
//            .dropFirst()
//            .sink { newSearch in
//            Task{
//                let searchText: String? = newSearch.isEmpty ? nil : newSearch
//                await self.fetchIngredients(search: searchText)
//            }
//        }
//        .store(in: &cancellable)
//    }
//    
//    
//    func didSelect(_ ingr: DBIngredient){
//        if localSelected[ingr] != nil{
//            localSelected.removeValue(forKey: ingr)
//        }else{
//            localSelected[ingr] = 0
//        }
//        self.selectedIngredients = localSelected
//    }
//    
//    
//    func onAdd(_ newIngredient: DBIngredient){
//        Task{
//            await self.fetchIngredients()
//            self.didSelect(newIngredient)
//            let parent = newIngredient.parentIngredient ?? newIngredient
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                withAnimation{
//                    self.scrollViewProxy?.scrollTo(parent.id, anchor: .center)
//                }
//            }
//        }
//    }
//
//    
//    func deleteIngredient(ingredient: DBIngredient){
//        Task{
//            await db.deleteIngredient(ingredient: ingredient)
//            await fetchIngredients()
//        }
//    }
//    
//    func setNewNameIngredient(ingredient: DBIngredient, newName: String){
//        Task{
//            ingredient.name = newName
//            await db.saveContext()
//            await fetchIngredients()
//        }
//    }
//    
//    func createSuccess(){
//        showIngredientCreate = false
//        search = ""
//        Task{
//            await fetchIngredients()
//        }
//    }
//    
//    
//    private func fetchIngredients(search: String? = nil) async{
//        let ingrds = await db.fetchIngredients(search: search)
//        DispatchQueue.main.async {
//            self.ingredients = ingrds
//        }
//    }
//}
