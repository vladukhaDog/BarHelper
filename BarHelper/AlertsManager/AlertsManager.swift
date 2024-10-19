//
//  AlertsManager.swift
//  BarHelper
//
//  Created by Владислав Пермяков on 19.10.2024.
//

import Foundation
import Combine

struct Alert: Identifiable {
    let id: UUID
    let text: String
}
final class AlertsManager: ObservableObject {
    @Published var alerts: [Alert] = []
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
    
    func removeAlert(id: UUID) {
        guard let index = self.alerts.firstIndex(where: {$0.id == id}) else {return}
        self.alerts.remove(at: index)
    }
    
    func alert(_ text: String) {
        DispatchQueue.main.async {
            self.alerts.insert(.init(id: .init(), text: text), at: 0)
        }
    }
}
