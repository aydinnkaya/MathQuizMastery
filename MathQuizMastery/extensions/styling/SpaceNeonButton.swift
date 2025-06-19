//
//  SpaceNeonButton.swift
//  MathQuizMastery
//
//  Created by AydınKaya on 19.06.2025.
//
//

import UIKit

class SpaceNeonButton: UIButton {
    
    private let starFieldLayer = CAEmitterLayer()
    private let primaryGradientLayer = CAGradientLayer()
    private let secondaryGradientLayer = CAGradientLayer()
    private let tertiaryGradientLayer = CAGradientLayer()
    private let hologramLayer = CAGradientLayer()
    private let quantumGlowLayer = CALayer()
    private let pulsatingRingLayer = CAShapeLayer()
    private let energyFieldLayer = CAShapeLayer()
    private let particleSystemLayer = CAEmitterLayer()
    private let crystalReflectionLayer = CAGradientLayer()
    
    private var isAnimating = false
    private var quantumPulseTimer: Timer?
    
    var spaceColors: [UIColor] = [
        UIColor(red: 0.1, green: 0.9, blue: 1.0, alpha: 1.0),    // Quantum Cyan
        UIColor(red: 0.8, green: 0.2, blue: 1.0, alpha: 1.0),   // Cosmic Purple
        UIColor(red: 0.0, green: 0.8, blue: 0.9, alpha: 1.0),   // Nebula Blue
        UIColor(red: 1.0, green: 0.4, blue: 0.8, alpha: 1.0),   // Stellar Pink
        UIColor(red: 0.4, green: 1.0, blue: 0.6, alpha: 1.0)    // Aurora Green
    ] {
        didSet {
            updateSpaceDesign()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSpaceLayers()
        startQuantumAnimation()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSpaceLayers()
        startQuantumAnimation()
    }
    
    private func setupSpaceLayers() {
        layer.cornerRadius = 24
        clipsToBounds = false
        backgroundColor = UIColor.black.withAlphaComponent(0.2)
        
        // 1. Quantum Glow Foundation
        quantumGlowLayer.backgroundColor = UIColor.clear.cgColor
        quantumGlowLayer.shadowColor = spaceColors[0].cgColor
        quantumGlowLayer.shadowRadius = 25
        quantumGlowLayer.shadowOpacity = 0.8
        quantumGlowLayer.shadowOffset = .zero
        quantumGlowLayer.cornerRadius = 24
        layer.insertSublayer(quantumGlowLayer, at: 0)
        
        // 2. Star Field Background
        setupStarField()
        
        // 3. Primary Holographic Gradient
        primaryGradientLayer.colors = [
            spaceColors[0].withAlphaComponent(0.3).cgColor,
            spaceColors[1].withAlphaComponent(0.2).cgColor,
            spaceColors[2].withAlphaComponent(0.3).cgColor
        ]
        primaryGradientLayer.locations = [0.0, 0.5, 1.0]
        primaryGradientLayer.startPoint = CGPoint(x: 0, y: 0)
        primaryGradientLayer.endPoint = CGPoint(x: 1, y: 1)
        primaryGradientLayer.cornerRadius = 24
        layer.insertSublayer(primaryGradientLayer, above: starFieldLayer)
        
        // 4. Secondary Energy Layer
        secondaryGradientLayer.colors = [
            UIColor.clear.cgColor,
            spaceColors[3].withAlphaComponent(0.15).cgColor,
            UIColor.clear.cgColor
        ]
        secondaryGradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        secondaryGradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        secondaryGradientLayer.cornerRadius = 24
        layer.insertSublayer(secondaryGradientLayer, above: primaryGradientLayer)
        
        // 5. Crystal Reflection Effect
        crystalReflectionLayer.colors = [
            UIColor.white.withAlphaComponent(0.4).cgColor,
            UIColor.clear.cgColor,
            UIColor.white.withAlphaComponent(0.1).cgColor
        ]
        crystalReflectionLayer.locations = [0.0, 0.3, 1.0]
        crystalReflectionLayer.startPoint = CGPoint(x: 0, y: 0)
        crystalReflectionLayer.endPoint = CGPoint(x: 0.3, y: 0.8)
        crystalReflectionLayer.cornerRadius = 24
        layer.insertSublayer(crystalReflectionLayer, above: secondaryGradientLayer)
        
        // 6. Pulsating Ring Effect
        pulsatingRingLayer.fillColor = UIColor.clear.cgColor
        pulsatingRingLayer.strokeColor = spaceColors[0].cgColor
        pulsatingRingLayer.lineWidth = 3
        pulsatingRingLayer.shadowColor = spaceColors[0].cgColor
        pulsatingRingLayer.shadowRadius = 15
        pulsatingRingLayer.shadowOpacity = 1.0
        pulsatingRingLayer.shadowOffset = .zero
        layer.addSublayer(pulsatingRingLayer)
        
        // 7. Energy Field Border
        energyFieldLayer.fillColor = UIColor.clear.cgColor
        energyFieldLayer.strokeColor = spaceColors[1].cgColor
        energyFieldLayer.lineWidth = 2
        energyFieldLayer.shadowColor = spaceColors[1].cgColor
        energyFieldLayer.shadowRadius = 10
        energyFieldLayer.shadowOpacity = 0.8
        energyFieldLayer.shadowOffset = .zero
        layer.addSublayer(energyFieldLayer)
        
        // 8. Particle System
        setupParticleSystem()
        
        // Text Styling
        setTitleColor(.white, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .black)
        titleLabel?.layer.shadowColor = spaceColors[0].cgColor
        titleLabel?.layer.shadowRadius = 8
        titleLabel?.layer.shadowOpacity = 1.0
        titleLabel?.layer.shadowOffset = .zero
    }
    
    private func setupStarField() {
        starFieldLayer.emitterPosition = CGPoint(x: 0, y: 0)
        starFieldLayer.emitterSize = CGSize(width: 300, height: 200)
        starFieldLayer.renderMode = .additive
        
        let starCell = CAEmitterCell()
        starCell.contents = createStarImage().cgImage
        starCell.birthRate = 15
        starCell.lifetime = 8.0
        starCell.velocity = 20
        starCell.velocityRange = 15
        starCell.emissionRange = .pi * 2
        starCell.scale = 0.1
        starCell.scaleRange = 0.05
        starCell.alphaSpeed = -0.1
        starCell.color = spaceColors[0].cgColor
        
        starFieldLayer.emitterCells = [starCell]
        layer.insertSublayer(starFieldLayer, at: 0)
    }
    
    private func setupParticleSystem() {
        particleSystemLayer.emitterPosition = CGPoint(x: 150, y: 25)
        particleSystemLayer.emitterSize = CGSize(width: 300, height: 50)
        particleSystemLayer.renderMode = .additive
        
        let energyParticle = CAEmitterCell()
        energyParticle.contents = createEnergyParticle().cgImage
        energyParticle.birthRate = 25
        energyParticle.lifetime = 3.0
        energyParticle.velocity = 30
        energyParticle.velocityRange = 20
        energyParticle.emissionRange = .pi / 4
        energyParticle.scale = 0.05
        energyParticle.scaleRange = 0.03
        energyParticle.alphaSpeed = -0.3
        energyParticle.color = spaceColors[2].cgColor
        
        particleSystemLayer.emitterCells = [energyParticle]
        layer.addSublayer(particleSystemLayer)
    }
    
    private func createStarImage() -> UIImage {
        let size = CGSize(width: 10, height: 10)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let context = UIGraphicsGetCurrentContext()!
        
        context.setFillColor(UIColor.white.cgColor)
        context.fillEllipse(in: CGRect(origin: .zero, size: size))
        
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
    private func createEnergyParticle() -> UIImage {
        let size = CGSize(width: 6, height: 6)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let context = UIGraphicsGetCurrentContext()!
        
        let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(),
                                 colors: [UIColor.white.cgColor, UIColor.cyan.cgColor] as CFArray,
                                 locations: [0.0, 1.0])!
        
        context.drawRadialGradient(gradient,
                                 startCenter: CGPoint(x: 3, y: 3), startRadius: 0,
                                 endCenter: CGPoint(x: 3, y: 3), endRadius: 3,
                                 options: [])
        
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
    private func updateSpaceDesign() {
        primaryGradientLayer.colors = [
            spaceColors[0].withAlphaComponent(0.3).cgColor,
            spaceColors[1].withAlphaComponent(0.2).cgColor,
            spaceColors[2].withAlphaComponent(0.3).cgColor
        ]
        
        quantumGlowLayer.shadowColor = spaceColors[0].cgColor
        pulsatingRingLayer.strokeColor = spaceColors[0].cgColor
        pulsatingRingLayer.shadowColor = spaceColors[0].cgColor
        energyFieldLayer.strokeColor = spaceColors[1].cgColor
        energyFieldLayer.shadowColor = spaceColors[1].cgColor
    }
    
    private func startQuantumAnimation() {
        quantumPulseTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            self.animateQuantumPulse()
            self.animateEnergyFlow()
        }
    }
    
    private func animateQuantumPulse() {
        let pulseAnimation = CABasicAnimation(keyPath: "transform.scale")
        pulseAnimation.fromValue = 1.0
        pulseAnimation.toValue = 1.05
        pulseAnimation.duration = 2.0
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = .infinity
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        quantumGlowLayer.add(pulseAnimation, forKey: "quantumPulse")
    }
    
    private func animateEnergyFlow() {
        let colorAnimation = CAKeyframeAnimation(keyPath: "strokeColor")
        colorAnimation.values = spaceColors.map { $0.cgColor }
        colorAnimation.duration = 4.0
        colorAnimation.repeatCount = .infinity
        colorAnimation.autoreverses = true
        
        pulsatingRingLayer.add(colorAnimation, forKey: "energyFlow")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        starFieldLayer.frame = bounds
        starFieldLayer.emitterPosition = CGPoint(x: bounds.midX, y: bounds.midY)
        
        primaryGradientLayer.frame = bounds
        secondaryGradientLayer.frame = bounds
        crystalReflectionLayer.frame = bounds
        quantumGlowLayer.frame = bounds
        
        let ringPath = UIBezierPath(roundedRect: bounds.insetBy(dx: 2, dy: 2), cornerRadius: 22)
        pulsatingRingLayer.path = ringPath.cgPath
        
        let energyPath = UIBezierPath(roundedRect: bounds.insetBy(dx: 1, dy: 1), cornerRadius: 23)
        energyFieldLayer.path = energyPath.cgPath
        
        particleSystemLayer.emitterPosition = CGPoint(x: bounds.midX, y: bounds.minY)
    }
    
    // Touch Effects
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        animateQuantumTouch()
    }
    
