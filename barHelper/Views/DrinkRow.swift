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
				let liqIndex = liqs.firstIndex(where: {$0.id == component.liqID })
				let liqName = liqs[liqIndex ?? 0].name
				let liqAmount = String(component.amount )
				HStack{
					Text(liqName)
					Text(" - ")
					Text(liqAmount)
					Text("ml")
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
				Text(drink.name)
					.padding()
					.font(.title)
				Spacer()
			}
			ComponentList(components: drink.recipe)
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
