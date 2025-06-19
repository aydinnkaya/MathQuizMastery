//
//  CosmicQuestionLabel.swift
//  MathQuizMastery
//
//  Created by AydınKaya on 19.06.2025.
//

import UIKit

@objc class CosmicQuestionLabel: UILabel {
    
    private let backgroundLayer = CAGradientLayer()
    private let borderLayer = CAShapeLayer()
    private let glowLayer = CALayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLabel()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLabel()
    }
    
    private func setupLabel() {
        clipsToBounds = false
        layer.masksToBounds = false
        
        // Clean dark background
        backgroundLayer.colors = [
            UIColor(red: 0.08, green: 0.12, blue: 0.25, alpha: 0.95).cgColor,
            UIColor(red: 0.05, green: 0.08, blue: 0.18, alpha: 0.95).cgColor
        ]
        backgroundLayer.startPoint = CGPoint(x: 0, y: 0)
        backgroundLayer.endPoint = CGPoint(x: 1, y: 1)
        backgroundLayer.cornerRadius = 20
        layer.insertSublayer(backgroundLayer, at: 0)
        
        // Subtle glow
        glowLayer.backgroundColor = UIColor.clear.cgColor
        glowLayer.shadowColor = UIColor(red: 0.0, green: 0.8, blue: 1.0, alpha: 1.0).cgColor
        glowLayer.shadowRadius = 15
        glowLayer.shadowOpacity = 0.5
        glowLayer.shadowOffset = .zero
        glowLayer.cornerRadius = 20
        layer.insertSublayer(glowLayer, below: backgroundLayer)
        
        // Clean border
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = UIColor(red: 0.0, green: 0.8, blue: 1.0, alpha: 1.0).cgColor
        borderLayer.lineWidth = 2
        borderLayer.shadowColor = UIColor(red: 0.0, green: 0.8, blue: 1.0, alpha: 1.0).cgColor
        borderLayer.shadowRadius = 8
        borderLayer.shadowOpacity = 0.6
        borderLayer.shadowOffset = .zero
        layer.addSublayer(borderLayer)
        
        // READABLE TEXT STYLING
        textAlignment = .center
        textColor = .white
        font = UIFont.systemFont(ofSize: 28, weight: .bold)
        numberOfLines = 2
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.7
        
        // Strong text shadow for perfect readability
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 3
        layer.shadowOpacity = 1.0
        layer.shadowOffset = CGSize(width: 0, height: 2)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundLayer.frame = bounds
        glowLayer.frame = bounds
        
        let borderPath = UIBezierPath(roundedRect: bounds, cornerRadius: 20)
        borderLayer.path = borderPath.cgPath
    }
    
    func animateTextChange(newText: String) {
        UIView.transition(with: self, duration: 0.3, options: .transitionCrossDissolve) {
            self.text = newText
        }
    }
}
