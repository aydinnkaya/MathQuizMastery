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
    private let glowView = UIView()
    
    private let textGradientLayer = CAGradientLayer()
    private let textMaskLayer = CATextLayer()
    
    private let gradientTextColors: [CGColor] = UIColor.Custom.answerTextGradient.map { $0.cgColor }
    
    @objc enum CosmicTheme: Int {
        case score = 0, questionNumber, timer
        
        var backgroundColors: [CGColor] {
            switch self {
            case .score:
                return UIColor.Custom.infoScoreBackground
            case .questionNumber:
                return UIColor.Custom.infoQuestionBackground
            case .timer:
                return UIColor.Custom.infoTimerBackground
            }
        }
        
        var borderColors: [CGColor] {
            switch self {
            case .score:
                return UIColor.Custom.infoScoreBorder
            case .questionNumber:
                return UIColor.Custom.infoQuestionBorder
            case .timer:
                return UIColor.Custom.infoTimerBorder
            }
        }
        
        var glowColor: UIColor {
            switch self {
            case .score:
                return UIColor.Custom.infoScoreGlow
            case .questionNumber:
                return UIColor.Custom.infoQuestionGlow
            case .timer:
                return UIColor.Custom.infoTimerGlow
            }
        }
        
        var useGradientText: Bool {
            return self == .score || self == .questionNumber
        }
        
        var solidTextColor: UIColor {
            switch self {
            case .timer:
                return .white
            default:
                return .clear
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
        backgroundColor = .clear
        clipsToBounds = false
        layer.cornerRadius = 20
        layer.masksToBounds = false
        
        glowView.layer.cornerRadius = 20
        glowView.layer.shadowOffset = .zero
        glowView.layer.shadowRadius = 30
        glowView.layer.shadowOpacity = 1.0
        glowView.backgroundColor = .clear
        insertSubview(glowView, at: 0)
        
        backgroundGradient.cornerRadius = 20
        layer.insertSublayer(backgroundGradient, at: 0)
        
        borderGradient.mask = borderMaskLayer
        layer.insertSublayer(borderGradient, above: backgroundGradient)
        borderMaskLayer.lineWidth = 4
        borderMaskLayer.lineJoin = .round
        borderMaskLayer.lineCap = .round
        borderMaskLayer.strokeColor = UIColor.white.cgColor
        borderMaskLayer.fillColor = UIColor.clear.cgColor
        
        textGradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        textGradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        textGradientLayer.colors = gradientTextColors
        layer.addSublayer(textGradientLayer)
        textGradientLayer.mask = textMaskLayer
        
        textMaskLayer.alignmentMode = .center
        textMaskLayer.contentsScale = UIScreen.main.scale
        textMaskLayer.truncationMode = .end
        
        textAlignment = .center
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.6
        numberOfLines = 1
        font = UIFont.systemFont(ofSize: 24, weight: .black)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        glowView.frame = bounds
        backgroundGradient.frame = bounds
        borderGradient.frame = bounds
        borderMaskLayer.frame = bounds
        textGradientLayer.frame = bounds
        
        let textHeight = font.lineHeight
        let yOffset = (bounds.height - textHeight) / 2
        textMaskLayer.frame = CGRect(x: 0, y: yOffset, width: bounds.width, height: textHeight)
        
        textMaskLayer.string = text ?? ""
        textMaskLayer.font = font
        textMaskLayer.fontSize = font.pointSize
        
        let path = UIBezierPath(roundedRect: bounds.insetBy(dx: 1.5, dy: 1.5), cornerRadius: 20)
        borderMaskLayer.path = path.cgPath
    }
    
    private func updateTheme() {
        backgroundGradient.colors = cosmicTheme.backgroundColors
        borderGradient.colors = cosmicTheme.borderColors
        glowView.layer.shadowColor = cosmicTheme.glowColor.cgColor
        textGradientLayer.isHidden = !cosmicTheme.useGradientText
        textColor = cosmicTheme.solidTextColor
        setNeedsDisplay()
    }
    
    func animateTextChange(newText: String) {
        UIView.transition(with: self, duration: 0.25, options: .transitionCrossDissolve) {
            self.text = newText
            self.textMaskLayer.string = newText
        }
    }
    
    func activateHighlight() {
        UIView.animate(withDuration: 0.15, animations: {
            self.glowView.layer.shadowRadius = 36
            self.glowView.layer.shadowOpacity = 1
            self.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
        }) { _ in
            UIView.animate(withDuration: 0.15) {
                self.glowView.layer.shadowRadius = 28
                self.glowView.layer.shadowOpacity = 0.8
                self.transform = .identity
            }
        }
    }
}
