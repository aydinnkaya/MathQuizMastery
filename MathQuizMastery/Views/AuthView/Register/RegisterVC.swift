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
    private let coordinator: AppCoordinator?
    private let hapticManager: HapticManagerProtocol
    private let toastManager: ToastManagerProtocol
    
    private var errorLabels: [UITextField: UILabel] = [:]
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
        coordinator: AppCoordinator? = nil,
        hapticManager: HapticManagerProtocol = HapticManager.shared,
        toastManager: ToastManagerProtocol = ToastManager.shared
    ) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        self.hapticManager = hapticManager
        self.toastManager = toastManager
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable, message: "Use init(viewModel:coordinator:) instead.")
    required init?(coder: NSCoder) {
        fatalError("Storyboard initialization not supported. Use dependency injection.")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        setupUIWhenLocalizerLoaded()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateGradientFrame()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.clearState()
    }
    
    // MARK: - Actions
    @IBAction private func registerSubmitButtonTapped(_ sender: UIButton) {
        handleRegistrationAttempt()
    }
    
    // MARK: - Private Methods
    private func setupViewModel() {
        viewModel.delegate = self
    }
    
    private func setupUIWhenLocalizerLoaded() {
        Localizer.shared.onLoaded { [weak self] in
            DispatchQueue.main.async {
                self?.setupUI()
                self?.setupGradientBackground()
                self?.configureGestures()
                self?.assignTextFieldDelegates()
            }
        }
    }
    
    private func handleRegistrationAttempt() {
        prepareForValidation()
        
        let formData = collectFormData()
        viewModel.validateAndRegister(
            name: formData.name,
            email: formData.email,
            password: formData.password,
            confirmPassword: formData.confirmPassword
        )
    }
    
    private func collectFormData() -> (name: String?, email: String?, password: String?, confirmPassword: String?) {
        return (
            name: registerFullNameField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
            email: registerEmailField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
            password: registerPasswordField.text,
            confirmPassword: registerConfirmPasswordField.text
        )
    }
    
    private func prepareForValidation() {
        dismissKeyboard()
        clearAllErrors()
        disableSubmitButton()
    }
    
    private func disableSubmitButton() {
        registerSubmitButton.isEnabled = false
        registerSubmitButton.alpha = 0.7
    }
    
    private func enableSubmitButton() {
        registerSubmitButton.isEnabled = true
        registerSubmitButton.alpha = 1.0
    }
}

// MARK: - RegisterViewModelDelegate
extension RegisterVC: RegisterViewModelDelegate {
    func registrationStateDidChange(_ state: RegistrationState) {
        switch state {
        case .idle:
            handleIdleState()
        case .validating:
            handleValidatingState()
        case .registering:
            handleRegisteringState()
        case .success(let user):
            handleSuccessState(user: user)
        case .failure(let error):
            handleFailureState(error: error)
        }
    }
    
    private func handleIdleState() {
       // hideLoading()
        enableSubmitButton()
    }
    
    private func handleValidatingState() {
        showLoading(message: L(.validation_error))
    }
    
    private func handleRegisteringState() {
        showLoading(message: L(.register_now))
    }
    
    private func handleSuccessState(user: AppUser) {
      //  hideLoading()
        enableSubmitButton()
        hapticManager.success()
        toastManager.showSuccess(message: L(.registration_success))
        
        // Navigate to home after a short delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.coordinator?.goToHome(with: user)
        }
    }
    
    private func handleFailureState(error: Error) {
      //  hideLoading()
        enableSubmitButton()
        hapticManager.error()
        
        if let registrationError = error as? RegistrationError {
            handleRegistrationError(registrationError)
        } else {
            toastManager.showError(message: error.localizedDescription)
        }
    }
    
    private func handleRegistrationError(_ error: RegistrationError) {
        switch error {
        case .invalidInput(let message):
           // handleValidationErrors(message)
        case .registrationFailed(let message):
            toastManager.showError(message: message)
        case .userDataMissing:
            toastManager.showError(message: L(.error))
        case .networkError:
            toastManager.showError(message: L(.error))
        }
    }
    

}

// MARK: - UI Setup
private extension RegisterVC {
    func setupUI() {
        setupTextFields()
        setupButton()
        setupLabels()
        setupErrorLabels()
    }
    
    func setupTextFields() {
        registerFullNameField.configure(
            iconName: "person.fill",
            placeholder: L(.enter_name),
            keyboardType: .default,
            returnKeyType: .next
        )
        
        registerEmailField.configure(
            iconName: "envelope.fill",
            placeholder: L(.enter_email),
            keyboardType: .emailAddress,
            returnKeyType: .next
        )
        
        registerPasswordField.configure(
            iconName: "lock.fill",
            placeholder: L(.enter_password),
            isSecureTextEntry: true,
        )
        
        registerConfirmPasswordField.configure(
            iconName: "lock.fill",
            placeholder: L(.reenter_password),
            
        )
    }
    
