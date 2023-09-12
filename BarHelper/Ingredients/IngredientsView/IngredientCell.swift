//
//  IngredientCell.swift
//  BarHelper
//
//  Created by Владислав Пермяков on 29.06.2023.
//

import SwiftUI

struct IngredientCell: View{
    let ingredient: DBIngredient
    let selectable: Bool
    let selected: [DBIngredient: Int]
    let deleteAction: (DBIngredient) -> ()
    let EditAction: (DBIngredient) -> ()
    let AddAction: (DBIngredient) -> ()
    let onSelect: (DBIngredient) -> ()
    
    var body: some View{
        VStack{
            if selectable{
                HStack{
                    Button {
                        onSelect(ingredient)
                    } label: {
                        HStack{
                            Text(ingredient.name ?? "")
                                .font(ingredient.parentIngredient == nil ? .smallTitle : .normal)
                                .foregroundColor(.white)
                            Spacer()
                        }
                        .padding(14)
                        .border(Color.softBlue, width: 2)
                        .opacity(selected[ingredient] != nil ? 0.7 : 1)
                    }
                    if ingredient.parentIngredient == nil{
                        addButton
                    }
                }
                
            }else{
                HStack{
                    Button {
                        EditAction(ingredient)
                    } label: {
                        Text(ingredient.name ?? "")
                            .font(ingredient.parentIngredient == nil ? .smallTitle : .normal)
                            .foregroundColor(.white)
                        Spacer()
                    }
                    if ingredient.parentIngredient == nil{
                        addButton
                    }
                    deleteButton
                }
                
            }
            children
        }
    }
    
    private var children: some View{
        VStack{
            if let ingredientsSet = ingredient.alternatives,
               let ingredients = ingredientsSet as? Set<DBIngredient>{
                let ingredientsSorted = ingredients.sorted { l, r in
                    ( l.name ?? "") < (r.name ?? "")
                }
                ForEach(ingredientsSorted, id: \.id){ingredientAlternative in
                    HStack(spacing: 8){
                        Text("-")
                            .font(.smallTitle)
                            .foregroundColor(.white)
                        IngredientCell(ingredient: ingredientAlternative,
                                       selectable: selectable,
                                       selected: selected,
                                       deleteAction: deleteAction,
                                       EditAction: EditAction,
                                       AddAction: AddAction,
                                       onSelect: onSelect)
                    }
                    
                }
            }
        }
    }
    
    private var addButton: some View{
        Button {
            AddAction(ingredient)
        } label: {
            PlusView()
                .frame(width: 40, height: 40)
        }
    }
    
    private var deleteButton: some View{
        Button {
            deleteAction(ingredient)
        } label: {
            TrashView()
                .frame(width: 40, height: 40)
        }
    }
}


struct IngredientCell_Previews: PreviewProvider {
    static var previews: some View {
        IngredientCell(ingredient: .init(), selectable: false, selected: [:], deleteAction: {_ in}, EditAction: {_ in}, AddAction: {_ in}, onSelect: {_ in})
    }
}
