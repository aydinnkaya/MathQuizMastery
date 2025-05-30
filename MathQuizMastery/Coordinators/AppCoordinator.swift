//
//  AppCoordinator.swift
//  MathQuizMastery
//
//  Created by Aydın KAYA on 17.05.2025.
//

import Foundation
import UIKit
import FirebaseAuth

protocol Coordinator{
    var navigationController: UINavigationController { get set}
    func start()
}

class AppCoordinator : Coordinator {
   
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Uygulama Başlangıç Noktası
    func start() {
        checkAuthentication()
    }
    
    // MARK: - Giriş Kontrolü
    private func checkAuthentication() {
        if Auth.auth().currentUser == nil {
            goToLogin()
        } else {
            guard let uid = Auth.auth().currentUser?.uid else { return }
            AuthService.shared.fetchUserData(uid: uid) { [weak self] result in
                switch result {
                case .success(let user):
                    self?.goToHome(with: user)
                case .failure(let error):
                    print("Kullanıcı verisi alınamadı: \(error.localizedDescription)")
                    self?.goToLogin()
                }
            }
        }
    }
    
    // MARK: - Geçişler
    func goToLogin() {
        let loginVC = LoginVC(viewModel: LoginViewModel(), coordinator: self)
        navigationController.setViewControllers([loginVC], animated: false)
    }
    
    func goToHome(with user: User) {
        let homeVC = HomeVC(user: user, coordinator: self)
        navigationController.setViewControllers([homeVC], animated: false)
    }
    
    func goToAvatarPopup() {
        let viewModel = AvatarPopupViewModel()
        let avatarPopupVC = AvatarPopupVC(viewModel: viewModel, coordinator: self)
        avatarPopupVC.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        avatarPopupVC.modalPresentationStyle = .overFullScreen
        avatarPopupVC.modalTransitionStyle = .flipHorizontal
        navigationController.present(avatarPopupVC, animated: true, completion: nil)
    }
    
    func goToSettingsPopup() {
        let viewModel = SettingsPopupViewModel()
        let popupVC = SettingsPopupVC(viewModel: viewModel, coordinator: self)
        popupVC.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        popupVC.modalPresentationStyle = .overFullScreen
        popupVC.modalTransitionStyle = .flipHorizontal
        navigationController.present(popupVC, animated: true, completion: nil)
    }
    
    func dismissPopup() {
        navigationController.topViewController?.dismiss(animated: true, completion: nil)
    }
    
    func goToCategory() {
        let viewModel = CategoryViewModel()
        let categoryVC = CategoryVC(viewModel: viewModel, coordinator: self)
        navigationController.pushViewController(categoryVC, animated: true)
    }
    
    func goToGameVC(with type: MathExpression.ExpressionType) {
        let gameVC = GameVC(viewModel: nil, coordinator: self, selectedExpressionType: type)
        navigationController.pushViewController(gameVC, animated: true)
    }
    
    func goToResult(score: String, expressionType: MathExpression.ExpressionType) {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("❌ Kullanıcı UID bulunamadı.")
            return
        }
        
        let viewModel = ResultViewModel(
            score: score,
            expressionType: expressionType,
            userUID: uid
        )
        
        let resultVC = ResultVC(viewModel: viewModel, coordinator: self)
        viewModel.delegate = resultVC
        navigationController.pushViewController(resultVC, animated: true)
    }
    
    func goToHomeAfterResult() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        AuthService.shared.fetchUserData(uid: uid) { [weak self] result in
            switch result {
            case .success(let user):
                self?.goToHome(with: user)
            case .failure(let error):
                print("Home fetch failed: \(error.localizedDescription)")
            }
        }
    }
    
    func restartGame(with type: MathExpression.ExpressionType) {
        goToGameVC(with: type)
    }
    
}
