//
//  ToastView.swift
//  MathQuizMastery
//
//  Created by Aydın KAYA on 6.04.2025.
//

import UIKit

final class ToastView {
    
    // MARK: - Static Methods
    static func show(in view: UIView, message: String, duration: TimeInterval = 3.0) {
        DispatchQueue.main.async {
            let toastView = createToastView(message: message)
            view.addSubview(toastView)
            
            // Setup constraints
            setupConstraints(for: toastView, in: view)
            
            // Initial state for animation
            toastView.alpha = 0
            toastView.transform = CGAffineTransform(translationX: 0, y: -50)
            
            // Animate in
            UIView.animate(
                withDuration: 0.3,
                delay: 0,
                usingSpringWithDamping: 0.8,
                initialSpringVelocity: 0.5,
                options: [.curveEaseOut]
            ) {
                toastView.alpha = 1
                toastView.transform = .identity
            }
            
            // Auto-dismiss after duration
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                hideToast(toastView)
            }
        }
    }
    
    // MARK: - Private Methods
    private static func createToastView(message: String) -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        containerView.layer.cornerRadius = 12
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowOpacity = 0.3
        containerView.layer.shadowRadius = 8
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        let messageLabel = UILabel()
        messageLabel.text = message
        messageLabel.font = .systemFont(ofSize: 14, weight: .medium)
        messageLabel.textColor = .white
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(messageLabel)
        
        NSLayoutConstraint.activate([
            messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            messageLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            messageLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12)
        ])
        
        return containerView
    }
    
    private static func setupConstraints(for toastView: UIView, in parentView: UIView) {
        NSLayoutConstraint.activate([
            toastView.leadingAnchor.constraint(greaterThanOrEqualTo: parentView.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            toastView.trailingAnchor.constraint(lessThanOrEqualTo: parentView.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            toastView.centerXAnchor.constraint(equalTo: parentView.centerXAnchor),
            toastView.topAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.topAnchor, constant: 16)
        ])
    }
    
    private static func hideToast(_ toastView: UIView) {
        UIView.animate(
            withDuration: 0.3,
            animations: {
                toastView.alpha = 0
                toastView.transform = CGAffineTransform(translationX: 0, y: -50)
            },
            completion: { _ in
                toastView.removeFromSuperview()
            }
        )
    }
}
