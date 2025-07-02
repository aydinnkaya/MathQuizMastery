//
//  ViewController.swift
//  MathQuizMastery
//
//  Created by AydınKaya on 9.01.2025.
//

import UIKit

class GameVC: UIViewController {
    @IBOutlet weak var questionNumberLabel: InfoLabel!
    @IBOutlet weak var questionLabel: QuestionLabel!
    @IBOutlet weak var buttonFirst: AnswerButton!
    @IBOutlet weak var buttonSecond: AnswerButton!
    @IBOutlet weak var timeLabel: TimerLabel!
    @IBOutlet weak var buttonThird: AnswerButton!
    @IBOutlet weak var scoreLabel: InfoLabel!
    
    @IBOutlet weak var backgroundImage: UIImageView!
    
    private let spaceBackgroundLayer = CAGradientLayer()
    private let nebulaLayer = CAGradientLayer()
    private let starFieldLayer = CAEmitterLayer()
    private let timeWarningLayer = CAShapeLayer()
    
    private var viewModel: GameScreenViewModelProtocol!
    private var coordinator: AppCoordinator!
    var selectedExpressionType: MathExpression.ExpressionType?
    
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
        setupProfessionalSpaceBackground()
        setupUIElements()
        setupTimeWarningEffect()
        viewModel.startGame()
        navigationItem.hidesBackButton = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateSpaceBackground()
        setupUIStyles()
        backgroundImage.frame = view.bounds
    }
    
    private func configureViewModel() {
        if let expressionType = selectedExpressionType {
            viewModel = GameScreenViewModel(delegate: self, expressionType: expressionType)
        }
    }
    
    
    private func setupProfessionalSpaceBackground() {
        view.backgroundColor = UIColor.Custom.backgroundDark1
        
        spaceBackgroundLayer.colors = UIColor.Custom.spaceBackgroundColors
        spaceBackgroundLayer.locations = [0.0, 0.4, 0.7, 1.0]
        spaceBackgroundLayer.startPoint = CGPoint(x: 0, y: 0)
        spaceBackgroundLayer.endPoint = CGPoint(x: 1, y: 1)
        view.layer.insertSublayer(spaceBackgroundLayer, at: 0)
        
        nebulaLayer.colors = UIColor.Custom.nebulaGradientColors
        nebulaLayer.locations = [0.0, 0.5, 1.0]
        nebulaLayer.startPoint = CGPoint(x: 0.2, y: 0.2)
        nebulaLayer.endPoint = CGPoint(x: 0.8, y: 0.8)
        view.layer.insertSublayer(nebulaLayer, above: spaceBackgroundLayer)
        
        setupStarField()
    }
    
    private func setupStarField() {
        starFieldLayer.emitterPosition = CGPoint(x: 200, y: 0)
        starFieldLayer.emitterSize = CGSize(width: 400, height: 900)
        starFieldLayer.renderMode = .additive
        
        let star = CAEmitterCell()
        star.contents = createStar().cgImage
        star.birthRate = 25
        star.lifetime = Float.infinity
        star.velocity = 0
        star.emissionRange = .pi * 2
        star.scale = 0.4
        star.scaleRange = 0.3
        star.alphaRange = 0.6
        star.color = UIColor.Custom.starFieldColor
        
        starFieldLayer.emitterCells = [star]
        view.layer.insertSublayer(starFieldLayer, above: nebulaLayer)
    }
    
    private func createStar() -> UIImage {
        let size = CGSize(width: 3, height: 3)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let context = UIGraphicsGetCurrentContext()!
        
        context.setFillColor(UIColor.white.cgColor)
        context.fillEllipse(in: CGRect(origin: .zero, size: size))
        
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
    private func setupTimeWarningEffect() {
        timeWarningLayer.fillColor = UIColor.clear.cgColor
        timeWarningLayer.strokeColor = UIColor.Custom.timeWarningStrokeColor
        timeWarningLayer.lineWidth = 6
        timeWarningLayer.opacity = 0
        view.layer.addSublayer(timeWarningLayer)
    }
    
    private func updateSpaceBackground() {
        spaceBackgroundLayer.frame = view.bounds
        nebulaLayer.frame = view.bounds
        starFieldLayer.frame = view.bounds
        starFieldLayer.emitterPosition = CGPoint(x: view.bounds.midX, y: 0)
        
        let warningPath = UIBezierPath()
        warningPath.move(to: CGPoint(x: 20, y: view.bounds.height - 20))
        warningPath.addLine(to: CGPoint(x: view.bounds.width - 20, y: view.bounds.height - 20))
        timeWarningLayer.path = warningPath.cgPath
    }
    
    private func updateUI(question: String, answers: [String]) {
        questionLabel.animateTextChange(newText: question)
        
        UIView.animate(withDuration: 0.3) {
            self.buttonFirst.setTitle(answers[0], for: .normal)
            self.buttonSecond.setTitle(answers[1], for: .normal)
            self.buttonThird.setTitle(answers[2], for: .normal)
        }
    }
    
    private func handleAnswer(for button: AnswerButton) {
        guard let selectedAnswer = button.title(for: .normal), let selectedAnswerInt = Int(selectedAnswer) else { return }
        let isCorrect = viewModel.checkAnswer(selectedAnswer: selectedAnswerInt)
        handleAnswerSelection(selectedButton: button, correct: isCorrect)
    }
    
    private func handleAnswerSelection(selectedButton: AnswerButton, correct: Bool) {
        [buttonFirst, buttonSecond, buttonThird].forEach { $0?.isEnabled = false }
        
        if correct {
            selectedButton.triggerCorrectAnswer()
            showCorrectAnswerEffect()
        } else {
            selectedButton.triggerWrongAnswer()
            showWrongAnswerEffect()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            [self.buttonFirst, self.buttonSecond, self.buttonThird].forEach { button in
                button?.isEnabled = true
                button?.resetToNormal()
            }
            self.viewModel.nextQuestion()
        }
    }
    
    private func showCorrectAnswerEffect() {
        let successLayer = CALayer()
        successLayer.frame = view.bounds
        successLayer.backgroundColor = UIColor.Custom.successEffectBackground
        view.layer.addSublayer(successLayer)
        
        let fadeAnimation = CABasicAnimation(keyPath: "opacity")
        fadeAnimation.fromValue = 1.0
        fadeAnimation.toValue = 0.0
        fadeAnimation.duration = 0.8
        successLayer.add(fadeAnimation, forKey: "fade")
        
        let successEmitter = CAEmitterLayer()
        successEmitter.emitterPosition = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
        successEmitter.emitterSize = CGSize(width: 50, height: 50)
        
        let successParticle = CAEmitterCell()
        successParticle.contents = UIColor.Custom.successParticleColor
        successParticle.birthRate = 50
        successParticle.lifetime = 1.0
        successParticle.velocity = 100
        successParticle.velocityRange = 50
        successParticle.emissionRange = .pi * 2
        successParticle.scale = 0.5
        successParticle.scaleRange = 0.3
        successParticle.alphaSpeed = -1.0
        
        successEmitter.emitterCells = [successParticle]
        view.layer.addSublayer(successEmitter)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            successLayer.removeFromSuperlayer()
            successEmitter.removeFromSuperlayer()
        }
    }
    
    private func showWrongAnswerEffect() {
        let shakeAnimation = CABasicAnimation(keyPath: "transform.translation.x")
        shakeAnimation.fromValue = -10
        shakeAnimation.toValue = 10
        shakeAnimation.duration = 0.08
        shakeAnimation.autoreverses = true
        shakeAnimation.repeatCount = 4
        view.layer.add(shakeAnimation, forKey: "shake")
        
        let errorLayer = CALayer()
        errorLayer.frame = view.bounds
        errorLayer.backgroundColor = UIColor.Custom.wrongEffectBackground
        view.layer.addSublayer(errorLayer)
        
        let fadeAnimation = CABasicAnimation(keyPath: "opacity")
        fadeAnimation.fromValue = 1.0
        fadeAnimation.toValue = 0.0
        fadeAnimation.duration = 0.6
        errorLayer.add(fadeAnimation, forKey: "fade")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            errorLayer.removeFromSuperlayer()
        }
    }
    
    private func triggerTimeWarningEffect() {
        let pulseAnimation = CABasicAnimation(keyPath: "opacity")
        pulseAnimation.fromValue = 0.0
        pulseAnimation.toValue = 1.0
        pulseAnimation.duration = 0.5
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = .infinity
        timeWarningLayer.add(pulseAnimation, forKey: "timeWarning")
    }
    
    private func stopTimeWarningEffect() {
        timeWarningLayer.removeAnimation(forKey: "timeWarning")
        timeWarningLayer.opacity = 0
    }
    
    @IBAction func answerFirstButton(_ sender: AnswerButton) {
        handleAnswer(for: sender)
    }
    
    @IBAction func answerSecondButton(_ sender: AnswerButton) {
        handleAnswer(for: sender)
    }
    
    @IBAction func answerThirdButton(_ sender: AnswerButton) {
        handleAnswer(for: sender)
    }
}

