//
//  AppCoordinator.swift
//  MathQuizMastery
//
//  Created by Aydın KAYA on 17.05.2025.
//

import Foundation
import UIKit
import FirebaseAuth

// MARK: - Coordinator Protocol
protocol Coordinator {
    var navigationController: UINavigationController { get set }
    func start()
}

// MARK: - Popup Types
enum PopupType {
    case settings
    case avatar
    case faq
    case notificationSettings
}

// MARK: - Custom Error Types
enum NetworkError: Error {
    case noConnection
    case timeout
    case serverError(Int)
}

enum ValidationError: Error {
    case invalidData
    case missingRequired
    case formatError
}

// MARK: - App Coordinator
class AppCoordinator: Coordinator {
    
    // MARK: - Properties
    var navigationController: UINavigationController
    let backImage = UIImage(named: "back_icon")?.withRenderingMode(.alwaysOriginal)
    private var currentPopupViewController: UIViewController?
    var currentUser: AppUser?
    
    // MARK: - Initializer
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Coordinator Protocol
    func start() {
        checkAuthentication()
    }
    
    // MARK: - Authentication
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
    
    // MARK: - Main Navigation Methods
    
    /// Login ekranına geçiş yapar
    func goToLogin() {
        let viewModel = LoginViewModel()
        let loginVC = LoginVC(viewModel: viewModel, coordinator: self)
        navigationController.setViewControllers([loginVC], animated: true)
    }
    
    /// Register ekranına geçiş yapar
    func goToRegister() {
        let viewModel = RegisterViewModel()
        let registerVC = RegisterVC(viewModel: viewModel, coordinator: self)
        configureCustomBackButton(for: registerVC, iconName: "back_buttons")
        navigationController.pushViewController(registerVC, animated: true)
    }
    
    /// Kayıt başarılı olduğunda çağrılır
    func handleRegistrationSuccess(user: AppUser) {
        goToHome(with: user)
    }
    
    /// Ana sayfaya güvenli geçiş yapar
    func navigateToHome(with user: AppUser) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            // Açık popup'ları kapat
            if let presentedVC = self.navigationController.presentedViewController {
                presentedVC.dismiss(animated: false) {
                    self.goToHome(with: user)
                }
            } else {
                self.goToHome(with: user)
            }
        }
    }
    
    /// Ana sayfayı oluşturur ve gösterir
    func goToHome(with user: AppUser) {
        CurrentSession.shared.user = user
        let homeVC = HomeVC(user: user, coordinator: self)
        navigationController.setViewControllers([homeVC], animated: false)
        print("🏠 Ana sayfaya geçiş yapıldı")
    }
    
    /// Ana sayfadan kategori ekranına geçiş
    func goToCategory() {
        // Analytics kaydı
        trackScreenNavigation(from: "home", to: "category")
        
        let viewModel = CategoryViewModel()
        let categoryVC = CategoryVC(viewModel: viewModel, coordinator: self)
        configureCustomBackButton(for: categoryVC, iconName: "back_buttons")
        
        navigationController.pushViewController(categoryVC, animated: true)
        print("🏠➡️📚 Kategori ekranına geçiş yapıldı")
    }
    
    /// Kategori ekranından oyun ekranına geçiş
    func goToGameVC(with type: MathExpression.ExpressionType) {
        // Analytics kaydı
        trackScreenNavigation(from: "category", to: "game")
        
        let gameVC = GameVC(viewModel: nil, coordinator: self, selectedExpressionType: type)
        configureCustomBackButton(for: gameVC, iconName: "game_back_icon")
        navigationController.pushViewController(gameVC, animated: true)
        print("📚➡️🎮 Oyun ekranına geçiş yapıldı: \(type.displayName)")
    }
    
    /// Oyun bitince sonuç ekranına geçiş
    func goToResult(score: String, expressionType: MathExpression.ExpressionType) {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("❌ Kullanıcı UID bulunamadı")
            return
        }
        
        // Analytics kaydı
        trackScreenNavigation(from: "game", to: "result")
        
        let viewModel = ResultViewModel(
            score: score,
            expressionType: expressionType,
            userUID: uid
        )
        
        let resultVC = ResultVC(viewModel: viewModel, coordinator: self)
        viewModel.delegate = resultVC
        navigationController.pushViewController(resultVC, animated: true)
        print("🎮➡️📊 Sonuç ekranına geçiş yapıldı - Skor: \(score)")
    }
    
    /// Sonuç ekranından ana sayfaya dönüş
    func goToHomeAfterResult() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        AuthService.shared.fetchUserData(uid: uid) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    self?.goToHome(with: user)
                    print("📊➡️🏠 Sonuçtan ana sayfaya dönüş yapıldı")
                case .failure(let error):
                    print("❌ Ana sayfa dönüşü başarısız: \(error.localizedDescription)")
                }
            }
        }
    }
    
    /// Oyunu yeniden başlatır
    func restartGame(with type: MathExpression.ExpressionType) {
        // Analytics kaydı
        trackGameRestart(type: type)
        
        let gameVC = GameVC(viewModel: nil, coordinator: self, selectedExpressionType: type)
        configureCustomBackButton(for: gameVC, iconName: "game_back_icon")
        
        // Mevcut oyun ekranını değiştir
        var viewControllers = navigationController.viewControllers
        if let lastVC = viewControllers.last, lastVC is GameVC {
            viewControllers[viewControllers.count - 1] = gameVC
            navigationController.setViewControllers(viewControllers, animated: true)
        } else {
            navigationController.pushViewController(gameVC, animated: true)
        }
        
        print("🔄 Oyun yeniden başlatıldı: \(type.displayName)")
    }
}

