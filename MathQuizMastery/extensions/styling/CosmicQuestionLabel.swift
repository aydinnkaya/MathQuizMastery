//
//  CosmicQuestionLabel.swift
//  MathQuizMastery
//
//  Created by AydınKaya on 19.06.2025.
//

import UIKit

class CosmicQuestionLabel: UILabel {
    
    private let galaxyBackgroundLayer = CAGradientLayer()
    private let nebulaLayer = CAGradientLayer()
    private let starDustLayer = CAEmitterLayer()
    private let hologramBorderLayer = CAShapeLayer()
    private let energyPulseLayer = CAShapeLayer()
    private let quantumFieldLayer = CALayer()
    private let cosmicRingLayer = CAShapeLayer()
    private let dimensionalGlowLayer = CALayer()
    
    private var cosmicTimer: Timer?
    private var lastSize: CGSize = .zero
    
    var cosmicColors: [CGColor] = [
        UIColor(red: 0.05, green: 0.1, blue: 0.3, alpha: 0.9).cgColor,    // Deep Space
        UIColor(red: 0.1, green: 0.2, blue: 0.6, alpha: 0.8).cgColor,     // Cosmic Blue
        UIColor(red: 0.2, green: 0.0, blue: 0.4, alpha: 0.7).cgColor,     // Void Purple
        UIColor(red: 0.0, green: 0.3, blue: 0.5, alpha: 0.8).cgColor,     // Nebula Teal
        UIColor(red: 0.15, green: 0.05, blue: 0.35, alpha: 0.9).cgColor   // Galaxy Purple
    ] {
        didSet {
            updateCosmicStyle()
        }
    }
    
