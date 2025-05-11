//
//  NeonLabel+Styling.swift
//  MathQuizMastery
//
//  Created by Aydın KAYA on 11.05.2025.
//

import Foundation
import UIKit

import UIKit

class NeonLabel: UILabel {
    
    private let outerBorder = CAShapeLayer()
    private let innerBorder = CAShapeLayer()
    private let glowEffect = CALayer()
    private var lastSize: CGSize = .zero
    
    var neonColor: UIColor = UIColor.cyan {
        didSet {
            setupBorders()
        }
    }
    
    var cornerRadius: CGFloat = 8 {
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
        outerBorder.strokeColor = neonColor.cgColor
        outerBorder.lineWidth = 2
        outerBorder.fillColor = UIColor.clear.cgColor
        outerBorder.shadowColor = neonColor.cgColor
        outerBorder.shadowOffset = CGSize(width: 0, height: 0)
        outerBorder.shadowRadius = 6
        outerBorder.shadowOpacity = 0.9
        
        innerBorder.strokeColor = neonColor.withAlphaComponent(0.6).cgColor
        innerBorder.lineWidth = 1.5
        innerBorder.fillColor = UIColor.clear.cgColor
        
        glowEffect.backgroundColor = neonColor.withAlphaComponent(0.25).cgColor
        glowEffect.cornerRadius = cornerRadius
        
        if glowEffect.superlayer == nil {
            layer.insertSublayer(glowEffect, at: 0)
            layer.addSublayer(outerBorder)
            layer.addSublayer(innerBorder)
        }
        
        self.textColor = neonColor
        self.textAlignment = .center
        self.adjustsFontSizeToFitWidth = true
        self.minimumScaleFactor = 0.5
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard bounds.size != lastSize else { return }
        lastSize = bounds.size
        
        let outerPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        outerBorder.path = outerPath.cgPath
        
        let insetBounds = bounds.insetBy(dx: 3, dy: 3)
        let innerPath = UIBezierPath(roundedRect: insetBounds, cornerRadius: cornerRadius)
        innerBorder.path = innerPath.cgPath
        
        glowEffect.frame = bounds
        
        let optimalFontSize = bounds.height * 0.5
        self.font = UIFont.systemFont(ofSize: optimalFontSize, weight: .bold)
    }
    
    func animateTextChange(newText: String) {
        UIView.transition(with: self, duration: 0.3, options: .transitionFlipFromTop, animations: {
            self.text = newText
        }, completion: nil)
    }
}
