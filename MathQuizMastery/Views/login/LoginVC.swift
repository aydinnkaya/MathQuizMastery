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
    @IBOutlet weak var loginButtonLabel: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGradientBackground()
        configureTextField(emailTextField, placeholderText: " Enter your email", iconName: "envelope.fill")
        configureTextField(passwordTextField, placeholderText: " Enter your password", iconName: "lock.fill")
        
        
        configureTextFieldBackground(for: emailTextField)
        configureTextFieldBackground(for: passwordTextField)
        configureButton(loginButtonLabel)
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "",
           let resultVC = segue.destination as? StartVC,
           let score = sender as? String {
        }
    }
    
    @IBAction func loginButtonAction(_ sender: Any, forEvent event: UIEvent) {
    }
    
    @IBAction func CreateAnAccountButton(_ sender: UIButton, forEvent event: UIEvent) {
    }
    
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        configureTextFieldBackground(for: emailTextField)
        configureTextFieldBackground(for: passwordTextField)
        configureButton(loginButtonLabel)
        
    }
    
}


extension LoginVC {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
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
    
    func configureButton(_ button : UIButton){
        
        button.layer.cornerRadius = 12
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor(red: 1.0, green: 0.8627, blue: 0.0, alpha: 1.0).cgColor
        button.backgroundColor = .clear
        
        
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.purple.cgColor,
            UIColor.red.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        
        
        
        if let superview = button.superview {
            let adjustedFrame = superview.convert(button.frame, to: superview)
            let backgroundView = UIView(frame: adjustedFrame)
            gradientLayer.frame = CGRect(origin: .zero, size: adjustedFrame.size)
            gradientLayer.cornerRadius = button.layer.cornerRadius
            
            backgroundView.layer.insertSublayer(gradientLayer, at: 0)
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
    
    func configureTextField(_ textField: UITextField, placeholderText: String, iconName: String) {
        textField.layer.cornerRadius = 12
        textField.layer.borderWidth = 2
        textField.layer.borderColor = UIColor(red: 1.0, green: 0.8627, blue: 0.0, alpha: 1.0).cgColor
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
        
        textField.superview?.layer.sublayers?
            .filter { $0 is CAGradientLayer }
            .forEach { $0.removeFromSuperlayer() }
        
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
        
        if let superview = textField.superview {
            let adjustedFrame = superview.convert(textField.frame, to: superview)
            let backgroundView = UIView(frame: adjustedFrame)
            gradientLayer.frame = CGRect(origin: .zero, size: adjustedFrame.size)
            gradientLayer.cornerRadius = textField.layer.cornerRadius
            
            backgroundView.layer.insertSublayer(gradientLayer, at: 0)
            backgroundView.layer.cornerRadius = textField.layer.cornerRadius
            backgroundView.layer.shadowColor = UIColor.purple.cgColor
            backgroundView.layer.shadowOffset = CGSize(width: 0, height: 3)
            backgroundView.layer.shadowOpacity = 0.3
            backgroundView.layer.shadowRadius = 6
            backgroundView.layer.masksToBounds = false
            
            superview.addSubview(backgroundView)
            superview.bringSubviewToFront(textField)
        }
    }
}

