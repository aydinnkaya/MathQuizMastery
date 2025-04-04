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
    
    private var errorLabels: [UITextField: UILabel] = [:]
    private var viewModel: RegisterScreenViewModelProtocol = RegisterScreenViewModel()
    private var loadingAlert : UIAlertController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextFields()
        configureGesture()
        assignTextFieldDelegates()
        bindViewModel()
        setupErrorLabels()
    }
    
    init(viewModel: RegisterScreenViewModelProtocol = RegisterScreenViewModel()) {
           self.viewModel = viewModel
           super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        let defaultViewModel = RegisterScreenViewModel()
        self.viewModel = defaultViewModel
        super.init(coder: coder)
    }
    
    // MARK: - ViewModel Binding
    private func bindViewModel() {
      //  (viewModel as? RegisterScreenViewModel)?.delegate = self
    }
    
    // MARK: - UI Setup
    private func configureUI() {
        configureTextFields()
        configureGesture()
        setupErrorLabels()
    }
    
    private func configureTextFields() {
        configureTextField(nameTextField, placeholderText: L(.enter_name), iconName: "person.fill")
        configureTextField(emailTextField, placeholderText: L(.enter_email), iconName: "envelope.fill")
        configureTextField(passwordTextField, placeholderText: L(.enter_password), iconName: "lock.fill")
        configureTextField(passwordAgainTextField, placeholderText: L(.reenter_password), iconName: "lock.fill")
    }
    
    private func assignTextFieldDelegates() {
        [nameTextField, emailTextField, passwordTextField, passwordAgainTextField].forEach { $0?.delegate = self }
    }
    
    private func configureGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func setupErrorLabels() {
        [nameTextField, emailTextField, passwordTextField, passwordAgainTextField].forEach { addErrorLabel(below: $0) }
    }
    
    // MARK: - Actions
    @IBAction func createAccountButtonTapped(_ sender: UIButton) {
        dismissKeyboard()
        
    }
}

// MARK: - UITextFieldDelegate
extension RegisterVC {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - UI Helpers
extension RegisterVC {
    private func configureTextField(_ textField: UITextField, placeholderText: String, iconName: String) {
        textField.layer.cornerRadius = 12
        textField.layer.borderWidth = 1.5
        textField.layer.borderColor = UIColor.systemGray.cgColor
        textField.backgroundColor = UIColor.tertiarySystemFill
        textField.textColor = .label
        textField.font = .systemFont(ofSize: 16, weight: .medium)
        
        let iconAttachment = NSTextAttachment()
        iconAttachment.image = UIImage(systemName: iconName)?.withTintColor(.gray, renderingMode: .alwaysOriginal)
        iconAttachment.bounds = CGRect(x: 0, y: -2, width: 20, height: 20)
        
        let iconString = NSAttributedString(attachment: iconAttachment)
        let placeholder = NSAttributedString(string: " \(placeholderText)", attributes: [
            .foregroundColor: UIColor.gray,
            .font: UIFont.systemFont(ofSize: 16)
        ])
        
        let final = NSMutableAttributedString()
        final.append(iconString)
        final.append(placeholder)
        
        textField.attributedPlaceholder = final
    }
}

// MARK: - Error Label Management
extension RegisterVC {
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

// MARK: - Loading Helpers
extension RegisterVC {
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
    
}

