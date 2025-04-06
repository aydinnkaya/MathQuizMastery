//
//  RegisterVC.swift
//  MathQuizMastery
//
//  Created by Aydın KAYA on 6.04.2025.
//

import Foundation
import UIKit


class RegisterVC:  UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var registerFullNameField: UITextField!
    @IBOutlet weak var registerEmailField: UITextField!
    @IBOutlet weak var registerPasswordField: UITextField!
    @IBOutlet weak var registerConfirmPasswordField: UITextField!
    @IBOutlet weak var registerSubmitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureGesture()
        assignDelegates()
        setupGradientBackground()

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        registerSubmitButton.updateGradientFrameIfNeeded()
    }
    
    
    @IBAction func registerSubmitButtonTapped(_ sender: UIButton, forEvent event: UIEvent) {
        
    }

}


extension RegisterVC {
    func setupUI(){
        registerFullNameField.applyStyledAppearance(placeholder: L(.enter_email), iconName: "")
        registerEmailField.applyStyledAppearance(placeholder: L(.enter_email), iconName: "envelope.fill")
        registerPasswordField.applyStyledAppearance(placeholder: L(.enter_password), iconName: "lock.fill")
        registerConfirmPasswordField.applyStyledAppearance(placeholder: L(.reenter_password), iconName: "lock.fill")
        
        registerFullNameField.addStyledBackground(in: view)
        registerEmailField.addStyledBackground(in: view)
        registerPasswordField.addStyledBackground(in: view)
        registerConfirmPasswordField.addStyledBackground(in: view)

        registerSubmitButton.applyStyledButton(withTitle: L(.register_title))
    }
    
    func configureGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func assignDelegates() {
        registerFullNameField.delegate = self
        registerEmailField.delegate = self
        registerPasswordField.delegate = self
        registerConfirmPasswordField.delegate = self
    }
    
    func setupGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [
            UIColor(red: 0.9, green: 0.7, blue: 0.0, alpha: 1.0).cgColor,
           // UIColor(red: 0.8, green: 0.1, blue: 0.0, alpha: 1.0).cgColor,
            UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1.0).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
}
