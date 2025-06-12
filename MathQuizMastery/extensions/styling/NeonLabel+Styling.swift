//
//  NeonLabel+Styling.swift
//  MathQuizMastery
//
//  Created by Aydın KAYA on 11.05.2025.
//

import Foundation
import UIKit

class NeonLabel: UILabel {

    private let outerBorder = CAShapeLayer()
    private let innerBorder = CAShapeLayer()
    private let glowEffect = CALayer()
    private var lastSize: CGSize = .zero

    var neonColor: UIColor = .cyan {
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
        layer.insertSublayer(glowEffect, at: 0)
        layer.addSublayer(outerBorder)
        layer.addSublayer(innerBorder)

        textAlignment = .center
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.5
        numberOfLines = 1
    }

    private func updateStyle() {
        // Glow
        glowEffect.backgroundColor = neonColor.withAlphaComponent(0.15).cgColor
        glowEffect.cornerRadius = cornerRadius

        // Outer Border
        outerBorder.strokeColor = neonColor.cgColor
        outerBorder.lineWidth = 2
        outerBorder.fillColor = UIColor.clear.cgColor
        outerBorder.shadowColor = neonColor.cgColor
        outerBorder.shadowOffset = .zero
        outerBorder.shadowRadius = 6
        outerBorder.shadowOpacity = 0.8

        // Inner Border
        innerBorder.strokeColor = neonColor.withAlphaComponent(0.5).cgColor
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

        let insetBounds = bounds.insetBy(dx: 3, dy: 3)
        let innerPath = UIBezierPath(roundedRect: insetBounds, cornerRadius: cornerRadius)
        innerBorder.path = innerPath.cgPath
        innerBorder.frame = bounds

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
