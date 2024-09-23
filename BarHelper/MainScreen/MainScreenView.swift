//
//  MainScreenView.swift
//  BarHelper
//
//  Created by Владислав Пермяков on 23.09.2024.
//

import SwiftUI

/// Main screen of an app with links and previews
struct MainScreenView: View {
    var body: some View {
        ScrollView {
            LazyVStack{
                CookingTypesHeader()
            }
            .padding()
        }
        .frame(maxWidth: .infinity)
    }
    
    
//    private var cookingTypes: some View {
//        NavigationLink(value: Destination.CookingTypesList) {
//            Rectangle()
//                .fill(Color.softPink)
//                .overlay(
//                    ZStack{
//                        HStack{
//                            VStack(spacing: 0){
//                                Image("shaker_top")
//                                    .resizable()
//                                    .scaledToFit()
//                                Image("shaker_bottom")
//                                    .resizable()
//                                    .scaledToFit()
//                            }
//                            .aspectRatio(0.5, contentMode: .fit)
//                            Spacer()
//                        }
//                        VStack{
//                            Spacer()
//                            Image("icesprite")
//                                .resizable()
//                                .scaledToFit()
//                                .frame(maxWidth: 40)
//                        }
//                        
//                    }
//                        .padding(.horizontal, 8)
//                        .padding(.vertical, 4)
//                    
//                )
//                .aspectRatio(1.0, contentMode: .fit)
//        }
//    }
//    
//    
//    private var ingredients: some View{
//        NavigationLink(value: Destination.IngredientsList) {
//            Rectangle()
//                .fill(Color.softBlue)
//                .overlay(
//                    HStack{
//                        Image("rum_spr")
//                            .resizable()
//                            .scaledToFit()
//                            .padding(15)
//                        Text("Ingredients")
//                            .lineLimit(1)
//                            .foregroundColor(.white)
//                            .font(.CBTitle)
//                            .minimumScaleFactor(0.1)
//                    }
//                )
//        }
//    }
//    
//    private var cocktails: some View{
//        NavigationLink(value: Destination.StoredCocktailsList) {
//            Rectangle()
//                .fill(Color.darkPurple)
//                .overlay(
//                    HStack{
//                        HStack(spacing: 0){
//                            Image("5")
//                                .resizable()
//                                .scaledToFit()
//                            Image("8")
//                                .resizable()
//                                .scaledToFit()
//                        }
//                        .padding(.horizontal, 8)
//                        .padding(.vertical, 10)
//                        Text("Cocktails")
//                            .lineLimit(1)
//                            .foregroundColor(.white)
//                            .font(.CBTitle)
//                            .minimumScaleFactor(0.1)
//                        HStack(spacing: 0){
//                            Image("6")
//                                .resizable()
//                                .scaledToFit()
//                            Image("1")
//                                .resizable()
//                                .scaledToFit()
//                        }
//                        .padding(.horizontal, 8)
//                        .padding(.vertical, 10)
//                        .padding(.top, 20)
//                    }
//                    
//                )
//        }
//    }
//    
//    private var cocktailsCreate: some View{
//        NavigationLink(value: Destination.CreateCocktail){
//            Rectangle()
//                .fill(Color.softGray)
//                .overlay(ZStack{
//                    Rectangle()
//                        .fill(Color.white)
//                        .aspectRatio(15, contentMode: .fit)
//                    Rectangle()
//                        .fill(Color.white)
//                        .aspectRatio(0.066, contentMode: .fit)
//                }
//                    .aspectRatio(1, contentMode: .fit)
//                    .padding(7)
//                    .allowsHitTesting(false)
//                )
//                .clipShape(Rectangle())
//        }
//    }
}

#Preview {
    MainScreenView()
}
