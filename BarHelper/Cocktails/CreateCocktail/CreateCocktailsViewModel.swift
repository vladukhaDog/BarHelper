//
//  CreateCocktailsViewModel.swift
//  BarHelper
//
//  Created by Владислав Пермяков on 09.05.2023.
//

import Foundation
import SwiftUI

class CreateCocktailsViewModel: ObservableObject{
    let db = DBManager.shared
    

    @Published var types: [CookingType] = []
    
    @Published var recipe: [DBIngredient: Int] = [:]
    @Published var name = ""
    @Published var description = ""
    @Published var cookType: CookingType? = nil
    @Published var image: UIImage? = nil
    
    @Published var imagePlaceholer: String = ((1...8).randomElement() ?? 1).description
    
    @Binding var toEditCocktail: DBCocktail?
    
    init() {
        self._toEditCocktail = .constant(nil)
        Task{
            await fetchTypes()
        }
    }
    
    init(editCocktail: Binding<DBCocktail?>){
        self._toEditCocktail = editCocktail
        if let cocktail = editCocktail.wrappedValue{
            name = cocktail.name ?? ""
            description = cocktail.desc ?? ""
            cookType = cocktail.cookingType
            if let imageName = cocktail.image?.fileName,
               let imageData = try? Data(contentsOf: FileManager.default.temporaryDirectory.appendingPathComponent(imageName)),
               let uiImage = UIImage(data: imageData){
                image = uiImage
            }
            
            if let recipeNSSet = cocktail.recipe,
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
        }
        Task{
            await fetchTypes()
        }
    }
    

    
    
    func save(){
        Task{
            guard let editedCocktail = toEditCocktail else {return}
            if let oldImage = editedCocktail.image, let oldImageName = oldImage.fileName{
                try? FileManager.default.removeItem(at: FileManager.default.temporaryDirectory.appendingPathComponent(oldImageName))
                await db.deleteImage(image: oldImage)
            }
            var imageEntry: ImageEntry? = nil
            do {
                // get the documents directory url
                let documentsDirectory = FileManager.default.temporaryDirectory
                print("documentsDirectory:", documentsDirectory.path)
                // choose a name for your image
                let fileName = "\(name)_\(UUID().uuidString).jpg"
                // create the destination file url to save your image
                let fileURL = documentsDirectory.appendingPathComponent(fileName)
                // get your UIImage jpeg data representation and check if the destination file url already exist
                let image = self.image ?? UIImage(named: self.imagePlaceholer)
                if let image, let data = image.pngData(),
                    !FileManager.default.fileExists(atPath: fileURL.path) {
                    // writes the image data to disk
                    try data.write(to: fileURL)
                    imageEntry = await db.addImage(name: fileName)
                }
            } catch {
                print("error creating image cocktail for edit cocktail:", error)
            }
            editedCocktail.image = imageEntry
            editedCocktail.name = name
            editedCocktail.desc = description
            editedCocktail.cookingType = cookType
            if let recipeNSSet = editedCocktail.recipe,
               let recipeSet = recipeNSSet as? Set<DBIngredientRecord>{
                let recipeSorted = recipeSet.sorted { l, r in
                    (l.ingredient?.name ?? "") < (r.ingredient?.name ?? "")
                }
                for inr in recipeSorted{
                    await db.deleteIngredientRecord(ing: inr)
                }
            }
            
            for ingredient in recipe{
                let ingredientRecord = DBIngredientRecord(context: db.backgroundContext)
                ingredientRecord.ingredientValue = Int64(ingredient.value)
                ingredientRecord.ingredient = ingredient.key
                editedCocktail.addToRecipe(ingredientRecord)
            }
            await db.saveContext()
            self.toEditCocktail = editedCocktail
        }
    }
    
    func add(){
        Task{
            var imageEntry: ImageEntry? = nil
            do {
                // get the documents directory url
                let documentsDirectory = FileManager.default.temporaryDirectory
                print("documentsDirectory for new Image:", documentsDirectory.path)
                // choose a name for your image
                let fileName = "\(name)_\(UUID().uuidString).jpg"
                // create the destination file url to save your image
                let fileURL = documentsDirectory.appendingPathComponent(fileName)
                // get your UIImage jpeg data representation and check if the destination file url already exists
                let image = self.image ?? UIImage(named: self.imagePlaceholer)
                if let image, let data = image.pngData(),
                    !FileManager.default.fileExists(atPath: fileURL.path) {
                    // writes the image data to disk
                    try data.write(to: fileURL)
                    imageEntry = await db.addImage(name: fileName)
                }
            } catch {
                print("error Creating image cocktail:", error)
            }
            guard let cookType else {return}
            await db.addCocktail(name: name,
                                 description: description,
                                 cookingType: cookType,
                                 recipe: recipe,
            image: imageEntry)
        }
    }
  

    private func fetchTypes() async{
#warning("NO FETCH FOR COOOKING METHODS")
//        let types = await db.fetchCookingTypes()
//        DispatchQueue.main.async {
//            self.types = types
//            if self.cookType == nil{
//                self.cookType = self.types.first
//            }
//        }
    }

}
