//
//  Array+extension.swift
//  ios-unsplash
//
//  Created by Hemg on 2/8/24.
//

import Foundation

extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
