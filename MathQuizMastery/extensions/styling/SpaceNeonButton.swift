//
//  SpaceNeonButton.swift
//  MathQuizMastery
//
//  Created by AydınKaya on 19.06.2025.
//
//

import UIKit

@objc class SpaceNeonButton: UIButton {
    
    private let backgroundGradient = CAGradientLayer()
    private let borderLayer = CAShapeLayer()
    private let glowLayer = CALayer()
    
    var spaceColors: [UIColor] = [
        UIColor(red: 0.1, green: 0.7, blue: 1.0, alpha: 1.0),    // Clean Blue
        UIColor(red: 0.0, green: 0.9, blue: 1.0, alpha: 1.0)     // Bright Cyan
    ] {
        didSet {
            updateDesign()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }
    
    private func setupButton() {
        // Clean background with subtle transparency
        backgroundColor = UIColor(red: 0.05, green: 0.1, blue: 0.2, alpha: 0.85)
        layer.cornerRadius = 16
        clipsToBounds = true
        
        // Subtle glow effect
        glowLayer.backgroundColor = UIColor.clear.cgColor
        glowLayer.shadowColor = spaceColors[0].cgColor
        glowLayer.shadowRadius = 12
        glowLayer.shadowOpacity = 0.6
        glowLayer.shadowOffset = .zero
        glowLayer.cornerRadius = 16
        layer.insertSublayer(glowLayer, at: 0)
        
        // Clean border
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = spaceColors[0].cgColor
        borderLayer.lineWidth = 2
        borderLayer.shadowColor = spaceColors[0].cgColor
        borderLayer.shadowRadius = 8
        borderLayer.shadowOpacity = 0.8
        borderLayer.shadowOffset = .zero
        layer.addSublayer(borderLayer)
        
        // Text styling - MUCH MORE READABLE
        setTitleColor(.white, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        titleLabel?.textAlignment = .center
        
        // Text shadow for better readability
        titleLabel?.layer.shadowColor = UIColor.black.cgColor
        titleLabel?.layer.shadowRadius = 2
        titleLabel?.layer.shadowOpacity = 0.8
        titleLabel?.layer.shadowOffset = CGSize(width: 0, height: 1)
    }
    
    private func updateDesign() {
        borderLayer.strokeColor = spaceColors[0].cgColor
        borderLayer.shadowColor = spaceColors[0].cgColor
        glowLayer.shadowColor = spaceColors[0].cgColor
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        glowLayer.frame = bounds
        
        let borderPath = UIBezierPath(roundedRect: bounds, cornerRadius: 16)
        borderLayer.path = borderPath.cgPath
    }
    
    // Clean touch animation
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        UIView.animate(withDuration: 0.1) {
            self.transform = CGAffineTransform(scaleX: 0.98, y: 0.98)
            self.alpha = 0.9
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        UIView.animate(withDuration: 0.1) {
            self.transform = CGAffineTransform.identity
            self.alpha = 1.0
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        UIView.animate(withDuration: 0.1) {
            self.transform = CGAffineTransform.identity
            self.alpha = 1.0
        }
    }
    
    func triggerCorrectAnswer() {
        UIView.animate(withDuration: 0.3) {
            self.backgroundColor = UIColor(red: 0.2, green: 0.8, blue: 0.4, alpha: 0.9)
            self.borderLayer.strokeColor = UIColor.green.cgColor
        }
    }
    
    func triggerWrongAnswer() {
        UIView.animate(withDuration: 0.3) {
            self.backgroundColor = UIColor(red: 0.8, green: 0.2, blue: 0.2, alpha: 0.9)
            self.borderLayer.strokeColor = UIColor.red.cgColor
        }
    }
    
    func resetToNormal() {
        UIView.animate(withDuration: 0.3) {
            self.backgroundColor = UIColor(red: 0.05, green: 0.1, blue: 0.2, alpha: 0.85)
            self.borderLayer.strokeColor = self.spaceColors[0].cgColor
        }
    }
}
