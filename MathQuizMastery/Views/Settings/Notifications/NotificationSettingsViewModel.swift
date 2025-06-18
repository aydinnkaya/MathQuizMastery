//
//  NotificationSettingsViewModel.swift
//  MathQuizMastery
//
//  Created by AydınKaya on 18.06.2025.
//

import Foundation
import UserNotifications
import UIKit

// MARK: - ViewModel States
enum NotificationState {
    case checking
    case notDetermined
    case authorized
    case denied
    case error(String)
}

// MARK: - ViewModel Protocol
protocol NotificationSettingsViewModelProtocol: AnyObject {
    var onStateChanged: ((NotificationState) -> Void)? { get set }
    var onShowAlert: ((NotificationAlertModel) -> Void)? { get set }
    
    func checkNotificationPermission()
}

// MARK: - ViewModel Implementation
class NotificationSettingsViewModel: NotificationSettingsViewModelProtocol {
    
    // MARK: - Properties
    private let notificationService: NotificationPermissionServiceProtocol
    
    // MARK: - Callbacks
    var onStateChanged: ((NotificationState) -> Void)?
    var onShowAlert: ((NotificationAlertModel) -> Void)?
    
    // MARK: - Initialization
    init(notificationService: NotificationPermissionServiceProtocol = NotificationPermissionService.shared) {
        self.notificationService = notificationService
    }
    
    // MARK: - Public Methods
    func checkNotificationPermission() {
        onStateChanged?(.checking)
        
        notificationService.checkPermission { [weak self] status in
            DispatchQueue.main.async {
                switch status {
                case .notDetermined:
                    self?.handleNotDetermined()
                case .denied:
                    self?.handleDenied()
                case .authorized:
                    self?.handleAuthorized()
                case .provisional:
                    self?.handleAuthorized()
                case .ephemeral:
                    self?.handleAuthorized()
                @unknown default:
                    self?.handleError("Unknown permission status")
                }
            }
        }
    }
    
    // MARK: - Private Methods
    private func handleNotDetermined() {
        onStateChanged?(.notDetermined)
        requestPermission()
    }
    
    private func handleDenied() {
        onStateChanged?(.denied)
        showSettingsAlert()
    }
    
    private func handleAuthorized() {
        onStateChanged?(.authorized)
        showSuccessAlert()
    }
    
    private func handleError(_ message: String) {
        onStateChanged?(.error(message))
        showErrorAlert(message)
    }
    
    private func requestPermission() {
        notificationService.requestPermission { [weak self] granted, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.handleError(error.localizedDescription)
                    return
                }
                
                if granted {
                    self?.handleAuthorized()
                } else {
                    self?.handleDenied()
                }
            }
        }
    }
    
    private func showSettingsAlert() {
        let alert = NotificationAlertModel(
            title: "Bildirim İzni",
            message: "Bildirimleri açmak için ayarlara gitmeniz gerekiyor.",
            primaryAction: NotificationAlertAction(
                title: "Ayarlar",
                style: .default
            ) { [weak self] in
                self?.openSettings()
            },
            secondaryAction: NotificationAlertAction(
                title: "İptal",
                style: .cancel
            )
        )
        onShowAlert?(alert)
    }
    
    private func showSuccessAlert() {
        let alert = NotificationAlertModel(
            title: "Bildirim İzni",
            message: "Bildirimler başarıyla açıldı.",
            primaryAction: NotificationAlertAction(title: "Tamam")
        )
        onShowAlert?(alert)
    }
    
    private func showErrorAlert(_ message: String) {
        let alert = NotificationAlertModel(
            title: "Hata",
            message: message,
            primaryAction: NotificationAlertAction(title: "Tamam")
        )
        onShowAlert?(alert)
    }
    
    private func openSettings() {
        notificationService.openSettings()
    }
}
