//
//  InfoLabel.swift
//  MathQuizMastery
//
//  Created by AydınKaya on 19.06.2025.
//

import UIKit

@objc class InfoLabel: UILabel {
    
    private let backgroundLayer = CALayer()
    private let borderLayer = CAShapeLayer()
    private let glowLayer = CALayer()
    
    @objc enum CosmicTheme: Int {
        case score = 0
        case questionNumber = 1
        case timer = 2
        
        var backgroundColor: CGColor {
            switch self {
            case .score:
                return UIColor(red: 0.12, green: 0.16, blue: 0.24, alpha: 0.92).cgColor  // Deep Slate
            case .questionNumber:
                return UIColor(red: 0.15, green: 0.18, blue: 0.26, alpha: 0.92).cgColor  // Dark Navy
            case .timer:
                return UIColor(red: 0.14, green: 0.20, blue: 0.16, alpha: 0.92).cgColor  // Forest Deep
            }
        }
        
        var borderColor: CGColor {
            switch self {
            case .score:
                return UIColor(red: 0.40, green: 0.60, blue: 0.85, alpha: 1.0).cgColor   // Soft Blue
            case .questionNumber:
                return UIColor(red: 0.55, green: 0.65, blue: 0.80, alpha: 1.0).cgColor   // Steel Blue
            case .timer:
                return UIColor(red: 0.45, green: 0.75, blue: 0.55, alpha: 1.0).cgColor   // Sage Green
            }
        }
        
        var glowColor: CGColor {
            switch self {
            case .score:
                return UIColor(red: 0.40, green: 0.60, blue: 0.85, alpha: 0.6).cgColor
            case .questionNumber:
                return UIColor(red: 0.55, green: 0.65, blue: 0.80, alpha: 0.6).cgColor
            case .timer:
                return UIColor(red: 0.45, green: 0.75, blue: 0.55, alpha: 0.6).cgColor
            }
        }
        
        var textColor: UIColor {
            switch self {
            case .score:
                return UIColor(red: 0.90, green: 0.95, blue: 1.0, alpha: 1.0)          // Cool White
            case .questionNumber:
                return UIColor(red: 0.95, green: 0.95, blue: 0.98, alpha: 1.0)          // Pure White
            case .timer:
                return UIColor(red: 0.92, green: 0.98, blue: 0.94, alpha: 1.0)          // Mint White
            }
        }
    }
    
    var cosmicTheme: CosmicTheme = .score {
        didSet {
            updateTheme()
        }
    }
    
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
        
        // Professional background
        backgroundLayer.backgroundColor = cosmicTheme.backgroundColor
        backgroundLayer.cornerRadius = 12
        layer.insertSublayer(backgroundLayer, at: 0)
        
        // Subtle professional glow
        glowLayer.backgroundColor = UIColor.clear.cgColor
        glowLayer.shadowColor = cosmicTheme.glowColor
        glowLayer.shadowRadius = 8
        glowLayer.shadowOpacity = 0.5
        glowLayer.shadowOffset = .zero
        glowLayer.cornerRadius = 12
        layer.insertSublayer(glowLayer, below: backgroundLayer)
        
        // Clean professional border
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = cosmicTheme.borderColor
        borderLayer.lineWidth = 1.5
        borderLayer.shadowColor = cosmicTheme.borderColor
        borderLayer.shadowRadius = 4
        borderLayer.shadowOpacity = 0.6
        borderLayer.shadowOffset = .zero
        layer.addSublayer(borderLayer)
        
        // Professional typography
        textAlignment = .center
        textColor = cosmicTheme.textColor
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.8
        numberOfLines = 1
        
        // Subtle text shadow
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 1
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 0, height: 1)
    }
    
    private func updateTheme() {
        backgroundLayer.backgroundColor = cosmicTheme.backgroundColor
        borderLayer.strokeColor = cosmicTheme.borderColor
        borderLayer.shadowColor = cosmicTheme.borderColor
        glowLayer.shadowColor = cosmicTheme.glowColor
        textColor = cosmicTheme.textColor
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundLayer.frame = bounds
        glowLayer.frame = bounds
        
        let borderPath = UIBezierPath(roundedRect: bounds, cornerRadius: 12)
        borderLayer.path = borderPath.cgPath
    }
    
    func animateTextChange(newText: String) {
        UIView.transition(with: self, duration: 0.25, options: .transitionCrossDissolve) {
            self.text = newText
        }
    }
    
    func activateHighlight() {
        UIView.animate(withDuration: 0.15, animations: {
            self.glowLayer.shadowRadius = 12
            self.glowLayer.shadowOpacity = 0.8
            self.transform = CGAffineTransform(scaleX: 1.02, y: 1.02)
        }) { _ in
            UIView.animate(withDuration: 0.15) {
                self.glowLayer.shadowRadius = 8
                self.glowLayer.shadowOpacity = 0.5
                self.transform = CGAffineTransform.identity
            }
        }
    }
}
