//
//   UIButton+Styling.swift
//  MathQuizMastery
//
//  Created by AydınKaya on 2.04.2025.
//

import Foundation
import UIKit

extension UIButton {
    func applyStyledButton(withTitle title: String) {
        setTitle(title, for: .normal)
        setTitleColor(.white, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        layer.cornerRadius = 12
        layer.borderWidth = 2
        layer.borderColor = UIColor(red: 1.0, green: 0.8627, blue: 0.0, alpha: 1.0).cgColor
        backgroundColor = .clear
        clipsToBounds = true
        
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.purple.cgColor,
            UIColor.red.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.frame = bounds
        gradientLayer.cornerRadius = 12
        gradientLayer.name = "StyledButtonGradient"
        
        layer.sublayers?.removeAll(where: { $0.name == "StyledButtonGradient" })
        layer.insertSublayer(gradientLayer, at: 0)
        
        layer.shadowColor = UIColor.purple.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 6
        layer.masksToBounds = true
    }
    
    func updateGradientFrameIfNeeded() {
        layer.sublayers?
            .first(where: { $0.name == "StyledButtonGradient" })?
            .frame = bounds
    }
}
