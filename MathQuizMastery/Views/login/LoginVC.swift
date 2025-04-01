//
//  LoginVC.swift
//  MathQuizMastery
//
//  Created by Aydın KAYA on 18.01.2025.
//

import UIKit

class LoginVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var fargotPasswordButtonLabel: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    // MARK: - Properties
    private var errorLabels: [UITextField: UILabel] = [:]
    private var viewModel: LoginScreenViewModelProtocol = LoginViewModel()
    private var loadingAlert: UIAlertController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureGesture()
        assignDelegates()
        bindViewModel()
        setupGradientBackground()
        loginButton.applyStyledButton(withTitle: "Log In")
      
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        loginButton.updateGradientFrameIfNeeded()
    }
    
    private func setupUI() {
        emailTextField.applyStyledAppearance(placeholder: L(.enter_email), iconName: "envelope.fill")
        emailTextField.addStyledBackground(in: view)

        passwordTextField.applyStyledAppearance(placeholder: L(.enter_password), iconName: "lock.fill")
        passwordTextField.addStyledBackground(in: view)

//        configureButton(loginButton)
        addErrorLabel(below: emailTextField)
        addErrorLabel(below: passwordTextField)
    }
    
    // MARK: - UI Setup
//    private func setupUI() {
//        configureTextField(emailTextField, placeholderText: L(.enter_email), iconName: "envelope.fill")
//        configureTextField(passwordTextField, placeholderText: L(.enter_password), iconName: "lock.fill")
//        configureButton(loginButton)
//        addErrorLabel(below: emailTextField)
//        addErrorLabel(below: passwordTextField)
//    }
    
//    private func configureUI() {
//        configureTextField(emailTextField, placeholderText: L(.enter_email), iconName: "envelope.fill")
//        configureTextField(passwordTextField, placeholderText: L(.enter_password), iconName: "lock.fill")
//        configureButton(loginButton)
//    }
    
    private func bindViewModel() {
        viewModel.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "",
           let resultVC = segue.destination as? StartVC,
           let score = sender as? String {
        }
    }
    
    // MARK: - Gesture
    private func configureGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - TextField Delegates
    private func assignDelegates() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    // MARK: - IBAction
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        dismissKeyboard()
        clearErrors()
        
        guard let emailField = emailTextField, let passwordField = passwordTextField else { return }
        
        let emailValidation = Validations.validateEmail(emailField.text)
        let passwordValidation = Validations.validateRequired(passwordField.text, messageKey: .field_required)
        
        var hasError = false
        
        for (validation, field) in [(emailValidation, emailField), (passwordValidation, passwordField)] {
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
        viewModel.login(email: emailField.text ?? "", password: passwordField.text ?? "")
    }
    
}

// MARK: - LoginViewModelDelegate
extension LoginVC: LoginViewModelDelegate {
    func didLoginSuccessfuly() {
        hideLoading()
        HapticManager.shared.success()
        ToastView.show(in: self.view, message: L(.login_success))
        // TODO: Navigate to next screen
    }
    
    func didFailWithError(_ error: Error) {
        hideLoading()
        HapticManager.shared.error()
        ToastView.show(in: self.view, message: error.localizedDescription)
    }
}

// MARK: - UITextFieldDelegate
extension LoginVC {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - Inline Error Helpers
extension LoginVC {
    private func setupErrorLabels() {
        [emailTextField, passwordTextField].forEach { addErrorLabel(below: $0) }
    }
    
    private func addErrorLabel(below textField: UITextField?) {
        guard let textField = textField else { return }
        let label = UILabel()
        label.textColor = .systemRed
        label.font = .systemFont(ofSize: 12)
        label.numberOfLines = 0
        label.isHidden = true
        view.addSubview(label)
        
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
        for (field, label) in errorLabels {
            field.layer.borderColor = UIColor.systemGray.cgColor
            label.isHidden = true
        }
    }
}

// MARK: - Loading
extension LoginVC {
    private func showLoading() {
        loadingAlert = UIAlertController(title: nil, message: L(.loading), preferredStyle: .alert)
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.startAnimating()
        loadingAlert?.view.addSubview(indicator)
        indicator.center = loadingAlert!.view.center
        present(loadingAlert!, animated: true)
    }
    
    private func hideLoading() {
        loadingAlert?.dismiss(animated: true)
    }
}

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
    
//    func configureButton(_ button : UIButton){
//        button.layer.cornerRadius = 12
//        button.layer.borderWidth = 2
//        button.layer.borderColor = UIColor(red: 1.0, green: 0.8627, blue: 0.0, alpha: 1.0).cgColor
//        button.backgroundColor = .clear
//      
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.colors = [
//            UIColor.purple.cgColor,
//            UIColor.red.cgColor
//        ]
//        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
//        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
//        
//        if let superview = button.superview {
//            let adjustedFrame = superview.convert(button.frame, to: superview)
//            let backgroundView = UIView(frame: adjustedFrame)
//            gradientLayer.frame = CGRect(origin: .zero, size: adjustedFrame.size)
//            gradientLayer.cornerRadius = button.layer.cornerRadius
//            
//            backgroundView.layer.insertSublayer(gradientLayer, at: 0)
//            backgroundView.layer.cornerRadius = button.layer.cornerRadius
//            backgroundView.layer.shadowColor = UIColor.purple.cgColor
//            backgroundView.layer.shadowOffset = CGSize(width: 0, height: 3)
//            backgroundView.layer.shadowOpacity = 0.3
//            backgroundView.layer.shadowRadius = 6
//            backgroundView.layer.masksToBounds = false
//            
//            superview.addSubview(backgroundView)
//            superview.bringSubviewToFront(button)
//        }
//    }
    
}

