//
//  ContentView.swift
//  barHelper
//
//  Created by vladukha on 04.03.2021.
//

import SwiftUI

func Json()
{
	//var drinks : [Drink] = []
	//var drink = Drink()
	//var component = Component()
	//var components : [Component] = []
	//component.liqID = 1
	//component.amount = 45
	//components.append(component)
	//component.liqID = 2
	//component.amount = 30
	//components.append(component)
	//drink.recipe = components
	//drink.id = 1001
	//drink.name = "whiskey sour"
	//drink.description = "ну кислый висскос"
	//drinks.append(drink)
	//
	//component.liqID = 1
	//component.amount = 45
	//components.append(component)
	//component.liqID = 2
	//component.amount = 30
	//components.append(component)
	//drink.recipe = components
	//drink.id = 1002
	//drink.name = "2whiskey sour2"
	//drink.description = "2ну кислый висскос"
	//drinks.append(drink)
	
	//var drinks: [Drink] = load("drinksData.json")
	do {
		let jsonData = try JSONEncoder().encode(drinks)
		let jsonString = String(data: jsonData, encoding: .utf8)!
		print(jsonString) // [{"sentence":"Hello world","lang":"en"},{"sentence":"Hallo Welt","lang":"de"}]

		
	} catch { print(error) }
}

struct ContentView: View {
    var body: some View {
        Text("Hello, world!")
            .padding()
			.onAppear{
				
			}
    }
}

