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
    let backImage = UIImage(named: "back_button")?.withRenderingMode(.alwaysOriginal)
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        goToLogin()
    }
    
    private func checkAuthentication() {
        guard let currentUser = Auth.auth().currentUser else {
            DispatchQueue.main.async { [weak self] in
                self?.goToLogin()
            }
            return
        }
        
        let uid = currentUser.uid
        
        AuthService.shared.fetchUserData(uid: uid) { [weak self] result in
            switch result {
            case .success(let user):
                DispatchQueue.main.async {
                    [weak self] in
                    guard let self else { return }
                    self.goToHome(with: user)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.goToLogin()
                }
            }
        }
    }
    
    // MARK: - Geçişler
    func goToLogin() {
        let viewModel =  LoginViewModel()
        let loginVC = LoginVC(viewModel:viewModel, coordinator: self)
        navigationController.setViewControllers([loginVC], animated: true)
    }
    
    func goToRegister() {
        let viewModel =  RegisterViewModel()
        let registerVC = RegisterVC(viewModel:viewModel, coordinator: self)
        
        navigationController.navigationBar.backIndicatorImage = backImage
        navigationController.navigationBar.backIndicatorTransitionMaskImage = backImage
        navigationController.topViewController?.navigationItem.backButtonTitle = ""
        navigationController.pushViewController(registerVC, animated: true)
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
    
    enum PopupType {
        case avatar
        case settings
    }
    
    func replacePopup(with popupType: PopupType) {
        if let presentedVC = navigationController.presentedViewController {
            presentedVC.dismiss(animated: true) { [weak self] in
                self?.presentPopup(popupType)
            }
        } else {
            presentPopup(popupType)
        }
    }
    
    private func presentPopup(_ type: PopupType) {
        switch type {
        case .avatar:
            self.goToAvatarPopup()
        case .settings:
            self.goToSettingsPopup()
        }
    }
    
    func dismissPopup() {
        navigationController.topViewController?.dismiss(animated: true, completion: nil)
    }
    
    func goToCategory() {
        let viewModel = CategoryViewModel()
        let categoryVC = CategoryVC(viewModel: viewModel, coordinator: self)
        navigationController.navigationBar.backIndicatorImage = backImage
        navigationController.navigationBar.backIndicatorTransitionMaskImage = backImage
        navigationController.topViewController?.navigationItem.backButtonTitle = ""
        navigationController.pushViewController(categoryVC, animated: true)
    }
    
    func goToGameVC(with type: MathExpression.ExpressionType) {
        let gameVC = GameVC(viewModel: nil, coordinator: self, selectedExpressionType: type)
        navigationController.pushViewController(gameVC, animated: true)
    }
    
    func goToResult(score: String, expressionType: MathExpression.ExpressionType) {
        guard let uid = Auth.auth().currentUser?.uid else {
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

