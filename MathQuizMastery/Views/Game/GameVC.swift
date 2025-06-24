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
                triggerTimeWarningEffect()
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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            self.coordinator.goToResult(score: "\(score)", expressionType: expressionType)
        }
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
