//
//  ViewController.swift
//  MathQuizMastery
//
//  Created by AydınKaya on 9.01.2025.
//

import UIKit

class GameVC: UIViewController {
    @IBOutlet weak var questionNumberLabel: CosmicInfoLabel!
    @IBOutlet weak var questionLabel: CosmicQuestionLabel!
    @IBOutlet weak var buttonFirst: SpaceNeonButton!
    @IBOutlet weak var buttonSecond: SpaceNeonButton!
    @IBOutlet weak var timeLabel: QuantumCircleLabel!
    @IBOutlet weak var buttonThird: SpaceNeonButton!
    @IBOutlet weak var scoreLabel: CosmicInfoLabel!
    
    @IBOutlet weak var backgroundImage: UIImageView!
    
    
    // Space Background Layers
    private let galaxyBackgroundLayer = CAGradientLayer()
    private let starFieldLayer = CAEmitterLayer()
    private let nebulaLayer = CAGradientLayer()
    private let cosmicDustLayer = CAEmitterLayer()
    private let quantumFieldLayer = CALayer()
    
    private var viewModel: GameScreenViewModelProtocol!
    private var coordinator: AppCoordinator!
    var selectedExpressionType: MathExpression.ExpressionType?
    private var spaceTimer: Timer?
    
    // Cosmic Animation Properties
    private var isCorrectAnswer = false
    private var currentQuestionIndex = 0
    
    init(viewModel: GameScreenViewModelProtocol!, coordinator: AppCoordinator!, selectedExpressionType: MathExpression.ExpressionType? = nil) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        self.selectedExpressionType = selectedExpressionType
        super.init(nibName: "GameVC", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewModel()
        setupSpaceEnvironment()
        setupUIElements()
        viewModel.startGame()
        navigationItem.hidesBackButton = true
        startSpaceAnimations()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateSpaceEnvironment()
        setupLabelStyles()
        setupButtonStyles()
        backgroundImage.frame = view.bounds
    }
    
    private func configureViewModel() {
        if let expressionType = selectedExpressionType {
            viewModel = GameScreenViewModel(delegate: self, expressionType: expressionType)
        }
    }
    
    private func setupSpaceEnvironment() {
        view.backgroundColor = UIColor.black
        
        // 1. Deep Space Galaxy Background
        galaxyBackgroundLayer.colors = [
            UIColor(red: 0.02, green: 0.02, blue: 0.08, alpha: 1.0).cgColor,  // Deep Space
            UIColor(red: 0.05, green: 0.03, blue: 0.15, alpha: 1.0).cgColor,  // Dark Cosmic
            UIColor(red: 0.08, green: 0.05, blue: 0.25, alpha: 1.0).cgColor,  // Void Blue
            UIColor(red: 0.03, green: 0.08, blue: 0.20, alpha: 1.0).cgColor,  // Deep Navy
            UIColor(red: 0.01, green: 0.01, blue: 0.05, alpha: 1.0).cgColor   // Absolute Dark
        ]
        galaxyBackgroundLayer.locations = [0.0, 0.25, 0.5, 0.75, 1.0]
        galaxyBackgroundLayer.startPoint = CGPoint(x: 0, y: 0)
        galaxyBackgroundLayer.endPoint = CGPoint(x: 1, y: 1)
        view.layer.insertSublayer(galaxyBackgroundLayer, at: 0)
        
        // 2. Nebula Effect
        nebulaLayer.colors = [
            UIColor.clear.cgColor,
            UIColor(red: 0.3, green: 0.1, blue: 0.6, alpha: 0.3).cgColor,
            UIColor(red: 0.1, green: 0.4, blue: 0.8, alpha: 0.2).cgColor,
            UIColor(red: 0.6, green: 0.2, blue: 0.4, alpha: 0.25).cgColor,
            UIColor.clear.cgColor
        ]
        nebulaLayer.locations = [0.0, 0.3, 0.5, 0.7, 1.0]
        nebulaLayer.startPoint = CGPoint(x: 0, y: 0.5)
        nebulaLayer.endPoint = CGPoint(x: 1, y: 0.5)
        view.layer.insertSublayer(nebulaLayer, above: galaxyBackgroundLayer)
        
        // 3. Quantum Field Effect
        quantumFieldLayer.backgroundColor = UIColor(red: 0.0, green: 0.1, blue: 0.3, alpha: 0.1).cgColor
        quantumFieldLayer.shadowColor = UIColor(red: 0.0, green: 0.8, blue: 1.0, alpha: 1.0).cgColor
        quantumFieldLayer.shadowRadius = 50
        quantumFieldLayer.shadowOpacity = 0.3
        quantumFieldLayer.shadowOffset = .zero
        view.layer.insertSublayer(quantumFieldLayer, above: nebulaLayer)
        
        // 4. Star Field
        setupStarField()
        
        // 5. Cosmic Dust
        setupCosmicDust()
    }
    
