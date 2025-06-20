//
//  QuestionLabel.swift
//  MathQuizMastery
//
//  Created by AydınKaya on 19.06.2025.
//

import UIKit

@objc class QuestionLabel: UILabel {
    
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
        
        // GÜÇLÜ CANLI GLOW
        glowLayer.backgroundColor = UIColor.clear.cgColor
        glowLayer.shadowColor = UIColor(red: 0.4, green: 0.6, blue: 1.0, alpha: 1.0).cgColor  // Parlak mavi glow
        glowLayer.shadowRadius = 20
        glowLayer.shadowOpacity = 0.9
        glowLayer.shadowOffset = .zero
        glowLayer.cornerRadius = 20
        layer.insertSublayer(glowLayer, at: 0)
        
        // PARLAK CANLI BORDER
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = UIColor(red: 0.4, green: 0.8, blue: 1.0, alpha: 1.0).cgColor  // Elektrik mavisi
        borderLayer.lineWidth = 3
        borderLayer.shadowColor = UIColor(red: 0.4, green: 0.8, blue: 1.0, alpha: 1.0).cgColor
        borderLayer.shadowRadius = 12
        borderLayer.shadowOpacity = 1.0
        borderLayer.shadowOffset = .zero
        layer.addSublayer(borderLayer)
        
        // PARLAK BEYAZ TEXT - MAKSIMUM OKUNAKLILIK
        textAlignment = .center
        textColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)  // Parlak beyaz
        font = UIFont.systemFont(ofSize: 28, weight: .bold)
        numberOfLines = 2
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.8
        
        // Güçlü text glow
        layer.shadowColor = UIColor.white.cgColor
        layer.shadowRadius = 3
        layer.shadowOpacity = 0.9
        layer.shadowOffset = .zero
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        glowLayer.frame = bounds
        
        let borderPath = UIBezierPath(roundedRect: bounds, cornerRadius: 20)
        borderLayer.path = borderPath.cgPath
    }
    
    func animateTextChange(newText: String) {
        // Daha dramatik animasyon
        UIView.transition(with: self, duration: 0.4, options: .transitionFlipFromTop) {
            self.text = newText
        }
        
        // Glow pulsing efekti
        let pulseAnimation = CABasicAnimation(keyPath: "shadowOpacity")
        pulseAnimation.fromValue = 0.9
        pulseAnimation.toValue = 1.0
        pulseAnimation.duration = 0.2
        pulseAnimation.autoreverses = true
        glowLayer.add(pulseAnimation, forKey: "questionPulse")
    }
}