// MARK: - Popup Navigation
extension AppCoordinator {
    
    /// Avatar seçim popup'ını gösterir
    func goToAvatarPopup() {
        // Guest kullanıcı kontrolü
        if let user = Auth.auth().currentUser, user.isAnonymous {
            showGuestWarningPopup()
            return
        }
        
        let viewModel = AvatarPopupViewModel()
        let avatarPopupVC = AvatarPopupVC(viewModel: viewModel, coordinator: self)
        presentPopupViewController(avatarPopupVC)
        print("👤 Avatar popup açıldı")
    }
    
    /// Ayarlar popup'ını gösterir
    func goToSettingsPopup() {
        guard let user = CurrentSession.shared.user else {
            print("❌ Kullanıcı bilgisi bulunamadı")
            return
        }
        
        let viewModel = SettingsPopupViewModel(user: user)
        let popupVC = SettingsPopupVC(viewModel: viewModel, coordinator: self)
        presentPopupViewController(popupVC)
        print("⚙️ Ayarlar popup açıldı")
    }
    
    /// Bildirim ayarları popup'ını gösterir
    func goToNotificationSettingsPopup() {
        let viewModel = NotificationSettingsViewModel()
        let notificationSettingsVC = NotificationSettingsVC(viewModel: viewModel, coordinator: self)
        presentPopupViewController(notificationSettingsVC)
        print("🔔 Bildirim ayarları popup açıldı")
    }
    
    /// SSS popup'ını gösterir
    func goToFAQPopup() {
        let faqVC = FAQVC(coordinator: self)
        presentPopupViewController(faqVC)
        print("❓ SSS popup açıldı")
    }
    
    /// Gizlilik politikası web sayfasını açar
    func goToPrivacyPolicy() {
        let url = "https://docs.google.com/document/d/1vxyHOi7SnfJpjBP6-epJG9rMzZUG_WP_VnUQuFP4qvQ/edit?usp=sharing"
        
        let presentWebVC = { [weak self] in
            guard let self = self else { return }
            
            let webVC = WebViewController(nibName: "WebViewController", bundle: nil)
            webVC.urlString = url
            webVC.title = "Gizlilik Politikası"
            
            let navController = UINavigationController(rootViewController: webVC)
            navController.modalPresentationStyle = .fullScreen
            
            self.navigationController.present(navController, animated: true, completion: nil)
            print("🌐 Gizlilik politikası açıldı")
        }
        
        // Açık popup varsa kapat
        if let presented = navigationController.presentedViewController {
            presented.dismiss(animated: false) {
                presentWebVC()
            }
        } else {
            presentWebVC()
        }
    }
    