    private func animateQuantumTouch() {
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = 1.0
        scaleAnimation.toValue = 0.95
        scaleAnimation.duration = 0.1
        scaleAnimation.autoreverses = true
        
        let glowAnimation = CABasicAnimation(keyPath: "shadowRadius")
        glowAnimation.fromValue = 25
        glowAnimation.toValue = 35
        glowAnimation.duration = 0.1
        glowAnimation.autoreverses = true
        
        layer.add(scaleAnimation, forKey: "touchScale")
        quantumGlowLayer.add(glowAnimation, forKey: "touchGlow")
    }
    
    func triggerQuantumExplosion() {
        let explosionLayer = CAEmitterLayer()
        explosionLayer.emitterPosition = CGPoint(x: bounds.midX, y: bounds.midY)
        explosionLayer.renderMode = .additive
        
        let explosionCell = CAEmitterCell()
        explosionCell.contents = createEnergyParticle().cgImage
        explosionCell.birthRate = 100
        explosionCell.lifetime = 1.0
        explosionCell.velocity = 100
        explosionCell.velocityRange = 50
        explosionCell.emissionRange = .pi * 2
        explosionCell.scale = 0.1
        explosionCell.scaleRange = 0.05
        explosionCell.alphaSpeed = -1.0
        
        explosionLayer.emitterCells = [explosionCell]
        layer.addSublayer(explosionLayer)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            explosionLayer.removeFromSuperlayer()
        }
    }
    
    deinit {
        quantumPulseTimer?.invalidate()
    }
}
