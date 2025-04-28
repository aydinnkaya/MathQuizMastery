//
//  LoginVC.swift
//  MathQuizMastery
//
//  Created by Aydın KAYA on 18.01.2025.
//

import UIKit

@available(iOS 16, *)
class LoginVC: UIViewController, UITextFieldDelegate {
    
    // MARK: - IBOutlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var fargotPasswordButtonLabel: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    // MARK: - Properties
    private var errorLabels: [UITextField: UILabel] = [:]
    private let viewModel: LoginScreenViewModelProtocol
    private var loadingAlert: UIAlertController?
    
    private var fieldMap: [FieldKey: UITextField] {
        return [
            .email: emailTextField,
            .password: passwordTextField
        ]
    }
    
    required init?(coder: NSCoder) {
        let defaultViewModel = LoginViewModel()
        self.viewModel = defaultViewModel
        super.init(coder: coder)
    }
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureGesture()
        bindViewModel()
        assignDelegates()
        setupGradientBackground()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        loginButton.updateGradientFrameIfNeeded()
    }
    
    // MARK: - IBActions
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        prepareForValidation()
        viewModel.validateInputs(
            email: emailTextField.text ?? "",
            password: passwordTextField.text ?? ""
        )
    }
}

@available(iOS 16, *)
extension LoginVC: LoginViewModelDelegate {
    func didValidationFail(results: [ValidationResult]) {
        hideLoading()
        clearErrors()
        
        guard results.isEmpty else {
            HapticManager.shared.error()
            results.forEach { result in
                if case .invalid(let field, let message) = result {
                    fieldMap[field].map { setError(for: $0, message: message) }
                }
            }
            return
        }
        
        HapticManager.shared.mediumImpact()
        showLoading()
        viewModel.login(
            email: emailTextField.text ?? "",
            password: passwordTextField.text ?? ""
        )
    }
    
    func didLoginSuccessfully(userUUID uuid: UUID) {
        hideLoading()
        HapticManager.shared.success()
        ToastView.show(in: self.view, message: L(.login_success))
        navigateToStartScreen(with: uuid)
    }
    
    func didFailWithError(_ error: Error) {
        hideLoading()
        HapticManager.shared.error()
        ToastView.show(in: self.view, message: error.localizedDescription)
    }
}

extension LoginVC {
    func setupUI() {
        emailTextField.applyStyledAppearance(placeholder: L(.enter_email), iconName: "envelope.fill")
        emailTextField.addStyledBackground(in: view)
        
        passwordTextField.applyStyledAppearance(placeholder: L(.enter_password), iconName: "lock.fill")
        passwordTextField.addStyledBackground(in: view)
        
        loginButton.applyStyledButton(withTitle: L(.log_in))
        
        [emailTextField, passwordTextField].forEach { addErrorLabel(below: $0) }
    }
    
    func assignDelegates() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    func bindViewModel() {
        viewModel.delegate = self
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
    
    func navigateToStartScreen(with uuid: UUID) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let startVC = storyboard.instantiateViewController(withIdentifier: "StartVC") as? StartVC {
            startVC.userUUID = uuid
            navigationController?.pushViewController(startVC, animated: true)
        }
    }
    
    func setupGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [
            UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1.0).cgColor,
            UIColor(red: 0.8, green: 0.1, blue: 0.0, alpha: 1.0).cgColor,
            UIColor(red: 0.9, green: 0.7, blue: 0.0, alpha: 1.0).cgColor,
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
}

