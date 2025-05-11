//
//  UIStackView+Styling.swift
//  MathQuizMastery
//
//  Created by Aydın KAYA on 10.05.2025.
//

import Foundation
import UIKit

// MARK: UIStackView Styling Extension
extension UIStackView {
    
    // MARK: - Ally Shadow
    func applyShadow(color: UIColor = .black, offest: CGSize = .zero  ,radius: CGFloat = 5.0, opacity: Float = 5.0) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = offest
        self.layer.shadowRadius = radius
        self.layer.shadowOpacity = opacity
        self.layer.masksToBounds = false
    }
    
    // MARK: - Apply Gradient Border
    func applyGradientBorder(colors: [UIColor], lineWidth: CGFloat) {
        removeGradientBorder()
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors.map({ $0.cgColor })
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.frame = self.bounds
        gradientLayer.name = "StackViewGradientBorder"
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.lineWidth = lineWidth
        shapeLayer.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius).cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.black.cgColor
        gradientLayer.mask = shapeLayer
        
        self.layer.addSublayer(gradientLayer)
    }
    
    // MARK: - Remove Gradinet Border
    func removeGradientBorder() {
        self.layer.sublayers?.removeAll(where: { $0.name == "StackViewGradientBorder" })
    }
    
    
    // MARKÇ - Layout Update
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        if let gradientLayer = self.layer.sublayers?.first(where: { $0.name == "StackViewGradientBorder" }) as? CAGradientLayer {
            gradientLayer.frame = self.bounds.insetBy(dx: 1, dy: 1)
            if let shapeLayer = gradientLayer.mask as? CAShapeLayer {
                shapeLayer.path = UIBezierPath(roundedRect: gradientLayer.bounds, cornerRadius: self.layer.cornerRadius).cgPath
            }
        }
    }
    
}
