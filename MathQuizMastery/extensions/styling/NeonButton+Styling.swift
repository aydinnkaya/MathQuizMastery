//
//  NeonButton+Styling.swift
//  MathQuizMastery
//
//  Created by Aydın KAYA on 12.05.2025.
//

import UIKit

class NeonButton: UIButton {
    
    private let gradientLayer = CAGradientLayer()
    private let glowLayer = CALayer()
    private let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    
    var neonColors: [UIColor] = [UIColor(red: 0, green: 234/255, blue: 1, alpha: 1), UIColor(red: 0, green: 180/255, blue: 255/255, alpha: 1), UIColor(red: 0, green: 120/255, blue: 255/255, alpha: 1)] {
        didSet {
            updateGradient()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayers()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayers()
    }
    
    private func setupLayers() {
        // Glassmorphism (blur) - as a layer, not a subview
        blurEffectView.isUserInteractionEnabled = false
        if blurEffectView.superview == nil {
            insertSubview(blurEffectView, at: 0)
        }
        blurEffectView.frame = bounds
        backgroundColor = UIColor.white.withAlphaComponent(0.10)
        layer.cornerRadius = 18
        clipsToBounds = true
        
        // Gradient Border
        gradientLayer.colors = neonColors.map { $0.cgColor }
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.frame = bounds
        gradientLayer.cornerRadius = 18
        gradientLayer.masksToBounds = true
        if gradientLayer.superlayer == nil {
            layer.insertSublayer(gradientLayer, at: 0)
        }
        layer.borderWidth = 3
        layer.borderColor = UIColor.clear.cgColor
        
        // Neon Glow
        glowLayer.backgroundColor = neonColors.first?.withAlphaComponent(0.18).cgColor ?? UIColor.cyan.withAlphaComponent(0.18).cgColor
        glowLayer.shadowColor = neonColors.first?.cgColor ?? UIColor.cyan.cgColor
        glowLayer.shadowRadius = 16
        glowLayer.shadowOpacity = 0.7
        glowLayer.shadowOffset = .zero
        glowLayer.frame = bounds
        glowLayer.cornerRadius = 18
        if glowLayer.superlayer == nil {
            layer.insertSublayer(glowLayer, below: gradientLayer)
        }
        setTitleColor(.white, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 22, weight: .bold)
    }
    
    private func updateGradient() {
        gradientLayer.colors = neonColors.map { $0.cgColor }
        glowLayer.backgroundColor = neonColors.first?.withAlphaComponent(0.18).cgColor ?? UIColor.cyan.withAlphaComponent(0.18).cgColor
        glowLayer.shadowColor = neonColors.first?.cgColor ?? UIColor.cyan.cgColor
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
        glowLayer.frame = bounds
        blurEffectView.frame = bounds
    }
    
    func animateBorder() {
        let animation = CABasicAnimation(keyPath: "colors")
        animation.fromValue = gradientLayer.colors
        animation.toValue = [
            UIColor.systemTeal.cgColor,
            UIColor.systemPink.cgColor,
            UIColor.systemPurple.cgColor
        ]
        animation.duration = 1.5
        animation.autoreverses = true
        animation.repeatCount = .infinity
        gradientLayer.add(animation, forKey: "colorChange")
    }
}
