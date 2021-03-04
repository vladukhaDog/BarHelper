//
//  DrinkRow.swift
//  barHelper
//
//  Created by vladukha on 04.03.2021.
//

import SwiftUI

struct DrinkRow: View {
	let drink : Drink
	
    var body: some View {
		Text(drink.name ?? "NoName")
    }
}

struct DrinkRow_Previews: PreviewProvider {
    static var previews: some View {
		Group{
			DrinkRow(drink: drinks[0])
			DrinkRow(drink: drinks[1])
		}
    }
}
