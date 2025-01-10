//
//  ViewController.swift
//  MathQuizMastery
//
//  Created by AydınKaya on 9.01.2025.
//

import UIKit

class GameScreen: UIViewController {
    @IBOutlet weak var questionView: UIView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var buttonFirst: UIButton!
    @IBOutlet weak var buttonSecond: UIButton!
    @IBOutlet weak var buttonThird: UIButton!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    var randomQuestionLabel:String?
    private var viewModel : GameScreenViewModel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 242/255, green: 238/255, blue: 230/255, alpha: 1.0)
        setupQuestionView()
        setupButtonView()
        viewModel = GameScreenViewModel()
        loadQuestion()
        scoreLabel.text = "Score : O"
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupButtonView()
    }
    
    
    private func loadQuestion(){
        
        let expression = viewModel.expression.getExpression()
        let answers = viewModel.answers
        
        if answers.count == 3 {
            questionLabel.text = expression
            buttonFirst.setTitle("\(answers[0])", for: .normal)
            buttonSecond.setTitle("\(answers[1])", for: .normal)
            buttonThird.setTitle("\(answers[2])", for: .normal)
        } else {
            print("Hata: answers dizisinin boyutu 3 değil! : \(answers.count)")
        }
    }
    
    private func setupQuestionView(){
        questionView.backgroundColor = UIColor(red: 210/255, green: 240/255, blue: 240/255, alpha: 1.0)
        questionView.layer.cornerRadius = 20
        questionView.layer.masksToBounds = false
        questionView.layer.shadowColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1.0).cgColor
        questionView.layer.shadowOffset = CGSize(width: 5, height: 5)
        questionView.layer.opacity = 0.4
        questionView.layer.shadowRadius = 8
        questionView.layer.borderWidth = 5
    }
    
    private func setupButtonView(){
        let buttonList = [buttonFirst,buttonSecond,buttonThird]
        
        for b in buttonList {
            b?.isHidden = false
            b?.backgroundColor = UIColor(red: 255/255, green: 230/255, blue: 150/255, alpha: 1.0)
            b?.layer.cornerRadius = 25
            b?.layer.shadowColor = UIColor(red: 180/255, green: 180/255, blue: 180/255, alpha: 1.0).cgColor
            b?.layer.shadowOffset = CGSize(width: 3, height: 3)
            b?.layer.shadowOpacity = 0.6
            b?.layer.shadowRadius = 5
        }
        
    }
    
    func handleAnswerSelection(selectedButton: UIButton, correct: Bool){
        
        selectedButton.backgroundColor = correct ? UIColor.green : UIColor.red
        
        let buttons = [buttonFirst,buttonSecond, buttonThird]
        
        for button in buttons {
            button?.isEnabled = false
        }
        updateScoreLabel()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5 ){
            for button in buttons {
                button?.isEnabled = true
                button?.backgroundColor = UIColor(red: 255/255, green: 230/255, blue: 150/255, alpha: 1.0)
            }
            
            self.viewModel.generateQuiz()
            self.loadQuestion()
            self.updateScoreLabel()
        }
      
        
    }
    
    func updateScoreLabel(){
        scoreLabel.text = String("Score:\(viewModel.score)")
    }
    
    @IBAction func answerFirstButton(_ sender: UIButton) {
        guard let selectedAnswer = sender.title(for: .highlighted), let selectedAnswerInt = Int(selectedAnswer) else {return}
        let isCorrect = viewModel.checkAnswer(selectedAnswer: selectedAnswerInt)
        handleAnswerSelection(selectedButton: sender, correct: isCorrect)
        
    }
    
    @IBAction func answerSecondButton(_ sender: UIButton) {
        guard let selectedAnswer = sender.title(for: .highlighted), let selectedAnswerInt = Int(selectedAnswer) else {return}
        let isCorrect = viewModel.checkAnswer(selectedAnswer: selectedAnswerInt)
        handleAnswerSelection(selectedButton: sender, correct: isCorrect)
    }
    
    @IBAction func answerThirdButton(_ sender: UIButton) {
        
        guard let selectedAnswer = sender.title(for: .highlighted), let selectedAnswerInt = Int(selectedAnswer) else {return}
        let isCorrect = viewModel.checkAnswer(selectedAnswer: selectedAnswerInt)
        handleAnswerSelection(selectedButton: sender, correct: isCorrect)
    }
    
}

