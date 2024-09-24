//
//  CookingMethodsViewModel.swift
//  BarHelper
//
//  Created by Владислав Пермяков on 09.05.2023.
//

import Foundation
import Combine
import SwiftUI

class CookingMethodsViewModel: ObservableObject{
    private let cookingMethodRepository = CookingMethodRepository()
    @Published var name = ""
    @Published var types: [CookingMethod] = []
    
    @Published var typeToDelete: CookingMethod? = nil
    private var cancellable = Set<AnyCancellable>()
    
    init(){
        Task{
            await fetchTypes()
        }
        cookingMethodRepository
            .getPublisher()
            .sink { notification in
                guard let action = notification.object as? CookingMethodRepository.Action
                else {return}
                self.updateList(action)
            }
            .store(in: &cancellable)
    }
    
    deinit {
        cancellable.removeAll()
    }
    
    private func updateList(_ action: CookingMethodRepository.Action) {
        DispatchQueue.main.async {
            withAnimation {
                switch action {
                case .Deleted(let cookingMethod):
                    self.types.removeAll(where: {$0.id == cookingMethod.id})
                case .Added(let cookingMethod):
                    self.types.append(cookingMethod)
                case .Changed(let cookingMethod):
                    if let index = self.types.firstIndex(where: {$0.id == cookingMethod.id}){
                        self.types[index] = cookingMethod
                    }
                }
            }
        }
    }
    
    func addCookingMethod(){
        Task{
            try? await cookingMethodRepository.addCookingMethod(name: self.name)
            DispatchQueue.main.async {
                self.name = ""
            }
        }
    }
    
    func deleteType(type: CookingMethod){
        Task{
            try? await cookingMethodRepository.deleteCookingMethod(cookingMethod: type)
            DispatchQueue.main.async {
                self.typeToDelete = nil
            }
        }
    }
    
    
    private func fetchTypes() async {
        guard let types = try? await cookingMethodRepository.fetchCookingMethods() else {return}
        DispatchQueue.main.async {
            self.types = types
        }
    }
}