// MARK: - GameScreenViewModelDelegate
extension GameVC : GameScreenViewModelDelegate {
    
    func onUpdateUI(questionText: String, answers: [String]) {
        self.updateUI(question: questionText, answers: answers)
    }
    
    func onUpdateScore(score: Int) {
        scoreLabel.animateTextChange(newText: "Score: \(score)")
        scoreLabel.activateHighlight()
    }
    
    func onUpdateTime(time: String) {
        timeLabel.animateTextChange(newText: time)
        
        if let timeInt = Int(time) {
            if timeInt <= 10 && timeInt > 0 {
                timeLabel.triggerWarning()
               // triggerTimeWarningEffect()
            } else {
                timeLabel.resetToNormal()
                stopTimeWarningEffect()
            }
        }
    }
    
    func onUpdateQuestionNumber(questionNumber: Int) {
        questionNumberLabel.animateTextChange(newText: "\(questionNumber) / 10")
    }
    
    func onGameFinished(score: Int, expressionType: MathExpression.ExpressionType) {
        showGameFinishEffect(score: score)
        
            self.coordinator.goToResult(score: "\(score)", expressionType: expressionType)
    }
    
    private func showGameFinishEffect(score: Int) {
        let finishLayer = CAGradientLayer()
        finishLayer.frame = view.bounds
        
        if score >= 8 {
            finishLayer.colors = UIColor.Custom.finishEffectColorsHigh
        } else if score >= 6 {
            finishLayer.colors = UIColor.Custom.finishEffectColorsMedium
        } else {
            finishLayer.colors = UIColor.Custom.finishEffectColorsLow
        }
        
        view.layer.addSublayer(finishLayer)
        
        let pulseAnimation = CABasicAnimation(keyPath: "opacity")
        pulseAnimation.fromValue = 0.0
        pulseAnimation.toValue = 1.0
        pulseAnimation.duration = 0.6
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = 4
        finishLayer.add(pulseAnimation, forKey: "pulse")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            finishLayer.removeFromSuperlayer()
        }
    }
    
    
    func onStartCountdownAnimation() {
        // Hangi animasyonu kullanmak istiyorsanız burada belirtin:
        
        setupVibrantRocketLaunchAnimation()
        // Seçenek 1: Uzay aracı fırlatma
      // startCountdownAnimation(type: .spaceshipLaunch)
        
        // Seçenek 2: Wormhole portal
        //startCountdownAnimation(type: .wormhole)
        
        // Seçenek 3: Asteroid belt
    //   startCountdownAnimation(type: .asteroidBelt)
        
        // Seçenek 4: Kozmik fırtına
      // startCountdownAnimation(type: .cosmicStorm)
        
        // Titreşim efekti de eklenebilir
        let impactFeedback = UIImpactFeedbackGenerator(style: .heavy)
        impactFeedback.impactOccurred()
    }
    
}

