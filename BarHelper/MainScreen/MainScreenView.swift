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
            LazyVStack {
                NavigationLink(value: Destination.CookingMethodsList) {
                    CookingMethodsHeader()
                }
                NavigationLink(value: Destination.IngredientsList) {
                    IngredientsHeader()
                }
                NavigationLink(value: Destination.StoredCocktailsList) {
                    CocktailsHeader()
                }
            }
            .padding()
            FavouritesHeader()
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    NavigationStack {
        MainScreenView()
            .routePath()
    }
    .tint(.mint)
}
