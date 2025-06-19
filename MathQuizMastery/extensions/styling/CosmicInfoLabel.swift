//
//  CosmicInfoLabel.swift
//  MathQuizMastery
//
//  Created by AydınKaya on 19.06.2025.
//

//
//  CosmicInfoLabel.swift
//  MathQuizMastery
//
//  Created by Aydın KAYA - Cosmic Information Display
//

import UIKit

class CosmicInfoLabel: UILabel {
    
    private let nebulaBackgroundLayer = CAGradientLayer()
    private let energyFieldLayer = CAShapeLayer()
    private let stardustLayer = CAEmitterLayer()
    private let hologramBorderLayer = CAShapeLayer()
    private let quantumGlowLayer = CALayer()
    private let crystallineLayer = CAGradientLayer()
    private let pulseWaveLayer = CAShapeLayer()
    
    private var cosmicTimer: Timer?
    private var lastSize: CGSize = .zero
    
    var cosmicTheme: CosmicTheme = .score {
        didSet {
            updateCosmicTheme()
        }
    }
    
    enum CosmicTheme {
        case score
        case questionNumber
        case timer
        
        var colors: [CGColor] {
            switch self {
            case .score:
                return [
                    UIColor(red: 1.0, green: 0.3, blue: 0.5, alpha: 0.8).cgColor,  // Stellar Red
                    UIColor(red: 1.0, green: 0.6, blue: 0.2, alpha: 0.7).cgColor,  // Cosmic Orange
                    UIColor(red: 0.9, green: 0.4, blue: 0.8, alpha: 0.6).cgColor   // Nebula Pink
                ]
            case .questionNumber:
                return [
                    UIColor(red: 0.0, green: 0.8, blue: 1.0, alpha: 0.8).cgColor,  // Quantum Cyan
                    UIColor(red: 0.3, green: 0.6, blue: 1.0, alpha: 0.7).cgColor,  // Electric Blue
                    UIColor(red: 0.1, green: 0.9, blue: 0.9, alpha: 0.6).cgColor   // Azure Glow
                ]
            case .timer:
                return [
                    UIColor(red: 0.4, green: 1.0, blue: 0.6, alpha: 0.8).cgColor,  // Aurora Green
                    UIColor(red: 0.2, green: 0.9, blue: 0.8, alpha: 0.7).cgColor,  // Mint Cosmic
                    UIColor(red: 0.6, green: 1.0, blue: 0.4, alpha: 0.6).cgColor   // Lime Energy
                ]
            }
        }
        
        var borderColor: CGColor {
            switch self {
            case .score:
                return UIColor(red: 1.0, green: 0.2, blue: 0.4, alpha: 1.0).cgColor
            case .questionNumber:
                return UIColor(red: 0.0, green: 0.9, blue: 1.0, alpha: 1.0).cgColor
            case .timer:
                return UIColor(red: 0.3, green: 1.0, blue: 0.5, alpha: 1.0).cgColor
            }
        }
        
