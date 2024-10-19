//
//  EditCookingMethodViewModel.swift
//  BarHelper
//
//  Created by Владислав Пермяков on 03.10.2024.
//

import Foundation
import SwiftUI


final class EditCookingMethodViewModel: EditCookingMethodViewModelProtocol {
    private let cookingMethodRepository = CookingMethodRepository()
    
    @Published var method: CookingMethod
    @Published var methodName: String
    @Published var description: String
    
    init(_ method: CookingMethod) {
        self.method = method
        self.methodName = method.name ?? ""
        self.description = method.desc ?? ""
    }
    
    func deleteMethod() {
        Task {
            do {
                try await self.cookingMethodRepository.deleteCookingMethod(cookingMethod: method)
            } catch RepositoryError.contextError(let error) {
                AlertsManager.shared.alert("Database error occured")
                print("failed to edit ingredient", error)
            } catch {
                AlertsManager.shared.alert("Something went wrong")
                print("Something bad happened", error)
            }
        }
    }
    
    func editMethod() {
        let editedMethod = method
        editedMethod.name = methodName
        editedMethod.desc = description
        Task {
            do {
                try await self.cookingMethodRepository.editCookingMethod(editedMethod)
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
}
