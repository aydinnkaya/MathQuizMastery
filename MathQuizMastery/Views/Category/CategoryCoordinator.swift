//
//  CategoryCoordinator.swift
//  MathQuizMastery
//
//  Created by Aydın KAYA on 10.05.2025.
//

import Foundation
import UIKit

protocol CategoryCoordinatorProtocol {
    func navigateToGameVC(with type: MathExpression.ExpressionType)
}

class CategoryCoordinator : CategoryCoordinatorProtocol {
    
    private weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController? = nil) {
        self.navigationController = navigationController
    }
    
    func navigateToGameVC(with type: MathExpression.ExpressionType) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let gameVC = storyBoard.instantiateViewController(withIdentifier: "GameVC") as? GameVC else { return }
        gameVC.selectedExpressionType = type
        navigationController?.pushViewController(gameVC, animated: true)
    }
    
}
