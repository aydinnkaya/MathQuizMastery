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
    
    var randomQuestionLabel:String?
    private var viewModel : GameScreenViewModel!
    private var stopWatch : StopWatch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 242/255, green: 238/255, blue: 230/255, alpha: 1.0)
        viewModel = GameScreenViewModel(questionView: questionView)
        viewModel?.setupButtonView(buttonFirst: buttonFirst, buttonSecond: buttonSecond, buttonThird: buttonThird)
      //  updateUI(question: viewModel.expression.getExpression(), answers: viewModel.answers)
            
        
        scoreLabel.text = "Score : O"
        questionNumberLabel.text = "1 /10"
        timeLabel.text = "01:00"
        stopWatch = StopWatch(gameScreen: self)
        stopWatch.startTimer()
    }
   
    private func updateUI(question: String, answers: [String]){
        questionLabel.text = question
        buttonFirst.setTitle("\(answers[0])", for: .normal)
        buttonSecond.setTitle("\(answers[1])", for: .normal)
        buttonThird.setTitle("\(answers[2])", for: .normal)
        
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
         //   self.updateUI(question: <#String#>, answers: <#[String]#>)
            self.updateScoreLabel()
            self.updateQuestionNumberLabel()
        }
    }
    
    func updateScoreLabel(){
        scoreLabel.text = String("Score: \(viewModel.score)")
    }
    
    func updateTimeLabel(timeString : String){
        timeLabel.text = timeString
    }
    
    func timeUp(){
        print("time up")
    }
    
    func updateQuestionNumberLabel(){
        self.viewModel.questionNumberUpdate()
        questionNumberLabel.text = String("\(viewModel.questionNumber) /10")
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

