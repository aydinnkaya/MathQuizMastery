//
//  CategoryVC.swift
//  MathQuizMastery
//
//  Created by AydınKaya on 16.01.2025.

import UIKit
import SceneKit
import AVFoundation

final class CategoryVC: UIViewController {
    private let sceneView = SCNView()
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var subtractButton: UIButton!
    @IBOutlet weak var multiplyButton: UIButton!
    @IBOutlet weak var divideButton: UIButton!
    @IBOutlet weak var randomButton: UIButton!
    
    
    private var player: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSceneView()
        //ceneView.setupInitialScene()
        //configureButtons()
       // SoundManager.shared.playIntroSound()
    }
    
    private func setupSceneView() {
        sceneView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sceneView)
        
        NSLayoutConstraint.activate([
//            sceneView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
//            sceneView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
//            sceneView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
//            sceneView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    
    private func configureButtons() {
        let buttonData: [(UIButton, OperationType)] = [
            (addButton, .add),
            (subtractButton, .subtract),
            (multiplyButton, .multiply),
            (divideButton, .divide),
            (randomButton, .random)
        ]
        
        for (button, operation) in buttonData {
            button.tag = operation.rawValue
            button.applyDefaultStyle()
        }
    }
    
    // MARK: - Actions
    @IBAction func addButtonTapped(_ sender: UIButton) {
        handleButtonTap(for: sender, operation: .add)
    }
    
    @IBAction func subtractButtonTapped(_ sender: UIButton) {
        handleButtonTap(for: sender, operation: .subtract)
    }
    
    @IBAction func multiplyButtonTapped(_ sender: UIButton) {
        handleButtonTap(for: sender, operation: .multiply)
    }
    
    @IBAction func divideButtonTapped(_ sender: UIButton) {
        handleButtonTap(for: sender, operation: .divide)
    }
    
    @IBAction func randomButtonTapped(_ sender: UIButton) {
        handleButtonTap(for: sender, operation: .random)
    }
    
    // MARK: - Navigation
    private func handleButtonTap(for button: UIButton, operation: OperationType) {
//        button.animatePulse()
//        button.laserGlowEffect()
//      //  SoundManager.shared.playSound(named: operation.soundFileName)
//        
//        view.showWarpEffect {
//            print("➡️ Seçilen kategori: \(operation.title)")
//            self.navigateToQuiz(for: operation)
//        }
    }
    
    private func navigateToQuiz(for operation: OperationType) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let gameVC = storyboard.instantiateViewController(withIdentifier: "GameVC") as? GameVC {
            gameVC.selectedExpressionType = operation.expressionType
            navigationController?.pushViewController(gameVC, animated: true)
        }
    }
}

private extension UIButton {
    func applyDefaultStyle() {
        layer.cornerRadius = 12
        layer.borderWidth = 2
        layer.borderColor = UIColor.white.cgColor
        backgroundColor = UIColor.systemTeal
        setTitleColor(.white, for: .normal)
    }
    
//    func animatePulse() {
//        let pulse = CASpringAnimation(keyPath: "transform.scale")
//        pulse.duration = 0.4
//        pulse.fromValue = 1.0
//        pulse.toValue = 1.15
//        pulse.autoreverses = true
//        pulse.initialVelocity = 0.5
//        pulse.damping = 1.0
//        layer.add(pulse, forKey: "pulse")
//    }
//    
//    func laserGlowEffect() {
//        let glow = CABasicAnimation(keyPath: "shadowOpacity")
//        glow.fromValue = 0.5
//        glow.toValue = 1.0
//        glow.duration = 0.2
//        glow.autoreverses = true
//        glow.repeatCount = 2
//        layer.add(glow, forKey: "laser")
//    }
}

//private extension UIView {
//    func showWarpEffect(completion: @escaping () -> Void) {
//        let warpView = WarpTransitionView(frame: bounds)
//        addSubview(warpView)
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//            warpView.removeFromSuperview()
//            completion()
//        }
//    }
//}

//private extension SCNView {
//    func setupInitialScene() {
//        let scene = SCNScene()
//        self.scene = scene
//        allowsCameraControl = true
//        backgroundColor = .black
//        
//        let text = SCNText(string: "Select Category", extrusionDepth: 2)
//        text.firstMaterial?.diffuse.contents = UIColor.systemBlue
//        text.font = UIFont.systemFont(ofSize: 10, weight: .bold)
//        
//        let textNode = SCNNode(geometry: text)
//        textNode.position = SCNVector3(x: -5, y: 0, z: 0)
//        scene.rootNode.addChildNode(textNode)
//        
//        let rotate = CABasicAnimation(keyPath: "rotation")
//        rotate.toValue = NSValue(scnVector4: SCNVector4(0, 1, 0, Float.pi * 2))
//        rotate.duration = 10
//        rotate.repeatCount = .infinity
//        textNode.addAnimation(rotate, forKey: "rotate")
//    }
//}
//
//final class SoundManager {
//    static let shared = SoundManager()
//    private var audioPlayer: AVAudioPlayer?
//    
//    private init() {}
//    
//    func playIntroSound() {
//        playSound(named: "introSound")
//    }
//    
//    func playSound(named name: String) {
//        guard let url = Bundle.main.url(forResource: name, withExtension: "mp3") else {
//            print("🔇 Ses dosyası bulunamadı: \(name).mp3")
//            return
//        }
//        do {
//            audioPlayer = try AVAudioPlayer(contentsOf: url)
//            audioPlayer?.play()
//        } catch {
//            print("🔇 Ses dosyası çalıştırılamadı: \(name).mp3")
//        }
//    }
//}
