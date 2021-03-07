//
//  LiqSearch.swift
//  barHelper
//
//  Created by vladukha on 07.03.2021.
//

import SwiftUI

struct LiqSearch: View {
	
	func add()
	{
		let index = liqs.firstIndex(where: {$0.id == selectedLiq})
		let comp = liqs[index ?? 1]
		if (!self.components.contains(comp))
		{
			self.components.append(comp)
		}
		
	}
	
	@State var components: [Liq] = []
	@State var selectedLiq = 1
	@Environment(\.colorScheme) var colorScheme
	
    var body: some View {
		NavigationView {
			ZStack{
				if(colorScheme == .dark)
				{BackgroundView(Schemes: .dark)}
				else
				{BackgroundView(Schemes: .light)}
				
				VStack{
					Picker("Cums", selection: $selectedLiq) {
						ForEach(liqs, id: \.self) {
							Text($0.name).tag($0.id)
						}
						.pickerStyle(SegmentedPickerStyle())
					}
					Image(systemName: "plus.circle")
						.resizable()
						.frame(width: 40, height: 40)
						.foregroundColor(.blue)
						.onTapGesture{
							self.add()
						}
					ScrollView(){
						ForEach(components, id: \.self) { component in
							componentsRow(component: component, components: $components)
								Divider()
						}
					}
					.padding()
					NavigationLink(destination: SearchResult(componentsFilter: components)) {
						Text("find me")
							.padding()
					}
					Spacer()
				}
			}
		}
    }
}

