//
//  ContentView.swift
//  BarHelper
//
//  Created by Владислав Пермяков on 08.05.2023.
//

import SwiftUI
import Combine
import CoreData


struct ContentView: View {
    
    @ObservedObject var router = Router.shared
    
    var body: some View {
        NavigationStack(path: $router.path){
            VStack(spacing: 4){
                HStack(spacing: 2){
                    cookingTypes
                    search
                }
                .frame(height: 90)
                HStack(spacing: 2){
                    ingredients
                }
                .frame(height: 90)
                cocktails
                    .frame(height: 90)
                cocktailsCreate
                    .frame(height: 90)
                
                
            }
            .padding(8)
            .backgroundWithoutSafeSpace(.pinkPurple)
            .navigationDestination(for: Destination.self) { route in
                switch route {
                case .CocktailsList(let cocktails):
                    CocktailsView(cocktails)
                case .Ingredients(let selectList):
                    if let list = selectList{
                        IngredientsView(selectedIngredients: list)
                    }else{
                        IngredientsView()
                    }
                case .Search:
                    SearchView()
                case .CreateCocktail:
                    CreateCocktailView()
                case .CookingTypes:
                    CookingTypesView()
                case .EditCocktail(let cocktail):
                    CreateCocktailView(editCocktail: cocktail)
                case .CocktailView(let cocktail):
                    CocktailView(cocktail: cocktail)
                }
            }
        }
    }
    
    private var cookingTypes: some View{
        NavigationLink(value: Destination.CookingTypes) {
            Rectangle()
                .fill(Color.softPink)
                .overlay(
                    ZStack{
                        HStack{
                            VStack(spacing: 0){
                                Image("shaker_top")
                                    .resizable()
                                    .scaledToFit()
                                Image("shaker_bottom")
                                    .resizable()
                                    .scaledToFit()
                            }
                            .aspectRatio(0.5, contentMode: .fit)
                            Spacer()
                        }
                        VStack{
                            Spacer()
                            Image("icesprite")
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: 40)
                        }
                        
                    }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                    
                )
                .aspectRatio(1.0, contentMode: .fit)
        }
    }
    
    
    private var ingredients: some View{
        NavigationLink(value: Destination.Ingredients(nil)) {
            Rectangle()
                .fill(Color.softBlue)
                .overlay(
                    HStack{
                        Image("rum_spr")
                            .resizable()
                            .scaledToFit()
                            .padding(15)
                        Text("Ingredients")
                            .lineLimit(1)
                            .foregroundColor(.white)
                            .font(.CBTitle)
                            .minimumScaleFactor(0.1)
                    }
                )
        }
    }
    
    private var search: some View{
        NavigationLink(value: Destination.Search) {
            Rectangle()
                .fill(Color.darkPurple)
                .overlay(
                    HStack{
                        Text("Search")
                            .lineLimit(1)
                            .foregroundColor(.white)
                            .font(.CBTitle)
                            .minimumScaleFactor(0.1)
                    }
                    
                )
                .depthBorder()
        }
        
    }
    
    private var cocktails: some View{
        NavigationLink(value: Destination.CocktailsList(nil)) {
            Rectangle()
                .fill(Color.darkPurple)
                .overlay(
                    HStack{
                        HStack(spacing: 0){
                            Image("5")
                                .resizable()
                                .scaledToFit()
                            Image("8")
                                .resizable()
                                .scaledToFit()
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 10)
                        Text("Cocktails")
                            .lineLimit(1)
                            .foregroundColor(.white)
                            .font(.CBTitle)
                            .minimumScaleFactor(0.1)
                        HStack(spacing: 0){
                            Image("6")
                                .resizable()
                                .scaledToFit()
                            Image("1")
                                .resizable()
                                .scaledToFit()
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 10)
                        .padding(.top, 20)
                    }
                    
                )
        }
    }
    
    private var cocktailsCreate: some View{
        NavigationLink(value: Destination.CreateCocktail){
            Rectangle()
                .fill(Color.softGray)
                .overlay(ZStack{
                    Rectangle()
                        .fill(Color.white)
                        .aspectRatio(15, contentMode: .fit)
                    Rectangle()
                        .fill(Color.white)
                        .aspectRatio(0.066, contentMode: .fit)
                }
                    .aspectRatio(1, contentMode: .fit)
                    .padding(7)
                    .allowsHitTesting(false)
                )
                .clipShape(Rectangle())
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
        //            .previewDevice(.init(rawValue: "iPhone 14 Pro"))
    }
}
