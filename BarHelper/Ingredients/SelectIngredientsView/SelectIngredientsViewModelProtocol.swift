//
//  SelectIngredientsViewModelProtocol.swift
//  BarHelper
//
//  Created by Владислав Пермяков on 22.10.2024.
//


import SwiftUI
import Combine

protocol SelectIngredientsViewModelProtocol: ObservableObject {
    var selectingIngredients: [DBIngredient: Int] {get set}
    var originalSelectIngredients: [DBIngredient: Int] {get set}
    func save()
}