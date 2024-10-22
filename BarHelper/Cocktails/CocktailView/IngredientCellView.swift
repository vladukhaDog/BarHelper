//
//  IngredientCellView.swift
//  BarHelper
//
//  Created by Владислав Пермяков on 22.10.2024.
//

import Foundation
import SwiftUI

struct RecipeIngredientCell: View{
    let ingredient: DBIngredientRecord
    @State private var showingAlternatives = false
    @Namespace private var animation
    var body: some View{
        VStack(alignment: .leading){
            if showingAlternatives{
                alternatives
            }
            Button {
                withAnimation {
                    showingAlternatives.toggle()
                }
            } label: {
                HStack{
                    if !showingAlternatives{
                        if ingredient.ingredient?.parentIngredient != nil || (ingredient.ingredient?.alternatives?.count ?? 0) > 0{
                            Text("*")
                                .cyberpunkFont(.smallTitle)
                        }
                        Text(ingredient.ingredient?.name ?? "Booze")
                            .cyberpunkFont(.smallTitle)
                            .multilineTextAlignment(.leading)
                            .lineLimit(1)
                                .minimumScaleFactor(0.5)
                            .matchedGeometryEffect(id: "UsedIngredient", in: animation)
                    }
                    Spacer()
                        .overlay(
                            Line()
                                .stroke(
                                    Color.white,
                                    style: StrokeStyle(
                                        lineWidth: 2,
                                        lineCap: .square,
                                        lineJoin: .miter,
                                        miterLimit: 0,
                                        dash: [2, 10],
                                        dashPhase: 0
                                    )
                                )
                                .frame(height: 2)
                                .padding(.horizontal, 8)
                        )
                    Text(ingredient.ingredientValue.description)
                        .cyberpunkFont(.smallTitle)
                        .multilineTextAlignment(.trailing)
                    Text(ingredient.ingredient?.metric ?? "ml")
                        .cyberpunkFont(.body)
                }
            }
            .disabled(ingredient.ingredient?.parentIngredient == nil && (ingredient.ingredient?.alternatives?.count ?? 0) == 0)
        }
        .foregroundColor(.white)
    }
    
    private var alternatives: some View{
        VStack(alignment: .leading){
            if let parentIngredient = ingredient.ingredient?.parentIngredient ?? ingredient.ingredient,
               let ingredientsSet = parentIngredient.alternatives,
               let ingredients = ingredientsSet as? Set<DBIngredient>{
                let ingredientsSorted = ingredients.sorted { l, r in
                    ( l.name ?? "") < (r.name ?? "")
                }
                let array = ([parentIngredient] + ingredientsSorted)
                ForEach(array, id: \.id){ingredientAlternative in
                    if ingredient.ingredient == ingredientAlternative{
                        Text(ingredientAlternative.name ?? "Booze")
                            .cyberpunkFont(.body)
                            .multilineTextAlignment(.leading)
                                            .minimumScaleFactor(0.9)
                            .matchedGeometryEffect(id: "UsedIngredient", in: animation)
                    }else{
                        Text(ingredientAlternative.name ?? "Booze")
                            .cyberpunkFont(.body)
                            .multilineTextAlignment(.leading)
                            .opacity(0.75)
                    }
                    
                }
            }
        }
    }
}
