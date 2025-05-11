//
//  NeonButton+Styling.swift
//  MathQuizMastery
//
//  Created by Aydın KAYA on 12.05.2025.
//

import UIKit

class NeonButton: UIButton {
    
    private let gradientLayer = CAGradientLayer()
    private let outerBorder = CAShapeLayer()
    private let glowEffect = CALayer()
    
    var neonColors: [UIColor] = [UIColor.systemPink, UIColor.systemPurple] {
        didSet {
            setupBorders()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBorders()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupBorders()
    }
    
    private func setupBorders() {
        gradientLayer.colors = neonColors.map { $0.cgColor }
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.cornerRadius = 16
        layer.insertSublayer(gradientLayer, at: 0)
        
        outerBorder.strokeColor = UIColor.purple.cgColor
        outerBorder.lineWidth = 2
        outerBorder.fillColor = UIColor.clear.cgColor
        outerBorder.shadowColor = UIColor.purple.cgColor
        outerBorder.shadowOffset = CGSize(width: 0, height: 0)
        outerBorder.shadowRadius = 5
        outerBorder.shadowOpacity = 0.8
        layer.addSublayer(outerBorder)
        
        glowEffect.backgroundColor = UIColor.purple.withAlphaComponent(0.15).cgColor
        glowEffect.frame = bounds
        glowEffect.cornerRadius = 16
        layer.insertSublayer(glowEffect, at: 0)
        
        self.setTitleColor(.white, for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
        let path = UIBezierPath(roundedRect: bounds, cornerRadius: 16)
        outerBorder.path = path.cgPath
        glowEffect.frame = bounds
    }
}
