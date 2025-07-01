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
    
    @IBOutlet weak var registerFullNameField: CustomTextField!
    @IBOutlet weak var registerEmailField: CustomTextField!
    @IBOutlet weak var registerPasswordField: CustomTextField!
    @IBOutlet weak var registerConfirmPasswordField: CustomTextField!
    @IBOutlet weak var registerTitle: UILabel!
    @IBOutlet weak var registerSubmitButton: UIButton!
    
    private var viewModel : RegisterViewModelProtocol
    private var errorLabels: [UITextField: UILabel] = [:]
    private var loadingAlert: UIAlertController?
    private var coordinator: AppCoordinator?
    
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
    
    init(viewModel: RegisterViewModelProtocol = RegisterViewModel(), coordinator: AppCoordinator?) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable, message: "Use init(viewModel:coordinator:) instead.")
    required init?(coder: NSCoder) {
        fatalError("Storyboard initialization not supported.")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        Localizer.shared.onLoaded { [weak self] in
            self?.registerSubmitButton.updateGradientFrameIfNeeded()
            self?.configureGesture()
            self?.assignDelegates()
            self?.setupUI()
            self?.setupGradientBackground()
            
        }
    }
 
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
      
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
        registerFullNameField.iconName = "person.fill"
        registerFullNameField.placeholderText = L(.enter_name)
        registerEmailField.iconName = "envelope.fill"
        registerEmailField.placeholderText = L(.enter_email)
        registerPasswordField.iconName = "lock.fill"
        registerPasswordField.placeholderText = L(.enter_password)
        registerConfirmPasswordField.iconName = "lock.fill"
        registerConfirmPasswordField.placeholderText = L(.reenter_password)
        registerSubmitButton.applyStyledButton(withTitle: L(.register_title))
        registerTitle.text = L(.register_title)
        
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
        if let startVC = storyboard.instantiateViewController(withIdentifier: "StartVC") as? HomeVC {
            navigationController?.pushViewController(startVC, animated: true)
        }
    }
    
    func setupGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = UIColor.Custom.registerBackground
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
}
