//
//  NeonCircleLabel+Styling.swift
//  MathQuizMastery
//
//  Created by Aydın KAYA on 11.05.2025.
//


import UIKit

class NeonCircleLabel: UILabel {
    
    private let outerBorder = CAShapeLayer()
    private let innerBorder = CAShapeLayer()
    private let glowEffect = CALayer()
    private var hasBeenConfigured = false
    
    var neonColor: UIColor = UIColor.magenta {
        didSet {
            if !hasBeenConfigured {
                setupBorders()
            }
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
        if hasBeenConfigured { return }
        hasBeenConfigured = true
        
        outerBorder.strokeColor = neonColor.cgColor
        outerBorder.lineWidth = 3
        outerBorder.fillColor = UIColor.clear.cgColor
        
        outerBorder.shadowColor = neonColor.cgColor
        outerBorder.shadowOffset = CGSize(width: 0, height: 0)
        outerBorder.shadowRadius = 5
        outerBorder.shadowOpacity = 0.7
        
        innerBorder.strokeColor = neonColor.withAlphaComponent(0.6).cgColor
        innerBorder.lineWidth = 1.5
        innerBorder.fillColor = UIColor.clear.cgColor
        
        glowEffect.backgroundColor = neonColor.withAlphaComponent(0.25).cgColor
        
        if glowEffect.superlayer == nil {
            layer.insertSublayer(glowEffect, at: 0)
            layer.addSublayer(outerBorder)
            layer.addSublayer(innerBorder)
        }
        
        self.textColor = neonColor
        self.textAlignment = .center
        self.adjustsFontSizeToFitWidth = true
        self.minimumScaleFactor = 0.5
        self.clipsToBounds = true
        self.layer.masksToBounds = true
        
        layoutIfNeeded()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if hasBeenConfigured {
            let diameter = min(bounds.width, bounds.height)
            layer.cornerRadius = diameter / 2
            glowEffect.cornerRadius = diameter / 2
            glowEffect.frame = bounds
            
            let outerPath = UIBezierPath(ovalIn: bounds)
            outerBorder.path = outerPath.cgPath
            
            let insetBounds = bounds.insetBy(dx: 3, dy: 3)
            let innerPath = UIBezierPath(ovalIn: insetBounds)
            innerBorder.path = innerPath.cgPath
            
            let optimalFontSize = diameter * 0.45
            self.font = UIFont.systemFont(ofSize: optimalFontSize, weight: .bold)
        }
    }
    
    func animateTextChange(newText: String) {
        UIView.transition(with: self, duration: 0.3, options: .transitionFlipFromTop, animations: {
            self.text = newText
        }, completion: nil)
    }
    
    func animateNeonBorder() {
        let color1 = UIColor(red: 0, green: 234/255, blue: 1, alpha: 1).cgColor // Neon mavi
        let color2 = UIColor(red: 162/255, green: 89/255, blue: 1, alpha: 1).cgColor // Neon mor
        let color3 = UIColor(red: 1, green: 78/255, blue: 205/255, alpha: 1).cgColor // Neon pembe
        let animation = CAKeyframeAnimation(keyPath: "strokeColor")
        animation.values = [color1, color2, color3, color1]
        animation.keyTimes = [0, 0.33, 0.66, 1]
        animation.duration = 2.0
        animation.repeatCount = .infinity
        animation.autoreverses = true
        outerBorder.add(animation, forKey: "neonBorderColor")
    }
}
