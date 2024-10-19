//
//  AlertCell.swift
//  BarHelper
//
//  Created by Владислав Пермяков on 19.10.2024.
//

import SwiftUI

/// Cell of a single alert
struct AlertCell: View {
    private let alert: Alert
    @State private var bottomCoordinate: CGFloat = .zero
    
    init(_ alert: Alert) {
        self.alert = alert
    }
    
    var body: some View {
        Text(alert.text)
            .cyberpunkFont(.title)
            .foregroundStyle(Color.white)
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity)
            .padding(5)
            .background(Color.black)
            .padding(5)
            .depthBorder()
            .padding(10)
            .background(Color.darkPurple)
            .depthBorderUp()
            .padding(.horizontal, 5)
            .background(GeometryReader { geometry in
                                Color.clear // Transparent view just to capture the geometry
                                    .onAppear {
                                        let top = geometry.frame(in: .global).maxY
                                        bottomCoordinate = top
                                    }
                                    .onChange(of: geometry.frame(in: .global).maxY) { _, _ in
                                        let top = geometry.frame(in: .global).maxY
                                        bottomCoordinate = top
                                    }
                            })
        // we capture the coordinate of a bottom point of the cell, to move it all the way up on deletion
            .transition(.asymmetric(insertion: .move(edge: .top),
                                    removal: .offset(y: -bottomCoordinate)
                .combined(with: .opacity)
                                   ))
    }
}

#Preview("AlertCell") {
    AlertCell(.init(id: .init(), text: "Text"))
}
