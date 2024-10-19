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
        } catch RepositoryError.contextError(let error) {
            AlertsManager.shared.alert("Database error occured")
            print("failed to edit ingredient", error)
        } catch {
            AlertsManager.shared.alert("Something went wrong")
            print("Something bad happened", error)
        }
    }
    
    func deleteIngredient(_ ingredient: DBIngredient) async {
        do{
            try await ingredientsRepository.deleteIngredient(ingredient: ingredient)
        } catch RepositoryError.contextError(let error) {
            AlertsManager.shared.alert("Database error occured")
            print("failed to edit ingredient", error)
        } catch {
            AlertsManager.shared.alert("Something went wrong")
            print("Something bad happened", error)
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
