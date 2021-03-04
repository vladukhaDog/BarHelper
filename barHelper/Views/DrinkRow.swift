//
//  DrinkRow.swift
//  barHelper
//
//  Created by vladukha on 04.03.2021.
//

import SwiftUI

struct ComponentList: View {
	var components : [Component]
	var body: some View {
		VStack{
			ForEach(components, id: \.self) { component in
				HStack{
					Text(String(component.liqID ?? 0) + " - " + String(component.amount ?? 0) + "ml")
					Spacer()
				}
			}
		}
	}
}

struct DrinkRow: View {
	let drink : Drink
	
    var body: some View {
		VStack{
			HStack{
				Text(drink.name ?? "NoName")
					.font(.title)
				Spacer()
			}
			ComponentList(components: drink.recipe!)
		}
		
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
