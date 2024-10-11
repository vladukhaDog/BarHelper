//
//  IngredientsRepository.swift
//  BarHelper
//
//  Created by Владислав Пермяков on 07.10.2024.
//

import Foundation
import CoreData

/// Dependency Injection info for a class that writes/gets Ingredient and notifies about it
typealias IngredientsDI = Repository<DBIngredient> & IngredientsRepositoryProtocol

enum IngredientFuseMode {
    /// makes all children orphans and assigns the parent
    case becomeChild(parent: DBIngredient)
    /// combines both sets of children to the ingredients
    case becomeParent
    /// sets parent and children to nil
    case becomeLonely
}

protocol IngredientsRepositoryProtocol {
    func editIngredient(_ ingredient: DBIngredient) async throws
    func addIngredient(name: String, metric: String, parentIngredient: DBIngredient?) async throws -> DBIngredient
    func fuse(left: DBIngredient, right: DBIngredient, name: String, metric: String, mode: IngredientFuseMode) async throws -> DBIngredient
    func assignParent(ingredient: DBIngredient, parent: DBIngredient) async throws -> DBIngredient
    func fetchIngredients(search: String?) async throws -> [DBIngredient]
    func deleteIngredient(ingredient: DBIngredient) async throws
}

/// Repository to change records about Cooking Methods
final class IngredientsRepository: IngredientsDI {
    
    func editIngredient(_ ingredient: DBIngredient) async throws {
        try await withCheckedThrowingContinuation { continuation in
            do {
                try self.context.performAndWait{
                    if self.context.hasChanges{
                        try context.save()
                    }
                    self.sendAction(.updated(ingredient))
                    continuation.resume()
                }
            } catch(let contextError) {
                continuation.resume(throwing: RepositoryError.contextError(contextError))
            }
        }
    }
    
    @discardableResult
    func addIngredient(name: String, metric: String, parentIngredient: DBIngredient? = nil) async throws -> DBIngredient {
        try await withCheckedThrowingContinuation({ continuation in
            do {
                try self.context.performAndWait{
                    let request = DBIngredient.fetchRequest()
                    let predicate = NSPredicate(format: "name == %@", name)
                    request.predicate = predicate
                    request.fetchLimit = 1
                    let items = (try? self.context.fetch(request)) ?? []
                    if items.isEmpty{
                        let newIngredient = DBIngredient(context: self.context)
                        if let parentIngredient{
                            newIngredient.parentIngredient = parentIngredient
                        }
                        newIngredient.id = .init()
                        newIngredient.name = name
                        newIngredient.metric = metric
                        try context.save()
                        continuation.resume(returning: newIngredient)
                        self.sendAction(.added(newIngredient))
                        
                        // updating parent for it to have the new children
                        if let parentIngredient {
                            var children = (parentIngredient.alternatives as? Set<DBIngredient>) ?? Set<DBIngredient>()
                            children.insert(newIngredient)
                            parentIngredient.alternatives = children as NSSet
                            self.sendAction(.updated(parentIngredient))
                        }
                        
                            
                    }else{
                        continuation.resume(throwing: RepositoryError.alreadyExists)
                    }
                    
                }
            } catch {
                continuation.resume(throwing: RepositoryError.contextError(error))
            }
        })
        
    }
    
    /*
     left right
     • Component can be fused with another component
     • You can select the final name, unit of meas., description, image, parent if one of the
     components has one)
     • all children from both components will be combined
     • if one component is a parent and another is a child - a selector should be available for
     component to be:
     a child with a selectable parent or to be
     a parent saving all the children
     
     • if a first option selected, all the children of a fused component which is now a child of
     itself, loose the link to a parent and become separate components
     • After fusing, list of cocktails can be viewed, showing the fused component in the recipes and the amount available for change in the event that the old value does not represent the new
     unit measurement correctly
     
     var id: UUID?
     var metric: String?
     var name: String?
     var alternatives: NSSet? // DBIngredient
     var parentIngredient: DBIngredient?
     var records: NSSet? // DBIngredientRecord
     
     left.name = name
     left.metric = metric
     
     if becomeAChild {
        left.parentIngredient = parent
        left.alternatives.removeAll
     } else if becomeParent {
        left.parentIngredient = nil
        left.alternatives.append(right.alternatives)
     } else {
        left.parentIngredient = nil
        left.alternatives.removeAll
     }
     
     for record in right.records {
        record.ingredient = left
     }
     
     
     */
    
    
    
