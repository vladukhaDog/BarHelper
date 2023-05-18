//
//  DBManager.swift
//  BarHelper
//
//  Created by Владислав Пермяков on 09.05.2023.
//

import Foundation
import CoreData
import os


class DBManager: ObservableObject{
    
    let q = DispatchQueue(label: "coredata.manager.queue")
    
    private init(){
        let container = NSPersistentContainer(name: "BarHelper")
        container.loadPersistentStores { storeDescription, error in
            if let error {
                fatalError("init Ошибка загрузки контейнера \(error.localizedDescription)")
            }
        }
        
        self.container = container
        print("init Загрузили контейнер")
    }
    
    public static let shared = DBManager.init()
    
    
    public var container: NSPersistentContainer
    lazy var backgroundContext: NSManagedObjectContext = {
        let newbackgroundContext = container.newBackgroundContext()
        newbackgroundContext.automaticallyMergesChangesFromParent = true
        return newbackgroundContext
    }()
    
    func addIngredient(name: String, metric: String) async {
        await withCheckedContinuation({ continuation in
            self.backgroundContext.performAndWait{
                let request = DBIngredient.fetchRequest()
                let predicate = NSPredicate(format: "name == %@", name)
                request.predicate = predicate
                request.fetchLimit = 1
                let items = (try? self.backgroundContext.fetch(request)) ?? []
                if items.isEmpty{
                    let newIngredient = DBIngredient(context: self.backgroundContext)
                    newIngredient.id = .init()
                    newIngredient.name = name
                    newIngredient.metric = metric
                    self.saveContext()
                }
                continuation.resume()
            }
        })
        
    }
    
    func deleteIngredient(ingredient: DBIngredient) async {
        await withCheckedContinuation({ continuation in
            self.backgroundContext.performAndWait{
                self.backgroundContext.delete(ingredient)
                self.saveContext()
                continuation.resume()
            }
        })
    }
    
    func fetchIngredients(search: String? = nil) async -> [DBIngredient] {
        await withCheckedContinuation({ continuation in
            self.backgroundContext.performAndWait{
                
                let request = DBIngredient.fetchRequest()
                request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
                if let search{
                    request.predicate = NSPredicate(format: "name CONTAINS[c] %@", search.lowercased())
                }
                do{
                    let items = try self.backgroundContext.fetch(request)
                    continuation.resume(returning: items)
                }catch{
                    print("fetchIngredients произошла ошибка получения списка всех ингредиентов в БД \(error.localizedDescription)")
                    continuation.resume(returning: [])
                }
                
            }
        })
        
    }
  
    
    
    func addCocktail(name: String, description: String, cookingType: CookingType, recipe: [DBIngredient: Int], image: ImageEntry?) async {
        await withCheckedContinuation({ continuation in
            self.backgroundContext.performAndWait{
                let cocktail = DBCocktail(context: self.backgroundContext)
                
                cocktail.id = .init()
                cocktail.name = name
                cocktail.desc = description
                cocktail.cookingType = cookingType
                cocktail.image = image
                for ingredient in recipe{
                    let ingredientRecord = DBIngredientRecord(context: self.backgroundContext)
                    ingredientRecord.ingredientValue = Int64(ingredient.value)
                    ingredientRecord.ingredient = ingredient.key
                    cocktail.addToRecipe(ingredientRecord)
                }
                self.saveContext()
                continuation.resume()
            }
        })

    }
    func saveContext() async {
        await withCheckedContinuation({ continuation in
            self.backgroundContext.performAndWait{
                self.saveContext()
                continuation.resume()
            }
        })

    }
    
    func addImage(name: String) async -> ImageEntry {
        await withCheckedContinuation({ continuation in
            self.backgroundContext.performAndWait{
                let image = ImageEntry(context: self.backgroundContext)
                image.fileName = name
                self.saveContext()
                continuation.resume(returning: image)
            }
        })
    }
    
    func deleteIngredientRecord(ing: DBIngredientRecord) async {
        await withCheckedContinuation({ continuation in
            self.backgroundContext.performAndWait{
                self.backgroundContext.delete(ing)
                self.saveContext()
                continuation.resume()
            }
        })
    }
    
    
    func deleteImage(image: ImageEntry) async {
        await withCheckedContinuation({ continuation in
            self.backgroundContext.performAndWait{
                self.backgroundContext.delete(image)
                self.saveContext()
                continuation.resume()
            }
        })
    }
    
    func addCookingType(name: String) async {
        await withCheckedContinuation({ continuation in
            self.backgroundContext.performAndWait{
                let request = CookingType.fetchRequest()
                let predicate = NSPredicate(format: "name == %@", name)
                request.predicate = predicate
                request.fetchLimit = 1
                let items = (try? self.backgroundContext.fetch(request)) ?? []
                if items.isEmpty{
                    let type = CookingType(context: self.backgroundContext)
                    type.name = name
                    self.saveContext()
                }
                continuation.resume()
            }
        })
    }
    
    func fetchCookingTypes() async -> [CookingType] {
        await withCheckedContinuation({ continuation in
            self.backgroundContext.performAndWait{
                
                let request = CookingType.fetchRequest()
                request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
                do{
                    let items = try self.backgroundContext.fetch(request)
                    continuation.resume(returning: items)
                }catch{
                    print("fetchCookingTypes произошла ошибка получения списка всех видов приготовления в БД \(error.localizedDescription)")
                    continuation.resume(returning: [])
                }
                
            }
        })
        
    }
    
    func deleteCookingType(cookingType: CookingType) async{
        await withCheckedContinuation({ continuation in
            self.backgroundContext.performAndWait{
                self.backgroundContext.delete(cookingType)
                self.saveContext()
                continuation.resume()
            }
        })
    }
    
    func deleteCocktail(cocktail: DBCocktail) async {
        await withCheckedContinuation({ continuation in
            self.backgroundContext.performAndWait{
                self.backgroundContext.delete(cocktail)
                self.saveContext()
                continuation.resume()
            }
        })
    }
    
    func fetchCocktails(search: String? = nil) async -> [DBCocktail] {
        await withCheckedContinuation({ continuation in
            self.backgroundContext.performAndWait{
                
                let request = DBCocktail.fetchRequest()
//                request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
                if let search{
                    request.predicate = NSPredicate(format: "name CONTAINS[c] %@", search.lowercased())
                }
                do{
                    let items = try self.backgroundContext.fetch(request)
                    continuation.resume(returning: items)
                }catch{
                    print("fetchIngredients произошла ошибка получения списка всех ингредиентов в БД \(error.localizedDescription)")
                    continuation.resume(returning: [])
                }
                
            }
        })
        
    }
    
    func fetchCocktails(hasAllIngredients ingredients: [DBIngredient]) async -> [DBCocktail] {
        await withCheckedContinuation({ continuation in
            self.backgroundContext.performAndWait{
                
                let request = DBCocktail.fetchRequest()
                
                do{
                    let items = try self.backgroundContext.fetch(request)
                    continuation.resume(returning: items)
                }catch{
                    print("fetchIngredients произошла ошибка получения списка всех ингредиентов в БД \(error.localizedDescription)")
                    continuation.resume(returning: [])
                }
                
            }
        })
        
    }
    
    
    private func saveContext(){
        let context = self.backgroundContext
        if context.hasChanges{
            do{
                try context.save()
            }catch{
                print("Ошибка сохранения \(error.localizedDescription)")
            }
        }
    }
}