    private func setupStarField() {
        starFieldLayer.emitterPosition = CGPoint(x: 200, y: 0)
        starFieldLayer.emitterSize = CGSize(width: 400, height: 900)
        starFieldLayer.renderMode = .additive
        
        // Distant Stars
        let distantStar = CAEmitterCell()
        distantStar.contents = createDistantStar().cgImage
        distantStar.birthRate = 25
        distantStar.lifetime = Float.infinity
        distantStar.velocity = 0
        distantStar.emissionRange = .pi * 2
        distantStar.scale = 0.1
        distantStar.scaleRange = 0.05
        distantStar.alphaRange = 0.8
        distantStar.color = UIColor.white.cgColor
        
        // Twinkling Stars
        let twinklingStar = CAEmitterCell()
        twinklingStar.contents = createTwinklingStar().cgImage
        twinklingStar.birthRate = 15
        twinklingStar.lifetime = Float.infinity
        twinklingStar.velocity = 0
        twinklingStar.emissionRange = .pi * 2
        twinklingStar.scale = 0.15
        twinklingStar.scaleRange = 0.08
        twinklingStar.alphaRange = 0.6
        twinklingStar.color = UIColor(red: 0.8, green: 0.9, blue: 1.0, alpha: 1.0).cgColor
        
        starFieldLayer.emitterCells = [distantStar, twinklingStar]
        view.layer.insertSublayer(starFieldLayer, above: quantumFieldLayer)
    }
    
    private func setupCosmicDust() {
        cosmicDustLayer.emitterPosition = CGPoint(x: 200, y: 0)
        cosmicDustLayer.emitterSize = CGSize(width: 400, height: 900)
        cosmicDustLayer.renderMode = .additive
        
        let dustParticle = CAEmitterCell()
        dustParticle.contents = createCosmicDust().cgImage
        dustParticle.birthRate = 30
        dustParticle.lifetime = 8.0
        dustParticle.velocity = 20
        dustParticle.velocityRange = 15
        dustParticle.emissionLongitude = .pi / 2
        dustParticle.emissionRange = .pi / 4
        dustParticle.scale = 0.02
        dustParticle.scaleRange = 0.015
        dustParticle.alphaSpeed = -0.1
        dustParticle.color = UIColor(red: 0.7, green: 0.8, blue: 1.0, alpha: 0.6).cgColor
        
        cosmicDustLayer.emitterCells = [dustParticle]
        view.layer.insertSublayer(cosmicDustLayer, above: starFieldLayer)
    }
    
