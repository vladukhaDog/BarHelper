//
//  EditcookingMethodViewModelProtocol.swift
//  BarHelper
//
//  Created by Владислав Пермяков on 03.10.2024.
//

import Foundation
import SwiftUI

protocol EditCookingMethodViewModelProtocol: ObservableObject {
    var method: CookingMethod {get set}
    var methodName: String {get set}
    var description: String {get set}
    func deleteMethod()
    func editMethod()
}
