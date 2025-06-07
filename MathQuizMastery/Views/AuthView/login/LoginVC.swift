//
//  LoginVC.swift
//  MathQuizMastery
//
//  Created by Aydın KAYA on 18.01.2025.
//

import UIKit

@available(iOS 16, *)
class LoginVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var fargotPasswordButtonLabel: UIButton!
    
    @IBOutlet weak var createAnAccountButton: UIButton!
    
    private var errorLabels: [UITextField: UILabel] = [:]
    private let viewModel: LoginScreenViewModelProtocol
    private var loadingAlert: UIAlertController?
    var coordinator: AppCoordinator?
    
    private var fieldMap: [FieldKey: UITextField] {
        return [
            .email: emailTextField,
            .password: passwordTextField
        ]
    }
    
    init(viewModel: LoginScreenViewModelProtocol = LoginViewModel(), coordinator: AppCoordinator?) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName:nil, bundle: nil)
    }
    
    @available(*, unavailable, message: "Use init(viewModel:coordinator:) instead.")
    required init?(coder: NSCoder) {
        fatalError("Storyboard initialization not supported.")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        loginButton.updateGradientFrameIfNeeded()
        configureGesture()
        assignDelegates()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupGradientBackground()
        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        prepareForValidation()
        viewModel.validateInputs(
            email: emailTextField.text ?? "",
            password: passwordTextField.text ?? ""
        )
    }
    
    @IBAction func createAnAccountTapped(_ sender: Any, forEvent event: UIEvent) {
        viewModel.handleRegiserTapped()
    }
    
}

@available(iOS 16, *)
extension LoginVC: LoginViewModelDelegate {
    func navigateToRegister() {
        coordinator?.goToRegister()
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
        viewModel.login(
            email: emailTextField.text ?? "",
            password: passwordTextField.text ?? ""
        )
    }
    
    func didLoginSuccessfully(user: User) {
        hideLoading()
        HapticManager.shared.success()
        ToastView.show(in: self.view, message: L(.login_success))
        coordinator?.goToHome(with: user)
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
   
    func setupGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = UIColor.Custom.loginBackground
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
}

