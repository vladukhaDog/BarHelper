//
//  BarHelperApp.swift
//  BarHelper
//
//  Created by Владислав Пермяков on 08.05.2023.
//

import SwiftUI

@main
struct BarHelperApp: App {
    init(){
        let fonts = Bundle.main.urls(forResourcesWithExtension: "ttf", subdirectory: nil)
        fonts?.forEach({ url in
            CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
        })
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.dark)
        }
    }
}
