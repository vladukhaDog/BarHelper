//
//  SelectIngredientsViewModel.swift
//  BarHelper
//
//  Created by Владислав Пермяков on 22.10.2024.
//


import SwiftUI
import Combine

final class SelectIngredientsViewModel: IngredientsViewModelProtocol, SelectIngredientsViewModelProtocol {
    @Published var ingredients: [DBIngredient] = []
    @Published var selectingIngredients: [DBIngredient: Int]
    @Binding var originalSelectIngredients: [DBIngredient: Int]
    @Published var isEditing: Bool = false
    @Published var search: String = ""
    @Published var addingIngredient: DBIngredient?
    
    private let ingredientsRepository: IngredientsRepository = .init()
    private var cancellable = Set<AnyCancellable>()
    
    init(_ list: Binding<[DBIngredient: Int]>) {
        _originalSelectIngredients = list
        self.selectingIngredients = list.wrappedValue
        
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
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
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
    
    func save() {
        self.originalSelectIngredients = selectingIngredients
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
    }
    
    internal func updateList(_ action: IngredientsRepository.Action) {
        DispatchQueue.main.async {
            withAnimation {
                switch action {
                case .deleted(let ingredient):
                    self.ingredients.removeAll(where: {$0.id == ingredient.id})
                case .added(let ingredient):
                    self.addingIngredient = ingredient
                    guard ingredient.parentIngredient == nil else {return}
                    let index = self.ingredients.map({$0.name ?? ""})
                        .findAlphabeticalOrderIndex(for: ingredient.name ?? "")
                    self.ingredients.insert(ingredient, at: index)
                case .updated(let ingredient):
                    if let index = self.ingredients.firstIndex(where: {$0.id == ingredient.id}) {
                        self.ingredients[index] = ingredient
                    }
                }
            }
        }
    }
}
