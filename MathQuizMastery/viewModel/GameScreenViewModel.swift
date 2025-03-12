//
//  GameScreenViewModel.swift
//  MathQuizMastery
//
//  Created by AydınKaya on 9.01.2025.
//

import Foundation
import UIKit


protocol GameScreenViewModelDelegate : AnyObject { // AnyObject => Class
    func onUpdateUI(questionText: String, answers : [String])
    func onUpdateScore(score: Int)
    func onUpdateTime(time : String)
    func onUpdateQuestionNumber(questionNumber: Int)
    func onTimeUp()
    // func selectedExpression(expression: String)
    
}


class GameScreenViewModel : GameScreenViewModelProtocol {
    
    private(set) var expression: MathExpression.Operation
    private(set) var answers: [Int] = []
    private(set) var correctAnswer: Int = 0
    private(set) var score: Int = 0
    private(set) var questionNumber: Int = 1
    private var timer: Timer?
    private var timeRemaining: Int = 60
    
    
    weak var delegate : GameScreenViewModelDelegate? // *** Retain Cycle => çevrimsel bellek sızıntısını önlemek için weak kullanıyoruz.
    
    init(delegate: GameScreenViewModelDelegate, expressionType: MathExpression.ExpressionType) {
        self.delegate = delegate
        self.expression = MathExpression.generateExpression(type: expressionType)
        generateQuiz()
    }
    
    func startGame() {
        startTimer()
        delegate?.onUpdateUI(questionText: expression.createQuestion(), answers: answers.map { String($0) })
    }
    
    func nextQuestion() {
        if questionNumber < 10 {
            questionNumber += 1
            generateQuiz()
            delegate?.onUpdateQuestionNumber(questionNumber: questionNumber)
            delegate?.onUpdateUI(questionText: expression.createQuestion(), answers: answers.map { String($0) })
        } else {
            delegate?.onTimeUp()
        }
    }
    
    func generateQuiz() {
        self.expression = MathExpression.generateExpression(type: expression.getExpressionType())
        self.correctAnswer = Int(expression.getAnswer())
        
        var wrongAnswers = generateWrongAnswers(correctAnswer: correctAnswer)
        wrongAnswers.append(correctAnswer)
        self.answers = wrongAnswers.shuffled()
    }
    
    private func generateWrongAnswers(correctAnswer: Int) -> [Int] {
        var wrongAnswers: [Int] = []
        
        while wrongAnswers.count < 2 {
            let randomWrongAnswer = correctAnswer + Int.random(in: -10...10)
            if randomWrongAnswer != correctAnswer && !wrongAnswers.contains(randomWrongAnswer) {
                wrongAnswers.append(randomWrongAnswer)
            }
        }
        
        return wrongAnswers
    }
    
    func checkAnswer(selectedAnswer: Int) -> Bool {
        let isCorrect = selectedAnswer == correctAnswer
        
        if isCorrect{
            score += 1
        }else {
            score = max(0, score - 1)
        }
        delegate?.onUpdateScore(score: score)
        return isCorrect
    }
    
    private func startTimer() {
        timeRemaining = 60
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.timeRemaining -= 1
            let minutes = self.timeRemaining / 60
            let seconds = self.timeRemaining % 60
            delegate?.onUpdateTime(time: String(format: "%02d:%02d", minutes, seconds))
            
            if self.timeRemaining <= 0 {
                self.timer?.invalidate()
                delegate?.onTimeUp()
            }
        }
    }
    
//    func setupButtonView(buttonFirst: UIButton, buttonSecond :UIButton, buttonThird : UIButton){
//        let buttonList = [buttonFirst,buttonSecond,buttonThird]
//        
//        for b in buttonList {
//            b.isHidden = false
//            b.backgroundColor = UIColor(red: 255/255, green: 230/255, blue: 150/255, alpha: 1.0)
//            b.layer.cornerRadius = 25
//            b.layer.shadowColor = UIColor(red: 180/255, green: 180/255, blue: 180/255, alpha: 1.0).cgColor
//            b.layer.shadowOffset = CGSize(width: 3, height: 3)
//            b.layer.shadowOpacity = 0.6
//            b.layer.shadowRadius = 5
//        }
//        
//    }
    
}










