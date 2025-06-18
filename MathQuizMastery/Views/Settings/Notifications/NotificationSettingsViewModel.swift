////
////  NotificationSettingsViewModel.swift
////  MathQuizMastery
////
////  Created by AydınKaya on 18.06.2025.
////
//
//import Foundation
//import UserNotifications
//import UIKit
//
//// MARK: - ViewModel States
//enum NotificationState {
//    case checking
//    case notDetermined
//    case authorized
//    case denied
//    case error(String)
//}
//
//// MARK: - ViewModel Protocol
//protocol NotificationSettingsViewModelProtocol: AnyObject {
//    var onStateChanged: ((NotificationState) -> Void)? { get set }
//    var onShowAlert: ((AlertModel) -> Void)? { get set }
//    
//    func checkNotificationPermission()
//}
//
//// MARK: - Alert Model
//struct AlertModel {
//    let title: String
//    let message: String
//    let primaryAction: AlertAction?
//    let secondaryAction: AlertAction?
//    
//    init(title: String, message: String, primaryAction: AlertAction? = nil, secondaryAction: AlertAction? = nil) {
//        self.title = title
//        self.message = message
//        self.primaryAction = primaryAction
//        self.secondaryAction = secondaryAction
//    }
//}
//
//struct AlertAction {
//    let title: String
//    let style: AlertActionStyle
//    let handler: (() -> Void)?
//    
//    init(title: String, style: AlertActionStyle = .default, handler: (() -> Void)? = nil) {
//        self.title = title
//        self.style = style
//        self.handler = handler
//    }
//}
//
//enum AlertActionStyle {
//    case `default`
//    case cancel
//    case destructive
//    
//    var uiAlertActionStyle: UIAlertAction.Style {
//        switch self {
//        case .default:
//            return .default
//        case .cancel:
//            return .cancel
//        case .destructive:
//            return .destructive
//        }
//    }
//}
//
//// MARK: - ViewModel Implementation
//class NotificationSettingsViewModel: NotificationSettingsViewModelProtocol {
//    
//    // MARK: - Properties
//    private let notificationService: NotificationPermissionService
//    
//    // MARK: - Callbacks
//    var onStateChanged: ((NotificationState) -> Void)?
//    var onShowAlert: ((AlertModel) -> Void)?
//    
//    // MARK: - Initialization
//    init(notificationService: NotificationPermissionService = NotificationPermissionService()) {
//        self.notificationService = notificationService
//    }
//    
//    // MARK: - Public Methods
//    func checkNotificationPermission() {
//        onStateChanged?(.checking)
//        
//        notificationService.checkPermission { [weak self] status in
//            DispatchQueue.main.async {
//                switch status {
//                case .notDetermined:
//                    self?.handleNotDetermined()
//                case .denied:
//                    self?.handleDenied()
//                case .authorized:
//                    self?.handleAuthorized()
//                case .provisional:
//                    self?.handleAuthorized()
//                case .ephemeral:
//                    self?.handleAuthorized()
//                @unknown default:
//                    self?.handleError("Unknown permission status")
//                }
//            }
//        }
//    }
//    
//    // MARK: - Private Methods
//    private func handleNotDetermined() {
//        onStateChanged?(.notDetermined)
//        requestPermission()
//    }
//    
//    private func handleDenied() {
//        onStateChanged?(.denied)
//        showSettingsAlert()
//    }
//    
//    private func handleAuthorized() {
//        onStateChanged?(.authorized)
//        showSuccessAlert()
//    }
//    
//    private func handleError(_ message: String) {
//        onStateChanged?(.error(message))
//        showErrorAlert(message)
//    }
//    
//    private func requestPermission() {
//        notificationService.requestPermission { [weak self] granted, error in
//            DispatchQueue.main.async {
//                if let error = error {
//                    self?.handleError(error.localizedDescription)
//                    return
//                }
//                
//                if granted {
//                    self?.handleAuthorized()
//                } else {
//                    self?.handleDenied()
//                }
//            }
//        }
//    }
//    
//    private func showSettingsAlert() {
//        let alert = AlertModel(
//            title: L(.notification_permission_title),
//            message: L(.notification_permission_message),
//            primaryAction: AlertAction(title: L(.settings_title), style: .default) { [weak self] in
//                self?.openSettings()
//            },
//            secondaryAction: AlertAction(title: L(.cancel), style: .cancel)
//        )
//        onShowAlert?(alert)
//    }
//    
//    private func showSuccessAlert() {
//        let alert = AlertModel(
//            title: L(.notification_permission_title),
//            message: L(.notification_permission_granted),
//            primaryAction: AlertAction(title: L(.ok))
//        )
//        onShowAlert?(alert)
//    }
//    
//    private func showErrorAlert(_ message: String) {
//        let alert = AlertModel(
//            title: L(.notification_permission_title),
//            message: message,
//            primaryAction: AlertAction(title: L(.ok))
//        )
//        onShowAlert?(alert)
//    }
//    
//    private func openSettings() {
//        if let url = URL(string: UIApplication.openSettingsURLString) {
//            UIApplication.shared.open(url)
//        }
//    }
//}
