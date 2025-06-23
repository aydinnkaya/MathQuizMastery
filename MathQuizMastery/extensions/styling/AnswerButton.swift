//
//  AnswerButton.swift
//  MathQuizMastery
//
//  Created by Aydın KAYA on 20.06.2025.
//

import UIKit

@objc class AnswerButton: UIButton {
    
    private let backgroundLayer = CAGradientLayer()
    private let borderLayer = CAShapeLayer()
    private let glowLayer = CALayer()
    private let borderMaskLayer = CAShapeLayer()
    private let borderGradientLayer = CAGradientLayer()
    private let originalBackgroundColors: [CGColor]
    private let originalBorderColor: CGColor
    private let originalGlowColor: CGColor
    
    
    override init(frame: CGRect) {
        self.originalBackgroundColors = [
            UIColor(red: 54/255, green: 15/255, blue: 30/255, alpha: 0.95).cgColor,
            UIColor(red: 25/255, green: 5/255, blue: 20/255, alpha: 0.95).cgColor
        ]
        self.originalBorderColor = UIColor(red: 255/255, green: 122/255, blue: 0/255, alpha: 1.0).cgColor
        self.originalGlowColor = UIColor(red: 255/255, green: 122/255, blue: 0/255, alpha: 1.0).cgColor
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        self.originalBackgroundColors = [
            UIColor(red: 54/255, green: 15/255, blue: 30/255, alpha: 0.95).cgColor,
            UIColor(red: 25/255, green: 5/255, blue: 20/255, alpha: 0.95).cgColor
        ]
        self.originalBorderColor = UIColor(red: 255/255, green: 122/255, blue: 0/255, alpha: 1.0).cgColor
        self.originalGlowColor = UIColor(red: 255/255, green: 122/255, blue: 0/255, alpha: 1.0).cgColor
        super.init(coder: coder)
        setupButton()
    }
    
