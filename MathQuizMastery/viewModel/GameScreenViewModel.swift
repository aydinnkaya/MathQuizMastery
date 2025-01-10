//
//  GameScreenViewModel.swift
//  MathQuizMastery
//
//  Created by AydınKaya on 9.01.2025.
//

import Foundation

class GameScreenViewModel{
    private(set) var expression : MathExpression
    private(set) var answers: [Int] = []
    private(set) var correctAnswer : Int = 0
    private(set) var score: Int = 0
    
    init() {
        self.expression = MathExpression.randomExpression()
        self.generateQuiz()
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
}
