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
    var body: some View {
		ZStack{
			
			NavigationView {
				
				List(FilteredDrinks) { drink in
					NavigationLink(destination: DrinkDetal(drink: drink)) {
					DrinkRow(drink: drink)
					}
				}
				.navigationTitle("Cocktails")
				
			}
			VStack
			{
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
							//clearing search
							search = ""
					   }
						
				}
				Spacer()
			}
		}
    }
}

struct DrinkList_Previews: PreviewProvider {
    static var previews: some View {
        DrinkList()
    }
}