// MARK: - GameVC Extension for Countdown Animations
extension GameVC {

    private func setupVibrantRocketLaunchAnimation() {
        let spaceshipContainer = UIView()
        spaceshipContainer.frame = CGRect(x: view.bounds.width / 2 - 40, y: view.bounds.height + 200, width: 80, height: 200)
        view.addSubview(spaceshipContainer)
        
        // 🛡️ Roket gövdesi (parlak beyaz gövde, dar ve uzun)
        let rocketBody = CAShapeLayer()
        let bodyPath = UIBezierPath()
        bodyPath.move(to: CGPoint(x: 35, y: 170))
        bodyPath.addLine(to: CGPoint(x: 45, y: 170))
        bodyPath.addLine(to: CGPoint(x: 50, y: 100))
        bodyPath.addLine(to: CGPoint(x: 45, y: 40))
        bodyPath.addLine(to: CGPoint(x: 40, y: 10))  // burun
        bodyPath.addLine(to: CGPoint(x: 35, y: 40))
        bodyPath.addLine(to: CGPoint(x: 30, y: 100))
        bodyPath.close()
        
        rocketBody.path = bodyPath.cgPath
        rocketBody.fillColor = UIColor.white.cgColor
        rocketBody.strokeColor = UIColor.red.cgColor
        rocketBody.lineWidth = 2
        spaceshipContainer.layer.addSublayer(rocketBody)
        
        // 🟥 Kanatlar (canlı kırmızı, daha büyük üçgen şekiller)
        let leftFin = CAShapeLayer()
        let leftFinPath = UIBezierPath()
        leftFinPath.move(to: CGPoint(x: 30, y: 100))
        leftFinPath.addLine(to: CGPoint(x: 10, y: 130))
        leftFinPath.addLine(to: CGPoint(x: 30, y: 140))
        leftFinPath.close()
        leftFin.path = leftFinPath.cgPath
        leftFin.fillColor = UIColor.red.cgColor
        spaceshipContainer.layer.addSublayer(leftFin)

        let rightFin = CAShapeLayer()
        let rightFinPath = UIBezierPath()
        rightFinPath.move(to: CGPoint(x: 50, y: 100))
        rightFinPath.addLine(to: CGPoint(x: 70, y: 130))
        rightFinPath.addLine(to: CGPoint(x: 50, y: 140))
        rightFinPath.close()
        rightFin.path = rightFinPath.cgPath
        rightFin.fillColor = UIColor.red.cgColor
        spaceshipContainer.layer.addSublayer(rightFin)
        
        // 🔵 Cam (parlak mavi)
        let cockpit = CAShapeLayer()
        let cockpitPath = UIBezierPath(ovalIn: CGRect(x: 38, y: 25, width: 8, height: 8))
        cockpit.path = cockpitPath.cgPath
        cockpit.fillColor = UIColor.systemBlue.cgColor
        cockpit.shadowColor = UIColor.white.cgColor
        cockpit.shadowRadius = 3
        cockpit.shadowOpacity = 0.8
        cockpit.shadowOffset = .zero
        spaceshipContainer.layer.addSublayer(cockpit)

        // 🔥 Alevler – Üç katmanlı
        let flameRed = CAShapeLayer()
        let flameRedPath = UIBezierPath()
        flameRedPath.move(to: CGPoint(x: 35, y: 170))
        flameRedPath.addLine(to: CGPoint(x: 45, y: 170))
        flameRedPath.addLine(to: CGPoint(x: 40, y: 200))
        flameRedPath.close()
        flameRed.path = flameRedPath.cgPath
        flameRed.fillColor = UIColor.red.cgColor
        spaceshipContainer.layer.addSublayer(flameRed)

        let flameYellow = CAShapeLayer()
        let flameYellowPath = UIBezierPath()
        flameYellowPath.move(to: CGPoint(x: 36, y: 170))
        flameYellowPath.addLine(to: CGPoint(x: 44, y: 170))
        flameYellowPath.addLine(to: CGPoint(x: 40, y: 190))
        flameYellowPath.close()
        flameYellow.path = flameYellowPath.cgPath
        flameYellow.fillColor = UIColor.yellow.cgColor
        spaceshipContainer.layer.addSublayer(flameYellow)

        let flameBlue = CAShapeLayer()
        let flameBluePath = UIBezierPath()
        flameBluePath.move(to: CGPoint(x: 37, y: 170))
        flameBluePath.addLine(to: CGPoint(x: 43, y: 170))
        flameBluePath.addLine(to: CGPoint(x: 40, y: 185))
        flameBluePath.close()
        flameBlue.path = flameBluePath.cgPath
        flameBlue.fillColor = UIColor.systemBlue.cgColor
        spaceshipContainer.layer.addSublayer(flameBlue)

        // ✨ Alev parlaması animasyonu
        let flicker = CABasicAnimation(keyPath: "opacity")
        flicker.fromValue = 0.5
        flicker.toValue = 1.0
        flicker.duration = 0.1
        flicker.autoreverses = true
        flicker.repeatCount = .infinity
        flameRed.add(flicker, forKey: "flicker")
        flameYellow.add(flicker, forKey: "flicker")
        flameBlue.add(flicker, forKey: "flicker")

        // ✨ Kıvılcım efektleri (altın sarısı)
        let sparkEmitter = CAEmitterLayer()
        sparkEmitter.emitterPosition = CGPoint(x: 40, y: 170)
        sparkEmitter.emitterShape = .point

        let sparkCell = CAEmitterCell()
        sparkCell.birthRate = 120
        sparkCell.lifetime = 0.6
        sparkCell.velocity = 60
        sparkCell.velocityRange = 30
        sparkCell.emissionRange = .pi / 3
        sparkCell.scale = 0.025
        sparkCell.scaleRange = 0.01
        sparkCell.color = UIColor.yellow.cgColor
        sparkCell.contents = UIImage(systemName: "sparkle")?.withTintColor(.yellow).cgImage

        sparkEmitter.emitterCells = [sparkCell]
        spaceshipContainer.layer.addSublayer(sparkEmitter)

        // 📳 Haptic feedback
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.prepare()
        generator.impactOccurred()

        // 📱 Ekran sarsıntısı (shake)
        let shake = CAKeyframeAnimation(keyPath: "transform.translation.x")
        shake.values = [-5, 5, -4, 4, -2, 2, 0]
        shake.duration = 0.4
        view.layer.add(shake, forKey: "shake")

        // 🚀 Fırlatma animasyonu
        UIView.animate(withDuration: 6.0, delay: 0, options: [.curveEaseOut], animations: {
            spaceshipContainer.transform = CGAffineTransform(translationX: 0, y: -self.view.bounds.height - 300).rotated(by: CGFloat.pi / 40)
            spaceshipContainer.alpha = 0
        }) { _ in
            spaceshipContainer.removeFromSuperview()
            sparkEmitter.removeFromSuperlayer()
        }
    }


