//
//  OperationType.swift
//  MathQuizMastery
//
//  Created by AydınKaya on 6.05.2025.
//

import Foundation

enum OperationType: Int {
    case add = 0
    case subtract
    case multiply
    case divide
    case random
    
    var title: String {
        switch self {
        case .add: return "Addition"
        case .subtract: return "Subtraction"
        case .multiply: return "Multiplication"
        case .divide: return "Division"
        case .random: return "Random"
        }
    }
    
    var soundFileName: String {
        switch self {
        case .add: return "addSound"
        case .subtract: return "subtractSound"
        case .multiply: return "multiplySound"
        case .divide: return "divideSound"
        case .random: return "randomSound"
        }
    }

    var expressionType: MathExpression.ExpressionType {
        switch self {
        case .add: return .addition
        case .subtract: return .subtraction
        case .multiply: return .multiplication
        case .divide: return .division
        case .random: return .random
        }
    }
}