    /// Genel popup gösterme methodu
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
    
    /// Popup değiştirme methodu
    func replacePopup(with popupType: PopupType) {
        dismissCurrentPopup { [weak self] in
            self?.showPopup(popupType)
        }
    }
    
    /// Mevcut popup'ı kapatır
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
}

// MARK: - Universal Popup Delegate
extension AppCoordinator: UniversalPopupDelegate {
    
    /// Hesap silme popup'ını gösterir
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
        print("🗑️ Hesap silme popup açıldı")
    }
    
    /// Misafir kullanıcı uyarısı gösterir
    func showGuestWarningPopup() {
        let viewModel = UniversalPopupViewModel(
            messageText: L(.login_required_message),
            primaryButtonText: L(.log_in),
            secondaryButtonText: L(.cancel),
            iconImage: UIImage(systemName: "person.crop.circle")
        )
        
        let popupVC = UniversalPopupView()
        popupVC.configure(with: viewModel)
        popupVC.purpose = .guestWarning
        popupVC.delegate = self
        presentPopupViewController(popupVC)
        print("⚠️ Misafir kullanıcı uyarısı gösterildi")
    }
    
    /// Popup ana buton tıklaması
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
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self?.goToLogin()
                }
            }
        case .generic:
            dismissPopup()
        }
    }
    
    /// Popup ikincil buton tıklaması
    func universalPopupSecondaryTapped() {
        dismissPopup()
    }
    
    /// Hesap silme işlemi
    private func deleteAccountAndNavigate() {
        AuthService.shared.deleteAccount { [weak self] error in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                if let error = error {
                    print("❌ Hesap silinirken hata: \(error.localizedDescription)")
                    return
                }
                
                self.dismissPopup {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        self.goToLogin()
                        print("✅ Hesap silindi, login ekranına yönlendirildi")
                    }
                }
            }
        }
    }
    
    /// Popup gösterme helper methodu
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
    
    /// Popup kapatma helper methodu
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
    
    /// Geri buton tıklaması
    @objc func handleCustomBackButton() {
        navigationController.popViewController(animated: true)
        print("⬅️ Geri buton tıklandı")
    }
    
    /// Custom geri buton oluşturur
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
    
    /// View controller için custom geri buton ayarlar
    func configureCustomBackButton(for viewController: UIViewController, iconName: String) {
        let backButton = createCustomBackButton(iconName: iconName, action: #selector(handleCustomBackButton))
        let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        spacer.width = -8
        
        viewController.navigationItem.leftBarButtonItems = [spacer, UIBarButtonItem(customView: backButton)]
    }
}

// MARK: - Category Enhanced Navigation
extension AppCoordinator {
    
    /// Kategori ekranına gelişmiş geçiş (animasyon ile)
    func goToCategoryWithAnimation(animated: Bool = true, completion: (() -> Void)? = nil) {
        // Analytics kaydı
        trackScreenNavigation(from: "home", to: "category_animated")
        
        let viewModel = CategoryViewModel()
        let categoryVC = CategoryVC(viewModel: viewModel, coordinator: self)
        configureCustomBackButton(for: categoryVC, iconName: "back_buttons")
        
        if animated {
            // Özel geçiş animasyonu
            CATransaction.begin()
            CATransaction.setAnimationDuration(0.5)
            CATransaction.setCompletionBlock {
                completion?()
                print("🎬 Kategori ekranı animasyon ile açıldı")
            }
            
            let transition = CATransition()
            transition.duration = 0.5
            transition.type = .fade
            transition.subtype = .fromRight
            navigationController.view.layer.add(transition, forKey: kCATransition)
            
            navigationController.pushViewController(categoryVC, animated: false)
            CATransaction.commit()
        } else {
            navigationController.pushViewController(categoryVC, animated: false)
            completion?()
        }
    }
    
