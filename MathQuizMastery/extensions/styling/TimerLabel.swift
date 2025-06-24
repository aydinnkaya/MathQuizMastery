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

    private let textGradientLayer = CAGradientLayer()
    private let textMaskLayer = CATextLayer()

    private var isWarningActive = false

    private let gradientTextColors: [CGColor] = UIColor.Custom.timerTextGradient.map { $0.cgColor }

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

        // Background gradient
        backgroundLayer.colors = UIColor.Custom.timerBackground
        backgroundLayer.startPoint = CGPoint(x: 0, y: 0)
        backgroundLayer.endPoint = CGPoint(x: 1, y: 1)
        layer.insertSublayer(backgroundLayer, at: 0)

        // Glow effect
        glowLayer.backgroundColor = UIColor.clear.cgColor
        glowLayer.shadowColor = UIColor.Custom.timerGlow.cgColor
        glowLayer.shadowRadius = 18
        glowLayer.shadowOpacity = 0.8
        glowLayer.shadowOffset = .zero
        layer.insertSublayer(glowLayer, below: backgroundLayer)

        // Border
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = UIColor.Custom.timerBorder.cgColor
        borderLayer.lineWidth = 3.5
        borderLayer.shadowColor = UIColor.Custom.timerBorder.cgColor
        borderLayer.shadowRadius = 10
        borderLayer.shadowOpacity = 1.0
        borderLayer.shadowOffset = .zero
        layer.addSublayer(borderLayer)

        // Warning effect
        warningLayer.fillColor = UIColor.clear.cgColor
        warningLayer.strokeColor = UIColor.Custom.timerWarning.cgColor
        warningLayer.lineWidth = 5
        warningLayer.shadowColor = UIColor.Custom.timerWarning.cgColor
        warningLayer.shadowRadius = 15
        warningLayer.shadowOpacity = 1.0
        warningLayer.shadowOffset = .zero
        warningLayer.opacity = 0
        layer.addSublayer(warningLayer)

        // Gradient text setup
        textGradientLayer.colors = gradientTextColors
        textGradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        textGradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        layer.addSublayer(textGradientLayer)
        textGradientLayer.mask = textMaskLayer

        // Text mask properties
        textMaskLayer.contentsScale = UIScreen.main.scale
        textMaskLayer.alignmentMode = .center
        textMaskLayer.truncationMode = .end

        textColor = .clear // we use mask
        textAlignment = .center
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.6
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let diameter = min(bounds.width, bounds.height)
        let radius = diameter / 2

        layer.cornerRadius = radius
        backgroundLayer.cornerRadius = radius
        glowLayer.cornerRadius = radius

        backgroundLayer.frame = bounds
        glowLayer.frame = bounds
        textGradientLayer.frame = bounds

        let path = UIBezierPath(ovalIn: bounds)
        borderLayer.path = path.cgPath
        warningLayer.path = path.cgPath

        // Optimal font
        let optimalFontSize = diameter * 0.35
        font = UIFont.systemFont(ofSize: optimalFontSize, weight: .bold)

        // Update CATextLayer to match label's text
        let textHeight = font.lineHeight
        let yOffset = (bounds.height - textHeight) / 2
        textMaskLayer.frame = CGRect(x: 0, y: yOffset, width: bounds.width, height: textHeight)
        textMaskLayer.font = font
        textMaskLayer.fontSize = font.pointSize
        textMaskLayer.string = text
    }

    override var text: String? {
        didSet {
            textMaskLayer.string = text
        }
    }

    func animateTextChange(newText: String) {
        UIView.transition(with: self, duration: 0.2, options: .transitionFlipFromTop) {
            self.text = newText
        }
    }

    func triggerWarning() {
        guard !isWarningActive else { return }
        isWarningActive = true

        UIView.animate(withDuration: 0.3) {
            self.borderLayer.strokeColor = UIColor.Custom.timerWarning.cgColor
            self.borderLayer.shadowColor = UIColor.Custom.timerWarning.cgColor
            self.glowLayer.shadowColor = UIColor.Custom.timerWarning.cgColor
            self.backgroundLayer.colors = UIColor.Custom.timerWarningBackground
        }

        let pulse = CABasicAnimation(keyPath: "opacity")
        pulse.fromValue = 0
        pulse.toValue = 1
        pulse.duration = 0.4
        pulse.autoreverses = true
        pulse.repeatCount = .infinity
        warningLayer.add(pulse, forKey: "warningPulse")
    }

    func resetToNormal() {
        isWarningActive = false
        warningLayer.removeAllAnimations()

        UIView.animate(withDuration: 0.3) {
            self.borderLayer.strokeColor = UIColor.Custom.timerBorder.cgColor
            self.borderLayer.shadowColor = UIColor.Custom.timerBorder.cgColor
            self.glowLayer.shadowColor = UIColor.Custom.timerGlow.cgColor
            self.backgroundLayer.colors = UIColor.Custom.timerBackground
            self.warningLayer.opacity = 0
        }
    }
}

