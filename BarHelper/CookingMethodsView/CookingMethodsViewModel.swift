//
//  CookingMethodsViewModel.swift
//  BarHelper
//
//  Created by Владислав Пермяков on 09.05.2023.
//

import Foundation
import Combine
import SwiftUI

protocol CookingMethodsViewModelProtocol: ObservableObject {
    var methods: [CookingMethod] { get set }
    var methodToView: CookingMethod? { get set }
    func fetchMethods() async
    func updateList(_ action: CookingMethodRepository.Action)
    func deleteMethod(method: CookingMethod)
}

class CookingMethodsViewModel: CookingMethodsViewModelProtocol {
    private let cookingMethodRepository = CookingMethodRepository()
    @Published var methods: [CookingMethod] = []
    @Published var methodToView: CookingMethod? = nil
    private var cancellable = Set<AnyCancellable>()
    
    init(){
        Task{
            await fetchMethods()
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
    
    internal func updateList(_ action: CookingMethodRepository.Action) {
        DispatchQueue.main.async {
            withAnimation {
                switch action {
                case .Deleted(let cookingMethod):
                    self.methods.removeAll(where: {$0.id == cookingMethod.id})
                case .Added(let cookingMethod):
                    self.methods.append(cookingMethod)
                case .Changed(let cookingMethod):
                    if let index = self.methods.firstIndex(where: {$0.id == cookingMethod.id}){
                        self.methods[index] = cookingMethod
                    }
                }
            }
        }
    }
    
    func deleteMethod(method: CookingMethod){
        Task{
            try? await cookingMethodRepository.deleteCookingMethod(cookingMethod: method)
            DispatchQueue.main.async {
                self.methodToView = nil
            }
        }
    }
    
    
    internal func fetchMethods() async {
        guard let methods = try? await cookingMethodRepository.fetchCookingMethods() else {return}
        DispatchQueue.main.async {
            self.methods = methods
        }
    }
}
