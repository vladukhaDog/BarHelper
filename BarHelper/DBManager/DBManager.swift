//
//  DBManager.swift
//  BarHelper
//
//  Created by Владислав Пермяков on 09.05.2023.
//

import Foundation
import CoreData
import os

enum RepositoryError: Error {
    case alreadyExists
    case contextError(Error)
    case cannotBeAParent
    case cannotHaveAParent
}

class DBManager: ObservableObject{
    
    private let q = DispatchQueue(label: "coredata.manager.queue")
    
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
    
    
    private(set) var container: NSPersistentContainer
    private(set) lazy var backgroundContext: NSManagedObjectContext = {
        let newbackgroundContext = container.newBackgroundContext()
        newbackgroundContext.automaticallyMergesChangesFromParent = true
        return newbackgroundContext
    }()
    
    func addIngredient(name: String, metric: String, parentIngredient: DBIngredient? = nil) async -> DBIngredient? {
        await withCheckedContinuation({ continuation in
            self.backgroundContext.performAndWait{
                let request = DBIngredient.fetchRequest()
                let predicate = NSPredicate(format: "name == %@", name)
                request.predicate = predicate
                request.fetchLimit = 1
                let items = (try? self.backgroundContext.fetch(request)) ?? []
                if items.isEmpty{
                    let newIngredient = DBIngredient(context: self.backgroundContext)
                    if let parentIngredient{
                        newIngredient.parentIngredient = parentIngredient
                    }
                    newIngredient.id = .init()
                    newIngredient.name = name
                    newIngredient.metric = metric
                    self.saveContext()
                    continuation.resume(returning: newIngredient)
                }else{
                    continuation.resume(returning: nil)
                }
                
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
                var predicates: [NSPredicate] = []
                if let search{
                    predicates.append(NSCompoundPredicate.init(type: .or, subpredicates: [
                        NSPredicate(format: "name CONTAINS[c] %@", search.lowercased()),
                        NSPredicate(format: "ANY alternatives.name CONTAINS[c] %@", search.lowercased()),
                    ]))
                }
                predicates.append(NSPredicate(format: "parentIngredient == nil"))
                request.predicate = NSCompoundPredicate.init(type: .and, subpredicates: predicates)
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
  
    
    
    func addCocktail(name: String, description: String, cookingMethod: CookingMethod, recipe: [DBIngredient: Int], image: ImageEntry?) async {
        await withCheckedContinuation({ continuation in
            self.backgroundContext.performAndWait{
                let cocktail = DBCocktail(context: self.backgroundContext)
                
                cocktail.id = .init()
                cocktail.name = name
                cocktail.desc = description
                cocktail.cookingMethod = cookingMethod
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
