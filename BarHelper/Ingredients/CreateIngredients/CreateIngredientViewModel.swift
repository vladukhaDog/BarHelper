//
//  CreateIngredientViewModel.swift
//  BarHelper
//
//  Created by Владислав Пермяков on 11.05.2023.
//

import Foundation

class CreateIngredientViewModel: ObservableObject{
    let db = DBManager.shared
    
    @Published var name = ""
    @Published var metric = "ml"
    let onAdd: () -> ()
    
    init(onAdd: @escaping () ->()){
        self.onAdd = onAdd
    }
    
    func addIngredient(){
        Task{
            await db.addIngredient(name: self.name, metric: self.metric)
            self.onAdd()
        }
    }
}
