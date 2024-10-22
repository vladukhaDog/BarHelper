//
//  CocktailsRepository.swift
//  BarHelper
//
//  Created by Владислав Пермяков on 21.10.2024.
//

import Foundation
import CoreData
import UIKit

/// Dependency Injection info for a class that writes/gets Cocktails and notifies about it
typealias CocktailsDI = Repository<DBCocktail> & CocktailsRepositoryProtocol

struct Cocktail: Hashable {
    static func == (lhs: Cocktail, rhs: Cocktail) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
    
    var description: String?
    var id: UUID
    var isFavourite: Bool
    var name: String?
    var cookingMethod: CookingMethod?
    var image: ImageEntry?
    var recipe: [IngredientRecord]?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(description)
        hasher.combine(isFavourite)
        hasher.combine(name)
        hasher.combine(cookingMethod?.name)
        hasher.combine(image?.fileName)
    }
}

struct IngredientRecord {
    var ingredientValue: Int
    var ingredient: DBIngredient?
}

extension DBIngredientRecord {
    func structRecord() -> IngredientRecord {
        IngredientRecord(ingredientValue: Int(self.ingredientValue),
                         ingredient: self.ingredient)
    }
}

extension DBCocktail {
    func structCocktail() -> Cocktail {
        let recipe = (self.recipe as? Set<DBIngredientRecord>) ?? .init()
        return Cocktail(description: self.desc,
                 id: self.id ?? .init(),
                 isFavourite: self.isFavourite,
                 name: self.name,
                 cookingMethod: self.cookingMethod,
                 image: self.image,
                 recipe: recipe.map({$0.structRecord()}))
    }
}

protocol CocktailsRepositoryProtocol {
    @discardableResult
    func addCocktail(name: String,
                     description: String,
                     cookingMethod: CookingMethod,
                     recipe: [DBIngredient: Int],
                     image: ImageEntry?) async throws -> DBCocktail
    func deleteCocktail(_ cocktail: DBCocktail) async throws
    func favCocktail(_ cocktail: DBCocktail, isFav: Bool) async throws
    func fetchCocktails(search: String?) async throws -> [DBCocktail]
    func fetchFavCocktails(limit: Int?) async throws -> [DBCocktail]
    @discardableResult
    func editCocktail(originCocktail: DBCocktail,
                      name: String,
                      description: String,
                      cookingMethod: CookingMethod,
                      recipe: [DBIngredient: Int],
                      image: ImageEntry?) async throws -> DBCocktail
}

final class CocktailsRepository: CocktailsDI {
    @discardableResult
    func editCocktail(originCocktail: DBCocktail,
                      name: String,
                      description: String,
                      cookingMethod: CookingMethod,
                      recipe: [DBIngredient: Int],
                      image: ImageEntry?) async throws -> DBCocktail {
        try await withCheckedThrowingContinuation({ continuation in
            do {
                try self.context.performAndWait {
                    // check if same name cocktail exists
                    if name != originCocktail.name{
                        let request = DBCocktail.fetchRequest()
                        let predicate = NSPredicate(format: "name == %@", name)
                        request.predicate = predicate
                        request.fetchLimit = 1
                        let items = (try? self.context.fetch(request)) ?? []
                        guard items.isEmpty else {
                            continuation.resume(throwing: RepositoryError.alreadyExists)
                            return
                        }
                    }
                    
                    let cocktail = originCocktail
                    cocktail.name = name
                    cocktail.desc = description
                    cocktail.cookingMethod = cookingMethod
                    cocktail.image = image
                    // deleting old recipe
                    if let recipeNSSet = originCocktail.recipe,
                       let recipeSet = recipeNSSet as? Set<DBIngredientRecord>{
                        let recipeSorted = recipeSet.sorted { l, r in
                            (l.ingredient?.name ?? "") < (r.ingredient?.name ?? "")
                        }
                        for ingredientRecord in recipeSorted{
                            self.context.delete(ingredientRecord)
                        }
                    }
                    // writing new recipe
                    for ingredient in recipe{
                        let ingredientRecord = DBIngredientRecord(context: self.context)
                        ingredientRecord.ingredientValue = Int64(ingredient.value)
                        ingredientRecord.ingredient = ingredient.key
                        cocktail.addToRecipe(ingredientRecord)
                    }
                    if self.context.hasChanges{
                        try context.save()
                    }
                    self.sendAction(.updated(cocktail))
                    continuation.resume(returning: cocktail)
                }
            } catch {
                continuation.resume(throwing: RepositoryError.contextError(error))
            }
        })
    }
    
