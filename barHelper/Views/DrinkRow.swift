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
			if (components.count < 5)
			{
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
			else
			{
				ForEach(0..<5) { index in
					let component = components[index]
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
				HStack{
					Text("....")
					Spacer()
				}
			}
		}
		.modifier(TextW())
	}
}

struct DrinkRow: View {
	let drink : Drink
	@Environment(\.colorScheme) var colorScheme
    var body: some View {
		ZStack{
			drink.image
				.resizable()
				.frame(width: 300, height: 300)
				.cornerRadius(10)
				.overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.white, lineWidth: 4))
				.shadow(radius: 7)
			
			VStack{
				HStack{
					Text(drink.name)
						.font(.title)
						.modifier(TextW())
					Spacer()
				}
				Divider()
				ComponentList(components: drink.recipe)
			}
			.padding()
		}
		.padding()
		.cornerRadius(10.0)
		
    }
}


struct TextW: ViewModifier {
	func body(content: Content) -> some View {
		content
			.foregroundColor(.white)
			.shadow(color: .black, radius: 1)
			.shadow(color: .black, radius: 1)
			.shadow(color: .black, radius: 1)
			.shadow(color: .black, radius: 1)
			.shadow(color: .black, radius: 1)
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