    // MARK: - Animasyon 1: Uzay Aracı Fırlatma
    private func setupSpaceshipLaunchAnimation() {
        let spaceshipContainer = UIView()
        spaceshipContainer.frame = CGRect(x: view.bounds.width/2 - 30, y: view.bounds.height + 100, width: 90, height: 180)
        view.addSubview(spaceshipContainer)
        
        // Uzay aracı gövdesi
        let rocketBody = CAShapeLayer()
        let bodyPath = UIBezierPath()
        bodyPath.move(to: CGPoint(x: 20, y: 100))
        bodyPath.addLine(to: CGPoint(x: 40, y: 100))
        bodyPath.addLine(to: CGPoint(x: 45, y: 60))
        bodyPath.addLine(to: CGPoint(x: 40, y: 20))
        bodyPath.addLine(to: CGPoint(x: 30, y: 5))
        bodyPath.addLine(to: CGPoint(x: 20, y: 20))
        bodyPath.addLine(to: CGPoint(x: 15, y: 60))
        bodyPath.close()
        
        rocketBody.path = bodyPath.cgPath
        rocketBody.fillColor = UIColor.systemOrange.cgColor
        rocketBody.strokeColor = UIColor.purple.cgColor
        rocketBody.lineWidth = 2
        spaceshipContainer.layer.addSublayer(rocketBody)
        
        // Roket alevi
        let flame = CAShapeLayer()
        let flamePath = UIBezierPath()
        flamePath.move(to: CGPoint(x: 25, y: 100))
        flamePath.addLine(to: CGPoint(x: 35, y: 100))
        flamePath.addLine(to: CGPoint(x: 30, y: 120))
        flamePath.close()
        
        flame.path = flamePath.cgPath
        flame.fillColor = UIColor.systemRed.cgColor
        spaceshipContainer.layer.addSublayer(flame)
        
        // Alev animasyonu
        let flameFlicker = CABasicAnimation(keyPath: "opacity")
        flameFlicker.fromValue = 0.3
        flameFlicker.toValue = 1.0
        flameFlicker.duration = 0.1
        flameFlicker.autoreverses = true
        flameFlicker.repeatCount = .infinity
        flame.add(flameFlicker, forKey: "flicker")
        
        // Fırlatma animasyonu
        UIView.animate(withDuration: 10.0, delay: 0, options: [.curveEaseIn], animations: {
            spaceshipContainer.transform = CGAffineTransform(translationX: 0, y: -self.view.bounds.height - 200)
            spaceshipContainer.alpha = 0.0
        }) { _ in
            spaceshipContainer.removeFromSuperview()
        }
        
        // Titreşim efekti
        let shake = CABasicAnimation(keyPath: "transform.translation.x")
        shake.fromValue = -2
        shake.toValue = 2
        shake.duration = 0.05
        shake.autoreverses = true
        shake.repeatCount = .infinity
        spaceshipContainer.layer.add(shake, forKey: "shake")
    }
    
