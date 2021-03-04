//
//  ContentView.swift
//  barHelper
//
//  Created by vladukha on 04.03.2021.
//

import SwiftUI



struct ContentView: View {
    var body: some View {
		TabView {
			DrinkList()
				.tabItem {
					Image(systemName: "person.fill")
					Text("Drinks")
				}
			
		}
    }
}

