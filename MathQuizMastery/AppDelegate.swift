//
//  AppDelegate.swift
//  MathQuizMastery
//
//  Created by AydınKaya on 9.01.2025.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift
import IQKeyboardToolbarManager
import IQKeyboardReturnManager
import FirebaseCore

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        configureKeyboardManager()
        configureToolbarManager()
        configureFirebase()
        return true
    }
    
    // MARK: - Configuration Methods
    private func configureKeyboardManager() {
        let keyboardManager = IQKeyboardManager.shared
        keyboardManager.isEnabled = true
        // keyboardManager.isDebuggingEnabled = true
    }
    
    private func configureToolbarManager() {
        let toolbarManager = IQKeyboardToolbarManager.shared
        toolbarManager.isEnabled = true
        toolbarManager.isDebuggingEnabled = true
        toolbarManager.playInputClicks = false
        
        let toolbarConfig = toolbarManager.toolbarConfiguration
        toolbarConfig.useTextInputViewTintColor = true
        toolbarConfig.tintColor = .systemGreen
        toolbarConfig.barTintColor = .systemYellow
        toolbarConfig.previousNextDisplayMode = .alwaysShow
        toolbarConfig.manageBehavior = .byPosition
        
        let placeholderConfig = toolbarConfig.placeholderConfiguration
        placeholderConfig.showPlaceholder = false
        placeholderConfig.font = UIFont.italicSystemFont(ofSize: 14)
        placeholderConfig.color = .systemPurple
        placeholderConfig.buttonColor = .systemBrown
        
        toolbarManager.deepResponderAllowedContainerClasses.append(UIStackView.self)
    }
    
    private func configureFirebase() {
        FirebaseApp.configure()
    }
    
    // MARK: - UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {}
}