    var borderColors: [CGColor] = [
        UIColor(red: 0.0, green: 0.9, blue: 1.0, alpha: 1.0).cgColor,     // Quantum Cyan
        UIColor(red: 0.8, green: 0.3, blue: 1.0, alpha: 1.0).cgColor,     // Cosmic Purple
        UIColor(red: 1.0, green: 0.5, blue: 0.8, alpha: 1.0).cgColor,     // Stellar Pink
        UIColor(red: 0.3, green: 1.0, blue: 0.6, alpha: 1.0).cgColor      // Aurora Green
    ]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCosmicLayers()
        startCosmicAnimation()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCosmicLayers()
        startCosmicAnimation()
    }
    
    private func setupCosmicLayers() {
        clipsToBounds = false
        layer.masksToBounds = false
        
        // 1. Dimensional Glow Foundation
        dimensionalGlowLayer.backgroundColor = UIColor.clear.cgColor
        dimensionalGlowLayer.shadowColor = UIColor(red: 0.0, green: 0.8, blue: 1.0, alpha: 1.0).cgColor
        dimensionalGlowLayer.shadowRadius = 30
        dimensionalGlowLayer.shadowOpacity = 0.8
        dimensionalGlowLayer.shadowOffset = .zero
        dimensionalGlowLayer.cornerRadius = 20
        layer.insertSublayer(dimensionalGlowLayer, at: 0)
        
        // 2. Galaxy Background
        galaxyBackgroundLayer.colors = cosmicColors
        galaxyBackgroundLayer.locations = [0.0, 0.3, 0.6, 0.8, 1.0]
        galaxyBackgroundLayer.startPoint = CGPoint(x: 0, y: 0)
        galaxyBackgroundLayer.endPoint = CGPoint(x: 1, y: 1)
        galaxyBackgroundLayer.cornerRadius = 20
        layer.insertSublayer(galaxyBackgroundLayer, above: dimensionalGlowLayer)
        
        // 3. Nebula Effect
        nebulaLayer.colors = [
            UIColor.clear.cgColor,
            UIColor(red: 0.6, green: 0.2, blue: 0.8, alpha: 0.3).cgColor,
            UIColor(red: 0.2, green: 0.7, blue: 0.9, alpha: 0.2).cgColor,
            UIColor.clear.cgColor
        ]
        nebulaLayer.locations = [0.0, 0.3, 0.7, 1.0]
        nebulaLayer.startPoint = CGPoint(x: 0, y: 0.5)
        nebulaLayer.endPoint = CGPoint(x: 1, y: 0.5)
        nebulaLayer.cornerRadius = 20
        layer.insertSublayer(nebulaLayer, above: galaxyBackgroundLayer)
        
        // 4. Quantum Field
        quantumFieldLayer.backgroundColor = UIColor.white.withAlphaComponent(0.05).cgColor
        quantumFieldLayer.cornerRadius = 20
        quantumFieldLayer.borderWidth = 1
        quantumFieldLayer.borderColor = UIColor.white.withAlphaComponent(0.2).cgColor
        layer.insertSublayer(quantumFieldLayer, above: nebulaLayer)
        
        // 5. Star Dust Particles
        setupStarDust()
        
        // 6. Hologram Border
        hologramBorderLayer.fillColor = UIColor.clear.cgColor
        hologramBorderLayer.lineWidth = 3
        hologramBorderLayer.shadowRadius = 15
        hologramBorderLayer.shadowOpacity = 1.0
        hologramBorderLayer.shadowOffset = .zero
        layer.addSublayer(hologramBorderLayer)
        
        // 7. Energy Pulse Ring
        energyPulseLayer.fillColor = UIColor.clear.cgColor
        energyPulseLayer.lineWidth = 2
        energyPulseLayer.shadowRadius = 10
        energyPulseLayer.shadowOpacity = 0.8
        energyPulseLayer.shadowOffset = .zero
        layer.addSublayer(energyPulseLayer)
        
        // 8. Cosmic Ring Effect
        cosmicRingLayer.fillColor = UIColor.clear.cgColor
        cosmicRingLayer.lineWidth = 1
        cosmicRingLayer.opacity = 0.6
        layer.addSublayer(cosmicRingLayer)
        
        // Text Styling
        textAlignment = .center
        textColor = .white
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.5
        numberOfLines = 1
        
        // Text Shadow Effects
        layer.shadowColor = UIColor(red: 0.0, green: 0.9, blue: 1.0, alpha: 1.0).cgColor
        layer.shadowRadius = 12
        layer.shadowOpacity = 0.8
        layer.shadowOffset = .zero
    }
    
    private func setupStarDust() {
        starDustLayer.emitterPosition = CGPoint(x: 200, y: 25)
        starDustLayer.emitterSize = CGSize(width: 400, height: 50)
        starDustLayer.renderMode = .additive
        
        let dustParticle = CAEmitterCell()
        dustParticle.contents = createStarDustParticle().cgImage
        dustParticle.birthRate = 20
        dustParticle.lifetime = 6.0
        dustParticle.velocity = 15
        dustParticle.velocityRange = 10
        dustParticle.emissionRange = .pi / 6
        dustParticle.scale = 0.02
        dustParticle.scaleRange = 0.015
        dustParticle.alphaSpeed = -0.15
        dustParticle.color = UIColor(red: 0.8, green: 0.9, blue: 1.0, alpha: 1.0).cgColor
        
        starDustLayer.emitterCells = [dustParticle]
        layer.insertSublayer(starDustLayer, above: quantumFieldLayer)
    }
    
    private func createStarDustParticle() -> UIImage {
        let size = CGSize(width: 4, height: 4)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let context = UIGraphicsGetCurrentContext()!
        
        let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(),
                                 colors: [UIColor.white.cgColor, UIColor.clear.cgColor] as CFArray,
                                 locations: [0.0, 1.0])!
        
        context.drawRadialGradient(gradient,
                                 startCenter: CGPoint(x: 2, y: 2), startRadius: 0,
                                 endCenter: CGPoint(x: 2, y: 2), endRadius: 2,
                                 options: [])
        
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
    private func updateCosmicStyle() {
        galaxyBackgroundLayer.colors = cosmicColors
        
        let currentBorderColor = borderColors.randomElement() ?? borderColors[0]
        hologramBorderLayer.strokeColor = currentBorderColor
        hologramBorderLayer.shadowColor = currentBorderColor
        
        let currentPulseColor = borderColors.randomElement() ?? borderColors[1]
        energyPulseLayer.strokeColor = currentPulseColor
        energyPulseLayer.shadowColor = currentPulseColor
    }
    
    private func startCosmicAnimation() {
        cosmicTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            self.animateGalaxyRotation()
            self.animateEnergyPulse()
            self.animateCosmicBorder()
        }
    }
    
    private func animateGalaxyRotation() {
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation.fromValue = 0
        rotationAnimation.toValue = Float.pi * 2
        rotationAnimation.duration = 20.0
        rotationAnimation.repeatCount = .infinity
        
        galaxyBackgroundLayer.add(rotationAnimation, forKey: "galaxyRotation")
    }
    
    private func animateEnergyPulse() {
        let pulseAnimation = CABasicAnimation(keyPath: "opacity")
        pulseAnimation.fromValue = 0.3
        pulseAnimation.toValue = 1.0
        pulseAnimation.duration = 2.0
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = .infinity
        
        energyPulseLayer.add(pulseAnimation, forKey: "energyPulse")
    }
    
    private func animateCosmicBorder() {
        let borderAnimation = CAKeyframeAnimation(keyPath: "strokeColor")
        borderAnimation.values = borderColors
        borderAnimation.duration = 3.0
        borderAnimation.repeatCount = .infinity
        borderAnimation.autoreverses = true
        
        hologramBorderLayer.add(borderAnimation, forKey: "cosmicBorder")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard bounds.size != lastSize else { return }
        lastSize = bounds.size
        
        // Update all layer frames
        galaxyBackgroundLayer.frame = bounds
        nebulaLayer.frame = bounds
        quantumFieldLayer.frame = bounds
        dimensionalGlowLayer.frame = bounds
        
        starDustLayer.frame = bounds
        starDustLayer.emitterPosition = CGPoint(x: bounds.midX, y: bounds.minY)
        
        // Create paths for border layers
        let borderPath = UIBezierPath(roundedRect: bounds, cornerRadius: 20)
        hologramBorderLayer.path = borderPath.cgPath
        
        let pulsePath = UIBezierPath(roundedRect: bounds.insetBy(dx: 2, dy: 2), cornerRadius: 18)
        energyPulseLayer.path = pulsePath.cgPath
        
        let ringPath = UIBezierPath(roundedRect: bounds.insetBy(dx: 4, dy: 4), cornerRadius: 16)
        cosmicRingLayer.path = ringPath.cgPath
        cosmicRingLayer.strokeColor = UIColor.white.withAlphaComponent(0.3).cgColor
        
        // Optimal font sizing
        let optimalFontSize = bounds.height * 0.4
        font = UIFont.systemFont(ofSize: optimalFontSize, weight: .black)
    }
    
    func animateTextChange(newText: String) {
        // Quantum text transition effect
        let transition = CATransition()
        transition.type = .fade
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        layer.add(transition, forKey: "textTransition")
        
        // Trigger cosmic explosion effect
        triggerCosmicExplosion()
        
        text = newText
    }
    
     func triggerCosmicExplosion() {
        let explosionLayer = CAEmitterLayer()
        explosionLayer.emitterPosition = CGPoint(x: bounds.midX, y: bounds.midY)
        explosionLayer.renderMode = .additive
        
        let explosionCell = CAEmitterCell()
        explosionCell.contents = createStarDustParticle().cgImage
        explosionCell.birthRate = 150
        explosionCell.lifetime = 1.5
        explosionCell.velocity = 80
        explosionCell.velocityRange = 40
        explosionCell.emissionRange = .pi * 2
        explosionCell.scale = 0.08
        explosionCell.scaleRange = 0.04
        explosionCell.alphaSpeed = -0.8
        explosionCell.color = UIColor(red: 0.0, green: 0.9, blue: 1.0, alpha: 1.0).cgColor
        
        explosionLayer.emitterCells = [explosionCell]
        layer.addSublayer(explosionLayer)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            explosionLayer.removeFromSuperlayer()
        }
    }
    
    deinit {
        cosmicTimer?.invalidate()
    }
}