    func setupButton() {
        registerSubmitButton.applyStyledButton(withTitle: L(.register_title))
        registerSubmitButton.updateGradientFrameIfNeeded()
    }
    
    func setupLabels() {
        registerTitle.text = L(.register_title)
        registerTitle.font = .systemFont(ofSize: 24, weight: .bold)
        registerTitle.textAlignment = .center
    }
    
    func setupErrorLabels() {
        fieldMap.values.forEach { addErrorLabel(below: $0) }
    }
    
    func setupGradientBackground() {
        gradientLayer?.removeFromSuperlayer()
        
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = UIColor.Custom.registerBackground
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        
        view.layer.insertSublayer(gradient, at: 0)
        gradientLayer = gradient
    }
    
    func updateGradientFrame() {
        gradientLayer?.frame = view.bounds
    }
    
    func configureGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func assignTextFieldDelegates() {
        [registerFullNameField, registerEmailField, registerPasswordField, registerConfirmPasswordField]
            .forEach { $0?.delegate = self }
    }
}

// MARK: - Error Handling
private extension RegisterVC {
    func addErrorLabel(below textField: UITextField) {
        let errorLabel = UILabel()
        errorLabel.font = .systemFont(ofSize: 12, weight: .regular)
        errorLabel.textColor = .systemRed
        errorLabel.numberOfLines = 0
        errorLabel.isHidden = true
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(errorLabel)
        
        NSLayoutConstraint.activate([
            errorLabel.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 4),
            errorLabel.leadingAnchor.constraint(equalTo: textField.leadingAnchor),
            errorLabel.trailingAnchor.constraint(equalTo: textField.trailingAnchor)
        ])
        
        errorLabels[textField] = errorLabel
    }
    
//    func setError(for textField: UITextField, message: String) {
//        guard let errorLabel = errorLabels[textField] else { return }
//        
//        errorLabel.text = message
//        errorLabel.isHidden = false
//        
//        // Add subtle animation
//        errorLabel.alpha = 0
//        UIView.animate(withDuration: 0.3) {
//            errorLabel.alpha = 1
//        }
//        
//        // Add border color change
//        textField.layer.borderColor = UIColor.systemRed.cgColor
//        textField.layer.borderWidth = 1
//    }
//    
    func clearAllErrors() {
        errorLabels.values.forEach { label in
            label.isHidden = true
            label.text = nil
        }
        
        fieldMap.values.forEach { textField in
            textField.layer.borderColor = UIColor.clear.cgColor
            textField.layer.borderWidth = 0
        }
    }
}

// MARK: - Loading States
private extension RegisterVC {
    func showLoading(message: String = L(.loading)) {
        guard loadingAlert == nil else { return }
        
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(style: .medium)
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.startAnimating()
        
        alert.setValue(loadingIndicator, forKey: "accessoryView")
        
        present(alert, animated: true)
        loadingAlert = alert
    }
    
//    func hideLoading() {
//        loadingAlert?.dismiss(animated: true) { [weak self] in
//            self?.loadingAlert = nil
//        }
//    }
}

// MARK: - UITextFieldDelegate
extension RegisterVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case registerFullNameField:
            registerEmailField.becomeFirstResponder()
        case registerEmailField:
            registerPasswordField.becomeFirstResponder()
        case registerPasswordField:
            registerConfirmPasswordField.becomeFirstResponder()
        case registerConfirmPasswordField:
            textField.resignFirstResponder()
            handleRegistrationAttempt()
        default:
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Clear error for this field when user starts editing
        if let errorLabel = errorLabels[textField] {
            errorLabel.isHidden = true
            textField.layer.borderColor = UIColor.clear.cgColor
            textField.layer.borderWidth = 0
        }
    }
}

// MARK: - Protocol Definitions for Testability
protocol HapticManagerProtocol {
    func success()
    func error()
}

protocol ToastManagerProtocol {
    func showSuccess(message: String)
    func showError(message: String)
}

// MARK: - Default Implementations
extension HapticManager: HapticManagerProtocol {}

final class ToastManager: ToastManagerProtocol {
    static let shared = ToastManager()
    private init() {}
    
    func showSuccess(message: String) {
        // Actual toast implementation would go here
        DispatchQueue.main.async {
            // Show success toast UI
            print("✅ Success: \(message)")
        }
    }
    
    func showError(message: String) {
        // Actual toast implementation would go here
        DispatchQueue.main.async {
            // Show error toast UI
            print("❌ Error: \(message)")
        }
    }
}

// MARK: - CustomTextField Extension
private extension CustomTextField {
    func configure(
        iconName: String,
        placeholder: String,
        keyboardType: UIKeyboardType = .default,
        returnKeyType: UIReturnKeyType = .next,
        isSecureTextEntry: Bool = false
    ) {
        self.iconName = iconName
        self.placeholderText = placeholder
        self.keyboardType = keyboardType
        self.returnKeyType = returnKeyType
        self.isSecureTextEntry = isSecureTextEntry
    }
}
