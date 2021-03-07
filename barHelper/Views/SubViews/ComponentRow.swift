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
		
		print(components)
		components.removeAll(where: {$0.id == self.component.id})
		print(components)
	}
}