    func fuse(left: DBIngredient, right: DBIngredient, name: String, metric: String, mode: IngredientFuseMode) async throws -> DBIngredient {
        try await withCheckedThrowingContinuation({ continuation in
            do {
                try self.context.performAndWait{
                    
                    left.name = name
                    left.metric = metric
                    
                    switch mode {
                    case .becomeChild(let parent):
                        left.parentIngredient = parent
                        left.alternatives = nil
                    case .becomeParent:
                        left.parentIngredient = nil
                        if let rightChildren = right.alternatives as? Set<DBIngredient>,
                           let leftChildren = left.alternatives as? Set<DBIngredient> {
                            let combinedChildren = leftChildren.union(rightChildren)
                            left.alternatives = combinedChildren as NSSet
                        }
                    case .becomeLonely:
                        left.alternatives = nil
                        left.parentIngredient = nil
                    }
                    if let records = right.records as? Set<DBIngredientRecord> {
                        for record in records {
                            record.ingredient = left
                        }
                    }
                    self.context.delete(right)
                    try context.save()
                    continuation.resume(returning: left)
                    self.sendAction(.updated(left))
                    self.sendAction(.deleted(right))
                }
            } catch {
                continuation.resume(throwing: RepositoryError.contextError(error))
            }
        })
    }
    
    @discardableResult
    func assignParent(ingredient: DBIngredient, parent: DBIngredient) async throws -> DBIngredient {
        try await withCheckedThrowingContinuation({ continuation in
            do {
                try self.context.performAndWait{
                    guard parent.parentIngredient == nil else {
                        throw RepositoryError.cannotBeAParent
                    }
                    guard ingredient.alternatives == [] || ingredient.alternatives == nil else {
                        throw RepositoryError.cannotHaveAParent
                    }
                    ingredient.parentIngredient = parent
                    try context.save()
                    continuation.resume(returning: ingredient)
                    self.sendAction(.updated(ingredient))
                }
            } catch {
                continuation.resume(throwing: RepositoryError.contextError(error))
            }
        })
    }
    
    func fetchIngredients(search: String? = nil) async throws -> [DBIngredient] {
       try await withCheckedThrowingContinuation({ continuation in
            self.context.performAndWait{
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
                do {
                    let items = try self.context.fetch(request)
                    continuation.resume(returning: items)
                } catch {
                    continuation.resume(throwing: RepositoryError.contextError(error))
                }
                
            }
        })
        
    }
    
    func deleteIngredient(ingredient: DBIngredient) async throws {
        try await withCheckedThrowingContinuation({ continuation in
            self.context.performAndWait{
                self.context.delete(ingredient)
                do {
                    self.sendAction(.deleted(ingredient))
                    
                    // if deleted is a child, we update the parent to listeners
                    if let parent = ingredient.parentIngredient,
                       var children = parent.alternatives as? Set<DBIngredient> {
                        children.remove(ingredient)
                        parent.alternatives = children as NSSet
                        self.sendAction(.updated(parent))
                    }
                    // if ingredient has children, we are setting their parent to nil and technically it counts as adding separate ingredients
                    if let children = ingredient.alternatives as? Set<DBIngredient> {
                        children.forEach({
                            $0.parentIngredient = nil
                            self.sendAction(.added($0))
                        })
                    }
                    if self.context.hasChanges{
                        try context.save()
                    }
                    continuation.resume()
                } catch {
                    continuation.resume(throwing: RepositoryError.contextError(error))
                }
            }
        })
    }
}
