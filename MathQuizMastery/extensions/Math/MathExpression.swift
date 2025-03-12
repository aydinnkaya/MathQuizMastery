//
//  MathExpression.swift
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
                return "\(a) × \(b)"
            case .division(let a, let b):
                return "\(a) ÷ \(b)"
            }
        }
        
        func getAnswer() -> Double {
            switch self {
            case .addition(let a, let b):
                return Double(a + b)
            case .subtraction(let a, let b):
                return Double(a - b)
            case .multiplication(let a, let b):
                return Double(a * b)
            case .division(let a, let b):
                return b != 0 ? Double(a) / Double(b) : 0.0
            }
        }
        
        func getExpressionType() -> ExpressionType {
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
    
    private static func generateOperands(range: Range<Int> = 0..<100) -> (Int, Int) {
        let a = Int.random(in: range)
        let b = Int.random(in: range)
        return (a, b)
    }
    
    private static func generateAddition() -> Operation {
        let (a, b) = generateOperands()
        return .addition(a, b)
    }
    
    private static func generateSubtraction() -> Operation {
        let (a, b) = generateOperands()
        return .subtraction(a, b)
    }
    
    private static func generateMultiplication() -> Operation {
        let (a, b) = generateOperands()
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
        guard let randomType = operations.randomElement() else {
            return generateAddition()
        }
        return generateExpression(type: randomType)
    }
}