    private func createDistantStar() -> UIImage {
        let size = CGSize(width: 6, height: 6)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let context = UIGraphicsGetCurrentContext()!
        
        context.setFillColor(UIColor.white.cgColor)
        context.fillEllipse(in: CGRect(origin: .zero, size: size))
        
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
    private func createTwinklingStar() -> UIImage {
        let size = CGSize(width: 12, height: 12)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let context = UIGraphicsGetCurrentContext()!
        
        let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(),
                                  colors: [UIColor.white.cgColor, UIColor.clear.cgColor] as CFArray,
                                  locations: [0.0, 1.0])!
        
        context.drawRadialGradient(gradient,
                                   startCenter: CGPoint(x: 6, y: 6), startRadius: 0,
                                   endCenter: CGPoint(x: 6, y: 6), endRadius: 6,
                                   options: [])
        
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
    private func createCosmicDust() -> UIImage {
        let size = CGSize(width: 3, height: 3)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let context = UIGraphicsGetCurrentContext()!
        
        context.setFillColor(UIColor(red: 0.8, green: 0.9, blue: 1.0, alpha: 0.4).cgColor)
        context.fillEllipse(in: CGRect(origin: .zero, size: size))
        
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
    private func updateSpaceEnvironment() {
        galaxyBackgroundLayer.frame = view.bounds
        nebulaLayer.frame = view.bounds
        quantumFieldLayer.frame = view.bounds
        starFieldLayer.frame = view.bounds
        cosmicDustLayer.frame = view.bounds
        
        starFieldLayer.emitterPosition = CGPoint(x: view.bounds.midX, y: 0)
        cosmicDustLayer.emitterPosition = CGPoint(x: view.bounds.midX, y: 0)
    }
    
    private func startSpaceAnimations() {
        // Galaxy rotation
        let galaxyRotation = CABasicAnimation(keyPath: "transform.rotation")
        galaxyRotation.fromValue = 0
        galaxyRotation.toValue = Float.pi * 2
        galaxyRotation.duration = 120.0
        galaxyRotation.repeatCount = .infinity
        galaxyBackgroundLayer.add(galaxyRotation, forKey: "galaxyRotation")
        
        // Nebula flow
        let nebulaFlow = CABasicAnimation(keyPath: "transform.translation.x")
        nebulaFlow.fromValue = -50
        nebulaFlow.toValue = 50
        nebulaFlow.duration = 25.0
        nebulaFlow.autoreverses = true
        nebulaFlow.repeatCount = .infinity
        nebulaLayer.add(nebulaFlow, forKey: "nebulaFlow")
        
        // Quantum field pulse
        let quantumPulse = CABasicAnimation(keyPath: "shadowRadius")
        quantumPulse.fromValue = 30
        quantumPulse.toValue = 80
        quantumPulse.duration = 4.0
        quantumPulse.autoreverses = true
        quantumPulse.repeatCount = .infinity
        quantumFieldLayer.add(quantumPulse, forKey: "quantumPulse")
        
        // Start cosmic timer for additional effects
        spaceTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            self.updateCosmicEffects()
        }
    }
    
    private func updateCosmicEffects() {
        // Add subtle twinkling to stars
        starFieldLayer.setValue(Float.random(in: 0.3...1.0), forKeyPath: "emitterCells.opacity")
    }
    
    private func updateUI(question: String, answers: [String]) {
        questionLabel.animateTextChange(newText: question)
        
        // Animate button text changes with cosmic effects
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
            self.buttonFirst.setTitle(answers[0], for: .normal)
            self.buttonSecond.setTitle(answers[1], for: .normal)
            self.buttonThird.setTitle(answers[2], for: .normal)
        }
        
        // Trigger quantum explosion for new question
       // questionLabel.triggerCosmicExplosion()
     //   timeLabel.triggerTimeWarp()
    }
    
    private func handleAnswer(for button: SpaceNeonButton) {
        guard let selectedAnswer = button.title(for: .normal), let selectedAnswerInt = Int(selectedAnswer) else { return }
        let isCorrect = viewModel.checkAnswer(selectedAnswer: selectedAnswerInt)
        handleAnswerSelection(selectedButton: button, correct: isCorrect)
    }
    
