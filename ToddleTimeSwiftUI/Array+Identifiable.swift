//
//  Array+Identifiable.swift
//  ToddleTimeSwiftUI
//
//  Created by J S on 4/24/21.
//

import Foundation

extension Array where Element: Identifiable {
    func firstIndex(matching: Element) -> Int? {
        for index in 0..<self.count where self[index].id == matching.id {
            return index
        }
        
        return nil
    }
}
