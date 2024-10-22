//
//  CocktailView.swift
//  BarHelper
//
//  Created by Владислав Пермяков on 10.05.2023.
//

import SwiftUI

extension CocktailView where ViewModel == CocktailViewModel {
    init(_ cocktail: DBCocktail) {
        self.init(vm: CocktailViewModel(cocktail: cocktail))
    }
}

/// Detailed view of a cocktail
///  >important: Requires Router environmentObject
struct CocktailView<ViewModel: CocktailViewModelProtocol>: View {
    @StateObject private var vm: ViewModel
    @EnvironmentObject private var router: Router
    
    init(vm: ViewModel) {
        self._vm = .init(wrappedValue: vm)
    }
    
    var body: some View {
        ScrollView {
            VStack {
                imageView
                text
                recipe
                buttons
            }
            .padding(.horizontal, 10)
            .id(vm.cocktail.hash)
        }
        .customToolBar(id: "favButton",
                       text: vm.cocktail.isFavourite ? "UnFav" : "Fav",
                       router: router) {
            vm.toggleFavourite()
        }
                       .task {
                           vm.setup(router: router)
                       }
        .scrollBounceBehavior(.basedOnSize)
        .backgroundWithoutSafeSpace(.darkPurple)
    }
    
    @State private var nav = false
    private var buttons: some View {
        HStack{
            Button("Delete") {
                vm.delete()
            }
            .cyberpunkStyle(.red)
            
            Button("Edit") {
                vm.edit()
            }
            .cyberpunkStyle(.orange)
        }
        .padding()
        .background(Color.black)
        .depthBorder()
        .padding(5)
    }
    
    private var text: some View{
        VStack(alignment: .leading, spacing: 20) {
            Text(vm.cocktail.cookingMethod?.name ?? "Cooking Method lost")
                .cyberpunkFont(.smallTitle)
                .multilineTextAlignment(.leading)
            if let description = vm.cocktail.desc {
                Text(description)
                    .cyberpunkFont(.body)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(10)
        .background(Color.black)
        .padding(5)
        .depthBorder()
    }
    
    private var recipe: some View{
        Group{
            if let recipeSet = vm.cocktail.recipe,
               let recipe = recipeSet as? Set<DBIngredientRecord>{
                let recipeSorted = recipe.sorted { l, r in
                    if (l.ingredientValue) == (r.ingredientValue){
                        return ((l.ingredient?.name ?? "") > (r.ingredient?.name ?? ""))
                    }else{
                        return (l.ingredientValue) > (r.ingredientValue)
                    }
                }
                VStack{
                    ForEach(recipeSorted) { ingredient in
                        RecipeIngredientCell(ingredient: ingredient)
                    }
                }
                .padding()
                .background(Color.black)
                .padding(5)
                .depthBorder()
                
            }
        }
    }
    
    private var imageView: some View{
        HStack{
            Group{
                if let image = vm.cocktail.image?.getImage() {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                }else{
                    Image("1")
                        .resizable()
                        .scaledToFit()
                }
            }
            .frame(width: 150, height: 150)
            .clipShape(Rectangle())
            Text(vm.cocktail.name ?? "CocktailName")
                .cyberpunkFont(.title)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(5)
        .background(Color.black)
        .padding(5)
        .depthBorder()
    }
}

private final class MockViewModel: CocktailViewModelProtocol {
    @Published var cocktail: DBCocktail = MockData.mockCocktail()
    
    func delete() {
    }
    
    func edit() {
    }
    
    func setup(router: Router) {
    }
    
    func toggleFavourite() {
        objectWillChange.send()
        cocktail.isFavourite = !cocktail.isFavourite
    }
    
    
}

#Preview {
    CocktailView(vm: MockViewModel())
        .previewWrapper()
}
