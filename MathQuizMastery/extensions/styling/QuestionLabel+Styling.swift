//
//  QuestionLabel+Styling.swift
//  MathQuizMastery
//
//  Created by AydınKaya on 13.05.2025.
//

import Foundation
import UIKit

class QuestionLabel: UILabel {

    private let outerBorder = CAShapeLayer()
    private let outerBorderLayer = CAGradientLayer()

    private let innerBorder = CAShapeLayer()
    private let innerBorderLayer = CAGradientLayer()

    private let glowEffect = CAGradientLayer()

    private var lastSize: CGSize = .zero

    var neonColors: [CGColor] = [
        UIColor(red: 1, green: 0, blue: 1, alpha: 1).cgColor,
        UIColor(red: 0, green: 0.96, blue: 1, alpha: 1).cgColor,
        UIColor(red: 0.54, green: 0.17, blue: 0.88, alpha: 1).cgColor
    ] {
        didSet {
            updateStyle()
        }
    }

    var cornerRadius: CGFloat = 8 {
        didSet {
            updateStyle()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        sharedInit()
    }

    private func sharedInit() {
        clipsToBounds = false
        layer.masksToBounds = false

        // Glow
        layer.insertSublayer(glowEffect, at: 0)

        // Outer border
        outerBorderLayer.mask = outerBorder
        layer.addSublayer(outerBorderLayer)

        // Inner border
        innerBorderLayer.mask = innerBorder
        layer.addSublayer(innerBorderLayer)

        // Label styling
        textAlignment = .center
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.5
        numberOfLines = 1
    }

    private func updateStyle() {
        guard neonColors.count >= 2 else { return }

        // Glow background
        glowEffect.colors = neonColors.map { $0.copy(alpha: 0.15) as Any }
        glowEffect.startPoint = CGPoint(x: 0, y: 0.5)
        glowEffect.endPoint = CGPoint(x: 1, y: 0.5)
        glowEffect.cornerRadius = cornerRadius

        // Outer border gradient
        outerBorderLayer.colors = neonColors
        outerBorderLayer.startPoint = CGPoint(x: 0, y: 0.5)
        outerBorderLayer.endPoint = CGPoint(x: 1, y: 0.5)

        outerBorder.lineWidth = 2
        outerBorder.fillColor = UIColor.clear.cgColor
        outerBorder.shadowColor = UIColor.white.cgColor // Gölge sabit kalabilir
        outerBorder.shadowOffset = .zero
        outerBorder.shadowRadius = 6
        outerBorder.shadowOpacity = 0.8

        // Inner border gradient
        innerBorderLayer.colors = neonColors.map { $0.copy(alpha: 0.5) as Any }
        innerBorderLayer.startPoint = CGPoint(x: 0, y: 0.5)
        innerBorderLayer.endPoint = CGPoint(x: 1, y: 0.5)

        innerBorder.lineWidth = 1.5
        innerBorder.fillColor = UIColor.clear.cgColor

        textColor = .white
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        guard bounds.size != lastSize else { return }
        lastSize = bounds.size

        let outerPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        outerBorder.path = outerPath.cgPath
        outerBorder.frame = bounds
        outerBorderLayer.frame = bounds

        let insetBounds = bounds.insetBy(dx: 3, dy: 3)
        let innerPath = UIBezierPath(roundedRect: insetBounds, cornerRadius: cornerRadius)
        innerBorder.path = innerPath.cgPath
        innerBorder.frame = bounds
        innerBorderLayer.frame = bounds

        glowEffect.frame = bounds

        let optimalFontSize = bounds.height * 0.5
        font = UIFont.systemFont(ofSize: optimalFontSize, weight: .bold)
    }

    func animateTextChange(newText: String) {
        UIView.transition(with: self, duration: 0.3, options: .transitionFlipFromTop) {
            self.text = newText
        }
    }
}
