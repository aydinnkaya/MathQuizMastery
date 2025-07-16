//
//  NotificationPermissionService.swift
//  MathQuizMastery
//
//  Created by System on 19.06.2025.
//

import UIKit
import UserNotifications

protocol NotificationPermissionServiceDelegate: AnyObject {
    func notificationPermissionDidChange(_ granted: Bool)
    func notificationPermissionDidFail(_ error: NotificationPermissionError)
}

enum NotificationPermissionError: Error {
    case denied
    case notDetermined
    case systemError(Error)
    case settingsUnavailable
    
    var localizedDescription: String {
        switch self {
        case .denied:
            return "Bildirim izni reddedildi"
        case .notDetermined:
            return "Bildirim izni belirlenmedi"
        case .systemError(let error):
            return "Sistem hatası: \(error.localizedDescription)"
        case .settingsUnavailable:
            return "Ayarlar sayfası açılamadı"
        }
    }
}

enum NotificationPermissionStatus {
    case authorized
    case denied
    case notDetermined
    case provisional
    case ephemeral
    
    init(from authorizationStatus: UNAuthorizationStatus) {
        switch authorizationStatus {
        case .authorized:
            self = .authorized
        case .denied:
            self = .denied
        case .notDetermined:
            self = .notDetermined
        case .provisional:
            self = .provisional
        case .ephemeral:
            self = .ephemeral
        @unknown default:
            self = .notDetermined
        }
    }
}

class NotificationPermissionService : NSObject {
    
    // MARK: - Singleton
    static let shared = NotificationPermissionService()
    
    // MARK: - Properties
    weak var delegate: NotificationPermissionServiceDelegate?
    let notificationCenter = UNUserNotificationCenter.current()
    
    // MARK: - Private Init
    private override init() {
        super.init()
        self.setupNotificationCenter()
    }
    
    // MARK: - Setup
    private func setupNotificationCenter() {
        notificationCenter.delegate = self
    }
    
    // MARK: - Public Methods
    
    /// Mevcut bildirim iznini kontrol eder
    func checkPermissionStatus(completion: @escaping (NotificationPermissionStatus) -> Void) {
        notificationCenter.getNotificationSettings { settings in
            DispatchQueue.main.async {
                let status = NotificationPermissionStatus(from: settings.authorizationStatus)
                completion(status)
            }
        }
    }
    
    /// Bildirim izni ister
    func requestPermission(completion: @escaping (Bool, NotificationPermissionError?) -> Void) {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        
        notificationCenter.requestAuthorization(options: options) { [weak self] granted, error in
            DispatchQueue.main.async {
                if let error = error {
                    let permissionError = NotificationPermissionError.systemError(error)
                    self?.delegate?.notificationPermissionDidFail(permissionError)
                    completion(false, permissionError)
                } else {
                    self?.delegate?.notificationPermissionDidChange(granted)
                    if !granted {
                        completion(false, .denied)
                    } else {
                        completion(true, nil)
                    }
                }
            }
        }
    }
    
    /// Uygulama ayarları sayfasını açar
    func openSettings() {
        checkPermissionStatus { [weak self] status in
            switch status {
            case .notDetermined:
                // İlk kez izin isteniyor
                self?.requestPermission { granted, error in
                    if !granted {
                        self?.showPermissionAlert()
                    }
                }
            case .denied:
                // İzin reddedilmiş, ayarlara yönlendir
                self?.showPermissionAlert()
            case .authorized, .provisional, .ephemeral:
                // İzin verilmiş, doğrudan iOS ayarlarına git
                self?.openAppSettings()
            }
        }
    }
    
