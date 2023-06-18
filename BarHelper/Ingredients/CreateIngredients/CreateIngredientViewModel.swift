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
    let baseIngredient: DBIngredient?
    init(onAdd: @escaping () ->(), baseIngredient: DBIngredient? = nil){
        self.onAdd = onAdd
        self.baseIngredient = baseIngredient
    }
    
    func addIngredient(){
        Task{
            let usedMetric: String
            if let baseIngredient{
                usedMetric = baseIngredient.metric ?? "ml"
            }else{
                usedMetric = self.metric
            }
            await db.addIngredient(name: self.name, metric: usedMetric, parentIngredient: baseIngredient)
            self.onAdd()
        }
    }
}
