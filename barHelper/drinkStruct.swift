//
//  drinkStruct.swift
//  barHelper
//
//  Created by vladukha on 04.03.2021.
//

import Foundation

struct Drink: Hashable, Codable {
	var id: Int?
	var name: String?
	var description: String?
	var recipe: [Component]?
}


struct Component: Hashable, Codable {
	var liqID: Int?
	var amount: Int?
}

struct Liq: Codable, Hashable {
	var id: Int?
	var name: String?
}

