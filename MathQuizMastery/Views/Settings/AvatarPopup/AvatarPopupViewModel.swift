//
//  AvatarPopupViewModel.swift
//  MathQuizMastery
//
//  Created by AydınKaya on 14.05.2025.
//

import Foundation
import FirebaseAuth

protocol AvatarPopupViewModelProtocol {
    var delegate: AvatarPopupViewModelDelegate? { get set }
    func loadUserData()
    func getAvatarCount() -> Int
    func getAvatar(at index: Int) -> Avatar
    func selectAvatar(at index: Int)
    func getSelectedIndexPath() -> IndexPath?
    func updateUsername(_ username: String)
    func handleSaveTapped()
}

protocol AvatarPopupViewModelDelegate: AnyObject {
    func userDataLoaded(username: String, avatar: Avatar)
    func avatarSelectionDidChange(selectedAvatar: Avatar)
    func avatarCellStyleUpdate(selectedIndexPath: IndexPath?, previousIndexPath: IndexPath?)
    func tappedSave()
    func showError(message: String)
    func showSuccess(message: String)
    func showLoading(_ show: Bool)
}

class AvatarPopupViewModel: AvatarPopupViewModelProtocol {
    
    weak var delegate: AvatarPopupViewModelDelegate?
    
    // MARK: - Private Properties
    private var avatars: [Avatar] = []
    private var selectedAvatarIndex: Int?
    private var currentUsername: String = ""
    private var originalUsername: String = ""
    private var originalAvatarIndex: Int?
    private let authService: AuthServiceProtocol
    
    // MARK: - Initialization
    init(authService: AuthServiceProtocol = AuthService.shared) {
        self.authService = authService
    }
    
    // MARK: - Public Methods
    func loadUserData() {
        loadAvatars()
        loadUserCurrentData()
    }
    
