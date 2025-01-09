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
    
    init() {
        self.expression = MathExpression.randomExpression()
        self.answers = [Int.random(in: 0..<100), Int.random(in: 0..<100), Int.random(in: 0..<100)]

    }
    
    
    private func generateWrongAnswers(correctAnswer: Int) -> [Int]{
        var wrongAnswers : [Int] = []
        
        while wrongAnswers.count < 2 {
            let randomWrongAnswer = correctAnswer + Int.random(in: -10...10)
            
            if randomWrongAnswer != correctAnswer && wrongAnswers.contains(randomWrongAnswer){
                wrongAnswers.append(randomWrongAnswer)
            }
        }
        
        return wrongAnswers
    }
    
    func generateQuiz (){
        let correctAnswer = expression.getAnswer()
        self.correctAnswer = correctAnswer
        
        
        var wrongAnswers = generateWrongAnswers(correctAnswer: correctAnswer)
        
        wrongAnswers.append(correctAnswer)
        wrongAnswers.shuffle()
        
        self.answers = wrongAnswers
    }
    
    
    func checkAnswer(selectedAnswer: Int) -> Bool {
        return selectedAnswer == correctAnswer
    }
}
