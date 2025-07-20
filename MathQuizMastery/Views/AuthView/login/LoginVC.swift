//
//  LoginVC.swift
//  MathQuizMastery
//
//  Created by Aydın KAYA on 18.01.2025.
//

import UIKit

@available(iOS 16, *)
class LoginVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: CustomTextField!
    @IBOutlet weak var passwordTextField: CustomTextField!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var guestButton: UIButton!
    @IBOutlet weak var noAccountLabel: UILabel!
    
    @IBOutlet weak var agreementLabel: UILabel!
    
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
        view.backgroundColor = .black
        viewModel.delegate = self
        
        Localizer.shared.onLoaded { [weak self] in
            self?.loginButton.updateGradientFrameIfNeeded()
            self?.configureGesture()
            self?.assignDelegates()
            self?.setupUI()
            self?.setupAgreementLabel()
            self?.setupAccountQuestionLabel()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupGradientBackground()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        agreementLabel.preferredMaxLayoutWidth = agreementLabel.frame.width
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        prepareForValidation()
        viewModel.validateInputs(
            email: emailTextField.text ?? "",
            password: passwordTextField.text ?? ""
        )
    }
    
    @IBAction func guestButtonTapped(_ sender: Any) {
        viewModel.handleGuestLogin()
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
    
    func didLoginSuccessfully(user: AppUser) {
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

@available(iOS 16, *)
extension LoginVC {
    func setupUI() {
        emailTextField.iconName = "paperplane.fill" // envelope.fill"
        emailTextField.placeholderText = L(.enter_email)
        passwordTextField.iconName = "lock.fill"
        passwordTextField.placeholderText = L(.enter_password)
        loginButton.applyStyledButton(withTitle: L(.log_in))
        [emailTextField, passwordTextField].forEach { addErrorLabel(below: $0) }
        setupGuestButton()
    }
    
    func assignDelegates() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
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
    
    
    func setupGuestButton() {
            guestButton.setTitle(L(.continue_as_guest), for: .normal)
            guestButton.setTitleColor(.white, for: .normal)
            guestButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
            guestButton.backgroundColor = .clear
            guestButton.layer.borderColor = UIColor.white.cgColor
            guestButton.layer.borderWidth = 1.5
            guestButton.layer.cornerRadius = 12
    }
    
    func setupGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = UIColor.Custom.loginBackground
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    // MARK: - Account Question Label Setup
    func setupAccountQuestionLabel() {
        let questionText = L(.no_account_question)
        let registerText = L(.register_now)
        let fullText = "\(questionText) \(registerText)"
        
        let attributedString = NSMutableAttributedString(string: fullText)
        
        // Base styling for the question part
        let questionRange = (fullText as NSString).range(of: questionText)
        attributedString.addAttribute(.foregroundColor,
                                      value: UIColor.white.withAlphaComponent(0.8),
                                      range: questionRange)
        attributedString.addAttribute(.font,
                                      value: UIFont.systemFont(ofSize: 13),
                                      range: questionRange)
        
        // Styling for the register part (clickable)
        let registerRange = (fullText as NSString).range(of: registerText)
        attributedString.addAttribute(.foregroundColor,
                                      value: UIColor.systemYellow,
                                      range: registerRange)
        attributedString.addAttribute(.font,
                                      value: UIFont.systemFont(ofSize: 16, weight: .semibold),
                                      range: registerRange)
        attributedString.addAttribute(.underlineStyle,
                                      value: NSUnderlineStyle.single.rawValue,
                                      range: registerRange)
        
        noAccountLabel.attributedText = attributedString
        noAccountLabel.isUserInteractionEnabled = true
        noAccountLabel.numberOfLines = 1
        noAccountLabel.textAlignment = .center
        noAccountLabel.lineBreakMode = .byTruncatingTail
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleAccountQuestionTap(_:)))
        noAccountLabel.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleAccountQuestionTap(_ gesture: UITapGestureRecognizer) {
        guard let text = noAccountLabel.attributedText?.string else { return }
        
        let registerText = L(.register_now)
        let registerRange = (text as NSString).range(of: registerText)
        
        let location = gesture.location(in: noAccountLabel)
        
        if let index = characterIndex(at: location, in: noAccountLabel) {
            if NSLocationInRange(index, registerRange) {
                HapticManager.shared.lightImpact()
                viewModel.handleRegiserTapped()
            }
        }
    }
    
    func setupAgreementLabel(){
        let fullText = L(.agreement_text)
        let termsText = L(.terms_of_service)
        let privacyText = L(.privacy_policy)
        
        let attributedString = NSMutableAttributedString(string: fullText)
        
        let linkColor = UIColor.systemYellow
        let termsRange = (fullText as NSString).range(of: termsText)
        let privacyRange = (fullText as NSString).range(of: privacyText)
        
        [termsRange, privacyRange].forEach { range in
            attributedString.addAttribute(.foregroundColor, value: linkColor, range: range)
            attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range)
        }
        
        agreementLabel.attributedText = attributedString
        agreementLabel.isUserInteractionEnabled = true
        agreementLabel.numberOfLines = 0
        agreementLabel.textAlignment = .center
        agreementLabel.lineBreakMode = .byWordWrapping
        agreementLabel.adjustsFontSizeToFitWidth = true
        agreementLabel.minimumScaleFactor = 0.8
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleAgreementTap(_:)))
        agreementLabel.addGestureRecognizer(tapGesture)
    }
    
    func characterIndex(at point: CGPoint, in label: UILabel) -> Int? {
        guard let attributedText = label.attributedText else { return nil }
        
        let textStorage = NSTextStorage(attributedString: attributedText)
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: label.bounds.size)
        
        textContainer.lineFragmentPadding = 0
        textContainer.maximumNumberOfLines = label.numberOfLines
        textContainer.lineBreakMode = label.lineBreakMode
        
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        return layoutManager.characterIndex(for: point, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
    }
    
    func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
    
    @objc func handleAgreementTap(_ gesture: UITapGestureRecognizer) {
        guard let text = agreementLabel.attributedText?.string else { return }
        
        let termsText = NSLocalizedString(L(.terms_of_service), comment: "")
        let privacyText = NSLocalizedString(L(.privacy_policy), comment: "")
        
        let termsRange = (text as NSString).range(of: termsText)
        let privacyRange = (text as NSString).range(of: privacyText)
        
        let location = gesture.location(in: agreementLabel)
        
        if let index = characterIndex(at: location, in: agreementLabel) {
            if NSLocationInRange(index, termsRange) {
                openURL("https://docs.google.com/document/d/1aR8pAbu5c-VYw0kmCQH22qL4Z1VMjE9_Ca9iiYDHtdU/edit?usp=sharing")
            } else if NSLocationInRange(index, privacyRange) {
                openURL("https://docs.google.com/document/d/1vxyHOi7SnfJpjBP6-epJG9rMzZUG_WP_VnUQuFP4qvQ/edit?usp=sharing")
            }
        }
    }
    
}