    // MARK: - Animasyon 2: Wormhole Portal
    private func setupWormholeAnimation() {
        let portalContainer = UIView()
        portalContainer.frame = CGRect(x: view.bounds.width/2 - 75, y: view.bounds.height - 200, width: 150, height: 150)
        view.addSubview(portalContainer)
        
        // Ana portal halkası
        let portalRing1 = CAShapeLayer()
        portalRing1.path = UIBezierPath(ovalIn: CGRect(x: 10, y: 10, width: 130, height: 130)).cgPath
        portalRing1.fillColor = UIColor.clear.cgColor
        portalRing1.strokeColor = UIColor.systemPurple.withAlphaComponent(0.8).cgColor
        portalRing1.lineWidth = 4
        portalContainer.layer.addSublayer(portalRing1)
        
        let portalRing2 = CAShapeLayer()
        portalRing2.path = UIBezierPath(ovalIn: CGRect(x: 25, y: 25, width: 100, height: 100)).cgPath
        portalRing2.fillColor = UIColor.clear.cgColor
        portalRing2.strokeColor = UIColor.systemBlue.withAlphaComponent(0.6).cgColor
        portalRing2.lineWidth = 3
        portalContainer.layer.addSublayer(portalRing2)
        
        let portalRing3 = CAShapeLayer()
        portalRing3.path = UIBezierPath(ovalIn: CGRect(x: 40, y: 40, width: 70, height: 70)).cgPath
        portalRing3.fillColor = UIColor.clear.cgColor
        portalRing3.strokeColor = UIColor.systemTeal.withAlphaComponent(0.4).cgColor
        portalRing3.lineWidth = 2
        portalContainer.layer.addSublayer(portalRing3)
        
        // Portal merkezi
        let portalCenter = CAShapeLayer()
        portalCenter.path = UIBezierPath(ovalIn: CGRect(x: 60, y: 60, width: 30, height: 30)).cgPath
        portalCenter.fillColor = UIColor.white.withAlphaComponent(0.9).cgColor
        portalContainer.layer.addSublayer(portalCenter)
        
        // Dönme animasyonları
        let rotation1 = CABasicAnimation(keyPath: "transform.rotation")
        rotation1.fromValue = 0
        rotation1.toValue = Double.pi * 2
        rotation1.duration = 3.0
        rotation1.repeatCount = .infinity
        portalRing1.add(rotation1, forKey: "rotate1")
        
        let rotation2 = CABasicAnimation(keyPath: "transform.rotation")
        rotation2.fromValue = 0
        rotation2.toValue = -Double.pi * 2
        rotation2.duration = 2.0
        rotation2.repeatCount = .infinity
        portalRing2.add(rotation2, forKey: "rotate2")
        
        let rotation3 = CABasicAnimation(keyPath: "transform.rotation")
        rotation3.fromValue = 0
        rotation3.toValue = Double.pi * 2
        rotation3.duration = 1.5
        rotation3.repeatCount = .infinity
        portalRing3.add(rotation3, forKey: "rotate3")
        
        // Portal büyüme animasyonu
        UIView.animate(withDuration: 10.0, animations: {
            portalContainer.transform = CGAffineTransform(scaleX: 3.0, y: 3.0)
            portalContainer.alpha = 0.0
        }) { _ in
            portalContainer.removeFromSuperview()
        }
        
        // Parçacık efekti
        addPortalParticles(to: portalContainer)
    }
    