    func updateUsername(_ username: String) {
        currentUsername = username.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func getAvatarCount() -> Int {
        return avatars.count
    }
    
    func getAvatar(at index: Int) -> Avatar {
        return avatars[index]
    }
    
    func getSelectedIndexPath() -> IndexPath? {
        guard let index = selectedAvatarIndex else { return nil }
        return IndexPath(row: index, section: 0)
    }
    
    func selectAvatar(at index: Int) {
        let previousIndexPath = getSelectedIndexPath()
        selectedAvatarIndex = index
        
        delegate?.avatarSelectionDidChange(selectedAvatar: avatars[index])
        delegate?.avatarCellStyleUpdate(selectedIndexPath: getSelectedIndexPath(), previousIndexPath: previousIndexPath)
    }
    
    func handleSaveTapped() {
        guard let currentUser = Auth.auth().currentUser else {
            delegate?.showError(message: "Kullanıcı oturumu bulunamadı.")
            return
        }
        
        // Username validation
        let trimmedUsername = currentUsername.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedUsername.isEmpty {
            delegate?.showError(message: "Kullanıcı adı boş olamaz.")
            return
        }
        
        if trimmedUsername.count < 3 {
            delegate?.showError(message: "Kullanıcı adı en az 3 karakter olmalıdır.")
            return
        }
        
        guard let selectedIndex = selectedAvatarIndex else {
            delegate?.showError(message: "Lütfen bir avatar seçin.")
            return
        }
        
        // Değişiklik kontrolü
        let usernameChanged = trimmedUsername != originalUsername
        let avatarChanged = selectedIndex != originalAvatarIndex
        
        if !usernameChanged && !avatarChanged {
            // Hiçbir değişiklik yapılmamış
            delegate?.tappedSave()
            return
        }
        
        // Loading göster
        delegate?.showLoading(true)
        
        // Kaydetme işlemini başlat
        saveUserData(uid: currentUser.uid, username: trimmedUsername, avatarIndex: selectedIndex, usernameChanged: usernameChanged, avatarChanged: avatarChanged)
        
    }
    
    // MARK: - Private Methods
    private func loadAvatars() {
        avatars = []
        
        // AvatarMappingHelper'dan tüm icon isimlerini al
        let iconNames = AvatarMappingHelper.getAllIconNames()
        
        for (index, iconName) in iconNames.enumerated() {
            let avatar = Avatar(id: "\(index + 1)", imageName: iconName)
            avatars.append(avatar)
        }
    }
    
    private func loadUserCurrentData() {
        guard let currentUser = Auth.auth().currentUser else { return }
        
        authService.fetchUserData(uid: currentUser.uid) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    self?.handleUserDataLoaded(user: user)
                    
                case .failure(let error):
                    self?.delegate?.showError(message: "Kullanıcı verileri yüklenemedi: \(error.localizedDescription)")
                    self?.selectDefaultData()
                }
            }
        }
    }
    
    private func handleUserDataLoaded(user: AppUser) {
        // Username'i kaydet
        originalUsername = user.username
        currentUsername = user.username
        
        // Avatar'ı bul ve seç
        let iconName = user.avatarImageName.toAvatarIconName
        
        if let index = avatars.firstIndex(where: { $0.imageName == iconName }) {
            selectedAvatarIndex = index
            originalAvatarIndex = index
            
            let selectedAvatar = avatars[index]
            delegate?.userDataLoaded(username: user.username, avatar: selectedAvatar)
            delegate?.avatarCellStyleUpdate(selectedIndexPath: getSelectedIndexPath(), previousIndexPath: nil)
        } else {
            selectDefaultData()
        }
    }
    
    private func selectDefaultData() {
        selectedAvatarIndex = 0
        originalAvatarIndex = 0
        originalUsername = "Kullanıcı"
        currentUsername = "Kullanıcı"
        
        if let firstAvatar = avatars.first {
            delegate?.userDataLoaded(username: "Kullanıcı", avatar: firstAvatar)
            delegate?.avatarCellStyleUpdate(selectedIndexPath: getSelectedIndexPath(), previousIndexPath: nil)
        }
    }
    
    private func saveUserData(uid: String, username: String, avatarIndex: Int, usernameChanged: Bool, avatarChanged: Bool) {
        let selectedAvatar = avatars[avatarIndex]
        let imageNameForFirebase = selectedAvatar.imageName.toAvatarImageName
        
        // Hangi işlemlerin yapılması gerektiğini belirle
        let dispatchGroup = DispatchGroup()
        var errors: [Error] = []
        
        // Username güncelleme
        if usernameChanged {
            dispatchGroup.enter()
            authService.updateUsername(uid: uid, username: username) { error in
                if let error = error {
                    errors.append(error)
                }
                dispatchGroup.leave()
            }
        }
        
        // Avatar güncelleme
        if avatarChanged {
            dispatchGroup.enter()
            
            // Önce UserDefaults'a kaydet (hızlı erişim için)
            UserDefaults.standard.set(imageNameForFirebase, forKey: "selectedAvatarImageName")
            
            authService.updateUserAvatar(uid: uid, avatarImageName: imageNameForFirebase) { error in
                if let error = error {
                    // Firebase hatası durumunda UserDefaults'ı geri al
                    UserDefaults.standard.removeObject(forKey: "selectedAvatarImageName")
                    errors.append(error)
                }
                dispatchGroup.leave()
            }
        }
        
        // Tüm işlemler tamamlandığında
        dispatchGroup.notify(queue: .main) { [weak self] in
            self?.delegate?.showLoading(false)
            
            if !errors.isEmpty {
                let errorMessage = errors.map { $0.localizedDescription }.joined(separator: "\n")
                self?.delegate?.showError(message: "Kaydetme sırasında hata oluştu:\n\(errorMessage)")
            } else {
                // Başarılı kayıt mesajı
                var successMessage = "Başarıyla kaydedildi!"
                
                if usernameChanged && avatarChanged {
                    successMessage = "Kullanıcı adı ve avatar başarıyla güncellendi!"
                } else if usernameChanged {
                    successMessage = "Kullanıcı adı başarıyla güncellendi!"
                } else if avatarChanged {
                    successMessage = "Avatar başarıyla güncellendi!"
                }
                
                self?.delegate?.showSuccess(message: successMessage)
                
                // Bildirim gönder
                if usernameChanged {
                    NotificationCenter.default.post(name: .usernameDidUpdate, object: nil)
                }
                if avatarChanged {
                    NotificationCenter.default.post(name: .avatarDidUpdate, object: nil)
                }
                
                // Popup'ı kapat
                self?.delegate?.tappedSave()
            }
        }
    }
}
