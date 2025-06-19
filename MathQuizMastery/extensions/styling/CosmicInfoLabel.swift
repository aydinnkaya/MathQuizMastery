//
//  CosmicInfoLabel.swift
//  MathQuizMastery
//
//  Created by AydınKaya on 19.06.2025.
//

import UIKit

@objc class CosmicInfoLabel: UILabel {
    
    private let backgroundLayer = CAGradientLayer()
    private let borderLayer = CAShapeLayer()
    private let glowLayer = CALayer()
    
    @objc enum CosmicTheme: Int {
        case score = 0
        case questionNumber = 1
        case timer = 2
        
        var colors: [CGColor] {
            switch self {
            case .score:
                return [
                    UIColor(red: 0.8, green: 0.2, blue: 0.4, alpha: 0.9).cgColor,  // Clean Red
                    UIColor(red: 0.6, green: 0.1, blue: 0.3, alpha: 0.9).cgColor   // Dark Red
                ]
            case .questionNumber:
                return [
                    UIColor(red: 0.0, green: 0.6, blue: 1.0, alpha: 0.9).cgColor,  // Clean Blue
                    UIColor(red: 0.0, green: 0.4, blue: 0.8, alpha: 0.9).cgColor   // Dark Blue
                ]
            case .timer:
                return [
                    UIColor(red: 0.2, green: 0.8, blue: 0.4, alpha: 0.9).cgColor,  // Clean Green
                    UIColor(red: 0.1, green: 0.6, blue: 0.3, alpha: 0.9).cgColor   // Dark Green
                ]
            }
        }
        
        var borderColor: CGColor {
            switch self {
            case .score:
                return UIColor(red: 1.0, green: 0.3, blue: 0.5, alpha: 1.0).cgColor
            case .questionNumber:
                return UIColor(red: 0.0, green: 0.8, blue: 1.0, alpha: 1.0).cgColor
            case .timer:
                return UIColor(red: 0.3, green: 1.0, blue: 0.5, alpha: 1.0).cgColor
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
        
        // Clean background
        backgroundLayer.colors = cosmicTheme.colors
        backgroundLayer.startPoint = CGPoint(x: 0, y: 0)
        backgroundLayer.endPoint = CGPoint(x: 1, y: 1)
        backgroundLayer.cornerRadius = 12
        layer.insertSublayer(backgroundLayer, at: 0)
        
        // Subtle glow
        glowLayer.backgroundColor = UIColor.clear.cgColor
        glowLayer.shadowColor = cosmicTheme.borderColor
        glowLayer.shadowRadius = 12
        glowLayer.shadowOpacity = 0.5
        glowLayer.shadowOffset = .zero
        glowLayer.cornerRadius = 12
        layer.insertSublayer(glowLayer, below: backgroundLayer)
        
        // Clean border
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = cosmicTheme.borderColor
        borderLayer.lineWidth = 2
        borderLayer.shadowColor = cosmicTheme.borderColor
        borderLayer.shadowRadius = 6
        borderLayer.shadowOpacity = 0.6
        borderLayer.shadowOffset = .zero
        layer.addSublayer(borderLayer)
        
        // PERFECTLY READABLE TEXT
        textAlignment = .center
        textColor = .white
        font = UIFont.systemFont(ofSize: 18, weight: .bold)
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.6
        numberOfLines = 1
        
        // Strong text shadow
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 2
        layer.shadowOpacity = 1.0
        layer.shadowOffset = CGSize(width: 0, height: 1)
    }
    
    private func updateTheme() {
        backgroundLayer.colors = cosmicTheme.colors
        borderLayer.strokeColor = cosmicTheme.borderColor
        borderLayer.shadowColor = cosmicTheme.borderColor
        glowLayer.shadowColor = cosmicTheme.borderColor
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundLayer.frame = bounds
        glowLayer.frame = bounds
        
        let borderPath = UIBezierPath(roundedRect: bounds, cornerRadius: 12)
        borderLayer.path = borderPath.cgPath
    }
    
    func animateTextChange(newText: String) {
        UIView.transition(with: self, duration: 0.3, options: .transitionCrossDissolve) {
            self.text = newText
        }
    }
    
    func activateHighlight() {
        UIView.animate(withDuration: 0.3) {
            self.glowLayer.shadowRadius = 20
            self.glowLayer.shadowOpacity = 0.8
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            UIView.animate(withDuration: 0.3) {
                self.glowLayer.shadowRadius = 12
                self.glowLayer.shadowOpacity = 0.5
            }
        }
    }
}
