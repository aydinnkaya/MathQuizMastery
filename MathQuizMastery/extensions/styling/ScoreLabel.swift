//
//  ScoreLabel.swift
//  MathQuizMastery
//
//  Created by Aydın KAYA on 23.06.2025.
//

import Foundation
import UIKit

class ScoreLabel: UILabel {

    private let backgroundGradient = CAGradientLayer()
    private let borderGradient = CAGradientLayer()
    private let borderMaskLayer = CAShapeLayer()
    private let glowLayer = CALayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        clipsToBounds = false
        layer.cornerRadius = 16
        layer.masksToBounds = false

        // Background
        backgroundGradient.colors = [
            UIColor(red: 0.20, green: 0.02, blue: 0.4, alpha: 1).cgColor,
            UIColor(red: 0.08, green: 0.0, blue: 0.25, alpha: 1).cgColor
        ]
        backgroundGradient.startPoint = CGPoint(x: 0, y: 0)
        backgroundGradient.endPoint = CGPoint(x: 1, y: 1)
        backgroundGradient.cornerRadius = 16
        layer.insertSublayer(backgroundGradient, at: 0)

        // Glow
        glowLayer.shadowColor = UIColor(red: 1, green: 0.4, blue: 0.0, alpha: 1.0).cgColor
        glowLayer.shadowRadius = 20
        glowLayer.shadowOpacity = 1.0
        glowLayer.shadowOffset = .zero
        glowLayer.backgroundColor = UIColor.clear.cgColor
        glowLayer.cornerRadius = 16
        layer.insertSublayer(glowLayer, below: backgroundGradient)

        // Border
        borderGradient.colors = [
            UIColor(red: 1.0, green: 0.65, blue: 0.2, alpha: 1).cgColor,
            UIColor(red: 1.0, green: 0.25, blue: 0.05, alpha: 1).cgColor
        ]
        borderGradient.startPoint = CGPoint(x: 0, y: 0)
        borderGradient.endPoint = CGPoint(x: 1, y: 1)
        borderGradient.mask = borderMaskLayer
        layer.addSublayer(borderGradient)

        // Text styling
        textAlignment = .center
        font = UIFont.boldSystemFont(ofSize: 20)
        adjustsFontSizeToFitWidth = true
        numberOfLines = 1
        minimumScaleFactor = 0.8
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundGradient.frame = bounds
        glowLayer.frame = bounds
        borderGradient.frame = bounds

        let path = UIBezierPath(roundedRect: bounds.insetBy(dx: 1.2, dy: 1.2), cornerRadius: 16)
        borderMaskLayer.path = path.cgPath
        borderMaskLayer.lineWidth = 2.5
        borderMaskLayer.strokeColor = UIColor.black.cgColor
        borderMaskLayer.fillColor = UIColor.clear.cgColor

        applyGradientText(text ?? "")
    }

    private func applyGradientText(_ text: String) {
        guard let font = self.font else { return }
        guard bounds.size.width > 0, bounds.size.height > 0 else { return }

        let size = bounds.size
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { ctx in
            let gradient = CGGradient(
                colorsSpace: CGColorSpaceCreateDeviceRGB(),
                colors: [
                    UIColor(red: 1.0, green: 0.7, blue: 0.2, alpha: 1).cgColor,
                    UIColor(red: 1.0, green: 0.4, blue: 0.0, alpha: 1).cgColor
                ] as CFArray,
                locations: [0, 1]
            )!
            ctx.cgContext.drawLinearGradient(gradient, start: .zero, end: CGPoint(x: size.width, y: size.height), options: [])

            let style = NSMutableParagraphStyle()
            style.alignment = .center
            let attrs: [NSAttributedString.Key: Any] = [
                .font: font,
                .paragraphStyle: style
            ]
            NSAttributedString(string: text, attributes: attrs).draw(in: CGRect(origin: .zero, size: size))
        }

        self.text = text
        self.textColor = UIColor(patternImage: image)
    }

    func animateTextChange(newText: String) {
        UIView.transition(with: self, duration: 0.25, options: .transitionCrossDissolve) {
            self.text = newText
            self.applyGradientText(newText)
        }
    }

    func activateHighlight() {
        UIView.animate(withDuration: 0.15, animations: {
            self.glowLayer.shadowRadius = 24
            self.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
        }) { _ in
            UIView.animate(withDuration: 0.15) {
                self.glowLayer.shadowRadius = 16
                self.transform = .identity
            }
        }
    }
}
