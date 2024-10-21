//
//  Array + extension.swift
//  BarHelper
//
//  Created by Владислав Пермяков on 21.10.2024.
//

import Foundation

extension Array<String> {
    func findAlphabeticalOrderIndex(for character: String) -> Int {
        var low = 0
        var high = self.count
        while low != high {
            let mid = (high+low)/2
            if self[mid] < character {
                low = self.index(after: mid)
            } else {
                high = mid
            }
        }
        return low
    }
}
