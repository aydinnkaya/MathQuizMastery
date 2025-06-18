//
//  NotificationPermissionService.swift
//  MathQuizMastery
//
//  Created by AydınKaya on 18.06.2025.
//

import Foundation
import UserNotifications
import UIKit

// MARK: - Protocols
protocol NotificationPermissionServiceProtocol {
    func checkPermission(completion: @escaping (UNAuthorizationStatus) -> Void)
    func requestPermission(completion: @escaping (Bool, Error?) -> Void)
    func openSettings()
}

// MARK: - Service Implementation
class NotificationPermissionService: NotificationPermissionServiceProtocol {
    
    static let shared = NotificationPermissionService()
    private let notificationCenter: UNUserNotificationCenter
    private let application: UIApplication
    
    // Dependency Injection için
    init(notificationCenter: UNUserNotificationCenter = .current(),
         application: UIApplication = .shared) {
        self.notificationCenter = notificationCenter
        self.application = application
    }
    
    func checkPermission(completion: @escaping (UNAuthorizationStatus) -> Void) {
        notificationCenter.getNotificationSettings { settings in
            completion(settings.authorizationStatus)
        }
    }
    
    func requestPermission(completion: @escaping (Bool, Error?) -> Void) {
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            completion(granted, error)
        }
    }
    
    func openSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString),
              application.canOpenURL(url) else { return }
        
        application.open(url, options: [:], completionHandler: nil)
    }
}
