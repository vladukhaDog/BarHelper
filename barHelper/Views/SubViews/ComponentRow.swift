//
//  ComponentRow.swift
//  barHelper
//
//  Created by vladukha on 07.03.2021.
//

import SwiftUI

struct componentsRow: View {
	@State var component: Liq
	@Binding var components: [Liq]
	@Binding var availableLiqs: [Liq]
	
	var body: some View {
		HStack{
			let liqIndex = liqs.firstIndex(where: {$0.id == component.id })
			let liqName = liqs[liqIndex ?? 0].name
			HStack{
				Text(liqName)
				Spacer()
				Image(systemName: "minus.circle")
				  .foregroundColor(.red)
					.onTapGesture{
						self.delete()
				   }
			}
		}
	}
	
	private func delete() {
		//remove liquor from selected list
		self.components.removeAll(where: {$0.id == self.component.id})
		
		var IndexInsert = 0
		//finding a place to insert liquor back in array of availables to filter
		
		if availableLiqs.isEmpty {
			self.availableLiqs.append(component)
		}else {
			
			for checkLiq in availableLiqs {
				if (component.id < checkLiq.id)
				{
					//next element has bigger id - insert component before it
					self.availableLiqs.insert(component, at: IndexInsert)
					break
				}else if (component.id > checkLiq.id)
				{
					if (checkLiq == availableLiqs.last){
						//if element is last id
						self.availableLiqs.append(component)
					}
					IndexInsert = IndexInsert + 1
				}
			}
		}
	}
}
