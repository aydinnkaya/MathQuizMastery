//
//  ResultViewModel.swift
//  MathQuizMastery
//
//  Created by AydınKaya on 21.05.2025.
//

import Foundation

protocol ResultViewModelProtocol : AnyObject{
    var delegate: ResultViewModelDelegate? { get set }
    func handleHomeTapped()
    func handleCategoryTapped()
    func handleRestartTapped()
    func getScoreText() -> String
}

protocol ResultViewModelDelegate : AnyObject{
    func navigateToHome()
    func navigateToCategory()
    func restartGame(with type: MathExpression.ExpressionType)
}

class ResultViewModel : ResultViewModelProtocol{
    
    private(set) var score: String
    var delegate : ResultViewModelDelegate?
    private(set) var expressionType: MathExpression.ExpressionType

    
    init(delegate: ResultViewModelDelegate? = nil, score: String, expressionType: MathExpression.ExpressionType) {
        self.delegate = delegate
        self.score = score
        self.expressionType = expressionType
    }
    
    func getScoreText() -> String {
        return "\(self.expressionType) kategorisinde \(score) doğru cevap verdin!"
        }
    
    func handleHomeTapped() {
        delegate?.navigateToHome()
    }
    
    func handleCategoryTapped() {
        delegate?.navigateToCategory()
    }
    
    func handleRestartTapped() {
        delegate?.restartGame(with: expressionType)
    }
    
}