    private func handleAnswerSelection(selectedButton: SpaceNeonButton, correct: Bool) {
        isCorrectAnswer = correct
        
        // Disable all buttons
        [buttonFirst, buttonSecond, buttonThird].forEach { $0?.isEnabled = false }
        
        if correct {
            // Correct answer effects
       //     selectedButton.triggerQuantumExplosion()
            triggerCorrectAnswerCosmicEffect()
            
            // Change button appearance for correct answer
            UIView.animate(withDuration: 0.3) {
                selectedButton.backgroundColor = UIColor(red: 0.2, green: 0.8, blue: 0.4, alpha: 0.8)
                selectedButton.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            }
        } else {
            // Wrong answer effects
            triggerWrongAnswerCosmicEffect()
            
            // Change button appearance for wrong answer
            UIView.animate(withDuration: 0.3) {
                selectedButton.backgroundColor = UIColor(red: 0.9, green: 0.3, blue: 0.3, alpha: 0.8)
                selectedButton.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            // Reset buttons
            [self.buttonFirst, self.buttonSecond, self.buttonThird].forEach { button in
                button?.isEnabled = true
                button?.backgroundColor = UIColor.clear
                button?.transform = CGAffineTransform.identity
            }
            self.viewModel.nextQuestion()
        }
    }
    
    private func triggerCorrectAnswerCosmicEffect() {
        // Screen-wide success effect
        let successLayer = CAEmitterLayer()
        successLayer.emitterPosition = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
        successLayer.emitterSize = view.bounds.size
        successLayer.renderMode = .additive
        
        let successParticle = CAEmitterCell()
        successParticle.contents = createTwinklingStar().cgImage
        successParticle.birthRate = 100
        successParticle.lifetime = 2.0
        successParticle.velocity = 150
        successParticle.velocityRange = 75
        successParticle.emissionRange = .pi * 2
        successParticle.scale = 0.1
        successParticle.scaleRange = 0.05
        successParticle.alphaSpeed = -0.5
        successParticle.color = UIColor(red: 0.3, green: 1.0, blue: 0.5, alpha: 1.0).cgColor
        
        successLayer.emitterCells = [successParticle]
        view.layer.addSublayer(successLayer)
        
        // Screen flash effect
        let flashLayer = CALayer()
        flashLayer.frame = view.bounds
        flashLayer.backgroundColor = UIColor(red: 0.3, green: 1.0, blue: 0.5, alpha: 0.3).cgColor
        view.layer.addSublayer(flashLayer)
        
        let flashAnimation = CABasicAnimation(keyPath: "opacity")
        flashAnimation.fromValue = 1.0
        flashAnimation.toValue = 0.0
        flashAnimation.duration = 0.5
        flashLayer.add(flashAnimation, forKey: "flash")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            successLayer.removeFromSuperlayer()
            flashLayer.removeFromSuperlayer()
        }
    }
    
    private func triggerWrongAnswerCosmicEffect() {
        // Screen shake effect
        let shakeAnimation = CABasicAnimation(keyPath: "transform.translation.x")
        shakeAnimation.fromValue = -10
        shakeAnimation.toValue = 10
        shakeAnimation.duration = 0.1
        shakeAnimation.autoreverses = true
        shakeAnimation.repeatCount = 3
        view.layer.add(shakeAnimation, forKey: "shake")
        
        // Red warning flash
        let warningLayer = CALayer()
        warningLayer.frame = view.bounds
        warningLayer.backgroundColor = UIColor(red: 1.0, green: 0.2, blue: 0.2, alpha: 0.2).cgColor
        view.layer.addSublayer(warningLayer)
        
        let warningAnimation = CABasicAnimation(keyPath: "opacity")
        warningAnimation.fromValue = 1.0
        warningAnimation.toValue = 0.0
        warningAnimation.duration = 0.6
        warningLayer.add(warningAnimation, forKey: "warning")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            warningLayer.removeFromSuperlayer()
        }
    }
    
    @IBAction func answerFirstButton(_ sender: SpaceNeonButton) {
        handleAnswer(for: sender)
    }
    
    @IBAction func answerSecondButton(_ sender: SpaceNeonButton) {
        handleAnswer(for: sender)
    }
    
    @IBAction func answerThirdButton(_ sender: SpaceNeonButton) {
        handleAnswer(for: sender)
    }
    
    deinit {
        spaceTimer?.invalidate()
    }
}

// MARK: - GameScreenViewModelDelegate
extension GameVC: GameScreenViewModelDelegate {
    
    func onUpdateUI(questionText: String, answers: [String]) {
        self.updateUI(question: questionText, answers: answers)
    }
    
    func onUpdateScore(score: Int) {
        scoreLabel.animateTextChange(newText: "Score: \(score)")
        //scoreLabel.activateQuantumField()
    }
    
    func onUpdateTime(time: String) {
        timeLabel.animateTextChange(newText: time)
        
//        // Warning effects for low time
//        if let timeInt = Int(time), timeInt <= 10 {
//            timeLabel.triggerTimeWarp()
//        }
    }
    
