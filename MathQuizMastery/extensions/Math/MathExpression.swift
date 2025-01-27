//
//  File.swift
//  MathQuizMastery
//
//  Created by AydınKaya on 9.01.2025.
//

import Foundation


struct MathExpression {
    enum Operation {
        case addition(Int, Int)
        case subtraction(Int, Int)
        case multiplication(Int, Int)
        case division(Int, Int)
        
        func createQuestion() -> String {
            switch self {
            case .addition(let a, let b):
                return "\(a) + \(b)"
            case .subtraction(let a, let b):
                return "\(a) - \(b)"
            case .multiplication(let a, let b):
                return "\(a) x \(b)"
            case .division(let a, let b):
                return "\(a) ÷ \(b)"
            }
        }
        
        func getAnswer() -> Int {
            switch self {
            case .addition(let a, let b):
                return a + b
            case .subtraction(let a, let b):
                return a - b
            case .multiplication(let a, let b):
                return  a * b
            case .division(let a, let b):
                return a / b
            }
        }
        
        private func getOperands() -> (Int, Int) {
            switch self {
            case .addition(let a, let b),
                    .subtraction(let a, let b),
                    .multiplication(let a, let b),
                    .division(let a, let b):
                return (a, b)
            }
        }
        
        
        func getExpressionType() -> MathExpression.ExpressionType {
            switch self {
            case .addition:
                return .addition
            case .subtraction:
                return .subtraction
            case .multiplication:
                return .multiplication
            case .division:
                return .division
            }
        }
        
    }
    
    
    enum ExpressionType {
        case addition
        case subtraction
        case multiplication
        case division
        case mixed
    }
    
    
    static func generateExpression(type: ExpressionType) -> Operation {
        switch type {
        case .addition:
            return generateAddition()
        case .subtraction:
            return generateSubtraction()
        case .multiplication:
            return generateMultiplication()
        case .division:
            return generateSafeDivision()
        case .mixed:
            return generateMixedExpression()
        }
    }
    
    
    private static func generateAddition() -> Operation {
        let a = Int.random(in: 0..<100)
        let b = Int.random(in: 0..<100)
        return .addition(a, b)
    }
    
    private static func generateSubtraction() -> Operation {
        let a = Int.random(in: 0..<100)
        let b = Int.random(in: 0..<100)
        return .subtraction(a, b)
    }
    
    
    private static func generateMultiplication() -> Operation {
        let a = Int.random(in: 0..<100)
        let b = Int.random(in: 0..<100)
        return .multiplication(a, b)
    }
    
    private static func generateSafeDivision() -> Operation {
        let divisor = Int.random(in: 1..<100)
        let quotient = Int.random(in: 1..<100)
        let dividend = divisor * quotient
        return .division(dividend, divisor)
    }
    
    
    private static func generateMixedExpression() -> Operation {
        let operations: [ExpressionType] = [.addition, .subtraction, .multiplication, .division]
        let randomType = operations.randomElement()!
        return generateExpression(type: randomType)
    }
    
    
}
