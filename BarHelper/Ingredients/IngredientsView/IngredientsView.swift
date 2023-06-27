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
                        IngredientCell(ingredient: ingredient, selectable: vm.selectable, selected: localSelected) {ingr in
                            vm.ingredientToDelete = ingr
                        } EditAction: {ingr in
                            vm.ingredientToEdit = ingr
                        } AddAction: {ingr in
                            vm.ingredientToAddAlternative = ingr
                        } onSelect: {ingr in
                            if let localIndex = localSelected.firstIndex(of: ingr){
                                localSelected.remove(at: localIndex)
                            }else{
                                localSelected.append(ingr)
                            }
                            self.vm.selectedIngredients = localSelected
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


struct IngredientCell: View{
    let ingredient: DBIngredient
    let selectable: Bool
    let selected: [DBIngredient]
    let deleteAction: (DBIngredient) -> ()
    let EditAction: (DBIngredient) -> ()
    let AddAction: (DBIngredient) -> ()
    let onSelect: (DBIngredient) -> ()
    
    var body: some View{
        VStack{
            if selectable{
                HStack{
                    Button {
                        onSelect(ingredient)
                    } label: {
                        HStack{
                            Text(ingredient.name ?? "")
                                .font(ingredient.parentIngredient == nil ? .smallTitle : .normal)
                                .foregroundColor(.white)
                            Spacer()
                        }
                        .padding(14)
                        .border(Color.softBlue, width: 2)
                        .opacity(selected.contains(ingredient) ? 0.7 : 1)
                    }
                    if ingredient.parentIngredient == nil{
                        addButton
                    }
                }
                
            }else{
                HStack{
                    Button {
                        EditAction(ingredient)
                    } label: {
                        Text(ingredient.name ?? "")
                            .font(ingredient.parentIngredient == nil ? .smallTitle : .normal)
                            .foregroundColor(.white)
                        Spacer()
                    }
                    if ingredient.parentIngredient == nil{
                        addButton
                    }
                    deleteButton
                }
                
            }
            children
        }
    }
    
    private var children: some View{
        VStack{
            if let ingredientsSet = ingredient.alternatives,
               let ingredients = ingredientsSet as? Set<DBIngredient>{
                let ingredientsSorted = ingredients.sorted { l, r in
                    ( l.name ?? "") < (r.name ?? "")
                }
                ForEach(ingredientsSorted, id: \.id){ingredientAlternative in
                    HStack(spacing: 8){
                        Text("-")
                            .font(.smallTitle)
                            .foregroundColor(.white)
                        IngredientCell(ingredient: ingredientAlternative,
                                       selectable: selectable,
                                       selected: selected,
                                       deleteAction: deleteAction,
                                       EditAction: EditAction,
                                       AddAction: AddAction,
                                       onSelect: onSelect)
                    }
                    
                }
            }
        }
    }
    
    private var addButton: some View{
        Button {
            AddAction(ingredient)
        } label: {
            PlusView()
                .frame(width: 40, height: 40)
        }
    }
    
    private var deleteButton: some View{
        Button {
            deleteAction(ingredient)
        } label: {
            TrashView()
                .frame(width: 40, height: 40)
        }
    }
}
