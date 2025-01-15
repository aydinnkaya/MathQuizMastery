//
//  GameScreenViewModelProvider.swift
//  MathQuizMastery
//
//  Created by AydınKaya on 14.01.2025.
//

import Foundation
import UIKit

protocol GameScreenViewModelProtocol {
    var expression: MathExpression.Operation { get }
    var answers: [Int] { get }
    var correctAnswer: Int { get }
    var score: Int { get }
    var questionNumber: Int { get }
    
    var onUpdateUI: ((String, [String]) -> Void)? { get set }
    var onUpdateScore: ((Int) -> Void)? { get set }
    var onUpdateTime: ((String) -> Void)? { get set }
    var onUpdateQuestionNumber: ((Int) -> Void)? { get set }
    var onTimeUp: (() -> Void)? { get set }
    
    func startGame()
    func nextQuestion()
    func checkAnswer(selectedAnswer: Int) -> Bool
    func setupButtonView(buttonFirst: UIButton, buttonSecond: UIButton, buttonThird: UIButton)
}
