//
//  IngredientsView.swift
//  BarHelper
//
//  Created by Владислав Пермяков on 09.05.2023.
//

import SwiftUI

struct IngredientsView<ViewModel>: View where ViewModel: IngredientsViewModelProtocol {
    @StateObject private var vm: ViewModel
    @EnvironmentObject private var router: Router
    init(vm: ViewModel = IngredientsViewModel()) {
        self._vm = StateObject(wrappedValue: vm)
    }
    
    var body: some View {
        ZStack {
            VStack {
                
                list
                addButton
            }
            .padding()
            .background(Color.darkPurple)
            .depthBorderUp()
            .padding(5)
            bits
        }
        .padding(5)
        .backgroundWithoutSafeSpace(.darkPurple)
        .navigationTitle("Ingredients")
        .environmentObject(vm)
        .customToolBar(id: "EditIngredients",
                       text: vm.isEditing ? "Done" : "Edit",
                       router: router,
                       action: {
            vm.isEditing.toggle()
        })
    }
    
    @ViewBuilder
    private var bits: some View {
        Color.darkPurple.frame(width: 30, height: 20)
                .depthBorderUp()
                .padding(.bottom, 20)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        Color.darkPurple.frame(width: 30, height: 20)
                .depthBorderUp()
                .padding(.top, 20)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        Color.darkPurple.frame(width: 30, height: 40)
                .depthBorderUp()
                .padding(.top, 20)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        
        Color.darkPurple.frame(width: 20, height: 20)
            .depthBorderUp()
                .padding(.leading, 120)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
    
    private var list: some View {
        ScrollView {
            LazyVStack(spacing: 5, pinnedViews: [.sectionHeaders]) {
                Section {
                    ForEach(vm.ingredients, id: \.id) { ingredient in
                        IngredientCell<ViewModel>(ingredient: ingredient)
                    }
                } header: {
                    if !vm.ingredients.isEmpty{
                        searchField
                    }
                }
            }
            .padding(5)
            .animation(.default, value: vm.ingredients.isEmpty)
        }
        .padding(5)
        .depthBorder()
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
        .padding(.bottom, 5)
        .background(Color.darkPurple)
    }
    
    private var addButton: some View {
        Button("New Ingredient") {
            router.push(.CreateIngredientView(nil))
        }
        .cyberpunkStyle(.green)
        .padding(8)
        .background(Color.black)
        .padding(5)
        .depthBorder()
    }
    
}


fileprivate final class MockIngredientsViewModel: IngredientsViewModelProtocol {
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
    NavigationStack(path: .constant([Destination.IngredientsList])) {
        Color.blue
            .navigationDestination(for: Destination.self) { route in
                IngredientsView(vm: MockIngredientsViewModel())
                    .navigationBarTitleDisplayMode(.inline)
            }
    }
    .navigationBarTitleTextColor(.white)
    .tint(.mint)
    
}
