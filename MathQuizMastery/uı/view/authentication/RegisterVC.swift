//
//  RegisterVC.swift
//  MathQuizMastery
//
//  Created by Aydın KAYA on 21.01.2025.
//

import UIKit

class RegisterVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordAgainTextField: UITextField!
    @IBOutlet weak var cerateAccountLabel: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.setupGradientBackground()
            self.configureTextFieldBackground(for: self.nameTextField)
            self.configureTextFieldBackground(for: self.emailTextField)
            self.configureTextFieldBackground(for: self.passwordTextField)
            self.configureTextFieldBackground(for: self.passwordAgainTextField)
            
            self.configureTextField(self.nameTextField, placeholderText: "Enter your name", iconName: "person.fill")
            self.configureTextField(self.emailTextField, placeholderText: "Enter your email", iconName: "envelope.fill")
            self.configureTextField(self.passwordTextField, placeholderText: "Enter your password", iconName: "lock.fill")
            self.configureTextField(self.passwordAgainTextField, placeholderText: "Re enter your password", iconName: "lock.fill")
        }
        
        nameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        passwordAgainTextField.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @IBAction func CreateAccountButton(_ sender: UIButton, forEvent event: UIEvent) {
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureTextFieldBackground(for: nameTextField)
        configureTextFieldBackground(for: emailTextField)
        configureTextFieldBackground(for: passwordTextField)
        configureTextFieldBackground(for: passwordAgainTextField)
    }
    
}


extension RegisterVC {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func setupGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [
            UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1.0).cgColor,
            UIColor(red: 0.9, green: 0.7, blue: 0.0, alpha: 1.0).cgColor,
            UIColor(red: 0.8, green: 0.1, blue: 0.0, alpha: 1.0).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func configureTextField(_ textField: UITextField, placeholderText: String, iconName: String) {
        textField.layer.cornerRadius = 12
        textField.layer.borderWidth = 2
        // textField.layer.borderColor = UIColor(red: 1.0, green: 0.8627, blue: 0.0, alpha: 1.0).cgColor
        textField.layer.borderColor = UIColor(red: 0.8, green: 0.1, blue: 0.0, alpha: 1.0).cgColor
        textField.backgroundColor = .clear
        textField.textColor = .black
        textField.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        
        let iconAttachment = NSTextAttachment()
        iconAttachment.image = UIImage(systemName: iconName)?.withTintColor(.black, renderingMode: .alwaysOriginal)
        iconAttachment.bounds = CGRect(x: 0, y: -4, width: 25, height: 25)
        
        let iconString = NSAttributedString(attachment: iconAttachment)
        let textString = NSAttributedString(string: " \(placeholderText)", attributes: [
            .foregroundColor: UIColor.black,
            .font: UIFont.systemFont(ofSize: 16, weight: .medium)
        ])
        
        let combinedString = NSMutableAttributedString()
        combinedString.append(iconString)
        combinedString.append(textString)
        
        textField.attributedPlaceholder = combinedString
        textField.contentVerticalAlignment = .center
    }
    
    func configureTextFieldBackground(for textField: UITextField) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(red: 0.8, green: 0.85, blue: 0.9, alpha: 1).cgColor,
            UIColor(red: 0.75, green: 0.75, blue: 0.9, alpha: 1).cgColor,
            UIColor(red: 0.7, green: 0.8, blue: 0.85, alpha: 1).cgColor,
            UIColor(red: 0.65, green: 0.65, blue: 0.8, alpha: 1).cgColor,
            UIColor(red: 0.6, green: 0.7, blue: 0.75, alpha: 1).cgColor
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
