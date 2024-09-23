//
//  Binding extension.swift
//  BarHelper
//
//  Created by Владислав Пермяков on 23.09.2024.
//

import Foundation
import Combine
import SwiftUI
// Making Binding with Equatable types equatable themselves to be able to pass them as a path for routing
extension Binding: @retroactive Equatable where Value: Equatable {
    public static func == (lhs: Binding<Value>, rhs: Binding<Value>) -> Bool {
        return lhs.wrappedValue == rhs.wrappedValue
    }
}

extension Binding: @retroactive Hashable where Value: Hashable{
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(self.wrappedValue)
    }
}
