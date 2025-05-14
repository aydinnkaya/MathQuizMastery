//
//  ViewController.swift
//  MathQuizMastery
//
//  Created by AydınKaya on 9.01.2025.
//

import UIKit

class GameVC: UIViewController {
    @IBOutlet weak var questionNumberLabel: NeonLabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var buttonFirst: NeonButton!
    @IBOutlet weak var buttonSecond: NeonButton!
    @IBOutlet weak var timeLabel: NeonCircleLabel!
    @IBOutlet weak var buttonThird: NeonButton!
    @IBOutlet weak var scoreLabel: NeonLabel!
    
    private var viewModel: GameScreenViewModelProtocol!
    var selectedExpressionType: MathExpression.ExpressionType?
    
    private var neonQuestionLabel: NeonLabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewModel()
        setupUIElements()
        viewModel.startGame()
        navigationItem.hidesBackButton = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupLabelStyles()
        setupQuestionLabelStyle()
        setupButtonStyles()
    }
    
    private func configureViewModel() {
        if let expressionType = selectedExpressionType {
            viewModel = GameScreenViewModel(delegate: self, expressionType: expressionType)
        }
    }
    
    private func updateUI(question: String, answers: [String]) {
        questionLabel.text = question
        buttonFirst.setTitle(answers[0], for: .normal)
        buttonSecond.setTitle(answers[1], for: .normal)
        buttonThird.setTitle(answers[2], for: .normal)
    }
    
    private func handleTimeUp() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let resultVC = storyboard.instantiateViewController(withIdentifier: "ResultVC") as? ResultVC {
            navigationController?.pushViewController(resultVC, animated: true)
        }
    }
    
    private func handleAnswer(for button: UIButton) {
        guard let selectedAnswer = button.title(for: .normal), let selectedAnswerInt = Int(selectedAnswer) else { return }
        let isCorrect = viewModel.checkAnswer(selectedAnswer: selectedAnswerInt)
        handleAnswerSelection(selectedButton: button, correct: isCorrect)
    }
    
    private func handleAnswerSelection(selectedButton: UIButton, correct: Bool) {
        selectedButton.backgroundColor = correct ? UIColor.green : UIColor.red
        [buttonFirst, buttonSecond, buttonThird].forEach { $0?.isEnabled = false }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            [self.buttonFirst, self.buttonSecond, self.buttonThird].forEach {
                $0?.isEnabled = true
                $0?.backgroundColor = UIColor(red: 255/255, green: 230/255, blue: 150/255, alpha: 1.0)
            }
            self.viewModel.nextQuestion()
        }
    }
    
    @IBAction func answerFirstButton(_ sender: UIButton) {
        handleAnswer(for: sender)
    }
    
    @IBAction func answerSecondButton(_ sender: UIButton) {
        handleAnswer(for: sender)
    }
    
    @IBAction func answerThirdButton(_ sender: UIButton) {
        handleAnswer(for: sender)
    }
    
    
}

extension GameVC : GameScreenViewModelDelegate{
    
    func onUpdateUI(questionText: String, answers: [String]) {
        self.updateUI(question: questionText, answers: answers)
    }
    
    func onUpdateScore(score: Int) {
        self.scoreLabel.text = "Score: \(score)"
    }
    
    func onUpdateTime(time: String) {
        self.timeLabel.text = time
    }
    
    func onUpdateQuestionNumber(questionNumber: Int) {
        self.questionNumberLabel.text = "\(questionNumber) / 10"
    }
    
    func onTimeUp() {
        self.handleTimeUp()
    }
    
}

extension GameVC {
    
    func setupUIElements() {
        scoreLabel.text = "Score: 0"
        questionNumberLabel.text = "1 / 10"
        timeLabel.text = "60"
        setupQuestionLabelStyle()
    }
    
    func setupLabelStyles() {
        questionNumberLabel.neonColor = UIColor.blue
        questionNumberLabel.cornerRadius = 8
        questionNumberLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        
        timeLabel.neonColor = UIColor.magenta
        timeLabel.layer.cornerRadius = timeLabel.frame.height / 2
        timeLabel.clipsToBounds = true
        
        scoreLabel.neonColor = UIColor(red: 0.96, green: 0.26, blue: 0.21, alpha: 1)
        scoreLabel.cornerRadius = 8
        scoreLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
    }
    
    func setupQuestionLabelStyle() {
        questionLabel.textAlignment = .center
        questionLabel.textColor = .white
    }
    
    func setupButtonStyles() {
        let buttonList = [buttonFirst, buttonSecond, buttonThird]
        
        for button in buttonList {
            button?.neonColors = [
                UIColor(red: 138/255, green: 43/255, blue: 226/255, alpha: 1),  // #8A2BE2 - BlueViolet
                UIColor(red: 0/255, green: 245/255, blue: 255/255, alpha: 1),   // #00F5FF - Electric Blue
                UIColor(red: 255/255, green: 0/255, blue: 255/255, alpha: 1)    // #FF00FF - Magenta
            ]
            button?.layer.cornerRadius = 15
            button?.layer.masksToBounds = true
            button?.layer.borderWidth = 2
            button?.layer.borderColor = UIColor.systemPink.cgColor
        }
    }
}



