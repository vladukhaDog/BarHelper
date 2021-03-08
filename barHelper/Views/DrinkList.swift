//
//  DrinkList.swift
//  barHelper
//
//  Created by vladukha on 04.03.2021.
//

import SwiftUI

struct DrinkList: View {
	@State var search = ""
	var FilteredDrinks : [Drink]{
		drinks.filter{ drink in
			(search.isEmpty || drink.name.lowercased().contains(search.lowercased()))
		}
	}
	@Environment(\.colorScheme) var colorScheme
    var body: some View {
		NavigationView {
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
				.navigationBarTitle("")
				.navigationBarHidden(true)
			}
		}
    }
}

struct DrinkList_Previews: PreviewProvider {
    static var previews: some View {
        DrinkList()
    }
}
