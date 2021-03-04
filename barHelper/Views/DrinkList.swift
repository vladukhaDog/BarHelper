//
//  DrinkList.swift
//  barHelper
//
//  Created by vladukha on 04.03.2021.
//

import SwiftUI

struct DrinkList: View {
    var body: some View {
		NavigationView {
			List(drinks) { drink in
				//NavigationLink() {
					DrinkRow(drink: drink)
				//}
			}
			.navigationTitle("Cocktails")
		}

    }
}

struct DrinkList_Previews: PreviewProvider {
    static var previews: some View {
        DrinkList()
    }
}
