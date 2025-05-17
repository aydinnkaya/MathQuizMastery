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
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC {
            loginVC.coordinator = self
            navigationController.setViewControllers([loginVC], animated: false)
        }
    }
    
    func goToHome(with user: User) {
        let homeVC = HomeVC.instantiate(with: user, coordinator: self)
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
    
    func dismissPopup() {
        navigationController.topViewController?.dismiss(animated: true, completion: nil)
    }
    
}
