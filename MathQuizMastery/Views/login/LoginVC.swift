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
    
    // MARK: - Initializer
    init(viewModel: LoginScreenViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
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
        assignDelegates()
        bindViewModel()
        setupGradientBackground()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        loginButton.updateGradientFrameIfNeeded()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        emailTextField.applyStyledAppearance(placeholder: L(.enter_email), iconName: "envelope.fill")
        emailTextField.addStyledBackground(in: view)
        
        passwordTextField.applyStyledAppearance(placeholder: L(.enter_password), iconName: "lock.fill")
        passwordTextField.addStyledBackground(in: view)
        
        loginButton.applyStyledButton(withTitle: "Login")
        
        [emailTextField, passwordTextField].forEach { addErrorLabel(below: $0) }
    }
    
    // MARK: - ViewModel Binding
    private func bindViewModel() {
        viewModel.delegate = self
    }
    
    // MARK: - Gesture Configuration
    private func configureGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - Delegate Assignment
    private func assignDelegates() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    // MARK: - IBActions
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        dismissKeyboard()
        clearErrors()
        
        let emailValidation = Validator.validateEmail(emailTextField.text)
        let passwordValidation = Validator.validateRequired(passwordTextField.text, message: L(.enter_password_required))
        
        let validations: [(ValidationResult, UITextField)] = [
            (emailValidation, emailTextField),
            (passwordValidation, passwordTextField)
        ]
        
        var hasError = false
        
        for (validation, field) in validations {
            switch validation {
            case .valid:
                setValid(for: field)
            case .invalid(let msg):
                setError(for: field, message: msg)
                hasError = true
            }
        }
        
        guard !hasError else {
            HapticManager.shared.error()
            return
        }
        
        HapticManager.shared.mediumImpact()
        showLoading()
        viewModel.login(email: emailTextField.text ?? "", password: passwordTextField.text ?? "")
    }
    
    // MARK: - Navigation
    private func navigateToStartScreen(with uuid: UUID) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let startVC = storyboard.instantiateViewController(withIdentifier: "StartVC") as? StartVC {
            startVC.userUUID = uuid
            navigationController?.pushViewController(startVC, animated: true)
        }
    }
}

// MARK: - LoginViewModelDelegate
@available(iOS 16, *)
extension LoginVC: LoginViewModelDelegate {
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

// MARK: - UITextFieldDelegate
@available(iOS 16, *)
extension LoginVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - Inline Error Helpers
@available(iOS 16, *)
extension LoginVC {
    private func addErrorLabel(below textField: UITextField?) {
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
        
        errorLabels[textField] = label
    }
    
    private func setError(for textField: UITextField, message: String) {
        textField.layer.borderColor = UIColor.systemRed.cgColor
        errorLabels[textField]?.text = message
        errorLabels[textField]?.isHidden = false
    }
    
    private func setValid(for textField: UITextField) {
        textField.layer.borderColor = UIColor.systemGreen.cgColor
        errorLabels[textField]?.isHidden = true
    }
    
    private func clearErrors() {
        errorLabels.forEach { $0.key.layer.borderColor = UIColor.systemGray.cgColor; $0.value.isHidden = true }
    }
}

// MARK: - Loading
@available(iOS 16, *)
extension LoginVC {
    private func showLoading() {
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
    
    private func hideLoading() {
        loadingAlert?.dismiss(animated: true)
    }
}

// MARK: - Gradient Background
@available(iOS 16, *)
extension LoginVC {
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
