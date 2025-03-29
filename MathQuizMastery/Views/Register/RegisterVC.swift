//
//  RegisterVC.swift
//  MathQuizMastery
//
//  Created by Aydın KAYA on 21.01.2025.
//

import UIKit


// MARK: - Register View Controller
final class RegisterVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordAgainTextField: UITextField!
    @IBOutlet weak var createAccountButton: UIButton!
    
    private var viewModel: RegisterScreenViewModelProtocol = RegisterScreenViewModel()
    private var loadingAlert : UIAlertController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureGesture()
        assignTextFieldDelegates()
        bindViewModel()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureGradientBackground()
        configureUIComponents()
    }
    
    // MARK: - ViewModel Binding
    private func bindViewModel() {
        (viewModel as? RegisterScreenViewModel)?.delegate = self
    }
    
    // MARK: - UI Setup
    private func configureView() {
        configureTextField(nameTextField, placeholderText: "Enter your name", iconName: "person.fill")
        configureTextField(emailTextField, placeholderText: "Enter your email", iconName: "envelope.fill")
        configureTextField(passwordTextField, placeholderText: "Enter your password", iconName: "lock.fill")
        configureTextField(passwordAgainTextField, placeholderText: "Re-enter your password", iconName: "lock.fill")
    }
    
    private func configureUIComponents() {
        [nameTextField, emailTextField, passwordTextField, passwordAgainTextField].forEach {
            configureTextFieldBackground(for: $0)
        }
        configureButton(createAccountButton)
    }
    
    private func assignTextFieldDelegates() {
        [nameTextField, emailTextField, passwordTextField, passwordAgainTextField].forEach {
            $0?.delegate = self
        }
    }
    
    private func configureGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    // MARK: - Actions
    @IBAction func createAccountButtonTapped(_ sender: UIButton) {
        guard let name = nameTextField.text,
              let email = emailTextField.text,
              let password = passwordTextField.text,
              let confirmPassword = passwordAgainTextField.text else {
            showAlert(title: "Hata", message: "Lütfen tüm alanları doldurun.")
            return
        }
        
        guard !name.isEmpty, !email.isEmpty, !password.isEmpty else {
            showAlert(title: "Hata", message: "Lütfen tüm alanları doldurun.")
            return
        }
        
        guard password == confirmPassword else {
            showAlert(title: "Hata", message: "Şifreler uyuşmuyor.")
            return
        }
        
        showLoading()
        viewModel.savePerson(name: name, email: email, password: password)
        
    }
    
}

// MARK: - RegisterScreenViewModelDelegate
extension RegisterVC : RegisterScreenViewModelDelegate {
    func registrationSucceeded() {
        hideLoading()
        showAlert(title: "Başarılı", message: "Kayıt işlemi tamamlandı.") {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func registrationFailed(_ error: any Error) {
        hideLoading()
        showAlert(title: "Hata", message: error.localizedDescription)
    }
}

// MARK: - UITextFieldDelegate
extension RegisterVC {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - Alert & Loading Helpers
extension RegisterVC {
    private func showLoading(){
        loadingAlert = UIAlertController(title: nil, message: "Lütfen bekleyin...", preferredStyle: .alert)
        let loadingIndicator = UIActivityIndicatorView(style: .large)
        loadingIndicator.startAnimating()
        loadingAlert?.view.addSubview(loadingIndicator)
        loadingIndicator.center = loadingAlert!.view.center
        present(loadingAlert!, animated: true, completion: nil)
    }
    
    private func hideLoading(){
        loadingAlert?.dismiss(animated: true, completion: nil)
    }
    
    private func showAlert(title: String, message: String, completion: (() -> Void)? = nil){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: {  _ in completion?()}))
        present(alert, animated: true)
        
    }
}

// MARK: - UI Customization
extension RegisterVC {
    
    private func configureGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [
            UIColor.darkGray.cgColor,
            UIColor(red: 0.9, green: 0.7, blue: 0.0, alpha: 1.0).cgColor,
            UIColor.red.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func configureButton(_ button: UIButton) {
        button.layer.cornerRadius = 12
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.yellow.cgColor
        button.backgroundColor = .clear
        
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.purple.cgColor, UIColor.red.cgColor]
        gradient.startPoint = CGPoint(x: 0.5, y: 0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1)
        
        if let superview = button.superview {
            let adjustedFrame = superview.convert(button.frame, to: superview)
            let backgroundView = UIView(frame: adjustedFrame)
            gradient.frame = CGRect(origin: .zero, size: adjustedFrame.size)
            gradient.cornerRadius = button.layer.cornerRadius
            
            backgroundView.layer.insertSublayer(gradient, at: 0)
            backgroundView.layer.cornerRadius = button.layer.cornerRadius
            backgroundView.layer.shadowColor = UIColor.purple.cgColor
            backgroundView.layer.shadowOffset = CGSize(width: 0, height: 3)
            backgroundView.layer.shadowOpacity = 0.3
            backgroundView.layer.shadowRadius = 6
            backgroundView.layer.masksToBounds = false
            
            superview.addSubview(backgroundView)
            superview.bringSubviewToFront(button)
        }
    }
    
    private func configureTextField(_ textField: UITextField, placeholderText: String, iconName: String) {
        textField.layer.cornerRadius = 12
        textField.layer.borderWidth = 2
        textField.layer.borderColor = UIColor.red.cgColor
        textField.backgroundColor = .clear
        textField.textColor = .black
        textField.font = .systemFont(ofSize: 16, weight: .bold)
        
        let iconAttachment = NSTextAttachment()
        iconAttachment.image = UIImage(systemName: iconName)?.withTintColor(.black, renderingMode: .alwaysOriginal)
        iconAttachment.bounds = CGRect(x: 0, y: -4, width: 25, height: 25)
        
        let iconString = NSAttributedString(attachment: iconAttachment)
        let textString = NSAttributedString(string: " \(placeholderText)", attributes: [
            .foregroundColor: UIColor.black,
            .font: UIFont.systemFont(ofSize: 16, weight: .medium)
        ])
        
        let combined = NSMutableAttributedString()
        combined.append(iconString)
        combined.append(textString)
        
        textField.attributedPlaceholder = combined
        textField.contentVerticalAlignment = .center
    }
    
    private func configureTextFieldBackground(for textField: UITextField?) {
        guard let textField = textField else { return }
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.systemGray5.cgColor,
            UIColor.systemGray3.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.frame = textField.bounds
        gradientLayer.cornerRadius = 12
        
        let backgroundView = UIView(frame: textField.frame)
        backgroundView.layer.addSublayer(gradientLayer)
        backgroundView.layer.cornerRadius = 12
        backgroundView.layer.shadowColor = UIColor.purple.cgColor
        backgroundView.layer.shadowOffset = CGSize(width: 0, height: 3)
        backgroundView.layer.shadowOpacity = 0.3
        backgroundView.layer.shadowRadius = 6
        backgroundView.layer.masksToBounds = false
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        if let superview = textField.superview {
            superview.insertSubview(backgroundView, belowSubview: textField)
            NSLayoutConstraint.activate([
                backgroundView.leadingAnchor.constraint(equalTo: textField.leadingAnchor),
                backgroundView.trailingAnchor.constraint(equalTo: textField.trailingAnchor),
                backgroundView.topAnchor.constraint(equalTo: textField.topAnchor),
                backgroundView.bottomAnchor.constraint(equalTo: textField.bottomAnchor)
            ])
        }
    }
}
