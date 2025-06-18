//
//  NotificationManager.swift
//  MathQuizMastery
//
//  Created by AydınKaya on 18.06.2025.
//

import UIKit
import UserNotifications

// MARK: - Notification Manager Protocol
protocol NotificationManagerProtocol {
    func handleNotificationSettings(from viewController: UIViewController)
    func checkNotificationStatus(completion: @escaping (UNAuthorizationStatus) -> Void)
    func requestNotificationPermission(completion: @escaping (Bool, Error?) -> Void)
    func openAppSettings()
}

// MARK: - Notification Manager
final class NotificationManager: NotificationManagerProtocol {
    
    // MARK: - Singleton
    static let shared = NotificationManager()
    
    // MARK: - Properties
    private let notificationCenter: UNUserNotificationCenter
    private let application: UIApplication
    
    // MARK: - Initialization
    init(notificationCenter: UNUserNotificationCenter = .current(),
         application: UIApplication = .shared) {
        self.notificationCenter = notificationCenter
        self.application = application
    }
    
    // MARK: - Public Methods
    func handleNotificationSettings(from viewController: UIViewController) {
        checkNotificationStatus { [weak self, weak viewController] status in
            guard let self = self, let viewController = viewController else { return }
            
            DispatchQueue.main.async {
                switch status {
                case .notDetermined:
                    self.showPermissionRequestAlert(from: viewController)
                case .denied:
                    self.showPermissionDeniedAlert(from: viewController)
                case .authorized, .provisional, .ephemeral:
                    self.showPermissionGrantedAlert(from: viewController)
                @unknown default:
                    self.showPermissionDeniedAlert(from: viewController)
                }
            }
        }
    }
    
    func checkNotificationStatus(completion: @escaping (UNAuthorizationStatus) -> Void) {
        notificationCenter.getNotificationSettings { settings in
            completion(settings.authorizationStatus)
        }
    }
    
    func requestNotificationPermission(completion: @escaping (Bool, Error?) -> Void) {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        notificationCenter.requestAuthorization(options: options) { granted, error in
            completion(granted, error)
        }
    }
    
    func openAppSettings() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self,
                  let settingsUrl = URL(string: UIApplication.openSettingsURLString),
                  self.application.canOpenURL(settingsUrl) else {
                print("Cannot create settings URL")
                return
            }
            
            self.application.open(settingsUrl, options: [:]) { success in
                print("Settings opened: \(success)")
            }
        }
    }
    
    // MARK: - Private Methods
    private func showPermissionRequestAlert(from viewController: UIViewController) {
        let alert = UIAlertController(
            title: "Bildirimler",
            message: "Günlük hatırlatmalar ve önemli güncellemeler için bildirim göndermemize izin verin. Bu sayede matematik çalışmalarınızı düzenli takip edebilirsiniz.",
            preferredStyle: .alert
        )
        
        let allowAction = UIAlertAction(title: "İzin Ver", style: .default) { [weak self] _ in
            self?.requestNotificationPermission { [weak self] granted, error in
                DispatchQueue.main.async {
                    if granted {
                        self?.showSuccessAlert(from: viewController)
                    } else if let error = error {
                        self?.showErrorAlert(from: viewController, error: error)
                    } else {
                        self?.showPermissionDeniedAlert(from: viewController)
                    }
                }
            }
        }
        
        let notNowAction = UIAlertAction(title: "Şimdi Değil", style: .cancel)
        
        alert.addAction(allowAction)
        alert.addAction(notNowAction)
        
        viewController.present(alert, animated: true)
    }
    
    private func showPermissionDeniedAlert(from viewController: UIViewController) {
        let alert = UIAlertController(
            title: "Bildirimler Kapalı",
            message: "Bildirimleri açmak için Ayarlar > Bildirimler bölümüne gidip uygulamaya izin vermeniz gerekiyor.",
            preferredStyle: .alert
        )
        
        let settingsAction = UIAlertAction(title: "Ayarlara Git", style: .default) { [weak self] _ in
            self?.openAppSettings()
        }
        
        let cancelAction = UIAlertAction(title: "İptal", style: .cancel)
        
        alert.addAction(settingsAction)
        alert.addAction(cancelAction)
        
        viewController.present(alert, animated: true)
    }
    
    private func showPermissionGrantedAlert(from viewController: UIViewController) {
        let alert = UIAlertController(
            title: "Bildirimler Açık",
            message: "Bildirimler zaten açık. Ayarlardan bildirim tercihlerinizi yönetebilirsiniz.",
            preferredStyle: .alert
        )
        
        let settingsAction = UIAlertAction(title: "Ayarlara Git", style: .default) { [weak self] _ in
            self?.openAppSettings()
        }
        
        let okAction = UIAlertAction(title: "Tamam", style: .cancel)
        
        alert.addAction(settingsAction)
        alert.addAction(okAction)
        
        viewController.present(alert, animated: true)
    }
    
    private func showSuccessAlert(from viewController: UIViewController) {
        let alert = UIAlertController(
            title: "Başarılı",
            message: "Bildirimler başarıyla açıldı! Artık günlük hatırlatmalar alacaksınız.",
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(title: "Tamam", style: .default)
        alert.addAction(okAction)
        
        viewController.present(alert, animated: true)
    }
    
    private func showErrorAlert(from viewController: UIViewController, error: Error) {
        let alert = UIAlertController(
            title: "Hata",
            message: "Bildirim izni alınırken bir hata oluştu: \(error.localizedDescription)",
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(title: "Tamam", style: .default)
        alert.addAction(okAction)
        
        viewController.present(alert, animated: true)
    }
}
