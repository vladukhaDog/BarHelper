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
            } catch {
                print("Failed to add cooking method: \(error.localizedDescription)")
            }
        }
    }
}
