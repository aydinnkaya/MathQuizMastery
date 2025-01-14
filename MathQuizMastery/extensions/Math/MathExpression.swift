//
//  File.swift
//  MathQuizMastery
//
//  Created by AydınKaya on 9.01.2025.
//

import Foundation


enum MathExpression {
    case addition(Int,Int)
    case subtraction(Int, Int)
    
    func createQuestion() -> String {
        switch self {
        case .addition(let a, let b):
            return "\(a) + \(b)"
        case .subtraction(let a, let b):
            return "\(a) - \(b)"
        }
    }
    
    func getAnswer() -> Int {
        switch self {
        case .addition(let a, let b):
            return a + b
        case .subtraction(let a, let b):
            return a - b
        }
    }
    
    
    static func randomQuestionType() -> MathExpression {
        let randomType = Bool.random()
        let a = Int.random(in: 0..<100)
        let b = Int.random(in: 0..<100)
        
        if randomType {
            return .addition(a, b)
        } else {
            return .subtraction(a, b)
        }
    }
    
}
