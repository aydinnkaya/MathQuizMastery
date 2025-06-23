//
//  InfoLabel.swift
//  MathQuizMastery
//
//  Created by AydınKaya on 19.06.2025.
//

import UIKit

@objc class InfoLabel: UILabel {
    
    private let backgroundGradient = CAGradientLayer()
    private let borderGradient = CAGradientLayer()
    private let borderMaskLayer = CAShapeLayer()
    private let glowLayer = CALayer()
    
    @objc enum CosmicTheme: Int {
        case score = 0
        case questionNumber = 1
        case timer = 2
        
        var backgroundColors: [CGColor] {
            switch self {
            case .score:
                return [
                    UIColor(red: 16/255, green: 16/255, blue: 64/255, alpha: 1).cgColor,
                    UIColor(red: 0/255, green: 0/255, blue: 32/255, alpha: 1).cgColor
                ]
            case .questionNumber:
                return [
                    UIColor(red: 70/255, green: 0/255, blue: 100/255, alpha: 1).cgColor,
                    UIColor(red: 20/255, green: 0/255, blue: 40/255, alpha: 1).cgColor
                ]
            case .timer:
                return [
                    UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.4).cgColor,
                    UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.6).cgColor
                ]
            }
        }
        
        var borderColors: [CGColor] {
            switch self {
            case .score:
                return [
                    UIColor(red: 122/255, green: 208/255, blue: 255/255, alpha: 1.0).cgColor,
                    UIColor(red: 138/255, green: 43/255, blue: 226/255, alpha: 1).cgColor
                ]
            case .questionNumber:
                return [
                    UIColor(red: 1.0, green: 0.2, blue: 1.0, alpha: 1).cgColor,
                    UIColor(red: 1.0, green: 0.3, blue: 0.1, alpha: 1).cgColor
                ]
            case .timer:
                return [
                    UIColor(white: 0.8, alpha: 0.8).cgColor,
                    UIColor(white: 0.6, alpha: 0.6).cgColor
                ]
            }
        }
        
        var textGradientColors: [CGColor] {
            switch self {
            case .score:
                return [
                    UIColor(red: 255/255, green: 180/255, blue: 50/255, alpha: 1).cgColor,
                    UIColor(red: 255/255, green: 100/255, blue: 0/255, alpha: 1).cgColor
                ]
            case .questionNumber:
                return [
                    UIColor(red: 1.0, green: 0.65, blue: 0.2, alpha: 1).cgColor,
                    UIColor(red: 1.0, green: 0.33, blue: 0.0, alpha: 1).cgColor
                ]
            case .timer:
                return [
                    UIColor(white: 0.95, alpha: 1.0).cgColor,
                    UIColor(white: 0.75, alpha: 1.0).cgColor
                ]
            }
        }
        
        var glowColor: CGColor {
            switch self {
            case .score:
                return UIColor(red: 1.0, green: 0.45, blue: 0.1, alpha: 1).cgColor
            case .questionNumber:
                return UIColor(red: 1.0, green: 0.2, blue: 0.8, alpha: 1).cgColor
            case .timer:
                return UIColor.white.cgColor
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
        setupUI()
        updateTheme()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        updateTheme()
    }
    
    private func setupUI() {
        clipsToBounds = false
        backgroundColor = .clear
        textColor = .clear
        layer.cornerRadius = 20
        layer.masksToBounds = false
        
        backgroundGradient.cornerRadius = 20
        backgroundGradient.startPoint = CGPoint(x: 0.5, y: 0.0)
        backgroundGradient.endPoint = CGPoint(x: 0.5, y: 1.0)
        layer.insertSublayer(backgroundGradient, at: 0)
        
        glowLayer.shadowOffset = .zero
        glowLayer.shadowRadius = 24
        glowLayer.shadowOpacity = 1.0
        glowLayer.backgroundColor = UIColor.clear.cgColor
        glowLayer.cornerRadius = 20
        layer.insertSublayer(glowLayer, below: backgroundGradient)
        
        borderGradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        borderGradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        borderGradient.mask = borderMaskLayer
        layer.addSublayer(borderGradient)
        
        borderMaskLayer.lineWidth = 4.0
        borderMaskLayer.lineJoin = .round
        borderMaskLayer.lineCap = .round
        borderMaskLayer.strokeColor = UIColor.white.cgColor
        borderMaskLayer.fillColor = UIColor.clear.cgColor
        
        textAlignment = .center
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.6
        numberOfLines = 1
        font = UIFont.systemFont(ofSize: 24, weight: .black)
    }
    
    private func updateTheme() {
        backgroundGradient.colors = cosmicTheme.backgroundColors
        borderGradient.colors = cosmicTheme.borderColors
        glowLayer.shadowColor = cosmicTheme.glowColor
        setNeedsDisplay()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundGradient.frame = bounds
        glowLayer.frame = bounds
        borderGradient.frame = bounds
        borderMaskLayer.frame = bounds
        
        let path = UIBezierPath(roundedRect: bounds.insetBy(dx: 1.5, dy: 1.5), cornerRadius: 20)
        borderMaskLayer.path = path.cgPath
    }
    
    override func drawText(in rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext(), let text = text, let font = self.font else { return }
        guard bounds.width > 0, bounds.height > 0 else { return }
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .paragraphStyle: paragraph
        ]
        
        let attributed = NSAttributedString(string: text, attributes: attributes)
        let textSize = attributed.size()
        let textRect = CGRect(
            x: (bounds.width - textSize.width) / 2,
            y: (bounds.height - textSize.height) / 2,
            width: textSize.width,
            height: textSize.height
        )
        
        context.saveGState()
        context.translateBy(x: 0, y: bounds.height)
        context.scaleBy(x: 1, y: -1)
        
        let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: cosmicTheme.textGradientColors as CFArray, locations: [0, 1])!
        
        let rendererContext = CGContext(data: nil, width: Int(bounds.width), height: Int(bounds.height),
                                        bitsPerComponent: 8, bytesPerRow: 0,
                                        space: CGColorSpaceCreateDeviceRGB(),
                                        bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
        
        UIGraphicsPushContext(rendererContext)
        attributed.draw(in: textRect)
        UIGraphicsPopContext()
        
        if let mask = rendererContext.makeImage() {
            context.clip(to: bounds, mask: mask)
            context.drawLinearGradient(
                gradient,
                start: CGPoint(x: bounds.width / 2, y: bounds.height),
                end: CGPoint(x: bounds.width / 2, y: 0),
                options: []
            )
        }
        
        context.setShadow(offset: CGSize(width: 0, height: -2), blur: 4, color: UIColor.black.withAlphaComponent(0.5).cgColor)
        
        context.restoreGState()
    }
    
    func animateTextChange(newText: String) {
        UIView.transition(with: self, duration: 0.25, options: .transitionCrossDissolve) {
            self.text = newText
            self.setNeedsDisplay()
        }
    }
    
    func activateHighlight() {
        UIView.animate(withDuration: 0.15, animations: {
            self.glowLayer.shadowRadius = 28
            self.glowLayer.shadowOpacity = 1
            self.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
        }) { _ in
            UIView.animate(withDuration: 0.15) {
                self.glowLayer.shadowRadius = 20
                self.glowLayer.shadowOpacity = 0.7
                self.transform = .identity
            }
        }
    }
}
