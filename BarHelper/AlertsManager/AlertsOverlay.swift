//
//  Alerts.swift
//  BarHelper
//
//  Created by Владислав Пермяков on 19.10.2024.
//

import Foundation
import SwiftUI

extension View {
    func alertsOverlay() -> some View {
        AlertsView(view: self)
    }
}

private struct AlertsView<Content: View>: View {
    @ObservedObject var alerts: AlertsManager = .shared
    let view: Content
    var body: some View {
        view
            .overlay(alignment: .top) {
                VStack(spacing: 5) {
                    ForEach(alerts.alerts) { alert in
                        AlertCell(alert)
                            .gesture(
                                DragGesture(minimumDistance: 10) // Customize the swipe threshold
                                    .onEnded { value in
                                        if value.translation.height < 0 && abs(value.translation.width) < abs(value.translation.height) {
                                            // Swipe up detected
                                            alerts.removeAlert(id: alert.id)
                                        }
                                    }
                            )
                    }
                }
                .frame(maxWidth: .infinity)
                .clipped()
                .padding(.top, 1)
            }
            .animation(.default, value: alerts.alerts.count)
    }
}



#Preview("Alerts whole view preview") {
    VStack {
        Button("Add") {
            AlertsManager.shared.alert("Stuff happened awdawdawdawdawd awdawd awd awwdawd awdaw")
        }
        Button("Add") {
            AlertsManager.shared.alert("Not happened")
        }
    }
    .backgroundWithoutSafeSpace(.red)
    .alertsOverlay()
}