    /// Kategoriden oyun ekranına özel geçiş
    func goToGameFromCategory(
        with type: MathExpression.ExpressionType,
        fromCategory category: MathCategory,
        animated: Bool = true
    ) {
        print("🎮 Kategoriden oyuna geçiş: \(category.title) -> \(type.displayName)")
        
        // Analytics için kategori seçimini kaydet
        trackCategorySelection(category)
        
        // Haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
        
        // Oyun ekranını oluştur
        let gameVC = GameVC(viewModel: nil, coordinator: self, selectedExpressionType: type)
        configureCustomBackButton(for: gameVC, iconName: "game_back_icon")
        
        if animated {
            // Özel geçiş animasyonu
            CATransaction.begin()
            CATransaction.setAnimationDuration(0.6)
            
            let transition = CATransition()
            transition.duration = 0.6
            transition.type = .push
            transition.subtype = .fromRight
            transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            
            navigationController.view.layer.add(transition, forKey: kCATransition)
            navigationController.pushViewController(gameVC, animated: false)
            
            CATransaction.commit()
        } else {
            navigationController.pushViewController(gameVC, animated: animated)
        }
    }
    
    /// Kategoriden ana sayfaya geri dönüş
    func goBackToHomeFromCategory(animated: Bool = true) {
        if let homeVC = navigationController.viewControllers.first(where: { $0 is HomeVC }) {
            navigationController.popToViewController(homeVC, animated: animated)
            print("📚➡️🏠 Kategoriden ana sayfaya dönüş")
        } else {
            goToHomeAfterResult()
        }
    }
}

// MARK: - Analytics and Tracking
extension AppCoordinator {
    
    /// Ekran geçiş analytics'i
    private func trackScreenNavigation(from: String, to: String) {
        let analyticsData: [String: Any] = [
            "from_screen": from,
            "to_screen": to,
            "timestamp": Date().timeIntervalSince1970,
            "user_id": Auth.auth().currentUser?.uid ?? "anonymous"
        ]
        
        print("📊 Navigation - \(from) → \(to)")
    }
    
    /// Kategori seçim analytics'i
    private func trackCategorySelection(_ category: MathCategory) {
        let analyticsData: [String: Any] = [
            "category_id": category.id,
            "category_title": category.title,
            "category_type": category.expressionType.rawValue,
            "is_new_category": category.isNew,
            "timestamp": Date().timeIntervalSince1970
        ]
        
        print("📊 Analytics - Kategori seçildi: \(category.title)")
    }
    
    /// Oyun yeniden başlatma analytics'i
    private func trackGameRestart(type: MathExpression.ExpressionType) {
        let analyticsData: [String: Any] = [
            "game_type": type.rawValue,
            "action": "restart",
            "timestamp": Date().timeIntervalSince1970
        ]
        
        print("📊 Analytics - Oyun yeniden başlatıldı: \(type.displayName)")
    }
    
    /// Kategori ekranında geçirilen süre
    func trackCategoryScreenTime(timeSpent: TimeInterval, categoriesViewed: Int) {
        let analyticsData: [String: Any] = [
            "time_spent_seconds": timeSpent,
            "categories_viewed": categoriesViewed,
            "screen_name": "category_selection"
        ]
        
        print("⏱️ Analytics - Kategori ekranı süresi: \(timeSpent)s, görüntülenen: \(categoriesViewed)")
    }
}

// MARK: - Deep Links and Notifications
extension AppCoordinator {
    
