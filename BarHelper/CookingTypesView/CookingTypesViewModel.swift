//
//  CookingTypesViewModel.swift
//  BarHelper
//
//  Created by Владислав Пермяков on 09.05.2023.
//

import Foundation

class CookingTypesViewModel: ObservableObject{
    let db = DBManager.shared
    
    @Published var name = ""
    @Published var types: [CookingType] = []
    
    @Published var typeToDelete: CookingType? = nil
    init(){
        Task{
            await fetchTypes()
        }
    }
    
    func addCookingType(){
        Task{
            await db.addCookingType(name: self.name)
            await fetchTypes()
            DispatchQueue.main.async {
                self.name = ""
            }
        }
    }
    
    func deleteType(type: CookingType){
        Task{
            await db.deleteCookingType(cookingType: type)
            await fetchTypes()
            DispatchQueue.main.async {
                self.typeToDelete = nil
            }
        }
    }
    
    
    private func fetchTypes() async{
        let types = await db.fetchCookingTypes()
        DispatchQueue.main.async {
            self.types = types
        }
    }
}