    func onUpdateQuestionNumber(questionNumber: Int) {
        questionNumberLabel.animateTextChange(newText: "\(questionNumber) / 10")
        currentQuestionIndex = questionNumber
    }
    
    func onGameFinished(score: Int, expressionType: MathExpression.ExpressionType) {
        // Trigger final cosmic celebration
        triggerGameFinishCosmicEffect(score: score)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.coordinator.goToResult(score: "\(score)", expressionType: expressionType)
        }
    }
    
    private func triggerGameFinishCosmicEffect(score: Int) {
        let celebrationLayer = CAEmitterLayer()
        celebrationLayer.emitterPosition = CGPoint(x: view.bounds.midX, y: view.bounds.maxY)
        celebrationLayer.emitterSize = CGSize(width: view.bounds.width, height: 50)
        celebrationLayer.renderMode = .additive
        
        let celebrationParticle = CAEmitterCell()
        celebrationParticle.contents = createTwinklingStar().cgImage
        celebrationParticle.birthRate = 200
        celebrationParticle.lifetime = 4.0
        celebrationParticle.velocity = 200
        celebrationParticle.velocityRange = 100
        celebrationParticle.emissionLongitude = -(.pi / 2)
        celebrationParticle.emissionRange = .pi / 3
        celebrationParticle.scale = 0.15
        celebrationParticle.scaleRange = 0.1
        celebrationParticle.alphaSpeed = -0.3
        
        // Color based on score
        if score >= 8 {
            celebrationParticle.color = UIColor(red: 1.0, green: 0.8, blue: 0.0, alpha: 1.0).cgColor // Gold
        } else if score >= 6 {
            celebrationParticle.color = UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 1.0).cgColor // Silver
        } else {
            celebrationParticle.color = UIColor(red: 0.8, green: 0.5, blue: 0.2, alpha: 1.0).cgColor // Bronze
        }
        
        celebrationLayer.emitterCells = [celebrationParticle]
        view.layer.addSublayer(celebrationLayer)
    }
}

// MARK: - UI Setup Extensions
extension GameVC {
    
    func setupUIElements() {
        scoreLabel.text = "Score: 0"
        scoreLabel.cosmicTheme = .score
        
        questionNumberLabel.text = "1 / 10"
        questionNumberLabel.cosmicTheme = .questionNumber
        
        timeLabel.text = "60"
    }
    
    func setupLabelStyles() {
        // Score label: Stellar red theme
        scoreLabel.cosmicTheme = .score
        scoreLabel.font = UIFont.systemFont(ofSize: 18, weight: .black)
        
        // Question number: Quantum cyan theme
        questionNumberLabel.cosmicTheme = .questionNumber
        questionNumberLabel.font = UIFont.systemFont(ofSize: 16, weight: .black)
        
//        // Time label: Aurora green theme
//        timeLabel.quantumColors = [
//            UIColor(red: 0.3, green: 1.0, blue: 0.6, alpha: 1.0),    // Aurora Green
//            UIColor(red: 0.2, green: 0.9, blue: 0.8, alpha: 1.0),   // Mint Cosmic
//            UIColor(red: 0.4, green: 0.8, blue: 1.0, alpha: 1.0),   // Ice Blue
//            UIColor(red: 0.6, green: 1.0, blue: 0.4, alpha: 1.0),   // Lime Energy
//            UIColor(red: 0.1, green: 0.9, blue: 0.9, alpha: 1.0)    // Cyan Glow
//        ]
        
//        // Question label: Cosmic gradient theme
//        questionLabel.cosmicColors = [
//            UIColor(red: 0.05, green: 0.1, blue: 0.3, alpha: 0.95).cgColor,   // Deep Space
//            UIColor(red: 0.1, green: 0.15, blue: 0.4, alpha: 0.9).cgColor,    // Cosmic Blue
//            UIColor(red: 0.15, green: 0.08, blue: 0.35, alpha: 0.85).cgColor, // Void Purple
//            UIColor(red: 0.08, green: 0.2, blue: 0.45, alpha: 0.9).cgColor,   // Nebula Teal
//            UIColor(red: 0.12, green: 0.05, blue: 0.3, alpha: 0.95).cgColor   // Galaxy Purple
//        ]
//        
//        questionLabel.borderColors = [
//            UIColor(red: 0.0, green: 0.9, blue: 1.0, alpha: 1.0).cgColor,     // Quantum Cyan
//            UIColor(red: 0.8, green: 0.3, blue: 1.0, alpha: 1.0).cgColor,     // Cosmic Purple
//            UIColor(red: 1.0, green: 0.5, blue: 0.8, alpha: 1.0).cgColor,     // Stellar Pink
//            UIColor(red: 0.3, green: 1.0, blue: 0.6, alpha: 1.0).cgColor      // Aurora Green
//        ]
    }
    
