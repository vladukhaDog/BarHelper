//
//  EditIngredientsViewModelProtocol.swift
//  BarHelper
//
//  Created by Владислав Пермяков on 19.10.2024.
//

import Foundation

protocol EditIngredientsViewModelProtocol: ObservableObject {
    var name: String {get set}
    var description: String {get set}
    func setup(_ router: Router) async
    func save()
    func cancel()
}
