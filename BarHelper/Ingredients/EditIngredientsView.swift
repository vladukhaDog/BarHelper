//
//  EditIngredientsView.swift
//  BarHelper
//
//  Created by Владислав Пермяков on 18.06.2023.
//

import SwiftUI

struct EditIngredientView: View{
    let ingredient: DBIngredient
    let onEdit: (DBIngredient, String) -> ()
    @State private var name: String
    @Environment(\.presentationMode) var presentationMode
    init(ingredient: DBIngredient, onEdit: @escaping (DBIngredient, String) -> ()){
        self.ingredient = ingredient
        self.onEdit = onEdit
        self._name = .init(initialValue: ingredient.name ?? "")
    }
    
    var body: some View{
        VStack{
            TextField("Ingredient name", text: $name)
                .font(.smallTitle)
                .foregroundColor(.white)
                .tint(.white)
                .padding(5)
                .depthBorder()
            HStack{
                Button("Cancel") {
                    withAnimation{
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                .cyberpunkStyle(.gray)

                Button("Save") {
                    onEdit(ingredient, name)
                    withAnimation{
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                .cyberpunkStyle(.green)
            }
            Spacer()
        }
        .padding()
        .backgroundWithoutSafeSpace(.darkPurple)
    }
}

//struct EditIngredientsView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditIngredientsView()
//    }
//}
