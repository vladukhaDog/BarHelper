//
//  CookingTypesViewModel.swift
//  BarHelper
//
//  Created by Владислав Пермяков on 09.05.2023.
//

import Foundation
import Combine
import SwiftUI

class CookingTypesViewModel: ObservableObject{
    private let cookingTypeRepository = CookingMethodRepository()
    @Published var name = ""
    @Published var types: [CookingType] = []
    
    @Published var typeToDelete: CookingType? = nil
    private var cancellable = Set<AnyCancellable>()
    
    init(){
        Task{
            await fetchTypes()
        }
        cookingTypeRepository
            .gePublisher()
            .sink { notification in
                guard let action = notification.object as? CookingMethodRepository.Action
                else {return}
                self.updateList(action)
            }
            .store(in: &cancellable)
    }
    
    private func updateList(_ action: CookingMethodRepository.Action) {
        DispatchQueue.main.async {
            withAnimation {
                switch action {
                case .Deleted(let cookingType):
                    self.types.removeAll(where: {$0.id == cookingType.id})
                case .Added(let cookingType):
                    self.types.append(cookingType)
                case .Changed(let cookingType):
                    if let index = self.types.firstIndex(where: {$0.id == cookingType.id}){
                        self.types[index] = cookingType
                    }
                }
            }
        }
    }
    
    func addCookingType(){
        Task{
            try? await cookingTypeRepository.addCookingType(name: self.name)
            DispatchQueue.main.async {
                self.name = ""
            }
        }
    }
    
    func deleteType(type: CookingType){
        Task{
            try? await cookingTypeRepository.deleteCookingType(cookingType: type)
            DispatchQueue.main.async {
                self.typeToDelete = nil
            }
        }
    }
    
    
    private func fetchTypes() async {
        guard let types = try? await cookingTypeRepository.fetchCookingTypes() else {return}
        DispatchQueue.main.async {
            self.types = types
        }
    }
}
