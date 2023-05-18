//
//  SearchView.swift
//  BarHelper
//
//  Created by Владислав Пермяков on 14.05.2023.
//

import SwiftUI

struct SearchView: View {
    @StateObject private var vm = SearchViewModel()
    @State private var nav = false
    var body: some View {
        VStack{
            NavigationLink(isActive: $nav) {
                CocktailsView(vm.cocktails)
            } label: {
                EmptyView()
            }
            .hidden()

            modeSelect
            ingredientFilter
            CBButtonView(color: .green,
                         text: "Find",
                         enabled: !vm.selectedIngredients.isEmpty) {
                switch vm.searchMode{
                case .cocktailContainsAnyIngredient:
                    vm.findCocktailsWhichContain(ingredients: vm.selectedIngredients)
                case .ingredientsContainCocktails:
                    vm.findCocktailsWhichCanBeMadeUsing(ingredients: vm.selectedIngredients)
                }
                nav.toggle()
            }
        }
        .padding(.horizontal)
        
        .backgroundWithoutSafeSpace(.darkPurple)
    }
    
    private var modeSelect: some View{
        HStack{
            Text("Find Cocktails which contains any of these:")
                .font(.smallTitle)
                .foregroundColor(.white)
                .padding(5)
                .opacity(vm.searchMode == .cocktailContainsAnyIngredient ? 1 : 0.7 )
                .onTapGesture {
                    vm.searchMode = .cocktailContainsAnyIngredient
                }
            Text("Find Cocktails that can be made out of:")
                .font(.smallTitle)
                .foregroundColor(.white)
                .padding(5)
                .opacity(vm.searchMode == .ingredientsContainCocktails ? 1 : 0.7 )
                .onTapGesture {
                    vm.searchMode = .ingredientsContainCocktails
                }
        }
        .background(Color.black)
        .padding(5)
        .depthBorder()
    }
    
    private var ingredientFilter: some View{
        VStack{
            HStack{
                Text("Ingredients:")
                    .font(.smallTitle)
                    .foregroundColor(.white)
                Spacer()
                NavigationLink {
                    IngredientsView(selectedIngredients: $vm.selectedIngredients)
                        
                } label: {
                    PlusView()
                        .frame(height: 40)
                }
                .id(vm.selectedIngredients.count)
                
            }
            ScrollView{
                ForEach(vm.selectedIngredients){ingredient in
                    HStack{
                        Spacer()
                        Text(ingredient.name ?? "")
                            .font(.smallTitle)
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding(14)
                    .border(Color.softBlue, width: 2)
                }
            }
        }
        .padding(5)
        .background(Color.black)
        .padding(5)
        .depthBorder()
    }
    
 
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
            .preferredColorScheme(.dark)
    }
}
