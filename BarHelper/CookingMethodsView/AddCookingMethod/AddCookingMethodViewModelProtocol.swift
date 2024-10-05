//
//  AddCookingMethodViewModelProtocol.swift
//  BarHelper
//
//  Created by Владислав Пермяков on 06.10.2024.
//

import Foundation

protocol AddCookingMethodViewModelProtocol: ObservableObject {
    var methodName: String {get set}
    var description: String {get set}
    func addMethod()
}
