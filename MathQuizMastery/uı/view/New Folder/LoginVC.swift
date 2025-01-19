//
//  LoginVC.swift
//  MathQuizMastery
//
//  Created by Aydın KAYA on 18.01.2025.
//

import UIKit

class LoginVC: UIViewController, UITextFieldDelegate {
    
    // @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var fargotPasswordButtonLabel: UIButton!
    
    
    let scrollView = UIScrollView()
    var iconView: UIImageView?
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupGradientBackground()
        configureTextFields()
        emailTextField.delegate = self
        
        //headerView.transform = CGAffineTransform(rotationAngle: -70 * .pi / 180)
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // Klavyeyi kapatır
        return true
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
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
    
    
    func configureTextFields() {
        // TextField temel ayarları
        emailTextField.layer.cornerRadius = 12
        emailTextField.layer.borderWidth = 2
        emailTextField.layer.borderColor = UIColor(red: 255/255, green: 220/255, blue: 0/255, alpha: 1).cgColor
        emailTextField.backgroundColor = .clear
        emailTextField.textColor = .black
        emailTextField.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        // Placeholder (örnek yazı) ayarları
        let iconAttachment = NSTextAttachment()
        iconAttachment.image = UIImage(systemName: "envelope.fill")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        iconAttachment.bounds = CGRect(x: 0, y: -4, width: 25, height: 25) // İkon boyutu ve hizalaması
        
        let iconString = NSAttributedString(attachment: iconAttachment)
        let textString = NSAttributedString(string: " Enter your email", attributes: [
            .foregroundColor: UIColor.black,
            .font: UIFont.systemFont(ofSize: 16, weight: .medium)
        ])
        
        let combinedString = NSMutableAttributedString()
        combinedString.append(iconString)
        combinedString.append(textString)
        
        
        
        emailTextField.attributedPlaceholder = combinedString
        emailTextField.contentVerticalAlignment = .center
        
        // TextField'i ekrana ekleme
        emailTextField.frame = CGRect(x: 40, y: 100, width: 300, height: 50)
        self.view.addSubview(emailTextField)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Gradient ve gölge ayarları
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(red: 0.8, green: 0.85, blue: 0.9, alpha: 1).cgColor, // Açık pastel mavi
            UIColor(red: 0.75, green: 0.75, blue: 0.9, alpha: 1).cgColor, // Hafif pastel mor
            UIColor(red: 0.7, green: 0.8, blue: 0.85, alpha: 1).cgColor, // Hafif pastel teal
            UIColor(red: 0.65, green: 0.65, blue: 0.8, alpha: 1).cgColor, // Pastel mor ton
            UIColor(red: 0.6, green: 0.7, blue: 0.75, alpha: 1).cgColor  // Daha koyu pastel teal
        ]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.frame = emailTextField.bounds
        gradientLayer.cornerRadius = 8
        
        // Arka plan görünümü
        let emailBackgroundView = UIView(frame: emailTextField.frame)
        emailBackgroundView.layer.addSublayer(gradientLayer)
        emailBackgroundView.layer.cornerRadius = 8
        emailBackgroundView.layer.shadowColor = UIColor.purple.cgColor
        emailBackgroundView.layer.shadowOffset = CGSize(width: 0, height: 3)
        emailBackgroundView.layer.shadowOpacity = 0.3
        emailBackgroundView.layer.shadowRadius = 6
        emailBackgroundView.layer.masksToBounds = false
        
        // Görünüm hiyerarşisine ekleme
        if emailTextField.superview != nil {
            emailTextField.superview?.addSubview(emailBackgroundView)
            emailTextField.superview?.bringSubviewToFront(emailTextField)
        }
    }
    
}
