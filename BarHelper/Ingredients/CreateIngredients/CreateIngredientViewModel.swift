//
//  CreateIngredientViewModel.swift
//  BarHelper
//
//  Created by Владислав Пермяков on 11.05.2023.
//

import Foundation

class CreateIngredientViewModel: ObservableObject{
    private let ingredientRepository: IngredientsRepository = .init()
    
    @Published var name = ""
    @Published var description = ""
    @Published var metric = "ml"
    let parent: DBIngredient?
    private var router: Router? = nil
    init(parent: DBIngredient? = nil){
        self.parent = parent
    }
    
    func setup(_ router: Router) async {
        await MainActor.run {
            self.router = router
        }
    }
    
    func addIngredient() {
        Task {
            do {
                try await ingredientRepository.addIngredient(name: self.name,
                                                             metric: parent?.metric ?? self.metric,
                                                             description: self.description,
                                                             parentIngredient: self.parent)
                await MainActor.run {
                    self.router?.back()
                }
            } catch RepositoryError.alreadyExists{
                AlertsManager.shared.alert("That name already exists")
            } catch RepositoryError.contextError(let error) {
                AlertsManager.shared.alert("Database error occured")
                print("failed to edit ingredient", error)
            } catch RepositoryError.cannotHaveAParent{
                AlertsManager.shared.alert("Ingredient cannot be a parent")
            } catch {
                AlertsManager.shared.alert("Something went wrong")
                print("Something bad happened", error)
            }
        }
    }
}
