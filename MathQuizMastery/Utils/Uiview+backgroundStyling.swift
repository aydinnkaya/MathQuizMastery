//
//  Uiview+backgroundStyling.swift
//  MathQuizMastery
//
//  Created by Aydın KAYA on 1.04.2025.
//
//self.layer.borderColor = UIColor(red: 1.0, green: 0.8627, blue: 0.0, alpha: 1.0).cgColor

import UIKit
import ObjectiveC

private struct AssociatedKeys {
    static var hasStyledBackgroundKey: UInt8 = 0
}

extension UITextField {
    
    private var hasStyledBackground: Bool {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.hasStyledBackgroundKey) as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.hasStyledBackgroundKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func applyStyledAppearance(placeholder: String, iconName: String) {
        self.layer.cornerRadius = UIStyle.cornerRadius
        self.layer.borderWidth = 2
        self.layer.borderColor = UIStyle.borderDefault.cgColor
        self.backgroundColor = .clear
        self.textColor = UIStyle.textColor
        self.font = UIStyle.textFont
        
        let iconAttachment = NSTextAttachment()
        iconAttachment.image = UIImage(systemName: iconName)?.withTintColor(UIStyle.iconColor, renderingMode: .alwaysOriginal)
        iconAttachment.bounds = CGRect(x: 0, y: -4, width: 25, height: 25)
        
        let iconString = NSAttributedString(attachment: iconAttachment)
        let textString = NSAttributedString(string: " \(placeholder)", attributes: [
            .foregroundColor: UIStyle.placeholderColor,
            .font: UIStyle.placeholderFont
        ])
        
        let combined = NSMutableAttributedString()
        combined.append(iconString)
        combined.append(textString)
        
        self.attributedPlaceholder = combined
        self.contentVerticalAlignment = .center
    }
    
    func addStyledBackground(in container: UIView) {
        guard !hasStyledBackground else { return }
        hasStyledBackground = true
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = UIStyle.textFieldGradientColors
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.cornerRadius = layer.cornerRadius
        
        layoutIfNeeded()
        gradientLayer.frame = bounds
        
        let backgroundView = UIView(frame: frame)
        backgroundView.layer.insertSublayer(gradientLayer, at: 0)
        backgroundView.layer.cornerRadius = layer.cornerRadius
        backgroundView.layer.shadowColor = UIStyle.shadowColor.cgColor
        backgroundView.layer.shadowOffset = CGSize(width: 0, height: 3)
        backgroundView.layer.shadowOpacity = 0.3
        backgroundView.layer.shadowRadius = 6
        backgroundView.layer.masksToBounds = false
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        if let superview = superview {
            superview.insertSubview(backgroundView, belowSubview: self)
            NSLayoutConstraint.activate([
                backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
                backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
                backgroundView.topAnchor.constraint(equalTo: topAnchor),
                backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        }
    }
}
struct UIStyle {
    static let cornerRadius: CGFloat = 12
    static let textColor: UIColor = .black
    static let iconColor: UIColor = .black
    static let placeholderColor: UIColor = .black
    static let borderDefault: UIColor = UIColor(red: 1.0, green: 0.8627, blue: 0.0, alpha: 1.0)
    static let textFont: UIFont = .systemFont(ofSize: 16, weight: .bold)
    static let placeholderFont: UIFont = .systemFont(ofSize: 16, weight: .medium)
    static let shadowColor: UIColor = .purple
    
    static let textFieldGradientColors: [CGColor] = [
        UIColor(red: 0.8, green: 0.85, blue: 0.9, alpha: 1).cgColor,
        UIColor(red: 0.75, green: 0.75, blue: 0.9, alpha: 1).cgColor,
        UIColor(red: 0.7, green: 0.8, blue: 0.85, alpha: 1).cgColor,
        UIColor(red: 0.65, green: 0.65, blue: 0.8, alpha: 1).cgColor,
        UIColor(red: 0.6, green: 0.7, blue: 0.75, alpha: 1).cgColor
    ]
}

extension UIButton {
    func applyStyledButton(withTitle title: String) {
        setTitle(title, for: .normal)
        setTitleColor(.white, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        layer.cornerRadius = 12
        layer.borderWidth = 2
        layer.borderColor = UIColor(red: 1.0, green: 0.8627, blue: 0.0, alpha: 1.0).cgColor
        backgroundColor = .clear
        clipsToBounds = true
        
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.purple.cgColor,
            UIColor.red.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.frame = bounds
        gradientLayer.cornerRadius = 12
        gradientLayer.name = "StyledButtonGradient"
        
        layer.sublayers?.removeAll(where: { $0.name == "StyledButtonGradient" })
        layer.insertSublayer(gradientLayer, at: 0)
        
        layer.shadowColor = UIColor.purple.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 6
        layer.masksToBounds = true
    }
    
    func updateGradientFrameIfNeeded() {
        layer.sublayers?
            .first(where: { $0.name == "StyledButtonGradient" })?
            .frame = bounds
    }
}
