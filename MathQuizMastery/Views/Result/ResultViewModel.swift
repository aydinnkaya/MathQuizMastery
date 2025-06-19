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
    func getCoinText() -> String
    func updateUserCoin()
}

protocol ResultViewModelDelegate : AnyObject{
    func navigateToHome()
    func navigateToCategory()
    func restartGame(with type: MathExpression.ExpressionType)
}

class ResultViewModel : ResultViewModelProtocol{
    
    private(set) var score: String
    var delegate : ResultViewModelDelegate?
    private let authService: AuthServiceProtocol
    private(set) var expressionType: MathExpression.ExpressionType
    private let userUID: String
    
    
    
    init(
        score: String,
        expressionType: MathExpression.ExpressionType,
        userUID: String,
        authService: AuthServiceProtocol = AuthService.shared
    ) {
        self.score = score
        self.expressionType = expressionType
        self.userUID = userUID
        self.authService = authService
        
        updateUserCoin()
    }
    func getScoreText() -> String {
        let format = L(.result_score_text)
        return String(format: format, String(describing: self.expressionType), score)
    }
    
    func getCoinText() -> String {
        return "\(score)"
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
    
    internal func updateUserCoin() {
        guard let scoreInt = Int(score) else {
            print("❌ Skor sayıya dönüştürülemedi.")
            return
        }
        
        authService.updateUserCoin(uid: userUID, by: scoreInt) { result in
            switch result {
            case .success:
                print("✅ Coin başarıyla güncellendi.")
            case .failure(let error):
                print("❌ Coin güncellenemedi: \(error.localizedDescription)")
            }
        }
    }
}
