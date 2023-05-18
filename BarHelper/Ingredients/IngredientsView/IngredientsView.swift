//
//  IngredientsView.swift
//  BarHelper
//
//  Created by Владислав Пермяков on 09.05.2023.
//

import SwiftUI

struct IngredientsView: View {
    @StateObject private var vm: IngredientsViewModel
    @State private var up = false
    @State private var localSelected: [DBIngredient]
    init(){
        self._vm = .init(wrappedValue: .init())
        self._localSelected = .init(initialValue: [])
    }
    
    init(selectedIngredients: Binding<[DBIngredient]>){
        self._vm = .init(wrappedValue: .init(selectedIngredients: selectedIngredients))
        self._localSelected = .init(initialValue: selectedIngredients.wrappedValue)
    }
    var body: some View {
        VStack{
            HStack{
                TextField("Search", text: $vm.search)
                    .font(.smallTitle)
                    .foregroundColor(.white)
                    .tint(.white)
                    .padding(5)
                    .depthBorder()
                if !vm.search.isEmpty{
                    Button {
                        vm.search = ""
                    } label: {
                        Text("Clear")
                            .foregroundColor(.white)
                            .font(.normal)
                    }

                }
            }
            .padding(.horizontal, 10)
            
            ScrollView{
                HStack{
                    Spacer()
                }
                
                
                VStack{
                    ForEach(vm.ingredients){ingredient in
                        HStack{
                            Button {
                                if vm.selectable{
                                    if let localIndex = localSelected.firstIndex(of: ingredient){
                                        localSelected.remove(at: localIndex)
                                    }else{
                                        localSelected.append(ingredient)
                                    }
                                    self.vm.selectedIngredients = localSelected
                                }else{
                                    vm.ingredientToEdit = ingredient
                                }
                            } label: {
                                if vm.selectable{
                                    HStack{
                                        Spacer()
                                        Text(ingredient.name ?? "")
                                            .font(.smallTitle)
                                            .foregroundColor(.white)
                                        Spacer()
                                    }
                                    .padding(14)
                                    .border(Color.softBlue, width: 2)
                                    .opacity(localSelected.contains(ingredient) ? 0.7 : 1)
                                    .id(up)
                                }else{
                                    Text(ingredient.name ?? "")
                                        .font(.smallTitle)
                                        .foregroundColor(.white)
                                }
                                
                            }
                            
                        }
                        .padding(5)
                    }
                }
                .padding(.horizontal, 5)
            }
            .background(Color.black)
            .padding(5)
            .depthBorder()
            .padding(5)
        }
        .backgroundWithoutSafeSpace(.darkPurple)
        .navigationTitle("Ingredients")
        .sheet(item: $vm.ingredientToEdit) { item in
            EditIngredientView(ingredient: item) { ingredient in
                vm.deleteIngredient(ingredient: ingredient)
            } onEdit: { ingredient, name in
                vm.setNewNameIngredient(ingredient: ingredient, newName: name)
            }
            .presentationDetents([.medium, .large])
        }
    }
}

struct EditIngredientView: View{
    let ingredient: DBIngredient
    let onDelete: (DBIngredient) -> ()
    let onEdit: (DBIngredient, String) -> ()
    @State private var name: String
    
    init(ingredient: DBIngredient, onDelete: @escaping (DBIngredient) -> (), onEdit: @escaping (DBIngredient, String) -> ()){
        self.ingredient = ingredient
        self.onDelete = onDelete
        self.onEdit = onEdit
        self._name = .init(initialValue: ingredient.name ?? "")
    }
    
    var body: some View{
        VStack{
            TextField("Ingredient name", text: $name)
                .font(.smallTitle)
                .foregroundColor(.white)
                .tint(.white)
                .padding(5)
                .depthBorder()
            HStack{
                CBButtonView(color: .red, text: "Delete", enabled: true) {
                    onDelete(ingredient)
                }
                CBButtonView(color: .green, text: "Save", enabled: true) {
                    onEdit(ingredient, name)
                }
            }
            Spacer()
        }
        .padding()
        .backgroundWithoutSafeSpace(.darkPurple)
    }
}

struct IngredientsView_Previews: PreviewProvider {
    static var previews: some View {
        IngredientsView()
    }
}
