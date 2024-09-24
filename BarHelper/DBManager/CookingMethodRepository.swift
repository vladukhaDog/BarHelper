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
    
    enum Action {
        case Deleted(CookingMethod)
        case Added(CookingMethod)
        case Changed(CookingMethod)
        
        func object() -> CookingMethod {
            switch self {
            case .Deleted(let object): return object
            case .Added(let object): return object
            case .Changed(let object): return object
            }
        }
    }
    
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
    
    private func sendAction(_ action: CookingMethodRepository.Action) {
        NotificationCenter.default.post(name: Notification.Name("CookingMethodNotification"),
                                        object: action)
    }
    
    func getPublisher() -> NotificationCenter.Publisher {
        return NotificationCenter.default.publisher(for: Notification.Name("CookingMethodNotification"))
    }
    
//    func editCookingMethod(_ method: CookingMethod) async throws {
//        try await withCheckedThrowingContinuation {continuation in
//            do {
//                try self.context.performAndWait{
//                    // Get request for the struct
//                    let request = CookingMethod.fetchRequest()
//                    // Look for existing one by name
//                    let predicate = NSPredicate(format: "name == %@", name)
//                    request.predicate = predicate
//                    request.fetchLimit = 1
//                    // Fetching existing records
//                    let items = try self.context.fetch(request)
//                    
//                    // if list is empty, we are creating a new Cooking type and saving the context
//                    if items.isEmpty{
//                        let type = CookingMethod(context: self.context)
//                        type.name = name
//                        
//                        if self.context.hasChanges{
//                            try context.save()
//                        }
//                        self.sendAction(.Added(type))
//                        continuation.resume()
//                        
//                    } else {
//                        // Else we just throw an error that the cooking type with this name already exists
//                        continuation.resume(throwing: RepositoryError.alreadyExists)
//                    }
//                    
//                }
//            } catch(let contextError) {
//                continuation.resume(throwing: RepositoryError.contextError(contextError))
//            }
//        }
//    }
    
    func addCookingMethod(name: String) async throws {
        try await withCheckedThrowingContinuation {continuation in
            do {
                try self.context.performAndWait{
                    // Get request for the struct
                    let request = CookingMethod.fetchRequest()
                    // Look for existing one by name
                    let predicate = NSPredicate(format: "name == %@", name)
                    request.predicate = predicate
                    request.fetchLimit = 1
                    // Fetching existing records
                    let items = try self.context.fetch(request)
                    
                    // if list is empty, we are creating a new Cooking type and saving the context
                    if items.isEmpty{
                        let type = CookingMethod(context: self.context)
                        type.name = name
                        
                        if self.context.hasChanges{
                            try context.save()
                        }
                        self.sendAction(.Added(type))
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
    
    func fetchCookingMethods() async throws -> [CookingMethod] {
        try await withCheckedThrowingContinuation({ continuation in
            self.context.performAndWait{
                
                let request = CookingMethod.fetchRequest()
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
    
    func deleteCookingMethod(cookingMethod: CookingMethod) async throws {
        try await withCheckedThrowingContinuation({ continuation in
            self.context.performAndWait{
                self.context.delete(cookingMethod)
                do {
                    if self.context.hasChanges{
                        try context.save()
                    }
                    self.sendAction(.Deleted(cookingMethod))
                    continuation.resume()
                } catch {
                    continuation.resume(throwing: RepositoryError.contextError(error))
                }
            }
        })
    }
}
