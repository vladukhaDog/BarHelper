//
//  AddCookingMethodViewModel.swift
//  BarHelper
//
//  Created by Владислав Пермяков on 06.10.2024.
//

import SwiftUI

final class AddCookingMethodViewModel: AddCookingMethodViewModelProtocol {
    @Published var methodName: String = ""
    @Published var description: String = ""
    
    private let cookingMethodRepository: CookingMethodRepository = .init()
    
    func addMethod() {
        guard !methodName.isEmpty else {return}
        Task {
            do {
                try await self.cookingMethodRepository.addCookingMethod(name: methodName, description: description)
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
