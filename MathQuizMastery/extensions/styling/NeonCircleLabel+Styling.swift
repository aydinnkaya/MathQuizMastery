//
//  NeonCircleLabel+Styling.swift
//  MathQuizMastery
//
//  Created by Aydın KAYA on 11.05.2025.
//

import Foundation
import UIKit

class NeonCircleLabel: UILabel {
    
    private let outerBorder = CAShapeLayer()
    private let innerBorder = CAShapeLayer()
    private let glowEffect = CALayer()
    
    var neonColor: UIColor = UIColor.cyan {
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
        layer.cornerRadius = bounds.width / 2
        layer.masksToBounds = true
        
        outerBorder.strokeColor = neonColor.cgColor
        outerBorder.lineWidth = 2
        outerBorder.fillColor = UIColor.clear.cgColor
        
        innerBorder.strokeColor = neonColor.withAlphaComponent(0.5).cgColor
        innerBorder.lineWidth = 1.5
        innerBorder.fillColor = UIColor.clear.cgColor
        
        glowEffect.backgroundColor = neonColor.withAlphaComponent(0.15).cgColor
        glowEffect.frame = bounds
        glowEffect.cornerRadius = bounds.width / 2
        
        layer.insertSublayer(glowEffect, at: 0)
        layer.addSublayer(outerBorder)
        layer.addSublayer(innerBorder)
        
        self.textColor = neonColor
        self.textAlignment = .center
        self.font = UIFont.systemFont(ofSize: bounds.width * 0.3, weight: .bold)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let diameter = min(bounds.width, bounds.height)
        layer.cornerRadius = diameter / 2
        
        let outerPath = UIBezierPath(ovalIn: bounds)
        outerBorder.path = outerPath.cgPath
        
        let insetBounds = bounds.insetBy(dx: 3, dy: 3)
        let innerPath = UIBezierPath(ovalIn: insetBounds)
        innerBorder.path = innerPath.cgPath
        
        glowEffect.frame = bounds
        glowEffect.cornerRadius = diameter / 2
    }
}
