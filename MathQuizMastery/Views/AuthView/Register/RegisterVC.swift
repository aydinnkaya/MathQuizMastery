//
//  RegisterVC.swift
//  MathQuizMastery
//
//  Created by Aydın KAYA on 6.04.2025.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

class RegisterVC: UIViewController {
    
    @IBOutlet weak var registerFullNameField: CustomTextField!
    @IBOutlet weak var registerEmailField: CustomTextField!
    @IBOutlet weak var registerPasswordField: CustomTextField!
    @IBOutlet weak var registerConfirmPasswordField: CustomTextField!
    @IBOutlet weak var registerTitle: UILabel!
    @IBOutlet weak var registerSubmitButton: UIButton!
    
    // MARK: - Properties
    private let viewModel: RegisterViewModelProtocol
    private var coordinator: AppCoordinator?
    
    // UI Management
    private var loadingAlert: UIAlertController?
    private var gradientLayer: CAGradientLayer?
    
    // MARK: - Field Mapping
    private var fieldMap: [FieldKey: UITextField] {
        return [
            .name: registerFullNameField,
            .email: registerEmailField,
            .password: registerPasswordField,
            .confirmPassword: registerConfirmPasswordField
        ]
    }
    
    // MARK: - Initialization
    init(
        viewModel: RegisterViewModelProtocol = RegisterViewModel(),
        coordinator: AppCoordinator? = nil
    ) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable, message: "Use init(viewModel:coordinator:) instead.")
    required init?(coder: NSCoder) {
        fatalError("Storyboard initialization not supported. Use dependency injection.")
    }
    
    deinit {
        viewModel.delegate = nil
        loadingAlert?.dismiss(animated: false, completion: nil)
        NotificationCenter.default.removeObserver(self)
        print("🗑️ RegisterVC deallocated")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        
        Localizer.shared.onLoaded { [weak self] in
            self?.setupUI()
            self?.configureGestures()
            self?.assignTextFieldDelegates()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupGradientBackground()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateGradientFrame()
    }
    
    // MARK: - Actions
    @IBAction private func registerSubmitButtonTapped(_ sender: UIButton) {
        prepareForValidation()
        
        let formData = collectFormData()
        viewModel.validateInputs(
            name: formData.name,
            email: formData.email,
            password: formData.password,
            confirmPassword: formData.confirmPassword
        )
    }
    
    // MARK: - Private Methods
    private func collectFormData() -> (name: String, email: String, password: String, confirmPassword: String) {
        return (
            name: registerFullNameField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "",
            email: registerEmailField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "",
            password: registerPasswordField.text ?? "",
            confirmPassword: registerConfirmPasswordField.text ?? ""
        )
    }
    
    private func prepareForValidation() {
        dismissKeyboard()
        clearErrors()
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - RegisterViewModelDelegate
extension RegisterVC: RegisterViewModelDelegate {
    func didRegisterSuccessfully(user: AppUser) {
        hideLoading()
        HapticManager.shared.success()
        ToastView.show(in: self.view, message: L(.registration_success))
        coordinator?.goToHome(with: user)
    }
    
    func didFailWithError(_ error: Error) {
        hideLoading()
        HapticManager.shared.error()
        ToastView.show(in: self.view, message: error.localizedDescription)
    }
    
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
        
        let formData = collectFormData()
        viewModel.register(
            name: formData.name,
            email: formData.email,
            password: formData.password
        )
    }
}

// MARK: - UI Setup
extension RegisterVC {
    private func setupUI() {
        setupTextFields()
        setupLabels()
        setupErrorLabels()
    }
    
    private func setupTextFields() {
        registerFullNameField.iconName = "person.fill"
        registerFullNameField.placeholderText = L(.enter_name)
        registerFullNameField.keyboardType = .default
        registerFullNameField.returnKeyType = .next
        
        registerEmailField.iconName = "envelope.fill"
        registerEmailField.placeholderText = L(.enter_email)
        registerEmailField.keyboardType = .emailAddress
        registerEmailField.returnKeyType = .next
        
        registerPasswordField.iconName = "lock.fill"
        registerPasswordField.placeholderText = L(.enter_password)
        registerPasswordField.isSecureTextEntry = true
        registerPasswordField.returnKeyType = .next
        
        registerConfirmPasswordField.iconName = "lock.fill"
        registerConfirmPasswordField.placeholderText = L(.reenter_password)
        registerConfirmPasswordField.isSecureTextEntry = true
        registerConfirmPasswordField.returnKeyType = .done
    }
    
    private func setupLabels() {
        registerTitle.text = L(.register_title_text)
        registerTitle.font = .systemFont(ofSize: 24, weight: .bold)
        registerTitle.textAlignment = .center
    }
    
    private func setupErrorLabels() {
        fieldMap.values.forEach { addErrorLabel(below: $0) }
    }
    
    private func setupGradientBackground() {
        gradientLayer?.removeFromSuperlayer()
        
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = UIColor.Custom.registerBackground
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        
        view.layer.insertSublayer(gradient, at: 0)
        gradientLayer = gradient
    }
    
    private func updateGradientFrame() {
        gradientLayer?.frame = view.bounds
    }
    
    private func configureGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    private func assignTextFieldDelegates() {
        [registerFullNameField, registerEmailField, registerPasswordField, registerConfirmPasswordField]
            .forEach { $0?.delegate = self }
    }
}

// MARK: - Loading States
extension RegisterVC {
    private func showLoading(message: String = L(.loading)) {
        guard loadingAlert == nil else { return }
        
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(style: .medium)
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.startAnimating()
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        alert.setValue(loadingIndicator, forKey: "accessoryView")
        
        present(alert, animated: true)
        loadingAlert = alert
    }
    
   
}

// MARK: - UITextFieldDelegate
extension RegisterVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        HapticManager.shared.lightImpact()
        
        switch textField {
        case registerFullNameField:
            registerEmailField.becomeFirstResponder()
        case registerEmailField:
            registerPasswordField.becomeFirstResponder()
        case registerPasswordField:
            registerConfirmPasswordField.becomeFirstResponder()
        case registerConfirmPasswordField:
            textField.resignFirstResponder()
            registerSubmitButtonTapped(registerSubmitButton)
        default:
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Clear error for this field when user starts editing
        if let errorLabel = errorLabels[textField], !errorLabel.isHidden {
            UIView.animate(withDuration: 0.2) {
                errorLabel.alpha = 0
                textField.layer.borderColor = UIColor.clear.cgColor
                textField.layer.borderWidth = 0
            } completion: { _ in
                errorLabel.isHidden = true
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        // Trim whitespace for name and email fields
        if textField == registerFullNameField || textField == registerEmailField {
            textField.text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }
}
