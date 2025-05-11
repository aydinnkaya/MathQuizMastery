//
//  QuestionLabel+Styling.swift
//  MathQuizMastery
//
//  Created by Aydın KAYA on 12.05.2025.
//

import UIKit

class QuestionLabel: UILabel {
    
    private let outerBorder = CAShapeLayer()
    private let gradientLayer = CAGradientLayer()
    private let glowEffect = CALayer()
    private var lastSize: CGSize = .zero
    
    var neonColors: [UIColor] = [UIColor.systemCyan, UIColor.green] {
        didSet {
            setupBorders()
        }
    }
    
    override var text: String? {
        didSet {
            super.text = text
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
        
        outerBorder.strokeColor = UIColor.cyan.cgColor
        outerBorder.lineWidth = 3
        outerBorder.fillColor = UIColor.clear.cgColor
        outerBorder.shadowColor = UIColor.cyan.cgColor
        outerBorder.shadowOffset = CGSize(width: 0, height: 0)
        outerBorder.shadowRadius = 5
        outerBorder.shadowOpacity = 0.8
        layer.addSublayer(outerBorder)
        
        glowEffect.backgroundColor = UIColor.cyan.withAlphaComponent(0.15).cgColor
        glowEffect.frame = bounds
        glowEffect.cornerRadius = 16
        layer.insertSublayer(glowEffect, at: 0)
        
        self.textColor = .white
        self.textAlignment = .center
        self.adjustsFontSizeToFitWidth = true
        self.minimumScaleFactor = 0.5
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard bounds.size != lastSize else { return }
        lastSize = bounds.size
        
        gradientLayer.frame = bounds
        
        let outerPath = UIBezierPath(roundedRect: bounds, cornerRadius: 16)
        outerBorder.path = outerPath.cgPath
        
        glowEffect.frame = bounds
        
        let optimalFontSize = bounds.height * 0.4
        self.font = UIFont.systemFont(ofSize: optimalFontSize, weight: .bold)
    }
    
    func animateTextChange(newText: String) {
        UIView.transition(with: self, duration: 0.3, options: .transitionFlipFromTop, animations: {
            self.text = newText
        }, completion: nil)
    }
}
