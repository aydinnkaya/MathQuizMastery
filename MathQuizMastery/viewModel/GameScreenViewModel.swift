//
//  GameScreenViewModel.swift
//  MathQuizMastery
//
//  Created by AydınKaya on 9.01.2025.
//

import Foundation
import UIKit

class GameScreenViewModel{
    private(set) var expression : MathExpression
    private(set) var answers: [Int] = []
    private(set) var correctAnswer : Int = 0
    private(set) var score: Int = 0
    private(set) var questionNumber : Int = 1
    private let gameScreen = GameScreen()
    
    init(questionView: UIView!) {
        self.expression = MathExpression.randomExpression()
        self.generateQuiz()
        setupQuestionView(questionView: questionView)
    }
    
    
    private func generateWrongAnswers(correctAnswer: Int) -> [Int]{
        var wrongAnswers : [Int] = []
        
        while wrongAnswers.count < 2 {
            let randomWrongAnswer = correctAnswer + Int.random(in: -10...10)
            
            if randomWrongAnswer != correctAnswer && !wrongAnswers.contains(randomWrongAnswer) {
                wrongAnswers.append(randomWrongAnswer)
            }
        }
        
        return wrongAnswers
    }
    
    func generateQuiz(){
        self.expression = MathExpression.randomExpression()
        let correctAnswers = expression.getAnswer()
        self.correctAnswer = correctAnswers
        
        var wrongAnswers = generateWrongAnswers(correctAnswer: correctAnswers)
        
        wrongAnswers.append(correctAnswers)
        wrongAnswers.shuffle()
        
        self.answers = wrongAnswers
        print("Generated answers: \(answers)")
    }
    
    
    func checkAnswer(selectedAnswer: Int) -> Bool {
        let isCorrect = selectedAnswer == correctAnswer
        if isCorrect {
            score += 1
        }else {
            score = max(0, score-1)
        }
        return isCorrect
    }
    
    func questionNumberUpdate()  {
        if questionNumber < 10 {
            self.questionNumber += 1
        }
        else{
            
            
        }
       
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
    
    
    func setupButtonView(buttonFirst: UIButton, buttonSecond :UIButton, buttonThird : UIButton){
        let buttonList = [buttonFirst,buttonSecond,buttonThird]
        
        for b in buttonList {
            b.isHidden = false
            b.backgroundColor = UIColor(red: 255/255, green: 230/255, blue: 150/255, alpha: 1.0)
            b.layer.cornerRadius = 25
            b.layer.shadowColor = UIColor(red: 180/255, green: 180/255, blue: 180/255, alpha: 1.0).cgColor
            b.layer.shadowOffset = CGSize(width: 3, height: 3)
            b.layer.shadowOpacity = 0.6
            b.layer.shadowRadius = 5
        }
        
    }
    
    
    
}
