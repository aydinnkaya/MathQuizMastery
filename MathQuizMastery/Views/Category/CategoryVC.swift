//
//  CategoryVC.swift
//  MathQuizMastery
//
//  Created by AydınKaya on 16.01.2025.

import UIKit
import SceneKit
import AVFoundation

final class CategoryVC: UIViewController {
    private var audioPlayer: AVAudioPlayer?
    private let buttonSize: CGFloat = 140

    private let operations: [(title: String, symbol: String, colors: [UIColor], sound: String)] = [
        ("Toplama", "+", [UIColor.systemOrange, UIColor.systemYellow], "add"),
        ("Cikarma", "-", [UIColor.systemPink, UIColor.systemRed], "subtract"),
        ("Carpma", "×", [UIColor.systemPurple, UIColor.systemBlue], "multiply"),
        ("Bolme", "÷", [UIColor.systemTeal, UIColor.systemCyan], "divide"),
        ("Karisik", "?", [UIColor.lightGray, UIColor.white], "random")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSceneBackground()
        layoutButtons()
    }
}

private extension CategoryVC {
    func setupSceneBackground() {
        let sceneView = SCNView()
        sceneView.translatesAutoresizingMaskIntoConstraints = false
        sceneView.scene = SCNScene()
        sceneView.backgroundColor = .black
        sceneView.allowsCameraControl = false
        sceneView.isPlaying = true
        sceneView.isUserInteractionEnabled = false
        view.addSubview(sceneView)
        view.sendSubviewToBack(sceneView)

        NSLayoutConstraint.activate([
            sceneView.topAnchor.constraint(equalTo: view.topAnchor),
            sceneView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            sceneView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sceneView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        if let starParticle = SCNParticleSystem(named: "Stars.scnp", inDirectory: "Particles") {
            let particleNode = SCNNode()
            particleNode.addParticleSystem(starParticle)
            sceneView.scene?.rootNode.addChildNode(particleNode)
        }

        let glowSphere = SCNSphere(radius: 3.5)
        glowSphere.firstMaterial?.emission.contents = UIColor.cyan
        glowSphere.firstMaterial?.lightingModel = .constant
        let glowNode = SCNNode(geometry: glowSphere)
        glowNode.position = SCNVector3(0, 0, -5)
        sceneView.scene?.rootNode.addChildNode(glowNode)
    }

    func layoutButtons() {
        let mainContainer = UIView()
        mainContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mainContainer)

        NSLayoutConstraint.activate([
            mainContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        let gridStack = UIStackView()
        gridStack.axis = .vertical
        gridStack.spacing = 20
        gridStack.translatesAutoresizingMaskIntoConstraints = false
        mainContainer.addSubview(gridStack)

        let row1 = createButtonRow(from: [operations[0], operations[1]])
        let row2 = createButtonRow(from: [operations[2], operations[3]])
        gridStack.addArrangedSubview(row1)
        gridStack.addArrangedSubview(row2)

        let karisik = createButton(from: operations[4])
        karisik.translatesAutoresizingMaskIntoConstraints = false
        mainContainer.addSubview(karisik)

        NSLayoutConstraint.activate([
            gridStack.topAnchor.constraint(equalTo: mainContainer.topAnchor),
            gridStack.centerXAnchor.constraint(equalTo: mainContainer.centerXAnchor),
            karisik.topAnchor.constraint(equalTo: gridStack.bottomAnchor, constant: 28),
            karisik.centerXAnchor.constraint(equalTo: mainContainer.centerXAnchor),
            karisik.bottomAnchor.constraint(equalTo: mainContainer.bottomAnchor)
        ])

        view.bringSubviewToFront(mainContainer)
    }

    func createButtonRow(from items: [(String, String, [UIColor], String)]) -> UIStackView {
        let row = UIStackView()
        row.axis = .horizontal
        row.spacing = 20
        row.distribution = .fillEqually
        row.translatesAutoresizingMaskIntoConstraints = false

        for op in items {
            let button = createButton(from: op)
            row.addArrangedSubview(button)
        }
        return row
    }

    func createButton(from item: (title: String, symbol: String, colors: [UIColor], sound: String)) -> FuturisticButton {
        let button = FuturisticButton(symbol: item.symbol, title: item.title, gradientColors: item.colors)
        button.accessibilityHint = item.sound
        button.addTarget(self, action: #selector(operationSelected(_:)), for: .touchUpInside)
        return button
    }

    @objc func operationSelected(_ sender: FuturisticButton) {
        if let sound = sender.accessibilityHint {
            playSound(named: sound)
        }
        animatePulse(button: sender)
        laserGlowEffect(on: sender)
        showWarpEffect {
            let gameVC = GameVC()
            gameVC.modalPresentationStyle = .fullScreen
            self.present(gameVC, animated: false)
        }
    }

    func animatePulse(button: UIButton) {
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.4
        pulse.fromValue = 1.0
        pulse.toValue = 1.15
        pulse.autoreverses = true
        pulse.initialVelocity = 0.5
        pulse.damping = 1.0
        button.layer.add(pulse, forKey: "pulse")
    }

    func laserGlowEffect(on view: UIView) {
        let glow = CABasicAnimation(keyPath: "shadowOpacity")
        glow.fromValue = 0.5
        glow.toValue = 1.0
        glow.duration = 0.2
        glow.autoreverses = true
        glow.repeatCount = 2
        view.layer.shadowColor = UIColor.systemCyan.cgColor
        view.layer.shadowRadius = 20
        view.layer.shadowOffset = .zero
        view.layer.add(glow, forKey: "laser")
    }

    func playSound(named name: String) {
        guard let url = Bundle.main.url(forResource: name, withExtension: "mp3") else {
            print("\u{274C} Ses dosyası bulunamadı: \(name).mp3")
            return
        }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            print("\u{274C} Ses dosyası bulunamadı: \(name).mp3")        }
    }

    func showWarpEffect(completion: @escaping () -> Void) {
        let warpView = WarpTransitionView(frame: view.bounds)
        view.addSubview(warpView)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            warpView.removeFromSuperview()
            completion()
        }
    }
}

final class WarpTransitionView: UIView {
    private let sceneView = SCNView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupScene()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupScene() {
        sceneView.frame = bounds
        sceneView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(sceneView)

        let scene = SCNScene()
        sceneView.scene = scene
        sceneView.backgroundColor = .clear
        sceneView.isPlaying = true
        sceneView.allowsCameraControl = false

        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(0, 0, 5)
        scene.rootNode.addChildNode(cameraNode)

        if let particle = SCNParticleSystem(named: "NumberExplosion.scnp", inDirectory: nil) {
            let particleNode = SCNNode()
            particleNode.addParticleSystem(particle)
            scene.rootNode.addChildNode(particleNode)
        }

        let glowSphere = SCNSphere(radius: 0.5)
        glowSphere.firstMaterial?.emission.contents = UIColor.systemYellow
        glowSphere.firstMaterial?.lightingModel = .constant
        let glowNode = SCNNode(geometry: glowSphere)
        glowNode.opacity = 0.0
        scene.rootNode.addChildNode(glowNode)

        let fadeIn = SCNAction.fadeIn(duration: 0.2)
        let scaleUp = SCNAction.scale(to: 3.0, duration: 0.5)
        let fadeOut = SCNAction.fadeOut(duration: 0.2)
        let sequence = SCNAction.sequence([fadeIn, scaleUp, fadeOut])
        glowNode.runAction(sequence)
    }
}

final class FuturisticButton: UIButton {
    let title: String

    init(symbol: String, title: String, gradientColors: [UIColor]) {
        self.title = title
        super.init(frame: .zero)
        setup(symbol: symbol, title: title, gradientColors: gradientColors)
    }

    private func setup(symbol: String, title: String, gradientColors: [UIColor]) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: 140),
            heightAnchor.constraint(equalToConstant: 140)
        ])

        layer.cornerRadius = 28
        clipsToBounds = true

        let gradient = CAGradientLayer()
        gradient.colors = gradientColors.map { $0.cgColor }
        gradient.cornerRadius = 28
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        layer.insertSublayer(gradient, at: 0)

        layer.shadowColor = UIColor.cyan.cgColor
        layer.shadowOpacity = 0.9
        layer.shadowOffset = CGSize(width: 0, height: 10)
        layer.shadowRadius = 18

        let symbolLabel = UILabel()
        symbolLabel.text = symbol
        symbolLabel.font = UIFont.systemFont(ofSize: 36, weight: .heavy)
        symbolLabel.textColor = .white
        symbolLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(symbolLabel)

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = .lightGray
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)

        NSLayoutConstraint.activate([
            symbolLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            symbolLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -10),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: symbolLabel.bottomAnchor, constant: 6)
        ])
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.sublayers?.first(where: { $0 is CAGradientLayer })?.frame = bounds
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
