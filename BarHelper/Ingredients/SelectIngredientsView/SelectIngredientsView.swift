//
//  IngredientsView.swift
//  BarHelper
//
//  Created by Владислав Пермяков on 22.10.2024.
//


import SwiftUI
import Combine

extension SelectIngredientsView where ViewModel == SelectIngredientsViewModel {
    init(_ list: Binding<[DBIngredient: Int]>) {
        self.init(vm: SelectIngredientsViewModel(list))
    }
}

struct SelectIngredientsView<ViewModel>: View where ViewModel: IngredientsViewModelProtocol & SelectIngredientsViewModelProtocol {
    @StateObject private var vm: ViewModel
    @EnvironmentObject private var router: Router
    internal init(vm: ViewModel) {
        self._vm = StateObject(wrappedValue: vm)
    }
    
    var body: some View {
        VStack(spacing: 5) {
            if !vm.ingredients.isEmpty{
                searchField
                    .padding(.horizontal, 5)
            }
            list
            addButton
        }
        .backgroundWithoutSafeSpace(.darkPurple)
        .navigationTitle("Ingredients")
        .environmentObject(vm)
        .customToolBar(id: "SaveSelectIngredients",
                       text: "New",
                       router: router,
                       action: {
            vm.addingIngredient = nil
            amount = nil
            router.push(.CreateIngredientView(nil))
        })
        .overlay {
            amountInput
                .animation(.default, value: vm.addingIngredient == nil)
        }
    }
    
    @State private var amount: Int? = nil
    @FocusState private var amountFocus: Bool
    @ViewBuilder
    private var amountInput: some View {
        if let addingIngredient = vm.addingIngredient {
        ZStack {
            Color.black.opacity(0.8)
            VStack(alignment: .leading) {
                Text(addingIngredient.name ?? "")
                    .cyberpunkFont()
                HStack {
                    TextField("", text: .init(get: {
                        amount?.description ?? ""
                    }, set: { newVal in
                        amount = Int(newVal)
                    }), onCommit: {
                        vm.selectingIngredients[addingIngredient] = amount ?? 0
                        amount = nil
                        self.vm.addingIngredient = nil
                    } )
                    .cyberpunkStyle(focusState: $amountFocus)
                    .keyboardType(.numberPad)
                    .frame(width: 150)
                    Text(addingIngredient.metric ?? "")
                        .cyberpunkFont(20)
                    Button("Cancel") {
                        self.vm.addingIngredient = nil
                        amount = nil
                    }
                    .cyberpunkFont(25)
                }
            }
            .padding()
            .background(Color.darkPurple)
            .depthBorderUp()
            .task {
                amount = nil
                amountFocus = true
            }
        }
        .id(addingIngredient.id)
        .compositingGroup()
        .transition(.opacity)
        }
    }
    
    private var list: some View {
        ScrollView {
            VStack(spacing: 15) {
                ForEach(vm.ingredients, id: \.id) { ingredient in
                    let ingredientsSet = ingredient.alternatives
                    let ingredients = ingredientsSet as? Set<DBIngredient>
                    let ingredientsSorted = ingredients?.sorted { l, r in
                        ( l.name ?? "") < (r.name ?? "")
                    }
                    let children = ingredientsSorted ?? []
                    
                    VStack(spacing: 10) {
                        HStack {
                            cell(ingredient, child: false)
                            Button {
                                router.push(.CreateIngredientView(ingredient))
                            } label: {
                                Text("add child")
                                    .cyberpunkFont(20)
                                    .foregroundStyle(Color.white)
                            }
                        }
                        ForEach(children, id: \.id) { child in
                            cell(child, child: true)
                        }
                    }
                }
            }
            .padding(5)
            .animation(.default, value: vm.ingredients.isEmpty)
        }
        .frame(maxWidth: .infinity)
        .background(Color.black)
        .padding(5)
        .depthBorder()
        .padding(.horizontal, 5)
    }
    
    private func cell(_ ingredient: DBIngredient, child: Bool) -> some View {
        Button {
            if vm.selectingIngredients[ingredient] == nil {
                vm.addingIngredient = ingredient
            } else {
                vm.selectingIngredients.removeValue(forKey: ingredient)
            }
        } label: {
            HStack(spacing: 0) {
                if let value = vm.selectingIngredients[ingredient] {
                    Text("\(value.description) \(ingredient.metric ?? "ml")\(child ? "" : "-")")
                        .cyberpunkFont(child ? 25 : 30)
                        .foregroundStyle(Color.tintedOrange)
                }
                
                Text("\(child ? "-" : "")\(ingredient.name ?? "No name")")
                    .cyberpunkFont(child ? 25 : 30)
                    .multilineTextAlignment(.leading)
                    .foregroundStyle(vm.selectingIngredients[ingredient] == nil ? Color.white : Color.tintedOrange)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
    
    
    @FocusState var searchFieldFocus: Bool
    private var searchField: some View {
        HStack {
            TextField("Search", text: $vm.search)
                .cyberpunkStyle(focusState: $searchFieldFocus)
                .zIndex(1)
            if searchFieldFocus || !vm.search.isEmpty {
                Button("Cancel") {
                    vm.search = ""
                    searchFieldFocus = false
                }
                .cyberpunkFont(.smallTitle)
                .zIndex(0)
                .transition(.move(edge: .trailing)
                    .combined(with: .opacity))
            }
        }
        .clipped()
        .animation(.bouncy, value: vm.search)
        .animation(.bouncy, value: searchFieldFocus)
    }
    
    private var addButton: some View {
        Button("Save") {
            vm.save()
            router.back()
        }
        .cyberpunkStyle(.green)
        .padding(8)
        .background(Color.black)
        .padding(5)
        .depthBorder()
    }
    
}


fileprivate final class MockIngredientsViewModel: IngredientsViewModelProtocol & SelectIngredientsViewModelProtocol {
    @Published var addingIngredient: DBIngredient?
    
    @Published var selectingIngredients: [DBIngredient : Int] = [:]
    
    @Published var originalSelectIngredients: [DBIngredient : Int] = [:]
    
    func save() {
    }
    
    @Published var search: String = ""
    
    @Published var isEditing: Bool = false
    
    @Published var ingredients: [DBIngredient] = []
    init() {
        let first = MockData.mockIngredient("Parent")
        first.alternatives = Set<DBIngredient>.init([MockData.mockIngredient("child")]) as NSSet
        Task {
            try? await Task.sleep(for: .seconds(0.5))
            await MainActor.run {
                ingredients.append(contentsOf: MockData.mockIngredients([
                    "Vodka",
                    "Rum",
                    "Very stupid long name for multiple lines and stuff"
                ]))
                ingredients.append(first)
            }
        }
    }
    
    func deleteIngredient(_ ingredient: DBIngredient) async {
    }
    
    func startAddingIngredient(_ withParent: DBIngredient?) {
    }
    
}

#Preview {
    SelectIngredientsView(vm: MockIngredientsViewModel())
        .previewWrapper()
    
}
