//
//  IngredientCell.swift
//  BarHelper
//
//  Created by Владислав Пермяков on 29.06.2023.
//

import SwiftUI

struct IngredientCell<ViewModel>: View where ViewModel: IngredientsViewModelProtocol {
    let ingredient: DBIngredient
    let children: [DBIngredient]
    @EnvironmentObject var vm: ViewModel
    @EnvironmentObject private var router: Router
    
    init(ingredient: DBIngredient) {
        self.ingredient = ingredient
        let ingredientsSet = ingredient.alternatives
        let ingredients = ingredientsSet as? Set<DBIngredient>
        let ingredientsSorted = ingredients?.sorted { l, r in
            ( l.name ?? "") < (r.name ?? "")
        }
        children = ingredientsSorted ?? []
    }
    var body: some View{
        HStack(alignment: .top, spacing: 0) {
            VStack(alignment: .leading) {
                titleButton(ingredient)
                    .frame(maxWidth: .infinity, minHeight: 42, alignment: .leading)
                childrenList
            }
            .padding(5)
            .background(Color.black)
            .padding(5)
            .depthBorder()
            .zIndex(1)
            
            if vm.isEditing {
                editButtons
                    .zIndex(2)
                    .compositingGroup()
                    .transition(.move(edge: .trailing)
                        .combined(with: .opacity))
            }
        }
        .animation(.default, value: vm.isEditing)
    }
    
    
    private func titleButton(_ ingredient: DBIngredient) -> some View {
        Button {
            router.push(.EditIngredient(ingredient))
        } label: {
            Text(ingredient.name ?? "")
                .cyberpunkFont(ingredient.parentIngredient == nil ? .smallTitle : .body)
                .foregroundColor(.white)
                .multilineTextAlignment(.leading)
            
        }
    }
    
 
    private var editButtons: some View {
        HStack(spacing: 0) {
           
            Color.darkPurple.frame(width: 20, height: 20)
                    .depthBorderUp()
                    .frame(maxHeight: 40 + 10 + 10, alignment: .center) // height of buttons + their padding
                    .padding(.horizontal, -7.5)
                    .zIndex(3)
                HStack {
                    if ingredient.parentIngredient == nil {
                        addButton
                    }
                    deleteButton
                }
                .padding(5)
                .background(Color.black)
                .padding(5)
                .depthBorder()
        }
    }
    
    private var childrenList: some View {
        VStack(alignment: .leading, spacing: 4) {
            ForEach(children, id: \.id){ ingredientAlternative in
                HStack(spacing: 8) {
                    ZStack {
                            Button {
                                Task {
                                    await vm.deleteIngredient(ingredientAlternative)
                                }
                            } label: {
                                Text("X")
                                    .cyberpunkFont(.smallTitle)
                                    .foregroundColor(.red)
                                    
                            }
                            .opacity(vm.isEditing ? 1 : 0)
                            .disabled(!vm.isEditing)
                            Text("-")
                                .cyberpunkFont(.smallTitle)
                                .foregroundColor(.white)
                                .transition(.opacity.combined(with: .scale))
                                .opacity(vm.isEditing ? 0 : 1)
                    }
                    titleButton(ingredientAlternative)
                }
                
            }
        }
    }
    
    private var addButton: some View {
        NavigationLink(value: Destination.CreateIngredientView(ingredient)) {
            PlusView()
                .frame(width: 40, height: 40)
        }
    }
    
    private var deleteButton: some View {
        Button {
            Task {
                await vm.deleteIngredient(ingredient)
            }
        } label: {
            TrashView()
                .frame(width: 40, height: 40)
        }
    }
}

fileprivate final class MockIngredientsViewModel: IngredientsViewModelProtocol {
    var search: String = ""
    
    @Published var isEditing: Bool = true
    
    @Published var ingredients: [DBIngredient] = []
    init() {
        let first = MockData.mockIngredient("Parent")
        first.alternatives = Set<DBIngredient>.init([MockData.mockIngredient("child")]) as NSSet
        ingredients.append(contentsOf: MockData.mockIngredients([
            "Vodka",
            "Rum",
            "Very stupid long name for multiple lines and stuff"
        ]))
        ingredients.append(first)
    }
    
    func deleteIngredient(_ ingredient: DBIngredient) async {
    }
    
    func startAddingIngredient(_ withParent: DBIngredient?) {
    }
    
}

#Preview {
    @Previewable @StateObject var vm = MockIngredientsViewModel()
    Toggle(isOn: $vm.isEditing, label: {Text("edit")})
    VStack {
        IngredientCell<MockIngredientsViewModel>(ingredient: vm.ingredients.last ?? MockData.mockIngredient())
        IngredientCell<MockIngredientsViewModel>(ingredient: vm.ingredients.last!)
    }

        .environmentObject(vm)
        .environmentObject(Router())
        .background(Color.darkPurple)
}
