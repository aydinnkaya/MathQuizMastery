//
//  ValidationUI.swift
//  MathQuizMastery
//
//  Created by Aydın KAYA on 6.04.2025.
//

import Foundation
import UIKit
import ObjectiveC

private var errorLabelKey: UInt8 = 0
private var loadingKey: UInt8 = 1

extension UIViewController {
    
     var errorLabels: [UITextField: UILabel] {
        get {
            return objc_getAssociatedObject(self, &errorLabelKey) as? [UITextField: UILabel] ?? [:]
        }
        set {
            objc_setAssociatedObject(self, &errorLabelKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func addErrorLabel(below textField: UITextField?) {
        guard let textField = textField, let parent = textField.superview else { return }
        
        let label = UILabel()
        label.textColor = UIStyle.errorTextColor
        label.font = .systemFont(ofSize: 12)
        label.numberOfLines = 0
        label.isHidden = true
        parent.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: textField.leadingAnchor, constant: 8),
            label.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 4),
            label.trailingAnchor.constraint(equalTo: textField.trailingAnchor)
        ])
        
        var labels = errorLabels
        labels[textField] = label
        errorLabels = labels
    }
    
    func setError(for textField: UITextField, message: String) {
        updateBorder(for: textField, color: .systemRed)
        errorLabels[textField]?.text = message
        errorLabels[textField]?.isHidden = false
    }
    
    func setValid(for textField: UITextField) {
        updateBorder(for: textField, color: .systemGreen)
        errorLabels[textField]?.isHidden = true
    }
    
    func clearErrors() {
        errorLabels.forEach {
            updateBorder(for: $0.key, color: .systemGray)
            $0.value.isHidden = true
        }
    }
    
    private func updateBorder(for textField: UITextField, color: UIColor) {
        textField.layer.borderColor = color.cgColor
        textField.layer.borderWidth = 2
    }
    
    
    private var loadingAlert: UIAlertController? {
        get {
            objc_getAssociatedObject(self, &loadingKey) as? UIAlertController
        }
        set {
            objc_setAssociatedObject(self, &loadingKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func showLoading() {
        loadingAlert = UIAlertController(title: nil, message: L(.loading), preferredStyle: .alert)
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.startAnimating()
        
        loadingAlert?.view.addSubview(indicator)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        
        present(loadingAlert!, animated: true) {
            indicator.centerXAnchor.constraint(equalTo: self.loadingAlert!.view.centerXAnchor).isActive = true
            indicator.centerYAnchor.constraint(equalTo: self.loadingAlert!.view.centerYAnchor).isActive = true
        }
    }
    
    func hideLoading() {
        loadingAlert?.dismiss(animated: true)
    }
}
