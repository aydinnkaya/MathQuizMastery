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

enum PopupType {
    case settings
    case avatar
    case faq
    case notificationSettings
}

class AppCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    let backImage = UIImage(named: "back_icon")?.withRenderingMode(.alwaysOriginal)
    private var currentPopupViewController: UIViewController?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    var currentUser: AppUser?
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
        configureCustomBackButton(for: registerVC, iconName: "back_buttons")
        navigationController.pushViewController(registerVC, animated: true)
    }
    
    func handleRegistrationSuccess(user: AppUser) {
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
        CurrentSession.shared.user = user
        let homeVC = HomeVC(user: user, coordinator: self)
        navigationController.setViewControllers([homeVC], animated: false)
    }
    
    func goToAvatarPopup() {
        if let user = Auth.auth().currentUser, user.isAnonymous {
            // Kullanıcı misafir => izin verme
            showGuestWarningPopup()
            return
        }
        
        let viewModel = AvatarPopupViewModel()
        let avatarPopupVC = AvatarPopupVC(viewModel: viewModel, coordinator: self)
        presentPopupViewController(avatarPopupVC)
        //        avatarPopupVC.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        //        avatarPopupVC.modalPresentationStyle = .overFullScreen
        //        avatarPopupVC.modalTransitionStyle = .flipHorizontal
        //        navigationController.present(avatarPopupVC, animated: true, completion: nil)
    }
    
    func goToSettingsPopup() {
        guard let user = CurrentSession.shared.user else { return }
        let viewModel = SettingsPopupViewModel(user: user)
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
    
    
    func goToCategory() {
        let viewModel = CategoryViewModel()
        let categoryVC = CategoryVC(viewModel: viewModel, coordinator: self)
        configureCustomBackButton(for: categoryVC, iconName: "back_buttons")
        
        navigationController.pushViewController(categoryVC, animated: true)
    }
    
    func goToGameVC(with type: MathExpression.ExpressionType) {
        let gameVC = GameVC(viewModel: nil, coordinator: self, selectedExpressionType: type)
        configureCustomBackButton(for: gameVC, iconName: "game_back_icon")
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
        let gameVC = GameVC(viewModel: nil, coordinator: self, selectedExpressionType: type)
        configureCustomBackButton(for: gameVC, iconName: "game_back_icon")
        goToGameVC(with: type)
    }
    
    
    
    //    // MARK: - Private Methods
    //    private func presentPopupViewController(_ viewController: UIViewController) {
    //        viewController.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    //        viewController.modalPresentationStyle = .overFullScreen
    //        viewController.modalTransitionStyle = .flipHorizontal
    //
    //        if let presentedVC = navigationController.presentedViewController {
    //            presentedVC.dismiss(animated: false) { [weak self] in
    //                self?.navigationController.present(viewController, animated: true)
    //                self?.currentPopupViewController = viewController
    //            }
    //        } else {
    //            navigationController.present(viewController, animated: true)
    //            currentPopupViewController = viewController
    //        }
    //    }
    //
    
    //    func dismissPopup(completion: (() -> Void)? = nil) {
    //        dismissCurrentPopup(completion: completion)
    //    }
    
}


// MARK: - AppCoordinator Extension for Popup Handling
extension AppCoordinator: UniversalPopupDelegate {
    
    // MARK: - Popup Gösterimi
    
    func showDeleteAccountPopup() {
        let viewModel = UniversalPopupViewModel(
            messageText: L(.delete_account_message),
            primaryButtonText: L(.delete),
            secondaryButtonText: L(.cancel),
            iconImage: UIImage(named: "delete_account_icon")
        )
        
        let popupVC = UniversalPopupView()
        popupVC.configure(with: viewModel)
        popupVC.purpose = .deleteAccount
        popupVC.delegate = self
        presentPopupViewController(popupVC)
    }
    
    func showGuestWarningPopup() {
        let viewModel = UniversalPopupViewModel(
            messageText: L(.login_required_message),
            primaryButtonText: L(.log_in),
            secondaryButtonText: L(.cancel),
            iconImage: UIImage(named: "person.crop.circle")
        )
        
        let popupVC = UniversalPopupView()
        popupVC.configure(with: viewModel)
        popupVC.purpose = .guestWarning
        popupVC.delegate = self
        presentPopupViewController(popupVC)
    }
    
    // MARK: - Popup Delegate
    
    func universalPopupPrimaryTapped() {
        guard let popup = navigationController.presentedViewController as? UniversalPopupView else {
            dismissPopup()
            return
        }
        
        switch popup.purpose {
        case .deleteAccount:
            deleteAccountAndNavigate()
        case .guestWarning:
            dismissPopup { [weak self] in
                self?.goToLogin()
            }
        case .generic:
            dismissPopup()
        }
    }
    
    func universalPopupSecondaryTapped() {
        dismissPopup()
    }
    
    // MARK: - Hesap Silme
    
    private func deleteAccountAndNavigate() {
        AuthService.shared.deleteAccount { [weak self] error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Hesap silinirken hata oluştu: \(error.localizedDescription)")
                    return
                }
                self?.goToLogin()
            }
        }
    }
    
    // MARK: - Popup Present/Dismiss
    
    func presentPopupViewController(_ viewController: UIViewController) {
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
    
    func dismissPopup(completion: (() -> Void)? = nil) {
        if let presentedVC = navigationController.presentedViewController {
            presentedVC.dismiss(animated: false) {
                self.currentPopupViewController = nil
                completion?()
            }
        } else {
            completion?()
        }
    }
}

// MARK: - Custom Back Button
extension AppCoordinator {
    
    @objc func handleCustomBackButton() {
        navigationController.popViewController(animated: true)
    }
    
    func createCustomBackButton(iconName: String, action: Selector) -> UIButton {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: iconName), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 48, height: 48)
        button.layer.cornerRadius = 24
        button.backgroundColor = .clear
        button.clipsToBounds = true
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }
    
    
    func configureCustomBackButton(for viewController: UIViewController, iconName: String) {
        let backButton = createCustomBackButton(iconName: iconName, action: #selector(handleCustomBackButton))
        let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        spacer.width = -8
        
        viewController.navigationItem.leftBarButtonItems = [spacer, UIBarButtonItem(customView: backButton)]
    }
}
