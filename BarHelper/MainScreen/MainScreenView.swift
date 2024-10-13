//
//  MainScreenView.swift
//  BarHelper
//
//  Created by Владислав Пермяков on 23.09.2024.
//

import SwiftUI

/// Main screen of an app with links and previews
struct MainScreenView: View {
    let namespace: Namespace.ID
    init(_ namespace: Namespace.ID) {
        self.namespace = namespace
    }
    var body: some View {
        VStack(spacing: 4){
            HStack {
                NavigationLink(value: Destination.CookingMethodsList) {
                    CookingMethodsHeader()
                        .matchedTransitionSource(id: Destination.CookingMethodsList, in: namespace)
                }
                NavigationLink(value: Destination.IngredientsList) {
                    IngredientsHeader()
                        .matchedTransitionSource(id: Destination.IngredientsList, in: namespace)
                }
            }
            NavigationLink(value: Destination.StoredCocktailsList) {
                CocktailsHeader(cocktails: [])
                    .matchedTransitionSource(id: Destination.StoredCocktailsList, in: namespace)
            }
        }
        .padding(8)
        .backgroundWithoutSafeSpace(.pinkPurple)
    }
}

#Preview {
    @Previewable @Namespace var namespace
    NavigationStack {
        MainScreenView(namespace)
            .routePath(namespace)
    }
    .navigationBarTitleTextColor(.white)
    .tint(.mint)
}
