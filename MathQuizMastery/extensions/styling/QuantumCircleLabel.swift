//
//  QuantumCircleLabel.swift
//  MathQuizMastery
//
//  Created by AydınKaya on 19.06.2025.
//

import Foundation

class QuantumCircleLabel: UILabel {
    
    private let quantumCoreLayer = CAGradientLayer()
    private let energyRingLayer = CAShapeLayer()
    private let pulsatingAuraLayer = CAShapeLayer()
    private let particleOrbitLayer = CAEmitterLayer()
    private let holographicBorderLayer = CAShapeLayer()
    private let dimensionalGlowLayer = CALayer()
    private let starFieldLayer = CAEmitterLayer()
    private let plasmaEffectLayer = CAGradientLayer()
    private let timeWaveLayer = CAShapeLayer()
    
    private var quantumTimer: Timer?
    private var rotationTimer: Timer?
    private var hasBeenConfigured = false
    
    var quantumColors: [UIColor] = [
        UIColor(red: 0.0, green: 0.9, blue: 1.0, alpha: 1.0),    // Quantum Cyan
        UIColor(red: 0.2, green: 0.6, blue: 1.0, alpha: 1.0),   // Electric Blue
        UIColor(red: 0.6, green: 0.3, blue: 1.0, alpha: 1.0),   // Cosmic Purple
        UIColor(red: 0.9, green: 0.4, blue: 0.8, alpha: 1.0),   // Stellar Pink
        UIColor(red: 0.3, green: 1.0, blue: 0.7, alpha: 1.0)    // Aurora Green
    ] {
        didSet {
            if hasBeenConfigured {
                updateQuantumStyle()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupQuantumLayers()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupQuantumLayers()
    }
    
    private func setupQuantumLayers() {
        guard !hasBeenConfigured else { return }
        hasBeenConfigured = true
        
        clipsToBounds = false
        layer.masksToBounds = false
        
        // 1. Dimensional Glow Foundation
        dimensionalGlowLayer.backgroundColor = UIColor.clear.cgColor
        dimensionalGlowLayer.shadowColor = quantumColors[0].cgColor
        dimensionalGlowLayer.shadowRadius = 40
        dimensionalGlowLayer.shadowOpacity = 0.9
        dimensionalGlowLayer.shadowOffset = .zero
        layer.insertSublayer(dimensionalGlowLayer, at: 0)
        
        // 2. Star Field Background
        setupStarField()
        
        // 3. Quantum Core
        quantumCoreLayer.colors = [
            UIColor(red: 0.05, green: 0.1, blue: 0.2, alpha: 0.95).cgColor,
            UIColor(red: 0.1, green: 0.2, blue: 0.4, alpha: 0.9).cgColor,
            UIColor(red: 0.15, green: 0.3, blue: 0.6, alpha: 0.85).cgColor,
            UIColor(red: 0.05, green: 0.1, blue: 0.2, alpha: 0.95).cgColor
        ]
        quantumCoreLayer.locations = [0.0, 0.3, 0.7, 1.0]
        quantumCoreLayer.type = .radial
        quantumCoreLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
        quantumCoreLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        layer.insertSublayer(quantumCoreLayer, above: starFieldLayer)
        
        // 4. Plasma Effect
        plasmaEffectLayer.colors = [
            UIColor.clear.cgColor,
            quantumColors[0].withAlphaComponent(0.3).cgColor,
            quantumColors[1].withAlphaComponent(0.2).cgColor,
            UIColor.clear.cgColor
        ]
        plasmaEffectLayer.locations = [0.0, 0.4, 0.6, 1.0]
        plasmaEffectLayer.type = .radial
        plasmaEffectLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
        plasmaEffectLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        layer.insertSublayer(plasmaEffectLayer, above: quantumCoreLayer)
        
        // 5. Energy Ring (Outer)
        energyRingLayer.fillColor = UIColor.clear.cgColor
        energyRingLayer.strokeColor = quantumColors[0].cgColor
        energyRingLayer.lineWidth = 4
        energyRingLayer.shadowColor = quantumColors[0].cgColor
        energyRingLayer.shadowRadius = 20
        energyRingLayer.shadowOpacity = 1.0
        energyRingLayer.shadowOffset = .zero
        layer.addSublayer(energyRingLayer)
        
        // 6. Pulsating Aura (Middle)
        pulsatingAuraLayer.fillColor = UIColor.clear.cgColor
        pulsatingAuraLayer.strokeColor = quantumColors[1].cgColor
        pulsatingAuraLayer.lineWidth = 2
        pulsatingAuraLayer.shadowColor = quantumColors[1].cgColor
        pulsatingAuraLayer.shadowRadius = 15
        pulsatingAuraLayer.shadowOpacity = 0.8
        pulsatingAuraLayer.shadowOffset = .zero
        layer.addSublayer(pulsatingAuraLayer)
        
        // 7. Holographic Border (Inner)
        holographicBorderLayer.fillColor = UIColor.clear.cgColor
        holographicBorderLayer.strokeColor = quantumColors[2].withAlphaComponent(0.6).cgColor
        holographicBorderLayer.lineWidth = 1.5
        holographicBorderLayer.shadowColor = quantumColors[2].cgColor
        holographicBorderLayer.shadowRadius = 8
        holographicBorderLayer.shadowOpacity = 0.6
        holographicBorderLayer.shadowOffset = .zero
        layer.addSublayer(holographicBorderLayer)
        
        // 8. Time Wave Effect
        timeWaveLayer.fillColor = UIColor.clear.cgColor
        timeWaveLayer.strokeColor = UIColor.white.withAlphaComponent(0.4).cgColor
        timeWaveLayer.lineWidth = 1
        timeWaveLayer.lineDashPattern = [2, 4]
        layer.addSublayer(timeWaveLayer)
        
        // 9. Particle Orbit System
        setupParticleOrbit()
        
        // Text Styling
        textAlignment = .center
        textColor = .white
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.4
        
        // Text Effects
        layer.shadowColor = quantumColors[0].cgColor
        layer.shadowRadius = 12
        layer.shadowOpacity = 1.0
        layer.shadowOffset = .zero
        
        startQuantumAnimations()
    }
    
    private func setupStarField() {
        starFieldLayer.emitterPosition = CGPoint(x: 50, y: 50)
        starFieldLayer.emitterSize = CGSize(width: 100, height: 100)
        starFieldLayer.renderMode = .additive
        
        let starCell = CAEmitterCell()
        starCell.contents = createQuantumStar().cgImage
        starCell.birthRate = 8
        starCell.lifetime = 10.0
        starCell.velocity = 5
        starCell.velocityRange = 3
        starCell.emissionRange = .pi * 2
        starCell.scale = 0.05
        starCell.scaleRange = 0.03
        starCell.alphaSpeed = -0.1
        starCell.color = quantumColors[0].cgColor
        
        starFieldLayer.emitterCells = [starCell]
        layer.insertSublayer(starFieldLayer, at: 0)
    }
    
    private func setupParticleOrbit() {
        particleOrbitLayer.emitterPosition = CGPoint(x: 50, y: 50)
        particleOrbitLayer.emitterSize = CGSize(width: 2, height: 2)
        particleOrbitLayer.renderMode = .additive
        
        let orbitParticle = CAEmitterCell()
        orbitParticle.contents = createOrbitParticle().cgImage
        orbitParticle.birthRate = 12
        orbitParticle.lifetime = 4.0
        orbitParticle.velocity = 25
        orbitParticle.velocityRange = 5
        orbitParticle.emissionRange = .pi * 2
        orbitParticle.scale = 0.03
        orbitParticle.scaleRange = 0.02
        orbitParticle.alphaSpeed = -0.25
        orbitParticle.color = quantumColors[3].cgColor
        
        particleOrbitLayer.emitterCells = [orbitParticle]
        layer.addSublayer(particleOrbitLayer)
    }
    
    private func createQuantumStar() -> UIImage {
        let size = CGSize(width: 8, height: 8)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let context = UIGraphicsGetCurrentContext()!
        
        // Create star shape
        context.setFillColor(UIColor.white.cgColor)
        let center = CGPoint(x: 4, y: 4)
        context.move(to: CGPoint(x: center.x, y: center.y - 3))
        context.addLine(to: CGPoint(x: center.x + 1, y: center.y - 1))
        context.addLine(to: CGPoint(x: center.x + 3, y: center.y))
        context.addLine(to: CGPoint(x: center.x + 1, y: center.y + 1))
        context.addLine(to: CGPoint(x: center.x, y: center.y + 3))
        context.addLine(to: CGPoint(x: center.x - 1, y: center.y + 1))
        context.addLine(to: CGPoint(x: center.x - 3, y: center.y))
        context.addLine(to: CGPoint(x: center.x - 1, y: center.y - 1))
        context.closePath()
        context.fillPath()
        
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
    private func createOrbitParticle() -> UIImage {
        let size = CGSize(width: 6, height: 6)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let context = UIGraphicsGetCurrentContext()!
        
        let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(),
                                 colors: [quantumColors[3].cgColor, UIColor.clear.cgColor] as CFArray,
                                 locations: [0.0, 1.0])!
        
        context.drawRadialGradient(gradient,
                                 startCenter: CGPoint(x: 3, y: 3), startRadius: 0,
                                 endCenter: CGPoint(x: 3, y: 3), endRadius: 3,
                                 options: [])
        
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
    private func updateQuantumStyle() {
        energyRingLayer.strokeColor = quantumColors[0].cgColor
        energyRingLayer.shadowColor = quantumColors[0].cgColor
        
        pulsatingAuraLayer.strokeColor = quantumColors[1].cgColor
        pulsatingAuraLayer.shadowColor = quantumColors[1].cgColor
        
        holographicBorderLayer.strokeColor = quantumColors[2].withAlphaComponent(0.6).cgColor
        holographicBorderLayer.shadowColor = quantumColors[2].cgColor
        
        dimensionalGlowLayer.shadowColor = quantumColors[0].cgColor
        layer.shadowColor = quantumColors[0].cgColor
    }
    
    private func startQuantumAnimations() {
        // Quantum pulse animation
        quantumTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            self.animateQuantumPulse()
            self.animatePlasmaFlow()
        }
        
        // Rotation animation
        rotationTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { _ in
            self.animateParticleOrbit()
            self.animateTimeWave()
        }
    }
    
    private func animateQuantumPulse() {
        let pulseAnimation = CABasicAnimation(keyPath: "transform.scale")
        pulseAnimation.fromValue = 1.0
        pulseAnimation.toValue = 1.08
        pulseAnimation.duration = 1.5
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = .infinity
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        pulsatingAuraLayer.add(pulseAnimation, forKey: "quantumPulse")
    }
    
    private func animatePlasmaFlow() {
        let flowAnimation = CABasicAnimation(keyPath: "transform.rotation")
        flowAnimation.fromValue = 0
        flowAnimation.toValue = Float.pi * 2
        flowAnimation.duration = 8.0
        flowAnimation.repeatCount = .infinity
        
        plasmaEffectLayer.add(flowAnimation, forKey: "plasmaFlow")
    }
    
    private func animateParticleOrbit() {
        let orbitAnimation = CABasicAnimation(keyPath: "transform.rotation")
        orbitAnimation.fromValue = 0
        orbitAnimation.toValue = Float.pi * 2
        orbitAnimation.duration = 6.0
        orbitAnimation.repeatCount = .infinity
        
        particleOrbitLayer.add(orbitAnimation, forKey: "particleOrbit")
    }
    
    private func animateTimeWave() {
        let waveAnimation = CABasicAnimation(keyPath: "strokeEnd")
        waveAnimation.fromValue = 0.0
        waveAnimation.toValue = 1.0
        waveAnimation.duration = 2.0
        waveAnimation.repeatCount = .infinity
        
        timeWaveLayer.add(waveAnimation, forKey: "timeWave")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if hasBeenConfigured {
            let diameter = min(bounds.width, bounds.height)
            let radius = diameter / 2
            
            // Update circular shape
            layer.cornerRadius = radius
            dimensionalGlowLayer.cornerRadius = radius
            quantumCoreLayer.cornerRadius = radius
            plasmaEffectLayer.cornerRadius = radius
            
            // Update frames
            dimensionalGlowLayer.frame = bounds
            quantumCoreLayer.frame = bounds
            plasmaEffectLayer.frame = bounds
            
            starFieldLayer.frame = bounds
            starFieldLayer.emitterPosition = CGPoint(x: bounds.midX, y: bounds.midY)
            starFieldLayer.emitterSize = CGSize(width: diameter, height: diameter)
            
            particleOrbitLayer.frame = bounds
            particleOrbitLayer.emitterPosition = CGPoint(x: bounds.midX, y: bounds.midY)
            
            // Create circular paths
            let outerPath = UIBezierPath(ovalIn: bounds)
            energyRingLayer.path = outerPath.cgPath
            
            let auraInset: CGFloat = 6
            let auraPath = UIBezierPath(ovalIn: bounds.insetBy(dx: auraInset, dy: auraInset))
            pulsatingAuraLayer.path = auraPath.cgPath
            
            let borderInset: CGFloat = 10
            let borderPath = UIBezierPath(ovalIn: bounds.insetBy(dx: borderInset, dy: borderInset))
            holographicBorderLayer.path = borderPath.cgPath
            
            let waveInset: CGFloat = 15
            let wavePath = UIBezierPath(ovalIn: bounds.insetBy(dx: waveInset, dy: waveInset))
            timeWaveLayer.path = wavePath.cgPath
            
            // Optimal font sizing
            let optimalFontSize = diameter * 0.35
            font = UIFont.systemFont(ofSize: optimalFontSize, weight: .black)
        }
    }
    
    func animateTextChange(newText: String) {
        // Quantum transition effect
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = 1.0
        scaleAnimation.toValue = 1.2
        scaleAnimation.duration = 0.3
        scaleAnimation.autoreverses = true
        
        let glowAnimation = CABasicAnimation(keyPath: "shadowRadius")
        glowAnimation.fromValue = 12
        glowAnimation.toValue = 25
        glowAnimation.duration = 0.3
        glowAnimation.autoreverses = true
        
        layer.add(scaleAnimation, forKey: "textScale")
        layer.add(glowAnimation, forKey: "textGlow")
        
        UIView.transition(with: self, duration: 0.3, options: .transitionFlipFromTop) {
            self.text = newText
        }
    }
    
    func triggerTimeWarp() {
        // Create time warp effect
        let warpLayer = CAEmitterLayer()
        warpLayer.emitterPosition = CGPoint(x: bounds.midX, y: bounds.midY)
        warpLayer.renderMode = .additive
        
        let warpCell = CAEmitterCell()
        warpCell.contents = createOrbitParticle().cgImage
        warpCell.birthRate = 200
        warpCell.lifetime = 2.0
        warpCell.velocity = 100
        warpCell.velocityRange = 50
        warpCell.emissionRange = .pi * 2
        warpCell.scale = 0.1
        warpCell.scaleRange = 0.05
        warpCell.alphaSpeed = -0.5
        warpCell.color = quantumColors[0].cgColor
        
        warpLayer.emitterCells = [warpCell]
        layer.addSublayer(warpLayer)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            warpLayer.removeFromSuperlayer()
        }
    }
    
    deinit {
        quantumTimer?.invalidate()
        rotationTimer?.invalidate()
    }
}
