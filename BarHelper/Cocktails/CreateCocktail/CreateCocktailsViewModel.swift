//
//  CreateCocktailsViewModel.swift
//  BarHelper
//
//  Created by Владислав Пермяков on 09.05.2023.
//

import Foundation
import SwiftUI
import Combine

enum CocktailEditMode {
    case create
    case edit
}

class CreateCocktailsViewModel: ObservableObject {
    let db = DBManager.shared
    private let cocktailsRepository: CocktailsDI = CocktailsRepository()
    private let cookingMethodsRepository: CookingMethodDI = CookingMethodRepository()
    private let imagesRepository: ImagesDI = ImagesRepository()

    @Published var methods: [CookingMethod] = []
    
    @Published var recipe: [DBIngredient: Int] = [:]
    @Published var name = ""
    @Published var description = ""
    @Published var cookType: CookingMethod? = nil
    @Published var image: UIImage? = nil
    @Published var imagePlaceholer: String = ((1...8).randomElement() ?? 1).description
    private var router: Router?
    
    let mode: CocktailEditMode
    private let cocktailToEdit: DBCocktail?
    
    init() {
        self.mode = .create
        self.cocktailToEdit = nil
        Task {
            await fetchMethods()
        }
    }
    
    init(editCocktail: DBCocktail) {
        self.mode = .edit
        self.cocktailToEdit = editCocktail
        name = editCocktail.name ?? ""
        description = editCocktail.desc ?? ""
        cookType = editCocktail.cookingMethod
        if let image = editCocktail.image?.getImage(){
            self.image = image
        }
        
        if let recipeNSSet = editCocktail.recipe,
           let recipeSet = recipeNSSet as? Set<DBIngredientRecord>{
            let recipeSorted = recipeSet.sorted { l, r in
                (l.ingredient?.name ?? "") < (r.ingredient?.name ?? "")
            }
            recipe = recipeSorted.reduce(into: [DBIngredient: Int](), { partialResult, ingr in
                if let ingredient = ingr.ingredient{
                    partialResult[ingredient] = Int(ingr.ingredientValue)
                }
            })
        }
        
        Task {
            await fetchMethods()
        }
    }
    
    internal func updateList(_ action: CookingMethodDI.Action) {
        DispatchQueue.main.async {
            withAnimation {
                switch action {
                case .deleted(let cookingMethod):
                    self.methods.removeAll(where: {$0.id == cookingMethod.id})
                case .added(let cookingMethod):
                    self.methods.append(cookingMethod)
                case .updated(let cookingMethod):
                    if let index = self.methods.firstIndex(where: {$0.id == cookingMethod.id}){
                        self.methods[index] = cookingMethod
                    }
                }
            }
        }
    }
    
    func setup(router: Router) {
        self.router = router
    }
    
    func save() {
        Task {
            do {
                guard let uiImage = self.image ?? UIImage(named: self.imagePlaceholer) else {
                    AlertsManager.shared.alert("Please select an image")
                    return
                }
                guard let cookType else {
                    AlertsManager.shared.alert("Please select the cooking type")
                    return}
                guard let original = self.cocktailToEdit else {
                    AlertsManager.shared.alert("No original cocktail")
                    return}
                let image = try await self.imagesRepository.createImage(image: uiImage)
                let oldImage = original.image
                try await self.cocktailsRepository.editCocktail(originCocktail: original,
                                                                name: self.name,
                                                               description: self.description,
                                                               cookingMethod: cookType,
                                                               recipe: self.recipe,
                                                               image: image)
                // delete old
                if let oldImage,
                let fileName = oldImage.fileName,
                let documentsDirectory = FileManager.default
                    .urls(for: .documentDirectory, in: .userDomainMask)
                    .first {
                        try? FileManager.default.removeItem(at: documentsDirectory.appendingPathComponent(fileName))
                }
                await MainActor.run {
                    self.router?.back()
                }
            } catch RepositoryError.alreadyExists{
                AlertsManager.shared.alert("That name already exists")
            } catch RepositoryError.contextError(let error) {
                AlertsManager.shared.alert("Database error occured")
                print("failed to edit ingredient", error)
            } catch {
                AlertsManager.shared.alert("Something went wrong")
                print("Something bad happened", error)
            }
        }
    }
    
    func add(){
        Task {
            do {
                guard let uiImage = self.image ?? UIImage(named: self.imagePlaceholer) else {
                    AlertsManager.shared.alert("Please select an image")
                    return
                }
                guard let cookType else {
                    AlertsManager.shared.alert("Please select the cooking type")
                    return}
                let image = try await self.imagesRepository.createImage(image: uiImage)
                try await self.cocktailsRepository.addCocktail(name: self.name,
                                                               description: self.description,
                                                               cookingMethod: cookType,
                                                               recipe: self.recipe,
                                                               image: image)
                await MainActor.run {
                    self.router?.back()
                }
            } catch RepositoryError.alreadyExists{
                AlertsManager.shared.alert("That name already exists")
            } catch RepositoryError.contextError(let error) {
                AlertsManager.shared.alert("Database error occured")
                print("failed to edit ingredient", error)
            } catch {
                AlertsManager.shared.alert("Something went wrong")
                print("Something bad happened", error)
            }
        }
    }
  

    private func fetchMethods() async {
        do {
            let methods = try await self.cookingMethodsRepository.fetchCookingMethods()
            await MainActor.run {
                self.methods = methods
            }
        } catch RepositoryError.contextError(let error) {
           AlertsManager.shared.alert("Failed to get cooking methods")
           print("failed to fetch cocktails", error)
       } catch {
           AlertsManager.shared.alert("Failed to get cooking methods")
           print("Something bad happened", error)
       }
    }

}