    /// Deep link ile kategoriye geçiş
    func navigateToCategory(withId categoryId: Int, completion: @escaping (Bool) -> Void) {
        guard let targetCategory = MathCategoryFactory.shared.getCategoryById(categoryId) else {
            print("❌ Kategori bulunamadı: \(categoryId)")
            completion(false)
            return
        }
        
        goToCategoryWithAnimation(animated: true) { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self?.goToGameFromCategory(
                    with: targetCategory.expressionType,
                    fromCategory: targetCategory,
                    animated: true
                )
                completion(true)
            }
        }
    }
    
    /// URL scheme kategori navigasyonu
    func handleCategoryDeepLink(_ url: URL) -> Bool {
        guard url.scheme == "mathquiz",
              url.host == "category",
              let categoryIdString = url.pathComponents.last,
              let categoryId = Int(categoryIdString) else {
            return false
        }
        
        navigateToCategory(withId: categoryId) { success in
            print(success ? "✅ Deep link başarılı" : "❌ Deep link başarısız")
        }
        
        return true
    }
    
    /// Push notification kategori önerisi
    func handleCategoryNotification(_ userInfo: [AnyHashable: Any]) {
        guard let categoryId = userInfo["category_id"] as? Int else {
            print("❌ Notification'da kategori ID'si bulunamadı")
            return
        }
        
        showCategoryRecommendationAlert(categoryId: categoryId)
    }
    
    /// Kategori önerisi alert'i
    private func showCategoryRecommendationAlert(categoryId: Int) {
        guard let category = MathCategoryFactory.shared.getCategoryById(categoryId),
              let topViewController = navigationController.topViewController else {
            return
        }
        
        let alert = UIAlertController(
            title: "📚 Kategori Önerisi",
            message: "\(category.title) kategorisinde pratik yapmak ister misiniz?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "✨ Hadi Başlayalım!", style: .default) { [weak self] _ in
            self?.navigateToCategory(withId: categoryId) { success in
                print(success ? "✅ Öneriden navigasyon başarılı" : "❌ Öneriden navigasyon başarısız")
            }
        })
        
        alert.addAction(UIAlertAction(title: "Şimdi Değil", style: .cancel))
        
        topViewController.present(alert, animated: true)
        print("💡 Kategori önerisi gösterildi: \(category.title)")
    }
}

// MARK: - State Management
extension AppCoordinator {
    
    /// Kategori ekranı durumunu kaydet
    func saveCategoryScreenState(selectedCategoryId: Int?, scrollPosition: CGPoint) {
        let userDefaults = UserDefaults.standard
        
        if let categoryId = selectedCategoryId {
            userDefaults.set(categoryId, forKey: "lastSelectedCategoryId")
        } else {
            userDefaults.removeObject(forKey: "lastSelectedCategoryId")
        }
        
        userDefaults.set(scrollPosition.x, forKey: "categoryScrollX")
        userDefaults.set(scrollPosition.y, forKey: "categoryScrollY")
        userDefaults.synchronize()
        
        print("💾 Kategori ekranı durumu kaydedildi")
    }
    
    /// Kategori ekranı durumunu geri yükle
    func restoreCategoryScreenState() -> (selectedCategoryId: Int?, scrollPosition: CGPoint) {
        let userDefaults = UserDefaults.standard
        
        let selectedId = userDefaults.object(forKey: "lastSelectedCategoryId") as? Int
        let scrollX = userDefaults.double(forKey: "categoryScrollX")
        let scrollY = userDefaults.double(forKey: "categoryScrollY")
        let scrollPosition = CGPoint(x: scrollX, y: scrollY)
        
        print("📂 Kategori ekranı durumu geri yüklendi")
        
        return (selectedId, scrollPosition)
    }
}

// MARK: - Error Handling
extension AppCoordinator {
    
    /// Kategori ekranı hata yönetimi
    func handleCategoryError(_ error: Error, from sourceViewController: UIViewController) {
        let errorMessage: String
        
        switch error {
        case is NetworkError:
            errorMessage = "İnternet bağlantısı sorunu. Lütfen bağlantınızı kontrol edin."
        case is ValidationError:
            errorMessage = "Kategori verileri doğrulanamadı. Lütfen uygulamayı yeniden başlatın."
        default:
            errorMessage = "Beklenmeyen bir hata oluştu. \(error.localizedDescription)"
        }
        
        let alert = UIAlertController(
            title: "⚠️ Hata",
            message: errorMessage,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Tekrar Dene", style: .default) { [weak self] _ in
            if let categoryVC = sourceViewController as? CategoryVC {
                print("🔄 Kategori verileri yeniden yükleniyor...")
                // CategoryVC'de reload çağırabilir
            }
        })
        
        alert.addAction(UIAlertAction(title: "Ana Sayfaya Dön", style: .default) { [weak self] _ in
            self?.goBackToHomeFromCategory()
        })
        
        sourceViewController.present(alert, animated: true)
        print("❌ Hata gösterildi: \(errorMessage)")
    }
}