    func setupButtonStyles() {
        let buttons = [buttonFirst, buttonSecond, buttonThird]
        
        // Ultra premium space colors for buttons
        let spaceColorSets: [[UIColor]] = [
            [
                // Button 1: Quantum Blue Set
                UIColor(red: 0.0, green: 0.7, blue: 1.0, alpha: 1.0),    // Quantum Cyan
                UIColor(red: 0.2, green: 0.5, blue: 0.9, alpha: 1.0),    // Electric Blue
                UIColor(red: 0.1, green: 0.8, blue: 0.9, alpha: 1.0),    // Azure Glow
                UIColor(red: 0.0, green: 0.9, blue: 0.8, alpha: 1.0),    // Turquoise Energy
                UIColor(red: 0.3, green: 0.6, blue: 1.0, alpha: 1.0)     // Sky Blue
            ],
            [
                // Button 2: Cosmic Purple Set
                UIColor(red: 0.6, green: 0.2, blue: 1.0, alpha: 1.0),    // Cosmic Purple
                UIColor(red: 0.8, green: 0.3, blue: 0.9, alpha: 1.0),    // Violet Energy
                UIColor(red: 0.5, green: 0.1, blue: 0.8, alpha: 1.0),    // Deep Violet
                UIColor(red: 0.9, green: 0.4, blue: 0.8, alpha: 1.0),    // Magenta Glow
                UIColor(red: 0.7, green: 0.0, blue: 1.0, alpha: 1.0)     // Pure Purple
            ],
            [
                // Button 3: Stellar Pink Set
                UIColor(red: 1.0, green: 0.3, blue: 0.6, alpha: 1.0),    // Stellar Pink
                UIColor(red: 0.9, green: 0.5, blue: 0.7, alpha: 1.0),    // Rose Energy
                UIColor(red: 1.0, green: 0.2, blue: 0.5, alpha: 1.0),    // Hot Pink
                UIColor(red: 0.8, green: 0.4, blue: 0.9, alpha: 1.0),    // Pink Purple
                UIColor(red: 1.0, green: 0.1, blue: 0.4, alpha: 1.0)     // Crimson Glow
            ]
        ]
        
        for (index, button) in buttons.enumerated() {
            if let button = button {
                button.spaceColors = spaceColorSets[index]
                button.layer.cornerRadius = 20
                button.clipsToBounds = false
                button.setTitleColor(.white, for: .normal)
                button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .black)
                
                // Enhanced shadow for buttons
                button.layer.shadowColor = spaceColorSets[index][0].cgColor
                button.layer.shadowRadius = 15
                button.layer.shadowOpacity = 0.6
                button.layer.shadowOffset = CGSize(width: 0, height: 5)
                
                // Add subtle bounce animation
                let bounceAnimation = CABasicAnimation(keyPath: "transform.scale")
                bounceAnimation.fromValue = 1.0
                bounceAnimation.toValue = 1.02
                bounceAnimation.duration = 2.0
                bounceAnimation.autoreverses = true
                bounceAnimation.repeatCount = .infinity
                bounceAnimation.beginTime = CACurrentMediaTime() + Double(index) * 0.3
                button.layer.add(bounceAnimation, forKey: "subtleBounce")
            }
        }
    }
    
    func setupQuestionLabelStyle() {
        questionLabel.textAlignment = .center
        questionLabel.textColor = .white
        questionLabel.font = UIFont.systemFont(ofSize: 24, weight: .black)
        
        // Enhanced text shadow for better readability
        questionLabel.layer.shadowColor = UIColor(red: 0.0, green: 0.9, blue: 1.0, alpha: 1.0).cgColor
        questionLabel.layer.shadowRadius = 15
        questionLabel.layer.shadowOpacity = 1.0
        questionLabel.layer.shadowOffset = .zero
    }
    
    // Additional cosmic effects
    func triggerLevelUpEffect() {
        // Screen-wide level up celebration
        let levelUpLayer = CAEmitterLayer()
        levelUpLayer.emitterPosition = CGPoint(x: view.bounds.midX, y: view.bounds.minY)
        levelUpLayer.emitterSize = CGSize(width: view.bounds.width, height: 20)
        levelUpLayer.renderMode = .additive
        
        let levelUpParticle = CAEmitterCell()
        levelUpParticle.contents = createTwinklingStar().cgImage
        levelUpParticle.birthRate = 150
        levelUpParticle.lifetime = 3.0
        levelUpParticle.velocity = 120
        levelUpParticle.velocityRange = 60
        levelUpParticle.emissionLongitude = .pi / 2
        levelUpParticle.emissionRange = .pi / 6
        levelUpParticle.scale = 0.12
        levelUpParticle.scaleRange = 0.06
        levelUpParticle.alphaSpeed = -0.4
        levelUpParticle.color = UIColor(red: 1.0, green: 0.8, blue: 0.0, alpha: 1.0).cgColor
        
        levelUpLayer.emitterCells = [levelUpParticle]
        view.layer.addSublayer(levelUpLayer)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            levelUpLayer.removeFromSuperlayer()
        }
    }
    
    func createSpaceWarpTransition() {
        // Space warp effect between questions
        let warpLayer = CALayer()
        warpLayer.frame = view.bounds
        warpLayer.backgroundColor = UIColor.black.cgColor
        
        let warpMask = CAShapeLayer()
        let warpPath = UIBezierPath(ovalIn: CGRect(x: view.bounds.midX - 5, y: view.bounds.midY - 5, width: 10, height: 10))
        warpMask.path = warpPath.cgPath
        warpLayer.mask = warpMask
        
        view.layer.addSublayer(warpLayer)
        
        let expandAnimation = CABasicAnimation(keyPath: "path")
        expandAnimation.fromValue = warpPath.cgPath
        
        let expandedPath = UIBezierPath(ovalIn: view.bounds.insetBy(dx: -100, dy: -100))
        expandAnimation.toValue = expandedPath.cgPath
        expandAnimation.duration = 0.8
        expandAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        
        warpMask.add(expandAnimation, forKey: "warpExpand")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            warpLayer.removeFromSuperlayer()
        }
    }
}


