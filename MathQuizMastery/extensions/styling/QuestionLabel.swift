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
    private let backgroundGradient = CAGradientLayer()
    
    private let textGradientLayer = CAGradientLayer()
    private let textMaskLayer = CATextLayer()
    
    private let gradientTextColors: [CGColor] = [
        UIColor(red: 255/255, green: 200/255, blue: 80/255, alpha: 1).cgColor, // Altın
        UIColor(red: 255/255, green: 100/255, blue: 30/255, alpha: 1).cgColor  // Turuncu
    ]
    
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
        
        // MARK: - Background Gradient
        backgroundGradient.colors = [
            UIColor(red: 28/255, green: 6/255, blue: 65/255, alpha: 1.0).cgColor,     // Gece moru
            UIColor(red: 10/255, green: 5/255, blue: 35/255, alpha: 1.0).cgColor      // Uzay mavisi
        ]

        backgroundGradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        backgroundGradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        backgroundGradient.cornerRadius = 20
        layer.insertSublayer(backgroundGradient, at: 0)
        
        // MARK: - Glow Layer
        glowLayer.backgroundColor = UIColor.clear.cgColor
        glowLayer.shadowColor = UIColor(red: 0.4, green: 0.6, blue: 1.0, alpha: 1.0).cgColor
        glowLayer.shadowRadius = 20
        glowLayer.shadowOpacity = 0.9
        glowLayer.shadowOffset = .zero
        glowLayer.cornerRadius = 20
        layer.insertSublayer(glowLayer, above: backgroundGradient)
        
        // MARK: - Border Layer
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = UIColor(red: 0.4, green: 0.8, blue: 1.0, alpha: 1.0).cgColor
        borderLayer.lineWidth = 3
        borderLayer.shadowColor = borderLayer.strokeColor
        borderLayer.shadowRadius = 12
        borderLayer.shadowOpacity = 1.0
        borderLayer.shadowOffset = .zero
        layer.addSublayer(borderLayer)
        
        // MARK: - Gradient Text
        textGradientLayer.colors = gradientTextColors
        textGradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        textGradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        layer.addSublayer(textGradientLayer)
        textGradientLayer.mask = textMaskLayer
        
        textMaskLayer.alignmentMode = .center
        textMaskLayer.truncationMode = .end
        textMaskLayer.contentsScale = UIScreen.main.scale
        
        // MARK: - UILabel Properties
        textAlignment = .center
        textColor = .clear // Gradient için
        font = UIFont.systemFont(ofSize: 28, weight: .bold)
        numberOfLines = 2
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.8
        
        // Shadow for readability
        layer.shadowColor = UIColor.white.cgColor
        layer.shadowRadius = 3
        layer.shadowOpacity = 0.9
        layer.shadowOffset = .zero
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundGradient.frame = bounds
        glowLayer.frame = bounds
        textGradientLayer.frame = bounds
        
        let textHeight = font.lineHeight * CGFloat(numberOfLines)
        let yOffset = (bounds.height - textHeight) / 2
        textMaskLayer.frame = CGRect(x: 0, y: yOffset, width: bounds.width, height: textHeight)
        textMaskLayer.string = text ?? ""
        textMaskLayer.font = font
        textMaskLayer.fontSize = font.pointSize
        
        let borderPath = UIBezierPath(roundedRect: bounds, cornerRadius: 20)
        borderLayer.path = borderPath.cgPath
    }
    
    override var text: String? {
        didSet {
            textMaskLayer.string = text ?? ""
        }
    }
    
    override var font: UIFont! {
        didSet {
            textMaskLayer.font = font
            textMaskLayer.fontSize = font.pointSize
        }
    }
    
    func animateTextChange(newText: String) {
        UIView.transition(with: self, duration: 0.4, options: .transitionFlipFromTop) {
            self.text = newText
        }
        
        let pulseAnimation = CABasicAnimation(keyPath: "shadowOpacity")
        pulseAnimation.fromValue = 0.9
        pulseAnimation.toValue = 1.0
        pulseAnimation.duration = 0.2
        pulseAnimation.autoreverses = true
        glowLayer.add(pulseAnimation, forKey: "questionPulse")
    }
}
