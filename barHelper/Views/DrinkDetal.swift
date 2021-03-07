//
//  DrinkDetal.swift
//  barHelper
//
//  Created by vladukha on 05.03.2021.
//

import SwiftUI

struct DrinkDetal: View {
	var drink : Drink
	@Environment(\.colorScheme) var colorScheme
    var body: some View {
		ZStack{
			if(colorScheme == .dark)
			{BackgroundView(Schemes: .dark)}
			else
			{BackgroundView(Schemes: .light)}
        VStack{
			HStack{
				drink.image
					.resizable()
					.scaledToFit()
					.cornerRadius(10)
				ScrollView{
					Text(drink.description)
						.font(.title2)
					
				}
			}
			Text("Ингредиенты")
			Divider()
			ScrollView(){
				ForEach(drink.recipe, id: \.self) { component in
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
					.padding(.leading)
					.modifier(TextW())
					Divider()
				}
			}
			
			Spacer()
		}
		.padding()
    }
		.navigationTitle(drink.name)
	}
}



struct DrinkDetal_Previews: PreviewProvider {
    static var previews: some View {
        DrinkDetal(drink: drinks[0])
    }
}
