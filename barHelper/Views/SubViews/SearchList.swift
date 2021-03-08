//
//  SearchList.swift
//  barHelper
//
//  Created by vladukha on 07.03.2021.
//

import SwiftUI

struct SearchResult: View {
	var componentsFilter : [Liq]
	
	
	
	var FilteredDrinks : [Drink]{
		drinks.filter{ drink in
			let SetComponents = Set(componentsFilter)
			var liqList : [Liq] = []
			for rec in drink.recipe {
				let ind = liqs.firstIndex(where: {$0.id == rec.liqID}) ?? 1
				liqList.append(liqs[ind])
			}
			return (SetComponents.isSubset(of: Set(liqList)))
			//(SetComponents.isSubset(of: ))
		}
	}
	
	@State var search = ""
	@Environment(\.colorScheme) var colorScheme
	
	var body: some View {
		VStack {
			ZStack{
				if(colorScheme == .dark)
				{BackgroundView(Schemes: .dark)}
				else
				{BackgroundView(Schemes: .light)}
			ScrollView(.vertical) {
					HStack{
						TextField("Поиск напитка", text: $search)
							.padding(.trailing)
							.padding(.leading)
							.textFieldStyle(RoundedBorderTextFieldStyle())
						Image(systemName: "xmark")
							.resizable()
							.frame(width: 15, height: 15)
							.padding()
							.foregroundColor(search.count > 0 ? .red : .gray)
							.onTapGesture{
								search = ""
							}
						
					}
					ForEach(FilteredDrinks, id: \.self) { drink in
						NavigationLink(destination: DrinkDetal(drink: drink)) {
							DrinkRow(drink: drink)
						}
					}
				}
			}
		}
		.navigationBarTitle("", displayMode: .inline)
		
	}
}
