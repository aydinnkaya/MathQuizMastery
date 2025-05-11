//
//   UITextField+Styling.swift
//  MathQuizMastery
//
//  Created by AydınKaya on 2.04.2025.
//

import Foundation
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
