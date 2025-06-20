//
//  SpaceBackgroundView.swift
//  MathQuizMastery
//
//  Created by Aydın KAYA on 20.06.2025.
//

import Foundation
import UIKit

class SpaceBackgroundView: UIView {
    
    private let gradientLayer = CAGradientLayer()
    private let starLayer = CAEmitterLayer()
    private let nebulaLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSpaceBackground()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSpaceBackground()
    }
    
    private func setupSpaceBackground() {
        // Deep space gradient
        gradientLayer.colors = [
            UIColor(red: 0.04, green: 0.06, blue: 0.12, alpha: 1.0).cgColor,
            UIColor(red: 0.08, green: 0.12, blue: 0.20, alpha: 1.0).cgColor,
            UIColor(red: 0.06, green: 0.10, blue: 0.18, alpha: 1.0).cgColor,
            UIColor(red: 0.02, green: 0.04, blue: 0.10, alpha: 1.0).cgColor
        ]
        gradientLayer.locations = [0.0, 0.3, 0.7, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        layer.addSublayer(gradientLayer)
        
        // Subtle nebula effect
        nebulaLayer.colors = [
            UIColor(red: 0.12, green: 0.16, blue: 0.28, alpha: 0.2).cgColor,
            UIColor(red: 0.16, green: 0.20, blue: 0.32, alpha: 0.1).cgColor,
            UIColor(red: 0.10, green: 0.14, blue: 0.24, alpha: 0.05).cgColor
        ]
        nebulaLayer.locations = [0.0, 0.5, 1.0]
        nebulaLayer.startPoint = CGPoint(x: 0.3, y: 0.2)
        nebulaLayer.endPoint = CGPoint(x: 0.7, y: 0.8)
        layer.addSublayer(nebulaLayer)
        
        // Professional star field
        setupStarField()
        startNebulaAnimation()
    }
    
    private func setupStarField() {
        starLayer.emitterPosition = CGPoint(x: bounds.midX, y: 0)
        starLayer.emitterSize = CGSize(width: bounds.width, height: 50)
        starLayer.renderMode = .additive
        
        // Create different star types
        let brightStar = createStarCell(size: 3, brightness: 1.0, birthRate: 8)
        let mediumStar = createStarCell(size: 2, brightness: 0.7, birthRate: 15)
        let dimStar = createStarCell(size: 1, brightness: 0.4, birthRate: 25)
        
        starLayer.emitterCells = [brightStar, mediumStar, dimStar]
        layer.addSublayer(starLayer)
    }
    
    private func createStarCell(size: CGFloat, brightness: Float, birthRate: Float) -> CAEmitterCell {
        let star = CAEmitterCell()
        star.contents = createStarImage(size: size).cgImage
        star.birthRate = birthRate
        star.lifetime = Float.infinity
        star.velocity = 0
        star.emissionRange = .pi * 2
        star.scale = 0.5
        star.scaleRange = 0.3
        star.alphaRange = 0.5
        star.color = UIColor(red: 0.90, green: 0.93, blue: 1.0, alpha: CGFloat(brightness)).cgColor
        
        return star
    }
    
    private func createStarImage(size: CGFloat) -> UIImage {
        let imageSize = CGSize(width: size, height: size)
        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0)
        let context = UIGraphicsGetCurrentContext()!
        
        context.setFillColor(UIColor.white.cgColor)
        context.fillEllipse(in: CGRect(origin: .zero, size: imageSize))
        
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
    private func startNebulaAnimation() {
        let animation = CABasicAnimation(keyPath: "colors")
        animation.fromValue = nebulaLayer.colors
        animation.toValue = [
            UIColor(red: 0.16, green: 0.20, blue: 0.32, alpha: 0.15).cgColor,
            UIColor(red: 0.12, green: 0.16, blue: 0.28, alpha: 0.08).cgColor,
            UIColor(red: 0.14, green: 0.18, blue: 0.30, alpha: 0.03).cgColor
        ]
        animation.duration = 8.0
        animation.autoreverses = true
        animation.repeatCount = .infinity
        nebulaLayer.add(animation, forKey: "nebulaShift")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
        nebulaLayer.frame = bounds
        starLayer.frame = bounds
        starLayer.emitterPosition = CGPoint(x: bounds.midX, y: 0)
        starLayer.emitterSize = CGSize(width: bounds.width, height: 50)
    }
}
