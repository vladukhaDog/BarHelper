//
//  CookingMethodRepository.swift
//  BarHelper
//
//  Created by Владислав Пермяков on 24.09.2024.
//

import Foundation
import CoreData

/// Repository to change records about Cooking Methods
final class CookingMethodRepository {
    
    /// Context which is used to access data memory safe
    /// ```swift
    ///await withCheckedContinuation({ continuation in
    /// self.backgroundContext.performAndWait{
    ///         //FETCH DATA
    ///         //RETURN DATA
    ///         continuation.resume(returning: DATA)
    ///         //OR CONTINUE WITHOUT RETURN
    ///         continuation.resume()
    /// }
    ///})
    ///
    /// ```
    private let context: NSManagedObjectContext
    
    init() {
        self.context = DBManager.shared.backgroundContext
    }
    
    // TODO: ADD LISTENERS AND NOTIFS
    
    func addCookingType(name: String) async throws {
        try await withCheckedThrowingContinuation {continuation in
            do {
                try self.context.performAndWait{
                    // Get request for the struct
                    let request = CookingType.fetchRequest()
                    // Look for existing one by name
                    let predicate = NSPredicate(format: "name == %@", name)
                    request.predicate = predicate
                    request.fetchLimit = 1
                    // Fetching existing records
                    let items = try self.context.fetch(request)
                    
                    // if list is empty, we are creating a new Cooking type and saving the context
                    if items.isEmpty{
                        let type = CookingType(context: self.context)
                        type.name = name
                        
                        if self.context.hasChanges{
                            try context.save()
                        }
                        continuation.resume()
                        
                    } else {
                        // Else we just throw an error that the cooking type with this name already exists
                        continuation.resume(throwing: RepositoryError.alreadyExists)
                    }
                    
                }
            } catch(let contextError) {
                continuation.resume(throwing: RepositoryError.contextError(contextError))
            }
        }
    }
    
    func fetchCookingTypes() async throws -> [CookingType] {
        try await withCheckedThrowingContinuation({ continuation in
            self.context.performAndWait{
                
                let request = CookingType.fetchRequest()
                request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
                do {
                    let items = try self.context.fetch(request)
                    continuation.resume(returning: items)
                } catch {
                    continuation.resume(throwing: RepositoryError.contextError(error))
                }
            }
        })
        
    }
    
    func deleteCookingType(cookingType: CookingType) async throws {
        try await withCheckedThrowingContinuation({ continuation in
            self.context.performAndWait{
                self.context.delete(cookingType)
                do {
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
