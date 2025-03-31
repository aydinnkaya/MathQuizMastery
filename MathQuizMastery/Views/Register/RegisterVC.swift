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
        configureButton(createAccountButton)
        configureGesture()
        assignTextFieldDelegates()
        bindViewModel()
        setupErrorLabels()
    }
    
    // MARK: - ViewModel Binding
    private func bindViewModel() {
        (viewModel as? RegisterScreenViewModel)?.delegate = self
    }
    
    // MARK: - UI Setup
    private func configureTextFields() {
        configureTextField(nameTextField, placeholderText: L(.enter_name), iconName: "person.fill")
        configureTextField(emailTextField, placeholderText: L(.enter_email), iconName: "envelope.fill")
        configureTextField(passwordTextField, placeholderText:L(.enter_password), iconName: "lock.fill")
        configureTextField(passwordAgainTextField, placeholderText: L(.reenter_password), iconName: "lock.fill")
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
    
    private func setupErrorLabels() {
        [nameTextField, emailTextField, passwordTextField, passwordAgainTextField].forEach {
            addErrorLabel(below: $0)
        }
    }
    
    
    // MARK: - Actions
    @IBAction func createAccountButtonTapped(_ sender: UIButton) {
        dismissKeyboard()
        clearErrors()
        
        let nameValidation = Validations.validateRequired(nameTextField.text, messageKey: .field_required)
        let emailValidation = Validations.validateEmail(emailTextField.text)
        let passwordValidation = Validations.validatePassword(passwordTextField.text)
        let matchValidation = Validations.validatePasswordMatch(passwordTextField.text, passwordAgainTextField.text)
        
        var hasError = false
        
        for (validation, field) in [(nameValidation, nameTextField), (emailValidation, emailTextField), (passwordValidation, passwordTextField), (matchValidation, passwordAgainTextField)] {
            guard let field = field else { continue }
            
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
        viewModel.savePerson(name: nameTextField.text!, email: emailTextField.text!, password: passwordTextField.text!)
    }
}

// MARK: - RegisterScreenViewModelDelegate
extension RegisterVC: RegisterScreenViewModelDelegate {
    func registrationSucceeded() {
        hideLoading()
        HapticManager.shared.success()
        ToastView.show(in: self.view, message: L(.registration_success))
        navigationController?.popViewController(animated: true)
    }
    
    func registrationFailed(_ error: Error) {
        hideLoading()
        HapticManager.shared.error()
        ToastView.show(in: self.view, message: error.localizedDescription)
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

    private func configureButton(_ button: UIButton) {
        button.layer.cornerRadius = 12
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.yellow.cgColor
        button.backgroundColor = .clear

        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.purple.cgColor, UIColor.red.cgColor]
        gradient.startPoint = CGPoint(x: 0.0, y: 0)
        gradient.endPoint = CGPoint(x: 0.0, y: 1)
        gradient.frame = button.bounds
        gradient.cornerRadius = button.layer.cornerRadius

        button.layer.insertSublayer(gradient, at: 0)

        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)

        // Shadow for better contrast
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.4
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        button.layer.shadowRadius = 4
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
/*
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
 textField.layer.borderColor = UIColor.green.cgColor
 textField.backgroundColor = .clear
 textField.layer.cornerRadius = 12
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
 // backgroundView.layer.shadowColor = UIColor.purple.cgColor
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
 */