    @discardableResult
    func addCocktail(name: String,
                     description: String,
                     cookingMethod: CookingMethod,
                     recipe: [DBIngredient: Int],
                     image: ImageEntry?) async throws -> DBCocktail {
        try await withCheckedThrowingContinuation({ continuation in
            do {
                try self.context.performAndWait {
                    // check if same name cocktail exists
                    let request = DBCocktail.fetchRequest()
                    let predicate = NSPredicate(format: "name == %@", name)
                    request.predicate = predicate
                    request.fetchLimit = 1
                    let items = (try? self.context.fetch(request)) ?? []
                    guard items.isEmpty else {
                        continuation.resume(throwing: RepositoryError.alreadyExists)
                        return
                    }
                    
                    let cocktail = DBCocktail(context: self.context)
                    cocktail.id = .init()
                    cocktail.name = name
                    cocktail.desc = description
                    cocktail.cookingMethod = cookingMethod
                    cocktail.image = image
                    for ingredient in recipe{
                        let ingredientRecord = DBIngredientRecord(context: self.context)
                        ingredientRecord.ingredientValue = Int64(ingredient.value)
                        ingredientRecord.ingredient = ingredient.key
                        cocktail.addToRecipe(ingredientRecord)
                    }
                    if self.context.hasChanges{
                        try context.save()
                    }
                    self.sendAction(.added(cocktail))
                    continuation.resume(returning: cocktail)
                }
            } catch {
                continuation.resume(throwing: RepositoryError.contextError(error))
            }
        })
    }
    
    func deleteCocktail(_ cocktail: DBCocktail) async throws {
        try await withCheckedThrowingContinuation({ continuation in
            do {
                try self.context.performAndWait{
                    self.context.delete(cocktail)
                    if self.context.hasChanges{
                        try context.save()
                    }
                    self.sendAction(.deleted(cocktail))
                    continuation.resume()
                }
            } catch {
                continuation.resume(throwing: RepositoryError.contextError(error))
            }
        })
    }
    
    func favCocktail(_ cocktail: DBCocktail, isFav: Bool) async throws {
        try await withCheckedThrowingContinuation({ continuation in
            do {
                try self.context.performAndWait{
                    cocktail.isFavourite = isFav
                    if self.context.hasChanges{
                        try context.save()
                    }
                    self.sendAction(.updated(cocktail))
                    continuation.resume()
                }
            } catch {
                continuation.resume(throwing: RepositoryError.contextError(error))
            }
        })
    }
    
    func fetchCocktails(search: String? = nil) async throws -> [DBCocktail] {
        try await withCheckedThrowingContinuation({ continuation in
            do {
                try self.context.performAndWait{
                    let request = DBCocktail.fetchRequest()
                    if let search {
                        request.predicate = NSPredicate(format: "name CONTAINS[c] %@", search.lowercased())
                    }
                    let items = try self.context.fetch(request)
                    continuation.resume(returning: items)
                }
            } catch {
                continuation.resume(throwing: RepositoryError.contextError(error))
            }
        })
    }
    
    func fetchFavCocktails(limit: Int? = nil) async throws -> [DBCocktail] {
        try await withCheckedThrowingContinuation({ continuation in
            do {
                try self.context.performAndWait{
                    let request = DBCocktail.fetchRequest()
                    if let limit {
                        request.fetchLimit = limit
                    }
                    let items = try self.context.fetch(request)
                    continuation.resume(returning: items)
                }
            } catch {
                continuation.resume(throwing: RepositoryError.contextError(error))
            }
        })
    }
}
