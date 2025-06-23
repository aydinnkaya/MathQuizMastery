////
////  QuestionCountLabel.swift
////  MathQuizMastery
////
////  Created by Aydın KAYA on 23.06.2025.
////
//
//import UIKit
//
//class QuestionCountLabel: UILabel {
//
//    private let backgroundGradient = CAGradientLayer()
//    private let borderGradient = CAGradientLayer()
//    private let borderMaskLayer = CAShapeLayer()
//    private let glowLayer = CALayer()
//
//    @objc enum CosmicTheme: Int {
//        case questionNumber, score, timer
//
//        var backgroundColors: [CGColor] {
//            switch self {
//            case .questionNumber:
//                return [
//                    UIColor(red: 0.4, green: 0.0, blue: 0.6, alpha: 0.4).cgColor,
//                    UIColor(red: 0.15, green: 0.0, blue: 0.4, alpha: 0.6).cgColor
//                ]
//            case .score:
//                return [
//                    UIColor(red: 0.20, green: 0.02, blue: 0.4, alpha: 1).cgColor,
//                    UIColor(red: 0.08, green: 0.0, blue: 0.25, alpha: 1).cgColor
//                ]
//            case .timer:
//                return [
//                    UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.4).cgColor,
//                    UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.6).cgColor
//                ]
//            }
//        }
//
//        var borderColors: [CGColor] {
//            switch self {
//            case .questionNumber:
//                return [
//                    UIColor(red: 1.0, green: 0.4, blue: 1.0, alpha: 1).cgColor,
//                    UIColor(red: 0.8, green: 0.1, blue: 1.0, alpha: 1).cgColor
//                ]
//            case .score:
//                return [
//                    UIColor(red: 1.0, green: 0.65, blue: 0.2, alpha: 1).cgColor,
//                    UIColor(red: 1.0, green: 0.25, blue: 0.05, alpha: 1).cgColor
//                ]
//            case .timer:
//                return [
//                    UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 0.6).cgColor,
//                    UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 0.4).cgColor
//                ]
//            }
//        }
//
//        var glowColor: CGColor {
//            switch self {
//            case .questionNumber:
//                return UIColor(red: 1.0, green: 0.4, blue: 1.0, alpha: 1).cgColor
//            case .score:
//                return UIColor(red: 1, green: 0.4, blue: 0.0, alpha: 1).cgColor
//            case .timer:
//                return UIColor.gray.cgColor
//            }
//        }
//    }
//
//    var cosmicTheme: CosmicTheme = .questionNumber {
//        didSet {
//            updateTheme()
//        }
//    }
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupUI()
//        updateTheme()
//    }
//
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        setupUI()
//        updateTheme()
//    }
//
//    private func setupUI() {
//        clipsToBounds = false
//        backgroundColor = .clear
//        textColor = .clear
//        layer.cornerRadius = 16
//        layer.masksToBounds = false
//
//        backgroundGradient.cornerRadius = 16
//        backgroundGradient.startPoint = CGPoint(x: 0, y: 0)
//        backgroundGradient.endPoint = CGPoint(x: 1, y: 1)
//        layer.insertSublayer(backgroundGradient, at: 0)
//
//        glowLayer.shadowOffset = .zero
//        glowLayer.shadowRadius = 14
//        glowLayer.shadowOpacity = 1.0
//        glowLayer.backgroundColor = UIColor.clear.cgColor
//        glowLayer.cornerRadius = 16
//        layer.insertSublayer(glowLayer, below: backgroundGradient)
//
//        borderGradient.startPoint = CGPoint(x: 0, y: 0)
//        borderGradient.endPoint = CGPoint(x: 1, y: 1)
//        borderGradient.mask = borderMaskLayer
//        layer.addSublayer(borderGradient)
//
//        borderMaskLayer.lineWidth = 2.5
//        borderMaskLayer.lineJoin = .round
//        borderMaskLayer.lineCap = .round
//        borderMaskLayer.strokeColor = UIColor.white.cgColor
//        borderMaskLayer.fillColor = UIColor.clear.cgColor
//
//        textAlignment = .center
//        adjustsFontSizeToFitWidth = true
//        minimumScaleFactor = 0.7
//        numberOfLines = 1
//        font = UIFont.boldSystemFont(ofSize: 18)
//    }
//
//    private func updateTheme() {
//        backgroundGradient.colors = cosmicTheme.backgroundColors
//        borderGradient.colors = cosmicTheme.borderColors
//        glowLayer.shadowColor = cosmicTheme.glowColor
//        setNeedsDisplay()
//    }
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//        backgroundGradient.frame = bounds
//        glowLayer.frame = bounds
//        borderGradient.frame = bounds
//        borderMaskLayer.frame = bounds
//
//        let path = UIBezierPath(roundedRect: bounds.insetBy(dx: 1.2, dy: 1.2), cornerRadius: 16)
//        borderMaskLayer.path = path.cgPath
//    }
//
//    override func drawText(in rect: CGRect) {
//        guard let context = UIGraphicsGetCurrentContext(), let text = text, let font = self.font else { return }
//        guard bounds.width > 0, bounds.height > 0 else { return }
//
//        let paragraph = NSMutableParagraphStyle()
//        paragraph.alignment = .center
//        let attributes: [NSAttributedString.Key: Any] = [
//            .font: font,
//            .paragraphStyle: paragraph
//        ]
//
//        let attributed = NSAttributedString(string: text, attributes: attributes)
//        let textSize = attributed.size()
//        let textRect = CGRect(
//            x: (bounds.width - textSize.width) / 2,
//            y: (bounds.height - textSize.height) / 2,
//            width: textSize.width,
//            height: textSize.height
//        )
//
//        context.saveGState()
//        context.translateBy(x: 0, y: bounds.height)
//        context.scaleBy(x: 1, y: -1)
//
//        let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: [
//            UIColor(red: 1.0, green: 0.7, blue: 0.2, alpha: 1).cgColor,
//            UIColor(red: 1.0, green: 0.4, blue: 0.0, alpha: 1).cgColor
//        ] as CFArray, locations: [0, 1])!
//
//        let rendererContext = CGContext(data: nil,
//                                        width: Int(bounds.width),
//                                        height: Int(bounds.height),
//                                        bitsPerComponent: 8,
//                                        bytesPerRow: 0,
//                                        space: CGColorSpaceCreateDeviceRGB(),
//                                        bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
//
//        UIGraphicsPushContext(rendererContext)
//        attributed.draw(in: textRect)
//        UIGraphicsPopContext()
//
//        if let mask = rendererContext.makeImage() {
//            context.clip(to: bounds, mask: mask)
//            context.drawLinearGradient(gradient, start: .zero, end: CGPoint(x: bounds.width, y: bounds.height), options: [])
//        }
//
//        context.restoreGState()
//    }
//
//    func animateTextChange(newText: String) {
//        UIView.transition(with: self, duration: 0.25, options: .transitionCrossDissolve) {
//            self.text = newText
//            self.setNeedsDisplay()
//        }
//    }
//
//    func activateHighlight() {
//        UIView.animate(withDuration: 0.15, animations: {
//            self.glowLayer.shadowRadius = 20
//            self.glowLayer.shadowOpacity = 1
//            self.transform = CGAffineTransform(scaleX: 1.04, y: 1.04)
//        }) { _ in
//            UIView.animate(withDuration: 0.15) {
//                self.glowLayer.shadowRadius = 14
//                self.glowLayer.shadowOpacity = 0.7
//                self.transform = .identity
//            }
//        }
//    }
//}
