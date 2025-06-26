//
//  UIStyle.swift
//  MathQuizMastery
//
//  Created by AydınKaya on 2.04.2025.
//

import Foundation
import UIKit

struct UIStyle {
    static let cornerRadius: CGFloat = 12
    static let textColor: UIColor = .black
    static let iconColor: UIColor = .black
    static let placeholderColor: UIColor = .darkGray
    static let borderDefault: UIColor = UIColor(red: 1.0, green: 0.8627, blue: 0.0, alpha: 1.0)
    static let textFont: UIFont = .systemFont(ofSize: 16, weight: .bold)
    static let placeholderFont: UIFont = .systemFont(ofSize: 16, weight: .medium)
    static let shadowColor: UIColor = .purple
    static let errorTextColor = UIColor("") ?? .white
    
    static let textFieldGradientColors: [CGColor] = [
        UIColor(red: 0.8, green: 0.85, blue: 0.9, alpha: 1).cgColor,
        UIColor(red: 0.75, green: 0.75, blue: 0.9, alpha: 1).cgColor,
        UIColor(red: 0.7, green: 0.8, blue: 0.85, alpha: 1).cgColor,
        UIColor(red: 0.65, green: 0.65, blue: 0.8, alpha: 1).cgColor,
        UIColor(red: 0.6, green: 0.7, blue: 0.75, alpha: 1).cgColor
    ]
}
