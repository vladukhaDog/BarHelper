//
//  NavigationUtils.swift
//  BarHelper
//
//  Created by Владислав Пермяков on 29.06.2023.
//

import Foundation
import SwiftUI
import Combine

extension Binding: Equatable where Value: Equatable {
    public static func == (lhs: Binding<Value>, rhs: Binding<Value>) -> Bool {
        return lhs.wrappedValue == rhs.wrappedValue
    }
}

extension Binding: Hashable where Value: Hashable{
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(self.wrappedValue)
    }
}

enum Destination: Hashable {
    case CocktailsList([DBCocktail]?)
    case Ingredients(Binding<[DBIngredient: Int]>?, Bool = true)
    case Search
    case CreateCocktail
    case CookingTypes
    case EditCocktail(Binding<DBCocktail?>)
    case CocktailView(Binding<DBCocktail>)
}

final class Router: ObservableObject {
    static let shared = Router()
    
    
    @Published var path = [Destination]()
    private var cancellable = Set<AnyCancellable>()
    private init(){
        $path
            .sink { pat in
                print(pat.count)
            }
            .store(in: &cancellable)
    }
    
    
    
    func push(_ destination: Destination){
        path.append(destination)
    }
    
    func backToRoot() {
        path.removeAll()
    }
    
    func back() {
        path.removeLast()
    }
}
