//
//  TimerLabel.swift
//  MathQuizMastery
//
//  Created by Aydın KAYA on 20.06.2025.
//

import Foundation
import UIKit

@objc class TimerLabel: UILabel {
    
    private let backgroundLayer = CAGradientLayer()
    private let borderLayer = CAShapeLayer()
    private let glowLayer = CALayer()
    private let warningLayer = CAShapeLayer()
    private var isWarningActive = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLabel()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLabel()
    }
    
    private func setupLabel() {
        clipsToBounds = true
        layer.masksToBounds = true
        
        // TURUNCU gradient background
        backgroundLayer.colors = [
            UIColor(red: 0.4, green: 0.15, blue: 0.05, alpha: 0.95).cgColor,
            UIColor(red: 0.5, green: 0.2, blue: 0.1, alpha: 0.95).cgColor
        ]
        backgroundLayer.startPoint = CGPoint(x: 0, y: 0)
        backgroundLayer.endPoint = CGPoint(x: 1, y: 1)
        layer.insertSublayer(backgroundLayer, at: 0)
        
        // Güçlü turuncu glow
        glowLayer.backgroundColor = UIColor.clear.cgColor
        glowLayer.shadowColor = UIColor(red: 1.0, green: 0.6, blue: 0.2, alpha: 1.0).cgColor
        glowLayer.shadowRadius = 18
        glowLayer.shadowOpacity = 0.8
        glowLayer.shadowOffset = .zero
        layer.insertSublayer(glowLayer, below: backgroundLayer)
        
        // Parlak turuncu border
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = UIColor(red: 1.0, green: 0.6, blue: 0.2, alpha: 1.0).cgColor
        borderLayer.lineWidth = 3.5
        borderLayer.shadowColor = UIColor(red: 1.0, green: 0.6, blue: 0.2, alpha: 1.0).cgColor
        borderLayer.shadowRadius = 10
        borderLayer.shadowOpacity = 1.0
        borderLayer.shadowOffset = .zero
        layer.addSublayer(borderLayer)
        
        // Warning effect layer
        warningLayer.fillColor = UIColor.clear.cgColor
        warningLayer.strokeColor = UIColor(red: 1.0, green: 0.3, blue: 0.3, alpha: 1.0).cgColor
        warningLayer.lineWidth = 5
        warningLayer.shadowColor = UIColor(red: 1.0, green: 0.3, blue: 0.3, alpha: 1.0).cgColor
        warningLayer.shadowRadius = 15
        warningLayer.shadowOpacity = 1.0
        warningLayer.shadowOffset = .zero
        warningLayer.opacity = 0
        layer.addSublayer(warningLayer)
        
        // PARLAK BEYAZ TEXT
        textAlignment = .center
        textColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)  // Parlak beyaz
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.6
        
        // Text glow
        layer.shadowColor = UIColor.white.cgColor
        layer.shadowRadius = 2
        layer.shadowOpacity = 0.9
        layer.shadowOffset = .zero
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let diameter = min(bounds.width, bounds.height)
        let radius = diameter / 2
        
        // Perfect circle
        layer.cornerRadius = radius
        backgroundLayer.cornerRadius = radius
        glowLayer.cornerRadius = radius
        
        backgroundLayer.frame = bounds
        glowLayer.frame = bounds
        
        let borderPath = UIBezierPath(ovalIn: bounds)
        borderLayer.path = borderPath.cgPath
        warningLayer.path = borderPath.cgPath
        
        // Optimal font sizing
        let optimalFontSize = diameter * 0.35
        font = UIFont.systemFont(ofSize: optimalFontSize, weight: .bold)
    }
    
    func animateTextChange(newText: String) {
        UIView.transition(with: self, duration: 0.2, options: .transitionFlipFromTop) {
            self.text = newText
        }
    }
    
    func triggerWarning() {
        guard !isWarningActive else { return }
        isWarningActive = true
        
        // KIRMIZI warning colors
        UIView.animate(withDuration: 0.3) {
            self.borderLayer.strokeColor = UIColor(red: 1.0, green: 0.3, blue: 0.3, alpha: 1.0).cgColor
            self.borderLayer.shadowColor = UIColor(red: 1.0, green: 0.3, blue: 0.3, alpha: 1.0).cgColor
            self.glowLayer.shadowColor = UIColor(red: 1.0, green: 0.3, blue: 0.3, alpha: 1.0).cgColor
            self.backgroundLayer.colors = [
                UIColor(red: 0.4, green: 0.1, blue: 0.1, alpha: 0.95).cgColor,
                UIColor(red: 0.5, green: 0.15, blue: 0.15, alpha: 0.95).cgColor
            ]
        }
        
        // Güçlü pulsing warning effect
        let pulseAnimation = CABasicAnimation(keyPath: "opacity")
        pulseAnimation.fromValue = 0.0
        pulseAnimation.toValue = 1.0
        pulseAnimation.duration = 0.4
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = .infinity
        warningLayer.add(pulseAnimation, forKey: "warningPulse")
    }
    
    func resetToNormal() {
        isWarningActive = false
        warningLayer.removeAllAnimations()
        
        UIView.animate(withDuration: 0.3) {
            self.borderLayer.strokeColor = UIColor(red: 1.0, green: 0.6, blue: 0.2, alpha: 1.0).cgColor
            self.borderLayer.shadowColor = UIColor(red: 1.0, green: 0.6, blue: 0.2, alpha: 1.0).cgColor
            self.glowLayer.shadowColor = UIColor(red: 1.0, green: 0.6, blue: 0.2, alpha: 1.0).cgColor
            self.backgroundLayer.colors = [
                UIColor(red: 0.4, green: 0.15, blue: 0.05, alpha: 0.95).cgColor,
                UIColor(red: 0.5, green: 0.2, blue: 0.1, alpha: 0.95).cgColor
            ]
            self.warningLayer.opacity = 0
        }
    }
}
