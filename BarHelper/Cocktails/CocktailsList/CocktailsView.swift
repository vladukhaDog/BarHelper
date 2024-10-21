//
//  CocktailsView.swift
//  BarHelper
//
//  Created by Владислав Пермяков on 10.05.2023.
//

import SwiftUI

extension CocktailsView where ViewModel == CocktailsViewModel {
    init() {
        self.init(vm: CocktailsViewModel(nil))
    }
}

struct CocktailsView<ViewModel: CocktailsViewModelProtocol>: View {
    @StateObject private var vm: ViewModel
    
    init(vm: ViewModel){
        self._vm = .init(wrappedValue: vm)
    }
    var body: some View {
        VStack {
            searchField
                .padding(.horizontal, 5)
            ScrollView {
                LazyVStack {
                    ForEach(vm.cocktails, id: \.id){ cocktail in
                       if let dbCocktail = vm.cocktailsFromDB[cocktail.id] {
                            NavigationLink(value: Destination.CocktailView(dbCocktail)) {
                                CocktailCellView(cocktail: dbCocktail)
                            }
                            .id(cocktail.hashValue)
                       }
                    }
                }
                .padding(.horizontal, 5)
            }
        }
        .backgroundWithoutSafeSpace(.darkPurple)
        .navigationTitle("Cocktails")
    }
    
    @FocusState private var searchFieldFocus: Bool
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
}



fileprivate final class MockViewModel: CocktailsViewModelProtocol {
    
    @Published var search: String = ""
    
    @Published var cocktails: [Cocktail] = []
    var cocktailsFromDB: [UUID? : DBCocktail] = [:]
    init() {
        let ar = MockData.mockCocktails(5)
        cocktails = ar.map({$0.structCocktail()})
        cocktailsFromDB = .init(uniqueKeysWithValues: ar.map{($0.id, $0)})
    }
    
}

#Preview {
    CocktailsView(vm: MockViewModel())
        .previewWrapper()
}
