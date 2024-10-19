//
//  AlertsManager.swift
//  BarHelper
//
//  Created by Владислав Пермяков on 19.10.2024.
//

import Foundation
import Combine

/// Alert model thats showing
struct Alert: Identifiable {
    let id: UUID
    let text: String
}

/// singleton alert manager that manages alerts, duh
final class AlertsManager: ObservableObject {
    /// list of alerts showing currently
    @Published private(set) var alerts: [Alert] = []
    
    /// Singleton instance because thats faster and easier
    static let shared: AlertsManager = .init()
    
    private var cancellable = Set<AnyCancellable>()
    
    private init() {
        $alerts
            .sink {[weak self] array in
                guard let last = array.last else {return}
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    guard let self else {return}
                    self.removeAlert(id: last.id)
                }
            }
            .store(in: &cancellable)
    }
    
    /// remove alert from screen prematurely
    func removeAlert(id: UUID) {
        guard let index = self.alerts.firstIndex(where: {$0.id == id}) else {return}
        self.alerts.remove(at: index)
    }
    
    /// Add a text as an alert  on screen
    func alert(_ text: String) {
        DispatchQueue.main.async {
            self.alerts.insert(.init(id: .init(), text: text), at: 0)
        }
    }
}
