//
//  GameScreenViewModelProvider.swift
//  MathQuizMastery
//
//  Created by AydınKaya on 14.01.2025.
//

import Foundation
import UIKit

protocol GameScreenViewModelProtocol : AnyObject {
    var expression: MathExpression.Operation { get }
    var answers: [Int] { get }
    var correctAnswer: Int { get }
    var score: Int { get }
    var questionNumber: Int { get }
    
    func startGame()
    func nextQuestion()
    func checkAnswer(selectedAnswer: Int) -> Bool
  //  func setupButtonView(buttonFirst: UIButton, buttonSecond: UIButton, buttonThird: UIButton)
}
