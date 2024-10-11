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
                                                             parentIngredient: self.parent)
                await MainActor.run {
                    self.router?.back()
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