//
//    private var viewModel: GameScreenViewModelProtocol!
//    private var coordinator: AppCoordinator!
//    var selectedExpressionType: MathExpression.ExpressionType?
//    private var neonQuestionLabel: NeonLabel!
//
//
//    init(viewModel: GameScreenViewModelProtocol!, coordinator: AppCoordinator!, selectedExpressionType: MathExpression.ExpressionType? = nil) {
//        self.viewModel = viewModel
//        self.coordinator = coordinator
//        self.selectedExpressionType = selectedExpressionType
//        super.init(nibName: "GameVC", bundle: nil)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        configureViewModel()
//        setupUIElements()
//        viewModel.startGame()
//        navigationItem.hidesBackButton = true
//    }
//
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        setupLabelStyles()
//        setupQuestionLabelStyle()
//        setupButtonStyles()
//        backgroundImage.frame = view.bounds
//        timeLabel.animateNeonBorder()
//    }
//
//    private func configureViewModel() {
//        if let expressionType = selectedExpressionType {
//            viewModel = GameScreenViewModel(delegate: self, expressionType: expressionType)
//        }
//    }
//
//    private func updateUI(question: String, answers: [String]) {
//        questionLabel.text = question
//        buttonFirst.setTitle(answers[0], for: .normal)
//        buttonSecond.setTitle(answers[1], for: .normal)
//        buttonThird.setTitle(answers[2], for: .normal)
//    }
//
//    private func handleAnswer(for button: UIButton) {
//        guard let selectedAnswer = button.title(for: .normal), let selectedAnswerInt = Int(selectedAnswer) else { return }
//        let isCorrect = viewModel.checkAnswer(selectedAnswer: selectedAnswerInt)
//        handleAnswerSelection(selectedButton: button, correct: isCorrect)
//    }
//
//    private func handleAnswerSelection(selectedButton: UIButton, correct: Bool) {
//        selectedButton.backgroundColor = correct ? UIColor.green : UIColor.red
//        [buttonFirst, buttonSecond, buttonThird].forEach { $0?.isEnabled = false }
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//            [self.buttonFirst, self.buttonSecond, self.buttonThird].forEach {
//                $0?.isEnabled = true
//                $0?.backgroundColor = UIColor(red: 255/255, green: 230/255, blue: 150/255, alpha: 1.0)
//            }
//            self.viewModel.nextQuestion()
//        }
//    }
//
//    @IBAction func answerFirstButton(_ sender: UIButton) {
//        handleAnswer(for: sender)
//    }
//
//    @IBAction func answerSecondButton(_ sender: UIButton) {
//        handleAnswer(for: sender)
//    }
//
//    @IBAction func answerThirdButton(_ sender: UIButton) {
//        handleAnswer(for: sender)
//    }
//
//}
//
//extension GameVC : GameScreenViewModelDelegate{
//
//    func onUpdateUI(questionText: String, answers: [String]) {
//        self.updateUI(question: questionText, answers: answers)
//    }
//
//    func onUpdateScore(score: Int) {
//        self.scoreLabel.text = "Score: \(score)"
//    }
//
//    func onUpdateTime(time: String) {
//        self.timeLabel.text = time
//    }
//
//    func onUpdateQuestionNumber(questionNumber: Int) {
//        self.questionNumberLabel.text = "\(questionNumber) / 10"
//    }
//
//    func onGameFinished(score: Int, expressionType: MathExpression.ExpressionType) {
//        coordinator.goToResult(score: "\(score)", expressionType: expressionType)
//    }
//
//}
//
//extension GameVC {
//
//    func setupUIElements() {
//        scoreLabel.text = "Score: 0"
//        questionNumberLabel.text = "1 / 10"
//        timeLabel.text = "60"
//        setupQuestionLabelStyle()
//    }
//
//    func setupLabelStyles() {
//        // Soru numarası için: Neon cyan border ve glow
//        questionNumberLabel.neonColor = UIColor(red: 0, green: 234/255, blue: 1, alpha: 1) // Neon cyan
//        questionNumberLabel.cornerRadius = 10
//        questionNumberLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
//
//        // Sayaç için: Neon mavi
//        timeLabel.neonColor = UIColor(red: 0, green: 180/255, blue: 255/255, alpha: 1) // Neon mavi
//
//        // Skor için: Modern, sade, uzay temalı
//        scoreLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
//        scoreLabel.textColor = UIColor(red: 0, green: 234/255, blue: 1, alpha: 1) // Neon cyan
//        scoreLabel.layer.shadowColor = UIColor(red: 0, green: 180/255, blue: 255/255, alpha: 1).cgColor
//        scoreLabel.layer.shadowRadius = 8
//        scoreLabel.layer.shadowOpacity = 0.7
//        scoreLabel.layer.shadowOffset = .zero
//        scoreLabel.backgroundColor = UIColor.clear
//    }
//
//    func setupQuestionLabelStyle() {
//        questionLabel.textAlignment = .center
//        questionLabel.textColor = .white
//    }
//
//    func setupButtonStyles() {
//        let buttonList = [buttonFirst, buttonSecond, buttonThird]
//        let premiumColors: [UIColor] = [
//            UIColor(red: 0, green: 234/255, blue: 1, alpha: 1), // Neon mavi
//            UIColor(red: 162/255, green: 89/255, blue: 1, alpha: 1), // Neon mor
//            UIColor(red: 1, green: 78/255, blue: 205/255, alpha: 1) // Neon pembe
//        ]
//        for button in buttonList {
//            button?.neonColors = premiumColors
//            button?.layer.cornerRadius = 18
//            button?.clipsToBounds = true
//            button?.setTitleColor(.white, for: .normal)
//            button?.titleLabel?.font = UIFont.systemFont(ofSize: 22, weight: .bold)
//        }
//    }
//}