        var glowColor: CGColor {
            switch self {
            case .score:
                return UIColor(red: 1.0, green: 0.3, blue: 0.5, alpha: 1.0).cgColor
            case .questionNumber:
                return UIColor(red: 0.0, green: 0.8, blue: 1.0, alpha: 1.0).cgColor
            case .timer:
                return UIColor(red: 0.4, green: 1.0, blue: 0.6, alpha: 1.0).cgColor
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCosmicLayers()
        startCosmicAnimations()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCosmicLayers()
        startCosmicAnimations()
    }
    
    private func setupCosmicLayers() {
        clipsToBounds = false
        layer.masksToBounds = false
        
        // 1. Quantum Glow Foundation
        quantumGlowLayer.backgroundColor = UIColor.clear.cgColor
        quantumGlowLayer.shadowColor = cosmicTheme.glowColor
        quantumGlowLayer.shadowRadius = 25
        quantumGlowLayer.shadowOpacity = 0.8
        quantumGlowLayer.shadowOffset = .zero
        quantumGlowLayer.cornerRadius = 15
        layer.insertSublayer(quantumGlowLayer, at: 0)
        
        // 2. Nebula Background
        nebulaBackgroundLayer.colors = [
            UIColor(red: 0.02, green: 0.05, blue: 0.15, alpha: 0.9).cgColor,
            UIColor(red: 0.05, green: 0.1, blue: 0.25, alpha: 0.8).cgColor,
            UIColor(red: 0.08, green: 0.15, blue: 0.35, alpha: 0.7).cgColor
        ]
        nebulaBackgroundLayer.locations = [0.0, 0.5, 1.0]
        nebulaBackgroundLayer.startPoint = CGPoint(x: 0, y: 0)
        nebulaBackgroundLayer.endPoint = CGPoint(x: 1, y: 1)
        nebulaBackgroundLayer.cornerRadius = 15
        layer.insertSublayer(nebulaBackgroundLayer, above: quantumGlowLayer)
        
        // 3. Crystalline Overlay
        crystallineLayer.colors = cosmicTheme.colors
        crystallineLayer.locations = [0.0, 0.5, 1.0]
        crystallineLayer.startPoint = CGPoint(x: 0, y: 0.5)
        crystallineLayer.endPoint = CGPoint(x: 1, y: 0.5)
        crystallineLayer.cornerRadius = 15
        layer.insertSublayer(crystallineLayer, above: nebulaBackgroundLayer)
        
        // 4. Stardust Particles
        setupStardust()
        
        // 5. Hologram Border
        hologramBorderLayer.fillColor = UIColor.clear.cgColor
        hologramBorderLayer.strokeColor = cosmicTheme.borderColor
        hologramBorderLayer.lineWidth = 2.5
        hologramBorderLayer.shadowColor = cosmicTheme.borderColor
        hologramBorderLayer.shadowRadius = 12
        hologramBorderLayer.shadowOpacity = 1.0
        hologramBorderLayer.shadowOffset = .zero
        layer.addSublayer(hologramBorderLayer)
        
        // 6. Energy Field
        energyFieldLayer.fillColor = UIColor.clear.cgColor
        energyFieldLayer.strokeColor = cosmicTheme.borderColor
        energyFieldLayer.lineWidth = 1.5
        energyFieldLayer.shadowColor = cosmicTheme.borderColor
        energyFieldLayer.shadowRadius = 8
        energyFieldLayer.shadowOpacity = 0.6
        energyFieldLayer.shadowOffset = .zero
        energyFieldLayer.opacity = 0.7
        layer.addSublayer(energyFieldLayer)
        
        // 7. Pulse Wave
        pulseWaveLayer.fillColor = UIColor.clear.cgColor
        pulseWaveLayer.strokeColor = UIColor.white.withAlphaComponent(0.4).cgColor
        pulseWaveLayer.lineWidth = 1
        pulseWaveLayer.lineDashPattern = [3, 6]
        layer.addSublayer(pulseWaveLayer)
        
        // Text Styling
        textAlignment = .center
        textColor = .white
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.5
        numberOfLines = 1
        
        // Text Shadow
        layer.shadowColor = cosmicTheme.glowColor
        layer.shadowRadius = 10
        layer.shadowOpacity = 1.0
        layer.shadowOffset = .zero
    }
    
    private func setupStardust() {
        stardustLayer.emitterPosition = CGPoint(x: 100, y: 20)
        stardustLayer.emitterSize = CGSize(width: 200, height: 40)
        stardustLayer.renderMode = .additive
        
        let dustParticle = CAEmitterCell()
        dustParticle.contents = createStardustParticle().cgImage
        dustParticle.birthRate = 15
        dustParticle.lifetime = 4.0
        dustParticle.velocity = 12
        dustParticle.velocityRange = 8
        dustParticle.emissionRange = .pi / 8
        dustParticle.scale = 0.02
        dustParticle.scaleRange = 0.015
        dustParticle.alphaSpeed = -0.2
        dustParticle.color = cosmicTheme.glowColor
        
        stardustLayer.emitterCells = [dustParticle]
        layer.insertSublayer(stardustLayer, above: crystallineLayer)
    }
    
    private func createStardustParticle() -> UIImage {
        let size = CGSize(width: 5, height: 5)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let context = UIGraphicsGetCurrentContext()!
        
        let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(),
                                 colors: [UIColor.white.cgColor, UIColor.clear.cgColor] as CFArray,
                                 locations: [0.0, 1.0])!
        
        context.drawRadialGradient(gradient,
                                 startCenter: CGPoint(x: 2.5, y: 2.5), startRadius: 0,
                                 endCenter: CGPoint(x: 2.5, y: 2.5), endRadius: 2.5,
                                 options: [])
        
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
    private func updateCosmicTheme() {
        crystallineLayer.colors = cosmicTheme.colors
        hologramBorderLayer.strokeColor = cosmicTheme.borderColor
        hologramBorderLayer.shadowColor = cosmicTheme.borderColor
        energyFieldLayer.strokeColor = cosmicTheme.borderColor
        energyFieldLayer.shadowColor = cosmicTheme.borderColor
        quantumGlowLayer.shadowColor = cosmicTheme.glowColor
        layer.shadowColor = cosmicTheme.glowColor
        
        // Update particle colors
        stardustLayer.emitterCells?.first?.color = cosmicTheme.glowColor
    }
    
    private func startCosmicAnimations() {
        cosmicTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            self.animateNebulaFlow()
            self.animateEnergyPulse()
            self.animateCrystallineShimmer()
        }
    }
    
    private func animateNebulaFlow() {
        let flowAnimation = CABasicAnimation(keyPath: "transform.rotation")
        flowAnimation.fromValue = 0
        flowAnimation.toValue = Float.pi * 2
        flowAnimation.duration = 15.0
        flowAnimation.repeatCount = .infinity
        
        nebulaBackgroundLayer.add(flowAnimation, forKey: "nebulaFlow")
    }
    
