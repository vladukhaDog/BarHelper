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
    
    init(){
        self._vm = .init(wrappedValue: .init())
    }
    
    init(selectedIngredients: Binding<[DBIngredient: Int]>, canInputNumber: Bool = true){
        self._vm = .init(wrappedValue: .init(selectedIngredients: selectedIngredients))
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
            ScrollViewReader{ proxy in
                ScrollView{
                    HStack{
                        Spacer()
                    }
                    VStack{
                        ForEach(vm.ingredients){ingredient in
                            IngredientCell(ingredient: ingredient, selectable: vm.selectable, selected: vm.localSelected) {ingr in
                                vm.ingredientToDelete = ingr
                            } EditAction: {ingr in
                                vm.ingredientToEdit = ingr
                            } AddAction: {ingr in
                                vm.ingredientToAddAlternative = ingr
                            } onSelect: {ingr in
                                vm.didSelect(ingr)
                            }
                            .id(ingredient.id)
                            .padding(5)
                        }
                    }
                    .padding(.horizontal, 5)
                }
                .onAppear{
                    vm.scrollViewProxy = proxy
                }
            }
            .background(Color.black)
            .padding(5)
            .depthBorder()
            .padding(5)
        }
        .backgroundWithoutSafeSpace(.darkPurple)
        .navigationTitle("Ingredients")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    vm.showIngredientCreate = true
                } label: {
                    PlusView()
                        .frame(width: 40, height: 40)
                }
                
            }
        }
        .sheet(item: $vm.ingredientToEdit) { ingredient in
            EditIngredientView(ingredient: ingredient,
                               onEdit: vm.setNewNameIngredient)
            .presentationDetents([.medium])
        }
        .sheet(item: $vm.ingredientToAddAlternative) { ingredient in
            CreateIngredientView(onAdd: vm.onAdd,
                                 baseIngredient: ingredient)
            .presentationDetents([.medium])
        }
        .sheet(item: $vm.ingredientToDelete) { ingredient in
            VStack{
                Text("Delete \(ingredient.name ?? "")?")
                    .font(.smallTitle)
                    .foregroundColor(.white)
                HStack{
                    CPButtonView(color: .gray, text: "Cancel", enabled: true, action: {
                        withAnimation{
                            self.vm.ingredientToDelete = nil
                        }
                    })
                    CPButtonView(color: .red, text: "Delete", enabled: true, action: {
                        withAnimation{
                            self.vm.ingredientToDelete = nil
                            self.vm.deleteIngredient(ingredient: ingredient)
                        }
                        
                    })
                }
                .padding(8)
            }
            .backgroundWithoutSafeSpace(.darkPurple)
            .presentationDetents([.fraction(0.2)])
        }
        .sheet(isPresented: $vm.showIngredientCreate) {
            CreateIngredientView(onAdd: vm.onAdd)
                .presentationDetents([.medium])
        }
        .sheet(isPresented: $vm.showIngredientCreate) {
            CreateIngredientView(onAdd: vm.onAdd)
                .presentationDetents([.medium, .large])
        }
        
    }
}



struct IngredientsView_Previews: PreviewProvider {
    static var previews: some View {
        IngredientsView()
    }
}


