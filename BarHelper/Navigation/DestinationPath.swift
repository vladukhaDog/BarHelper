//
//  DestinationPath.swift
//  BarHelper
//
//  Created by Владислав Пермяков on 23.09.2024.
//

import Foundation
import SwiftUI

extension View {
    
    func customToolBar(id: String, text: String, router: Router, action: @escaping () -> Void) -> some View {
        self
            .onChange(of: text, {[weak router] oldValue, newValue in
                router?.setToolBar(id: id, text: text)
            })
            .onAppear(perform: { [weak router] in
                router?.setToolBar(id: id, text: text)
            })
            .onDisappear { [weak router] in
                router?.removeToolbarItem(id: id)
            }
            .onReceive(NotificationCenter.default
                .publisher(for: Notification.Name("\(id)_toolbar_pressed"))) { _ in
                action()
            }
    }
    
    /// wraps the view with navigation destination modifier and explains navigation destination views for each destination enumerator
    func routePath() -> some View {
        self
            .navigationDestination(for: Destination.self) { route in
                switch route {
                case .CocktailsList(let cocktails):
                    CocktailsView(cocktails)
                        .navigationBarHidden(true)
                case .IngredientsSelector(_):
                    IngredientsView()
                        .navigationBarHidden(true)
                case .IngredientsList:
                    IngredientsView()
                        .navigationBarHidden(true)
                case .CreateCocktail:
                    CreateCocktailView()
                        .navigationBarHidden(true)
                case .CookingMethodsList:
                    CookingMethodsView()
                        .navigationBarHidden(true)
                case .EditCocktail(let cocktail):
                    CreateCocktailView(editCocktail: cocktail)
                        .navigationBarHidden(true)
                case .CocktailView(let cocktail):
                    CocktailView(cocktail: cocktail)
                        .navigationBarHidden(true)
                case .StoredCocktailsList:
                    CocktailsView()
                        .navigationBarHidden(true)
                case .CreateIngredientView(let parent):
                    CreateIngredientView(parent)
                        .navigationBarHidden(true)
                }
            }
    }
}