    private func animateEnergyPulse() {
        let pulseAnimation = CABasicAnimation(keyPath: "opacity")
        pulseAnimation.fromValue = 0.4
        pulseAnimation.toValue = 1.0
        pulseAnimation.duration = 2.0
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = .infinity
        
        energyFieldLayer.add(pulseAnimation, forKey: "energyPulse")
    }
    
    private func animateCrystallineShimmer() {
        let shimmerAnimation = CABasicAnimation(keyPath: "locations")
        shimmerAnimation.fromValue = [0.0, 0.5, 1.0]
        shimmerAnimation.toValue = [0.3, 0.8, 1.3]
        shimmerAnimation.duration = 3.0
        shimmerAnimation.autoreverses = true
        shimmerAnimation.repeatCount = .infinity
        
        crystallineLayer.add(shimmerAnimation, forKey: "crystallineShimmer")
    }
    
    private func animatePulseWave() {
        let waveAnimation = CABasicAnimation(keyPath: "strokeEnd")
        waveAnimation.fromValue = 0.0
        waveAnimation.toValue = 1.0
        waveAnimation.duration = 1.5
        waveAnimation.repeatCount = .infinity
        
        pulseWaveLayer.add(waveAnimation, forKey: "pulseWave")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard bounds.size != lastSize else { return }
        lastSize = bounds.size
        
        // Update all layer frames
        nebulaBackgroundLayer.frame = bounds
        crystallineLayer.frame = bounds
        quantumGlowLayer.frame = bounds
        
        stardustLayer.frame = bounds
        stardustLayer.emitterPosition = CGPoint(x: bounds.midX, y: bounds.minY)
        
        // Create paths for border layers
        let borderPath = UIBezierPath(roundedRect: bounds, cornerRadius: 15)
        hologramBorderLayer.path = borderPath.cgPath
        
        let energyPath = UIBezierPath(roundedRect: bounds.insetBy(dx: 2, dy: 2), cornerRadius: 13)
        energyFieldLayer.path = energyPath.cgPath
        
        let pulsePath = UIBezierPath(roundedRect: bounds.insetBy(dx: 4, dy: 4), cornerRadius: 11)
        pulseWaveLayer.path = pulsePath.cgPath
        
        // Optimal font sizing
        let optimalFontSize = bounds.height * 0.45
        font = UIFont.systemFont(ofSize: optimalFontSize, weight: .black)
    }
    
    func animateTextChange(newText: String) {
        // Cosmic text transition
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = 1.0
        scaleAnimation.toValue = 1.15
        scaleAnimation.duration = 0.4
        scaleAnimation.autoreverses = true
        
        let glowAnimation = CABasicAnimation(keyPath: "shadowRadius")
        glowAnimation.fromValue = 10
        glowAnimation.toValue = 20
        glowAnimation.duration = 0.4
        glowAnimation.autoreverses = true
        
        layer.add(scaleAnimation, forKey: "textScale")
        layer.add(glowAnimation, forKey: "textGlow")
        
        // Trigger cosmic burst
        triggerCosmicBurst()
        
        UIView.transition(with: self, duration: 0.4, options: .transitionCrossDissolve) {
            self.text = newText
        }
    }
    
    private func triggerCosmicBurst() {
        let burstLayer = CAEmitterLayer()
        burstLayer.emitterPosition = CGPoint(x: bounds.midX, y: bounds.midY)
        burstLayer.renderMode = .additive
        
        let burstCell = CAEmitterCell()
        burstCell.contents = createStardustParticle().cgImage
        burstCell.birthRate = 80
        burstCell.lifetime = 1.2
        burstCell.velocity = 60
        burstCell.velocityRange = 30
        burstCell.emissionRange = .pi * 2
        burstCell.scale = 0.06
        burstCell.scaleRange = 0.03
        burstCell.alphaSpeed = -0.8
        burstCell.color = cosmicTheme.glowColor
        
        burstLayer.emitterCells = [burstCell]
        layer.addSublayer(burstLayer)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            burstLayer.removeFromSuperlayer()
        }
    }
    
    func activateQuantumField() {
        // Activate enhanced quantum field effect
        let fieldAnimation = CABasicAnimation(keyPath: "shadowRadius")
        fieldAnimation.fromValue = 25
        fieldAnimation.toValue = 40
        fieldAnimation.duration = 1.0
        fieldAnimation.autoreverses = true
        fieldAnimation.repeatCount = 3
        
        quantumGlowLayer.add(fieldAnimation, forKey: "quantumField")
        
        // Enhanced border glow
        let borderGlowAnimation = CABasicAnimation(keyPath: "shadowRadius")
        borderGlowAnimation.fromValue = 12
        borderGlowAnimation.toValue = 25
        borderGlowAnimation.duration = 1.0
        borderGlowAnimation.autoreverses = true
        borderGlowAnimation.repeatCount = 3
        
        hologramBorderLayer.add(borderGlowAnimation, forKey: "borderGlow")
    }
    
    deinit {
        cosmicTimer?.invalidate()
    }
}
