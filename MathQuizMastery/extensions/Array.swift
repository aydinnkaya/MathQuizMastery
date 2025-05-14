//
//  Array.swift
//  MathQuizMastery
//
//  Created by AydınKaya on 14.05.2025.
//

import Foundation

extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
