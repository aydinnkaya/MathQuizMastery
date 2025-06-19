//
//  QuantumCircleLabel.swift
//  MathQuizMastery
//
//  Created by Aydın KAYA - Clean Timer Display
//

import UIKit

@objc class QuantumCircleLabel: UILabel {
    
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
        
        // Clean circular background
        backgroundLayer.colors = [
            UIColor(red: 0.1, green: 0.15, blue: 0.3, alpha: 0.95).cgColor,
            UIColor(red: 0.05, green: 0.1, blue: 0.2, alpha: 0.95).cgColor
        ]
        backgroundLayer.type = .radial
        backgroundLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
        backgroundLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        layer.insertSublayer(backgroundLayer, at: 0)
        
        // Subtle glow
        glowLayer.backgroundColor = UIColor.clear.cgColor
        glowLayer.shadowColor = UIColor(red: 0.3, green: 1.0, blue: 0.6, alpha: 1.0).cgColor
        glowLayer.shadowRadius = 20
        glowLayer.shadowOpacity = 0.6
        glowLayer.shadowOffset = .zero
        layer.insertSublayer(glowLayer, below: backgroundLayer)
        
        // Clean border
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = UIColor(red: 0.3, green: 1.0, blue: 0.6, alpha: 1.0).cgColor
        borderLayer.lineWidth = 3
        borderLayer.shadowColor = UIColor(red: 0.3, green: 1.0, blue: 0.6, alpha: 1.0).cgColor
        borderLayer.shadowRadius = 12
        borderLayer.shadowOpacity = 0.8
        borderLayer.shadowOffset = .zero
        layer.addSublayer(borderLayer)
        
        // VERY READABLE TEXT
        textAlignment = .center
        textColor = .white
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.5
        
        // Strong text shadow
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 3
        layer.shadowOpacity = 1.0
        layer.shadowOffset = CGSize(width: 0, height: 2)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let diameter = min(bounds.width, bounds.height)
        layer.cornerRadius = diameter / 2
        backgroundLayer.cornerRadius = diameter / 2
        glowLayer.cornerRadius = diameter / 2
        
        backgroundLayer.frame = bounds
        glowLayer.frame = bounds
        
        let borderPath = UIBezierPath(ovalIn: bounds)
        borderLayer.path = borderPath.cgPath
        
        // Perfect font sizing for circle
        let optimalFontSize = diameter * 0.35
        font = UIFont.systemFont(ofSize: optimalFontSize, weight: .black)
    }
    
    func animateTextChange(newText: String) {
        UIView.transition(with: self, duration: 0.3, options: .transitionFlipFromTop) {
            self.text = newText
        }
    }
    
    func triggerWarning() {
        // Low time warning
        UIView.animate(withDuration: 0.5, delay: 0, options: [.repeat, .autoreverse], animations: {
            self.borderLayer.strokeColor = UIColor.red.cgColor
            self.glowLayer.shadowColor = UIColor.red.cgColor
        })
    }
}