    private func addPortalParticles(to container: UIView) {
        let particleEmitter = CAEmitterLayer()
        particleEmitter.emitterPosition = CGPoint(x: 75, y: 75)
        particleEmitter.emitterSize = CGSize(width: 150, height: 150)
        particleEmitter.renderMode = .additive
        
        let particle = CAEmitterCell()
        particle.contents = UIImage(systemName: "star.fill")?.cgImage
        particle.birthRate = 20
        particle.lifetime = 2.0
        particle.velocity = 50
        particle.velocityRange = 30
        particle.emissionRange = .pi * 2
        particle.scale = 0.3
        particle.scaleRange = 0.2
        particle.alphaSpeed = -0.5
        particle.color = UIColor.systemPurple.cgColor
        
        particleEmitter.emitterCells = [particle]
        container.layer.addSublayer(particleEmitter)
    }
    
    // MARK: - Animasyon 3: Asteroid Belt Warning
    private func setupAsteroidBeltAnimation() {
        let asteroidContainer = UIView()
        asteroidContainer.frame = view.bounds
        view.addSubview(asteroidContainer)
        
        // Birden fazla asteroid oluştur
        for i in 0..<8 {
            let asteroid = createAsteroid()
            let startX = CGFloat.random(in: -100...view.bounds.width + 100)
            let startY = CGFloat.random(in: view.bounds.height + 50...view.bounds.height + 200)
            
            asteroid.frame = CGRect(x: startX, y: startY, width: 40, height: 40)
            asteroidContainer.addSubview(asteroid)
            
            // Asteroid hareketi
            UIView.animate(withDuration: Double.random(in: 8.0...12.0), delay: Double(i) * 0.5, options: [.curveLinear], animations: {
                asteroid.transform = CGAffineTransform(translationX: CGFloat.random(in: -200...200), y: -self.view.bounds.height - 300)
                asteroid.transform = asteroid.transform.rotated(by: CGFloat.random(in: 0...Double.pi * 4))
            }) { _ in
                asteroid.removeFromSuperview()
            }
        }
        
        // Container temizleme
        DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
            asteroidContainer.removeFromSuperview()
        }
    }
    
    private func createAsteroid() -> UIView {
        let asteroid = UIView()
        asteroid.backgroundColor = UIColor.systemBrown
        asteroid.layer.cornerRadius = 20
        
        // Asteroid detayları
        let crater1 = UIView()
        crater1.backgroundColor = UIColor.systemBrown.withAlphaComponent(0.5)
        crater1.layer.cornerRadius = 3
        crater1.frame = CGRect(x: 8, y: 10, width: 6, height: 6)
        asteroid.addSubview(crater1)
        
        let crater2 = UIView()
        crater2.backgroundColor = UIColor.systemBrown.withAlphaComponent(0.3)
        crater2.layer.cornerRadius = 4
        crater2.frame = CGRect(x: 20, y: 15, width: 8, height: 8)
        asteroid.addSubview(crater2)
        
        // Parıltı efekti
        let glow = CALayer()
        glow.frame = asteroid.bounds
        glow.cornerRadius = 20
        glow.backgroundColor = UIColor.systemOrange.withAlphaComponent(0.3).cgColor
        glow.shadowColor = UIColor.systemOrange.cgColor
        glow.shadowRadius = 10
        glow.shadowOpacity = 0.5
        asteroid.layer.insertSublayer(glow, at: 0)
        
        return asteroid
    }
    
    // MARK: - Animasyon 4: Cosmic Storm
    private func setupCosmicStormAnimation() {
        let stormContainer = UIView()
        stormContainer.frame = view.bounds
        view.addSubview(stormContainer)
        
        // Elektrik şimşekleri
        for i in 0..<5 {
            let lightning = createLightningBolt()
            let x = CGFloat.random(in: 0...view.bounds.width)
            lightning.frame = CGRect(x: x, y: view.bounds.height, width: 4, height: view.bounds.height)
            stormContainer.addSubview(lightning)
            
            // Şimşek animasyonu
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.5) {
                UIView.animate(withDuration: 0.3, animations: {
                    lightning.transform = CGAffineTransform(translationX: 0, y: -self.view.bounds.height)
                    lightning.alpha = 1.0
                }) { _ in
                    UIView.animate(withDuration: 0.2, animations: {
                        lightning.alpha = 0.0
                    }) { _ in
                        lightning.removeFromSuperview()
                    }
                }
            }
        }
        
        // Enerji dalgaları
        for i in 0..<3 {
            let wave = createEnergyWave()
            wave.center = CGPoint(x: view.bounds.width/2, y: view.bounds.height + 100)
            stormContainer.addSubview(wave)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 2.0) {
                UIView.animate(withDuration: 6.0, animations: {
                    wave.transform = CGAffineTransform(scaleX: 8.0, y: 8.0)
                    wave.alpha = 0.0
                }) { _ in
                    wave.removeFromSuperview()
                }
            }
        }
        
        // Container temizleme
        DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
            stormContainer.removeFromSuperview()
        }
    }
    
    private func createLightningBolt() -> UIView {
        let lightning = UIView()
        lightning.backgroundColor = UIColor.systemYellow
        lightning.alpha = 0.0
        
        // Şimşek efekti
        lightning.layer.shadowColor = UIColor.systemYellow.cgColor
        lightning.layer.shadowRadius = 15
        lightning.layer.shadowOpacity = 0.8
        
        return lightning
    }
    
    private func createEnergyWave() -> UIView {
        let wave = UIView()
        wave.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        wave.layer.cornerRadius = 50
        wave.layer.borderWidth = 3
        wave.layer.borderColor = UIColor.systemPurple.withAlphaComponent(0.6).cgColor
        wave.backgroundColor = UIColor.systemPurple.withAlphaComponent(0.1)
        
        return wave
    }
    
    // MARK: - Ana Fonksiyon - Animasyon Başlatıcı
    func startCountdownAnimation(type: CountdownAnimationType) {
        switch type {
        case .spaceshipLaunch:
            setupSpaceshipLaunchAnimation()
        case .wormhole:
            setupWormholeAnimation()
        case .asteroidBelt:
            setupAsteroidBeltAnimation()
        case .cosmicStorm:
            setupCosmicStormAnimation()
        }
    }
}

// MARK: - Countdown Animation Types
enum CountdownAnimationType {
    case spaceshipLaunch    // Uzay aracı fırlatma
    case wormhole          // Solucan deliği
    case asteroidBelt      // Asteroid kuşağı
    case cosmicStorm       // Kozmik fırtına
}


// MARK: - UI Setup
extension GameVC {
    
    func setupUIElements() {
        scoreLabel.text = "Score: 0"
        scoreLabel.cosmicTheme = .score
        
        questionNumberLabel.text = "1 / 10"
        questionNumberLabel.cosmicTheme = .questionNumber
        
        timeLabel.text = "60"
    }
    
    func setupUIStyles() {
        view.backgroundColor = UIColor.Custom.backgroundDark1
    }
}
