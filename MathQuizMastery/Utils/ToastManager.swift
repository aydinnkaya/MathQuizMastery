//
//  ToastManager.swift
//  MathQuizMastery
//
//  Created by Aydın KAYA on 6.04.2025.
//

import UIKit

// MARK: - Toast Manager Protocol
protocol ToastManagerProtocol {
    func showSuccess(message: String)
    func showError(message: String)
    func showInfo(message: String)
    func showWarning(message: String)
}

// MARK: - Toast Type
enum ToastType {
    case success
    case error
    case info
    case warning
    
    var backgroundColor: UIColor {
        switch self {
        case .success:
            return UIColor.systemGreen.withAlphaComponent(0.9)
        case .error:
            return UIColor.systemRed.withAlphaComponent(0.9)
        case .info:
            return UIColor.systemBlue.withAlphaComponent(0.9)
        case .warning:
            return UIColor.systemOrange.withAlphaComponent(0.9)
        }
    }
    
    var textColor: UIColor {
        return .white
    }
    
    var iconName: String {
        switch self {
        case .success:
            return "checkmark.circle.fill"
        case .error:
            return "xmark.circle.fill"
        case .info:
            return "info.circle.fill"
        case .warning:
            return "exclamationmark.triangle.fill"
        }
    }
}

// MARK: - Toast Manager Implementation
final class ToastManager: ToastManagerProtocol {
    
    // MARK: - Singleton
    static let shared = ToastManager()
    
    // MARK: - Properties
    private var currentToast: UIView?
    private let animationDuration: TimeInterval = 0.3
    private let displayDuration: TimeInterval = 3.0
    
    // MARK: - Initialization
    private init() {}
    
    // MARK: - Public Methods
    func showSuccess(message: String) {
        showToast(message: message, type: .success)
    }
    
    func showError(message: String) {
        showToast(message: message, type: .error)
    }
    
    func showInfo(message: String) {
        showToast(message: message, type: .info)
    }
    
    func showWarning(message: String) {
        showToast(message: message, type: .warning)
    }
    
    // MARK: - Private Methods
    private func showToast(message: String, type: ToastType) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.removeCurrentToast()
            
            guard let window = self.getKeyWindow() else { return }
            
            let toastView = self.createToastView(message: message, type: type)
            self.currentToast = toastView
            
            window.addSubview(toastView)
            self.setupConstraints(for: toastView, in: window)
            self.animateToastIn(toastView)
            
            // Auto-dismiss after delay
            DispatchQueue.main.asyncAfter(deadline: .now() + self.displayDuration) {
                self.hideToast(toastView)
            }
        }
    }
    
    private func getKeyWindow() -> UIWindow? {
        if #available(iOS 13.0, *) {
            return UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .flatMap { $0.windows }
                .first { $0.isKeyWindow }
        } else {
            return UIApplication.shared.keyWindow
        }
    }
    
    private func createToastView(message: String, type: ToastType) -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = type.backgroundColor
        containerView.layer.cornerRadius = 12
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowOpacity = 0.15
        containerView.layer.shadowRadius = 8
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        let iconImageView = UIImageView(image: UIImage(systemName: type.iconName))
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = type.textColor
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let messageLabel = UILabel()
        messageLabel.text = message
        messageLabel.font = .systemFont(ofSize: 14, weight: .medium)
        messageLabel.textColor = type.textColor
        messageLabel.numberOfLines = 0
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(iconImageView)
        containerView.addSubview(messageLabel)
        
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            iconImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.heightAnchor.constraint(equalToConstant: 24),
            
            messageLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12),
            messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            messageLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            messageLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12)
        ])
        
        return containerView
    }
    
    private func setupConstraints(for toastView: UIView, in window: UIWindow) {
        NSLayoutConstraint.activate([
            toastView.leadingAnchor.constraint(equalTo: window.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            toastView.trailingAnchor.constraint(equalTo: window.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            toastView.topAnchor.constraint(equalTo: window.safeAreaLayoutGuide.topAnchor, constant: 16)
        ])
    }
    
    private func animateToastIn(_ toastView: UIView) {
        toastView.alpha = 0
        toastView.transform = CGAffineTransform(translationX: 0, y: -50)
        
        UIView.animate(
            withDuration: animationDuration,
            delay: 0,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 0.5,
            options: [.curveEaseOut]
        ) {
            toastView.alpha = 1
            toastView.transform = .identity
        }
    }
    
    private func removeCurrentToast() {
        currentToast?.removeFromSuperview()
        currentToast = nil
    }
    
    private func hideToast(_ toast: UIView) {
        guard toast == currentToast else { return }
        
        UIView.animate(
            withDuration: animationDuration,
            animations: {
                toast.alpha = 0
                toast.transform = CGAffineTransform(translationX: 0, y: -50)
            },
            completion: { _ in
                toast.removeFromSuperview()
                if self.currentToast == toast {
                    self.currentToast = nil
                }
            }
        )
    }
}

// MARK: - Mock Toast Manager for Testing
final class MockToastManager: ToastManagerProtocol {
    
    // MARK: - Properties for Testing
    private(set) var successMessages: [String] = []
    private(set) var errorMessages: [String] = []
    private(set) var infoMessages: [String] = []
    private(set) var warningMessages: [String] = []
    
    // MARK: - Public Methods
    func showSuccess(message: String) {
        successMessages.append(message)
        print("✅ Mock Toast Success: \(message)")
    }
    
    func showError(message: String) {
        errorMessages.append(message)
        print("❌ Mock Toast Error: \(message)")
    }
    
    func showInfo(message: String) {
        infoMessages.append(message)
        print("ℹ️ Mock Toast Info: \(message)")
    }
    
    func showWarning(message: String) {
        warningMessages.append(message)
        print("⚠️ Mock Toast Warning: \(message)")
    }
    
    // MARK: - Test Helpers
    func reset() {
        successMessages.removeAll()
        errorMessages.removeAll()
        infoMessages.removeAll()
        warningMessages.removeAll()
    }
    
    func getAllMessages() -> [String] {
        return successMessages + errorMessages + infoMessages + warningMessages
    }
    
    func getMessageCount() -> Int {
        return getAllMessages().count
    }
}
