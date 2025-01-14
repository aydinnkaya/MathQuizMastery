//
//  ViewController.swift
//  MathQuizMastery
//
//  Created by AydınKaya on 9.01.2025.
//

import UIKit

class GameScreen: UIViewController {
    @IBOutlet weak var questionNumberLabel: UILabel!
    @IBOutlet weak var questionView: UIView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var buttonFirst: UIButton!
    @IBOutlet weak var buttonSecond: UIButton!
    
    @IBOutlet weak var buttonThird: UIButton!
    @IBOutlet weak var scoreLabel: UILabel!
    
    private var viewModel: GameScreenViewModelProtocol!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        viewModel.startGame()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(red: 242/255, green: 238/255, blue: 230/255, alpha: 1.0)
        setupQuestionView(questionView: questionView)
        viewModel = GameScreenViewModel()
        viewModel.setupButtonView(buttonFirst: buttonFirst, buttonSecond: buttonSecond, buttonThird: buttonThird)
        scoreLabel.text = "Score: 0"
        questionNumberLabel.text = "1 / 10"
        timeLabel.text = "01:00"
    }
    
    
    func setupQuestionView(questionView: UIView!){
        questionView.backgroundColor = UIColor(red: 210/255, green: 240/255, blue: 240/255, alpha: 1.0)
        questionView.layer.cornerRadius = 20
        questionView.layer.masksToBounds = false
        questionView.layer.shadowColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1.0).cgColor
        questionView.layer.shadowOffset = CGSize(width: 5, height: 5)
        questionView.layer.opacity = 0.4
        questionView.layer.shadowRadius = 8
        questionView.layer.borderWidth = 5
    }
    
    private func bindViewModel() {
        viewModel.onUpdateUI = { [weak self] question, answers in
            self?.updateUI(question: question, answers: answers)
        }
        
        viewModel.onUpdateScore = { [weak self] score in
            self?.scoreLabel.text = "Score: \(score)"
        }
        
        viewModel.onUpdateTime = { [weak self] timeString in
            self?.timeLabel.text = timeString
        }
        
        viewModel.onUpdateQuestionNumber = { [weak self] questionNumber in
            self?.questionNumberLabel.text = "\(questionNumber) / 10"
        }
        
        viewModel.onTimeUp = { [weak self] in
            self?.handleTimeUp()
        }
    }
    
    private func updateUI(question: String, answers: [String]) {
        questionLabel.text = question
        buttonFirst.setTitle(answers[0], for: .normal)
        buttonSecond.setTitle(answers[1], for: .normal)
        buttonThird.setTitle(answers[2], for: .normal)
    }
    
    private func handleTimeUp() {
        print("Time's up!")
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

