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
        VStack(spacing: 4){
            HStack {
                NavigationLink(value: Destination.CookingMethodsList) {
                    CookingMethodsHeader()
                    }
                NavigationLink(value: Destination.IngredientsList) {
                    IngredientsHeader()
                }
            }
            NavigationLink(value: Destination.StoredCocktailsList) {
                CocktailsHeader(cocktails: [])
            }
        }
        .padding(8)
        .backgroundWithoutSafeSpace(.pinkPurple)
    }
}

#Preview {
    NavigationStack {
        MainScreenView()
            .routePath()
    }
    .navigationBarTitleTextColor(.white)
    .tint(.mint)
}
