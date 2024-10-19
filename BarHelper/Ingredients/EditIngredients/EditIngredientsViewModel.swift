//
//  EditIngredientsViewModel.swift
//  BarHelper
//
//  Created by Владислав Пермяков on 19.10.2024.
//

import Foundation

final class EditIngredientsViewModel: EditIngredientsViewModelProtocol {
    private var router: Router? = nil
    let ingredient: DBIngredient
    private let ingredientsRepository: IngredientsRepository
    @Published var name: String
    
    func setup(_ router: Router) async {
        await MainActor.run {
            self.router = router
        }
    }
    
    func save() {
        Task {
            do {
                try await ingredientsRepository.editIngredient(ingredient, newName: name)
                await router?.back()
            } catch RepositoryError.alreadyExists{
                AlertsManager.shared.alert("That name already exists")
            } catch RepositoryError.contextError(let error) {
                AlertsManager.shared.alert("Database error occured")
                print("failed to edit ingredient", error)
            }  catch {
                AlertsManager.shared.alert("Something went wrong")
                print("Something bad happened", error)
            }
        }
    }
    
    func cancel() {
        Task {
            await router?.back()
        }
    }
    
    init(_ ingredient: DBIngredient) {
        self.ingredient = ingredient
        self.name = ingredient.name ?? ""
        self.ingredientsRepository = .init()
    }
}
