//
//  Array+Only.swift
//  ToddleTimeSwiftUI
//
//  Created by J S on 4/24/21.
//

import Foundation

extension Array {
    var only: Element? {
        count == 1 ? first : nil
    }
}
