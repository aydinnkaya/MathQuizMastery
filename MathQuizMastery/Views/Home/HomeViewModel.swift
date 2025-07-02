//
//  HomeViewModel.swift
//  MathQuizMastery
//
//  Created by AydınKaya on 30.04.2025.
//

import Foundation
import FirebaseAuth

protocol HomeViewModelProtocol {
    var delegate: HomeViewModelDelegate? { get set }
    func notifyViewDidLoad()
    func playButtonTapped()
}

protocol HomeViewModelDelegate: AnyObject {
    func didReceiveUser(_ user: AppUser?)
    func navigateToCategory()
}

class HomeViewModel: HomeViewModelProtocol {
    
    weak var delegate: HomeViewModelDelegate?
    private let authService: AuthServiceProtocol
    private(set) var user: AppUser?
    
    init(authService: AuthServiceProtocol = AuthService.shared) {
        self.authService = authService
    }
    
    func notifyViewDidLoad() {
        guard let currentUser = Auth.auth().currentUser else {
            delegate?.didReceiveUser(nil)
            return
        }
        
        let uid = currentUser.uid
        
        // Önce kullanıcı bilgilerini çek
        authService.fetchUserData(uid: uid) { [weak self] result in
            switch result {
            case .success(let fetchedUser):
                // Sonra avatar bilgisini çek
                self?.authService.fetchUserAvatar(uid: uid) { avatarResult in
                    DispatchQueue.main.async {
                        var finalAvatarImageName: String
                        
                        switch avatarResult {
                        case .success(let avatarImageName):
                            // Firebase'den başarıyla avatar alındı
                            finalAvatarImageName = avatarImageName
                            // UserDefaults'u da güncelle
                            UserDefaults.standard.set(avatarImageName, forKey: "selectedAvatarImageName")
                            
                        case .failure(_):
                            // Firebase'den avatar alınamazsa UserDefaults'tan dene
                            finalAvatarImageName = UserDefaults.standard.string(forKey: "selectedAvatarImageName") ?? "profile_image_1"
                        }
                        
                        // User nesnesini oluştur
                        self?.user = AppUser(
                            uid: fetchedUser.uid,
                            username: fetchedUser.username,
                            email: fetchedUser.email,
                            coin: fetchedUser.coin,
                            avatarImageName: finalAvatarImageName
                        )
                        
                        // Delegate'e bildir
                        self?.delegate?.didReceiveUser(self?.user)
                    }
                }
                
            case .failure(let error):
                print("Kullanıcı bilgileri çekilemedi: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self?.delegate?.didReceiveUser(nil)
                }
            }
        }
    }
    
    func playButtonTapped() {
        delegate?.navigateToCategory()
    }
}
