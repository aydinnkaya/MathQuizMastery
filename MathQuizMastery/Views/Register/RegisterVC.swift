//
//  RegisterVC.swift
//  MathQuizMastery
//
//  Created by Aydın KAYA on 6.04.2025.
//

import Foundation
import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore


class RegisterVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var registerFullNameField: UITextField!
    @IBOutlet weak var registerEmailField: UITextField!
    @IBOutlet weak var registerPasswordField: UITextField!
    @IBOutlet weak var registerConfirmPasswordField: UITextField!
    @IBOutlet weak var registerSubmitButton: UIButton!
    
    private var viewModel : RegisterViewModelProtocol
    private var errorLabels: [UITextField: UILabel] = [:]
    private var loadingAlert: UIAlertController?
    
    private var fieldMap: [FieldKey: UITextField] {
        return [
            .name: registerFullNameField,
            .email: registerEmailField,
            .password: registerPasswordField,
            .confirmPassword: registerConfirmPasswordField
        ]
    }
    
    init(viewModel : RegisterViewModelProtocol = RegisterViewModel()){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        let defaultViewModel = RegisterViewModel()
        self.viewModel = defaultViewModel
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        setupUI()
        configureGesture()
        assignDelegates()
        setupGradientBackground()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        registerSubmitButton.updateGradientFrameIfNeeded()
    }
    
    
    @IBAction func registerSubmitButtonTapped(_ sender: Any) {
        prepareForValidation()
        viewModel.validateInputs(
            name: registerFullNameField.text,
            email: registerEmailField.text,
            password: registerPasswordField.text,
            confirmPassword: registerConfirmPasswordField.text
        )
        didRegisterSuccessfully()
    }
    
}

@available(iOS 16, *)
extension RegisterVC: RegisterViewModelDelegate {
    
    func didRegisterSuccessfully() {
        hideLoading()
        HapticManager.shared.success()
        ToastView.show(in: self.view, message: L(.registration_success))
        navigateToStartScreen()
    }
    
    func didFailWithError(_ error: any Error) {
        hideLoading()
        HapticManager.shared.error()
        ToastView.show(in: self.view, message: error.localizedDescription)
    }
    
    func didValidationFail(results: [ValidationResult]) {
        hideLoading()
        clearErrors()
        
        guard !results.isEmpty else {
            showLoading()
            viewModel.validateInputs(
                name: registerFullNameField.text ?? "",
                email: registerEmailField.text ?? "",
                password: registerPasswordField.text ?? "",
                confirmPassword: registerConfirmPasswordField.text ?? ""
            )
            return
        }
        
        HapticManager.shared.error()
        results.forEach { result in
            if case .invalid(let field, let message) = result {
                fieldMap[field].map { setError(for: $0, message: message) }
            }
        }
    }
    
}

extension RegisterVC {
    func setupUI(){
        registerFullNameField.applyStyledAppearance(placeholder: L(.enter_name), iconName: "person.fill")
        registerEmailField.applyStyledAppearance(placeholder: L(.enter_email), iconName: "envelope.fill")
        registerPasswordField.applyStyledAppearance(placeholder: L(.enter_password), iconName: "lock.fill")
        registerConfirmPasswordField.applyStyledAppearance(placeholder: L(.reenter_password), iconName: "lock.fill")
        
        registerFullNameField.addStyledBackground(in: view)
        registerEmailField.addStyledBackground(in: view)
        registerPasswordField.addStyledBackground(in: view)
        registerConfirmPasswordField.addStyledBackground(in: view)
        
        registerSubmitButton.applyStyledButton(withTitle: L(.register_title))
        
        [registerFullNameField, registerEmailField, registerPasswordField, registerConfirmPasswordField].forEach { addErrorLabel(below: $0) }
    }
    
    func configureGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func prepareForValidation() {
        dismissKeyboard()
        clearErrors()
    }
    
    func assignDelegates() {
        registerFullNameField.delegate = self
        registerEmailField.delegate = self
        registerPasswordField.delegate = self
        registerConfirmPasswordField.delegate = self
    }
    
    func navigateToStartScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let startVC = storyboard.instantiateViewController(withIdentifier: "StartVC") as? StartVC {
            navigationController?.pushViewController(startVC, animated: true)
        }
    }
    
    func setupGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [
            UIColor(red: 0.9, green: 0.7, blue: 0.0, alpha: 1.0).cgColor,
            // UIColor(red: 0.8, green: 0.1, blue: 0.0, alpha: 1.0).cgColor,
            UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1.0).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
}
