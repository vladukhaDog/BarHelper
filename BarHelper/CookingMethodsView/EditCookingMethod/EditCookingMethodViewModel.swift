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
            } catch {
                print("Failed to delete cooking method: \(error.localizedDescription)")
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
            } catch {
                print("Failed to edit cooking method: \(error.localizedDescription)")
            }
        }
    }
}
