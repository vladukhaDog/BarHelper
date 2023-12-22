//
//  CocktailsView.swift
//  BarHelper
//
//  Created by Владислав Пермяков on 10.05.2023.
//

import SwiftUI

struct CocktailsView: View {
    @StateObject private var vm: CocktailsViewModel
    init(_ cocktails: [DBCocktail]? = nil){
        self._vm = .init(wrappedValue: .init(cocktails))
    }
    var body: some View {
        VStack{
            if vm.searchEnabled{
                searchField
                    .transition(.push(from: .top))
            }
            ScrollView{
                LazyVStack{
                    ForEach(vm.cocktails, id: \.id){ cocktail in
                        NavigationLink(value: Destination.CocktailView(
                            .init(get: {
                                cocktail
                            }, set: { new in
                                self.vm.didUpdate(new)
                            }))
                        ) {
                            CocktailCellView(cocktail: cocktail)
                                .id("\(cocktail.image?.fileName ?? "")+\(cocktail.name ?? "")")
                                
                        }
                    }
                }
                .padding(.horizontal)
            }
            .padding(5)
        }
        .backgroundWithoutSafeSpace(.darkPurple)
        .navigationTitle("Cocktails")
    }
    
    private var searchField: some View{
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
        .padding(.horizontal)
    }
}




struct CocktailsView_Previews: PreviewProvider {
    static var previews: some View {
        CocktailsView()
            .preferredColorScheme(.dark)
    }
}