    private func setupButton() {
        clipsToBounds = false
        layer.masksToBounds = false
        layer.cornerRadius = 16
        
        backgroundLayer.colors = originalBackgroundColors
        backgroundLayer.startPoint = CGPoint(x: 0, y: 0)
        backgroundLayer.endPoint = CGPoint(x: 1, y: 1)
        backgroundLayer.cornerRadius = 16
        layer.insertSublayer(backgroundLayer, at: 0)
        
        glowLayer.shadowColor = UIColor(red: 255/255, green: 110/255, blue: 0/255, alpha: 1).cgColor
        glowLayer.shadowRadius = 18
        glowLayer.shadowOpacity = 0.9
        glowLayer.shadowOffset = .zero
        glowLayer.backgroundColor = UIColor.clear.cgColor
        glowLayer.cornerRadius = 16
        layer.insertSublayer(glowLayer, below: backgroundLayer)
        
        // Border gradient with mask
        borderGradientLayer.colors = [
            UIColor(red: 255/255, green: 120/255, blue: 0/255, alpha: 1).cgColor,
            UIColor(red: 255/255, green: 60/255, blue: 40/255, alpha: 1).cgColor
        ]
        borderGradientLayer.startPoint = CGPoint(x: 0, y: 0)
        borderGradientLayer.endPoint = CGPoint(x: 1, y: 1)
        borderGradientLayer.mask = borderMaskLayer
        layer.addSublayer(borderGradientLayer)
        
        // Text styling
        setTitleColor(.clear, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        titleLabel?.textAlignment = .center
        applyTextGradient()
        
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = originalBorderColor
        borderLayer.lineWidth = 3.0
        borderLayer.shadowColor = originalBorderColor
        borderLayer.shadowRadius = 10
        borderLayer.shadowOpacity = 1.0
        borderLayer.shadowOffset = .zero
        layer.addSublayer(borderLayer)
        
        setTitleColor(UIColor(red: 255/255, green: 175/255, blue: 50/255, alpha: 1.0), for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        titleLabel?.textAlignment = .center
        titleLabel?.layer.shadowColor = UIColor.orange.cgColor
        titleLabel?.layer.shadowRadius = 4
        titleLabel?.layer.shadowOpacity = 1.0
        titleLabel?.layer.shadowOffset = .zero
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundLayer.frame = bounds
        glowLayer.frame = bounds
        
        let borderPath = UIBezierPath(roundedRect: bounds, cornerRadius: 16)
        borderLayer.path = borderPath.cgPath
    }
    
    // MARK: - Touch Animations
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        UIView.animate(withDuration: 0.1) {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
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
    
    // MARK: - Answer Feedback
    func triggerCorrectAnswer() {
        // PARLAK YEŞİL - Doğru cevap
        let correctColors = [
            UIColor(red: 30/255, green: 150/255, blue: 50/255, alpha: 0.95).cgColor,
            UIColor(red: 50/255, green: 180/255, blue: 70/255, alpha: 0.95).cgColor
        ]
        let correctBorder = UIColor(red: 80/255, green: 255/255, blue: 100/255, alpha: 1.0).cgColor
        let correctGlow = UIColor(red: 80/255, green: 255/255, blue: 100/255, alpha: 1.0).cgColor
        
        UIView.animate(withDuration: 0.3, animations: {
            self.backgroundLayer.colors = correctColors
            self.borderLayer.strokeColor = correctBorder
            self.borderLayer.shadowColor = correctBorder
            self.glowLayer.shadowColor = correctGlow
            self.glowLayer.shadowRadius = 20
            self.glowLayer.shadowOpacity = 1.0
        })
        
        // Güçlü pulse efekti
        let pulseAnimation = CABasicAnimation(keyPath: "transform.scale")
        pulseAnimation.fromValue = 1.0
        pulseAnimation.toValue = 1.08
        pulseAnimation.duration = 0.2
        pulseAnimation.autoreverses = true
        layer.add(pulseAnimation, forKey: "successPulse")
    }
    
    func triggerWrongAnswer() {
        // KOYU KIRMIZI - Yanlış cevap
        let wrongColors = [
            UIColor(red: 150/255, green: 30/255, blue: 30/255, alpha: 0.95).cgColor,
            UIColor(red: 180/255, green: 40/255, blue: 40/255, alpha: 0.95).cgColor
        ]
        let wrongBorder = UIColor(red: 255/255, green: 60/255, blue: 60/255, alpha: 1.0).cgColor
        let wrongGlow = UIColor(red: 255/255, green: 60/255, blue: 60/255, alpha: 1.0).cgColor
        
        UIView.animate(withDuration: 0.3, animations: {
            self.backgroundLayer.colors = wrongColors
            self.borderLayer.strokeColor = wrongBorder
            self.borderLayer.shadowColor = wrongBorder
            self.glowLayer.shadowColor = wrongGlow
            self.glowLayer.shadowRadius = 20
            self.glowLayer.shadowOpacity = 1.0
        })
        
        // Güçlü shake efekti
        let shakeAnimation = CABasicAnimation(keyPath: "transform.translation.x")
        shakeAnimation.fromValue = -8
        shakeAnimation.toValue = 8
        shakeAnimation.duration = 0.06
        shakeAnimation.autoreverses = true
        shakeAnimation.repeatCount = 5
        layer.add(shakeAnimation, forKey: "errorShake")
    }
    
    func resetToNormal() {
        UIView.animate(withDuration: 0.3, animations: {
            self.backgroundLayer.colors = self.originalBackgroundColors
            self.borderLayer.strokeColor = self.originalBorderColor
            self.borderLayer.shadowColor = self.originalBorderColor
            self.glowLayer.shadowColor = self.originalGlowColor
            self.glowLayer.shadowRadius = 15
            self.glowLayer.shadowOpacity = 0.8
        })
    }
    
    
    private func applyTextGradient() {
        guard let title = self.title(for: .normal), let label = titleLabel else { return }
        
        let size = label.intrinsicContentSize
        let renderer = UIGraphicsImageRenderer(size: size)
        let img = renderer.image { context in
            let colors = [UIColor(red: 255/255, green: 180/255, blue: 50/255, alpha: 1),
                          UIColor(red: 255/255, green: 100/255, blue: 0/255, alpha: 1)]
            let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(),
                                      colors: colors.map { $0.cgColor } as CFArray,
                                      locations: [0, 1])!
            context.cgContext.drawLinearGradient(gradient,
                                                 start: CGPoint(x: 0, y: 0),
                                                 end: CGPoint(x: size.width, y: size.height),
                                                 options: [])
            let style = NSMutableParagraphStyle()
            style.alignment = .center
            let attrs: [NSAttributedString.Key: Any] = [
                .font: label.font!,
                .paragraphStyle: style
            ]
            let attributed = NSAttributedString(string: title, attributes: attrs)
            attributed.draw(in: CGRect(origin: .zero, size: size))
        }
        
        setTitleColor(UIColor(patternImage: img), for: .normal)
    }
}