    /// iOS uygulama ayarları sayfasını açar
    private func openAppSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString),
              UIApplication.shared.canOpenURL(settingsUrl) else {
            delegate?.notificationPermissionDidFail(.settingsUnavailable)
            return
        }
        
        UIApplication.shared.open(settingsUrl) { [weak self] success in
            if !success {
                self?.delegate?.notificationPermissionDidFail(.settingsUnavailable)
            }
        }
    }
    
    /// Bildirim izni alert'i gösterir
    private func showPermissionAlert() {
        guard let topViewController = UIApplication.shared.topViewController() else {
            return
        }
        
        let alert = UIAlertController(
            title: L(.notification_permission_title),
            message: L(.notification_permission_message),
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(
            title: L(.notification_permission_cancel),
            style: .cancel
        ))
        
        alert.addAction(UIAlertAction(
            title: L(.notification_permission_settings),
            style: .default
        ) { [weak self] _ in
            self?.openAppSettings()
        })
        
        topViewController.present(alert, animated: true)
    }
    
    /// Test bildirimi gönderir (development için)
    func sendTestNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Test Bildirimi"
        content.body = "Bu bir test bildirimidir."
        content.sound = .default
        
        let request = UNNotificationRequest(
            identifier: "test_notification",
            content: content,
            trigger: UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        )
        
        notificationCenter.add(request) { error in
            if let error = error {
                print("Test bildirimi gönderilemedi: \(error.localizedDescription)")
            } else {
                print("Test bildirimi gönderildi")
            }
        }
    }
    
    /// Zamanlanmış bildirim oluşturur
    func scheduleNotification(
        identifier: String,
        title: String,
        body: String,
        timeInterval: TimeInterval,
        repeats: Bool = false
    ) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: timeInterval,
            repeats: repeats
        )
        
        let request = UNNotificationRequest(
            identifier: identifier,
            content: content,
            trigger: trigger
        )
        
        notificationCenter.add(request) { error in
            if let error = error {
                print("Bildirim zamanlanamadı: \(error.localizedDescription)")
            }
        }
    }
    
    /// Belirli bir bildirimi iptal eder
    func cancelNotification(withIdentifier identifier: String) {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier])
    }
    
    /// Tüm bekleyen bildirimleri iptal eder
    func cancelAllNotifications() {
        notificationCenter.removeAllPendingNotificationRequests()
    }
    
    /// Bekleyen bildirimleri listeler
    func getPendingNotifications(completion: @escaping ([UNNotificationRequest]) -> Void) {
        notificationCenter.getPendingNotificationRequests { requests in
            DispatchQueue.main.async {
                completion(requests)
            }
        }
    }
}

// MARK: - UNUserNotificationCenterDelegate
extension NotificationPermissionService: UNUserNotificationCenterDelegate {
    
    /// Uygulama ön plandayken bildirim geldiğinde çağrılır
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        if #available(iOS 14.0, *) {
            completionHandler([.banner, .sound, .badge])
        } else {
            completionHandler([.alert, .sound, .badge])
        }
    }
    
    /// Bildirime tıklandığında çağrılır
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let identifier = response.notification.request.identifier
        print("Bildirime tıklandı: \(identifier)")
        
        // Burada bildirim tıklama işlemlerini yapabilirsiniz
        handleNotificationTap(identifier: identifier)
        
        completionHandler()
    }
    
    private func handleNotificationTap(identifier: String) {
        // Bildirim tipine göre farklı işlemler yapılabilir
        switch identifier {
        case "quiz_reminder":
            // Quiz sayfasına yönlendir
            break
        case "daily_challenge":
            // Günlük challenge sayfasına yönlendir
            break
        default:
            // Varsayılan işlem
            break
        }
    }
}

// MARK: - UIApplication Extension
extension UIApplication {
    func topViewController() -> UIViewController? {
        guard let windowScene = connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first(where: { $0.isKeyWindow }) else {
            return nil
        }
        
        var topViewController = window.rootViewController
        
        while let presentedViewController = topViewController?.presentedViewController {
            topViewController = presentedViewController
        }
        
        if let navigationController = topViewController as? UINavigationController {
            topViewController = navigationController.visibleViewController
        }
        
        if let tabBarController = topViewController as? UITabBarController {
            topViewController = tabBarController.selectedViewController
        }
        
        return topViewController
    }
}
