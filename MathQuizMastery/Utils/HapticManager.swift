//
//  HapticManager.swift
//  MathQuizMastery
//
//  Created by Aydın KAYA on 31.03.2025.
//

import Foundation
import UIKit

// MARK: - Protocols
protocol HapticManagerProtocol {
    func success()
    func warning()
    func error()
    func lightImpact()
    func mediumImpact()
    func heavyImpact()
    func selectionChanged()
    func notify(_ type: UINotificationFeedbackGenerator.FeedbackType)
    func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle)
    
    // Convenience methods
    func triggerForUserInteraction()
    func triggerForValidationError()
    func triggerForSuccessfulAction()
    func triggerForButtonPress()
}

// MARK: - Haptic Types
enum HapticType {
    case success
    case warning
    case error
    case lightImpact
    case mediumImpact
    case heavyImpact
    case selectionChanged
}

// MARK: - HapticManager Implementation
final class HapticManager: HapticManagerProtocol {
    
    // MARK: - Singleton
    static let shared = HapticManager()
    
    // MARK: - Properties
    private let notificationGenerator = UINotificationFeedbackGenerator()
    private let selectionGenerator = UISelectionFeedbackGenerator()
    private var impactGenerators: [UIImpactFeedbackGenerator.FeedbackStyle: UIImpactFeedbackGenerator] = [:]
    private let hapticQueue = DispatchQueue(label: "com.mathquiz.haptic", qos: .userInitiated)
    
    // Settings
    private var isHapticsEnabled: Bool = true
    private var lastHapticTime: Date = Date()
    private let minimumHapticInterval: TimeInterval = 0.05 // Prevent spam
    
    // MARK: - Initialization
    private init() {
        setupImpactGenerators()
        prepareGenerators()
    }
    
    // MARK: - Public Methods
    func success() {
        triggerHaptic(.success)
    }
    
    func warning() {
        triggerHaptic(.warning)
    }
    
    func error() {
        triggerHaptic(.error)
    }
    
    func lightImpact() {
        triggerHaptic(.lightImpact)
    }
    
    //Medium
    func mediumImpact() {
        triggerHaptic(.mediumImpact)
    }
    
    func heavyImpact() {
        triggerHaptic(.heavyImpact)
    }
    
    func selectionChanged() {
        triggerHaptic(.selectionChanged)
    }
    
    func notify(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        guard shouldTriggerHaptic() else { return }
        
        hapticQueue.async { [weak self] in
            self?.notificationGenerator.prepare()
            
            DispatchQueue.main.async {
                self?.notificationGenerator.notificationOccurred(type)
            }
        }
    }
    
    func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        guard shouldTriggerHaptic() else { return }
        
        hapticQueue.async { [weak self] in
            let generator = self?.impactGenerators[style] ?? UIImpactFeedbackGenerator(style: style)
            generator.prepare()
            
            DispatchQueue.main.async {
                generator.impactOccurred()
            }
        }
    }
    
    // MARK: - Convenience Methods
    func triggerForUserInteraction() {
        selectionChanged()
    }
    
    func triggerForValidationError() {
        error()
    }
    
    func triggerForSuccessfulAction() {
        success()
    }
    
    func triggerForButtonPress() {
        lightImpact()
    }
    
    // MARK: - Settings
    func setHapticsEnabled(_ enabled: Bool) {
        isHapticsEnabled = enabled
    }
    
    func isHapticsAvailable() -> Bool {
        return UIDevice.current.hasHapticFeedback
    }
}

// MARK: - Private Methods
private extension HapticManager {
    
    func setupImpactGenerators() {
        impactGenerators[.light] = UIImpactFeedbackGenerator(style: .light)
        impactGenerators[.medium] = UIImpactFeedbackGenerator(style: .medium)
        impactGenerators[.heavy] = UIImpactFeedbackGenerator(style: .heavy)
        
        if #available(iOS 13.0, *) {
            impactGenerators[.soft] = UIImpactFeedbackGenerator(style: .soft)
            impactGenerators[.rigid] = UIImpactFeedbackGenerator(style: .rigid)
        }
    }
    
    func prepareGenerators() {
        hapticQueue.async { [weak self] in
            self?.notificationGenerator.prepare()
            self?.selectionGenerator.prepare()
            self?.impactGenerators.values.forEach { $0.prepare() }
        }
    }
    
    func triggerHaptic(_ type: HapticType) {
        guard shouldTriggerHaptic() else { return }
        
        switch type {
        case .success:
            notify(.success)
        case .warning:
            notify(.warning)
        case .error:
            notify(.error)
        case .lightImpact:
            impact(.light)
        case .mediumImpact:
            impact(.medium)
        case .heavyImpact:
            impact(.heavy)
        case .selectionChanged:
            triggerSelectionFeedback()
        }
        
        updateLastHapticTime()
    }
    
    func triggerSelectionFeedback() {
        hapticQueue.async { [weak self] in
            self?.selectionGenerator.prepare()
            
            DispatchQueue.main.async {
                self?.selectionGenerator.selectionChanged()
            }
        }
    }
    
    func shouldTriggerHaptic() -> Bool {
        guard isHapticsEnabled && isHapticsAvailable() else { return false }
        
        let timeSinceLastHaptic = Date().timeIntervalSince(lastHapticTime)
        return timeSinceLastHaptic >= minimumHapticInterval
    }
    
    func updateLastHapticTime() {
        lastHapticTime = Date()
    }
}

// MARK: - UIDevice Extension
private extension UIDevice {
    var hasHapticFeedback: Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }
}
