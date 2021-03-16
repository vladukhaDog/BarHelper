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
			self.availableLiqs.remove(at: availableLiqs.firstIndex(of: comp)!)
			self.selectedLiq = selectedLiq + 1
		}
		
	}
	
	func Reset()
	{
		availableLiqs = liqs
		components = []
		search = ""
	}
	
	@State var availableLiqs = liqs
	@State var components: [Liq] = []
	@State var selectedLiq = 1
	@State var search = ""
	
	var FilteredLiqs : [Liq]{
		availableLiqs.filter{ liq in
			(search.isEmpty || liq.name.lowercased().contains(search.lowercased()))
		}
	}
	
	var FilteredDrinks : [Drink]{
		drinks.filter{ drink in
			let SetComponents = Set(components)
			var liqList : [Liq] = []
			for rec in drink.recipe {
				let ind = liqs.firstIndex(where: {$0.id == rec.liqID}) ?? 1
				liqList.append(liqs[ind])
			}
			if !SearchAll {
				return (SetComponents.isSubset(of: Set(liqList)))
			}else{
				for component in SetComponents {
					if liqList.contains(component) {
						return true
					}
				}
				return false
			}
		}
	}
	
	@Environment(\.colorScheme) var colorScheme
	@State var SearchAll = false
	private var axes: Axis.Set {
			return []
		}
	
	var body: some View {
		NavigationView {
			ZStack{
				if(colorScheme == .dark)
				{BackgroundView(Schemes: .dark)}
				else
				{BackgroundView(Schemes: .light)}
				
				ScrollView(axes, showsIndicators: false){
					HStack{
						TextField("Поиск напитка", text: $search)
							.padding(.trailing)
							.padding(.leading)
							.textFieldStyle(RoundedBorderTextFieldStyle())
							.onChange(of: search, perform: {_ in
								let FilterIndex = FilteredLiqs.first
								if (FilterIndex != nil)
								{
									selectedLiq = FilterIndex!.id
								}
								
							})
						Image(systemName: "xmark")
							.resizable()
							.frame(width: 15, height: 15)
							.padding()
							.foregroundColor(search.count > 0 ? .red : .gray)
							.onTapGesture{
								search = ""
							}
					}
					
					
					Picker("Cums", selection: $selectedLiq) {
						ForEach(FilteredLiqs, id: \.self) {
							Text($0.name).tag($0.id)
						}
						.pickerStyle(SegmentedPickerStyle())
					}
					.padding(-25)
					HStack{
						Toggle("Все ингредиенты в коктейле", isOn: $SearchAll)
							.padding()
						Image(systemName: "plus.circle")
							.resizable()
							.frame(width: 40, height: 40)
							.foregroundColor(.blue)
							.onTapGesture{
								self.add()
							}
						
					}
					
					ScrollView(){
						ForEach(components, id: \.self) { component in
							componentsRow(component: component, components: $components, availableLiqs: $availableLiqs)
							Divider()
						}
					}
					.padding()
					
					HStack{
						Button {
							Reset()
						} label: {
							VallButton(ImageName: "reset", TextString: "Reset")
						}
						
						NavigationLink(destination: SearchResult(FilteredDrinks: FilteredDrinks)) {
							VallButton(ImageName: "greenMix", TextString: "Mix", RedButton: components.isEmpty)
						}
					}
					.padding()
				}
			}
			.navigationBarTitle("")
			.navigationBarHidden(true)
		}
	}
}


struct VallButton: View {
	var ImageName : String
	var TextString : String
	var RedButton : Bool?
	var body: some View {
		ZStack{
			if (RedButton ?? false)
			{
				Image("redMix")
					.resizable()
					.scaledToFit()
			}else{
				Image(ImageName)
					.resizable()
					.scaledToFit()
			}
			Text(TextString)
				.font(Font.custom("CyberpunkWaifus", size: 33))
				.foregroundColor(.black)
				.padding()
			
		}
	}
}

