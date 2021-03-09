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
			LiqSearch()
				.tabItem {
					Image(systemName: "doc.text.magnifyingglass")
					Text("Поиск")
				}
			
		}
    }
}

