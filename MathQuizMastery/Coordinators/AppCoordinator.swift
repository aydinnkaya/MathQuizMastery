//
//  AppCoordinator.swift
//  MathQuizMastery
//
//  Created by Aydın KAYA on 17.05.2025.
//

import Foundation
import UIKit
import FirebaseAuth

protocol Coordinator {
    var navigationController: UINavigationController { get set }
    func start()
}

/// <#Description#>
enum PopupType {
    case settings
    case avatar
    case faq
    case notificationSettings
}

/// <#Description#>
class AppCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    let backImage = UIImage(named: "back_buttonsss")?.withRenderingMode(.alwaysOriginal)
    private var currentPopupViewController: UIViewController?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        checkAuthentication()
    }
    
    func checkAuthentication() {
        if let currentUser = Auth.auth().currentUser {
            let uid = currentUser.uid
            AuthService.shared.fetchUserData(uid: uid) { [weak self] result in
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    switch result {
                    case .success(let user):
                        self.goToHome(with: user)
                    case .failure(_):
                        self.goToLogin()
                    }
                }
            }
        } else {
            DispatchQueue.main.async { [weak self] in
                self?.goToLogin()
            }
        }
    }
    
    // MARK: - Geçişler
    func goToLogin() {
        let viewModel = LoginViewModel()
        let loginVC = LoginVC(viewModel: viewModel, coordinator: self)
        navigationController.setViewControllers([loginVC], animated: true)
    }
    
    func goToRegister() {
        let viewModel = RegisterViewModel()
        let registerVC = RegisterVC(viewModel: viewModel, coordinator: self)
        
        navigationController.navigationBar.backIndicatorImage = backImage
        navigationController.navigationBar.backIndicatorTransitionMaskImage = backImage
        navigationController.topViewController?.navigationItem.backButtonTitle = ""
        navigationController.pushViewController(registerVC, animated: true)
    }
    
    func handleRegistrationSuccess(user: AppUser) {
        // Add any additional logic needed after successful registration
        // For example: analytics tracking, welcome flow, etc.
        
        print("🎉 Registration successful for user: \(user.username)")
        
        // Navigate to home
        goToHome(with: user)
    }
    
    func navigateToHome(with user: AppUser) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            // Dismiss any presented view controllers first
            if let presentedVC = self.navigationController.presentedViewController {
                presentedVC.dismiss(animated: false) {
                    self.goToHome(with: user)
                }
            } else {
                self.goToHome(with: user)
            }
        }
    }
    func goToHome(with user: AppUser) {
        let homeVC = HomeVC(user: user, coordinator: self)
        navigationController.setViewControllers([homeVC], animated: false)
    }
    
    func goToAvatarPopup() {
        let viewModel = AvatarPopupViewModel()
        let avatarPopupVC = AvatarPopupVC(viewModel: viewModel, coordinator: self)
        presentPopupViewController(avatarPopupVC)
        //        avatarPopupVC.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        //        avatarPopupVC.modalPresentationStyle = .overFullScreen
        //        avatarPopupVC.modalTransitionStyle = .flipHorizontal
        //        navigationController.present(avatarPopupVC, animated: true, completion: nil)
    }
    
    func goToSettingsPopup() {
        let viewModel = SettingsPopupViewModel()
        let popupVC = SettingsPopupVC(viewModel: viewModel, coordinator: self)
        presentPopupViewController(popupVC)
        //        popupVC.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        //        popupVC.modalPresentationStyle = .overFullScreen
        //        popupVC.modalTransitionStyle = .flipHorizontal
        //        navigationController.present(popupVC, animated: true, completion: nil)
    }
    func goToNotificationSettingsPopup() {
        let viewModel = NotificationSettingsViewModel()
        let notificationSettingsVC = NotificationSettingsVC(viewModel: viewModel, coordinator: self)
        presentPopupViewController(notificationSettingsVC)
        //        notificationSettingsVC.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        //        notificationSettingsVC.modalPresentationStyle = .overFullScreen
        //        notificationSettingsVC.modalTransitionStyle = .flipHorizontal
        //        navigationController.present(notificationSettingsVC, animated: true, completion: nil)
    }
    
    func goToFAQPopup() {
        let faqVC = FAQVC(coordinator: self)
        presentPopupViewController(faqVC)
    }
    
    func goToPrivacyPolicy() {
        let url = "https://docs.google.com/document/d/1vxyHOi7SnfJpjBP6-epJG9rMzZUG_WP_VnUQuFP4qvQ/edit?usp=sharing"
        
        let presentWebVC = { [weak self] in
            guard let self = self else { return }
            
            let webVC = WebViewController(nibName: "WebViewController", bundle: nil)
            webVC.urlString = url
            webVC.title = "Privacy Policy" // Navigation bar başlığı
            
            let navController = UINavigationController(rootViewController: webVC)
            navController.modalPresentationStyle = .fullScreen
            
            self.navigationController.present(navController, animated: true, completion: nil)
        }
        
        if let presented = navigationController.presentedViewController {
            presented.dismiss(animated: false) {
                presentWebVC()
            }
        } else {
            presentWebVC()
        }
    }
    
    func showPopup(_ type: PopupType) {
        switch type {
        case .settings:
            goToSettingsPopup()
        case .avatar:
            goToAvatarPopup()
        case .faq:
            goToFAQPopup()
        case .notificationSettings:
            goToNotificationSettingsPopup()
        }
    }
    
    func replacePopup(with popupType: PopupType) {
        dismissCurrentPopup { [weak self] in
            self?.showPopup(popupType)
        }
    }
    
    func dismissCurrentPopup(completion: (() -> Void)? = nil) {
        if let presentedVC = navigationController.presentedViewController {
            presentedVC.dismiss(animated: false) {
                self.currentPopupViewController = nil
                completion?()
            }
        } else {
            completion?()
        }
    }
    
    func dismissPopup(completion: (() -> Void)? = nil) {
        dismissCurrentPopup(completion: completion)
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
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    self?.goToHome(with: user)
                case .failure(let error):
                    print("Home fetch failed: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func restartGame(with type: MathExpression.ExpressionType) {
        goToGameVC(with: type)
    }
    
    // MARK: - Private Methods
    private func presentPopupViewController(_ viewController: UIViewController) {
        viewController.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        viewController.modalPresentationStyle = .overFullScreen
        viewController.modalTransitionStyle = .flipHorizontal
        
        if let presentedVC = navigationController.presentedViewController {
            presentedVC.dismiss(animated: false) { [weak self] in
                self?.navigationController.present(viewController, animated: true)
                self?.currentPopupViewController = viewController
            }
        } else {
            navigationController.present(viewController, animated: true)
            currentPopupViewController = viewController
        }
    }
}
