//
//  Font + extension.swift
//  BarHelper
//
//  Created by Владислав Пермяков on 11.05.2023.
//

import Foundation
import SwiftUI



extension Font {
    /// Default sizes for custom font size
    enum CyberpunkFontSize: CGFloat {
        case title = 33
        case smallTitle = 25
        case body = 20
    }
    
    @available(*, deprecated, renamed: "cyberpunkWaifu(size:)")
    static let CBTitle = Font.custom("CyberpunkWaifus", size: 33)
    @available(*, deprecated, renamed: "cyberpunkWaifu(size:)")
    static let smallTitle = Font.custom("CyberpunkWaifus", size: 25)
    @available(*, deprecated, renamed: "cyberpunkWaifu(size:)")
    static let normal = Font.custom("CyberpunkWaifus", size: 20)
    
    /// Return custom font with specified size
    static func cyberpunkWaifu(_ size: CyberpunkFontSize = .body) -> Font {
        return Font.custom("CyberpunkWaifus", size: size.rawValue)
    }
    
    /// Return custom font with specified size
    static func cyberpunkWaifu(_ size: CGFloat) -> Font {
        return Font.custom("CyberpunkWaifus", size: size)
    }
}

extension View {
    /// Wraps text with cyperpunk pixel font
    func cyberpunkFont(_ size: Font.CyberpunkFontSize = .body) -> some View {
        self
            .font(.cyberpunkWaifu(size))
    }
    
    /// Wraps text with cyperpunk pixel font
    func cyberpunkFont(_ size: CGFloat) -> some View {
        self
            .font(.cyberpunkWaifu(size))
    }
    
}

#Preview {
    VStack {
        Text("Title")
            .cyberpunkFont(.title)
        Text("smallTitle")
            .cyberpunkFont(.smallTitle)
        Text("body")
            .cyberpunkFont(.body)
        Text("Custom 50")
            .cyberpunkFont(50)
    }
}
