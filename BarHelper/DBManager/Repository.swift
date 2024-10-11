//
//  Repository.swift
//  BarHelper
//
//  Created by Владислав Пермяков on 03.10.2024.
//

import Foundation
import CoreData

class Repository<T> {
    enum Action {
        case deleted(T)
        case added(T)
        case updated(T)
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
    internal let context: NSManagedObjectContext
    
    init() {
        self.context = DBManager.shared.backgroundContext
    }
    
    internal func sendAction(_ action: Repository.Action) {
        let name = Notification.Name("\(type(of: self))_Notification")
        NotificationCenter.default.post(name: name,
                                        object: action)
    }
    
    func getPublisher() -> NotificationCenter.Publisher {
        let name = Notification.Name("\(type(of: self))_Notification")
        return NotificationCenter.default.publisher(for: name)
    }
}
