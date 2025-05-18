//
//  RegisterViewModel.swift
//  MathQuizMastery
//
//  Created by Aydın KAYA on 6.04.2025.
//

import Foundation


protocol RegisterViewModelProtocol{
    var delegate : RegisterViewModelDelegate? {get set}
    func validateInputs(name: String?, email: String?, password: String?, confirmPassword: String?)
}

protocol RegisterViewModelDelegate : AnyObject {
    func didRegisterSuccessfully()
    func didFailWithError(_ error: Error)
    func didValidationFail(results: [ValidationResult])
}

class RegisterViewModel : RegisterViewModelProtocol {
    weak var delegate : RegisterViewModelDelegate?
    private var validator: ValidatorProtocol
    private var authService: AuthServiceProtocol
    private var cachedName: String?
    private var cachedEmail: String?
    private var cachedPassword: String?
    
    init(
        validator: ValidatorProtocol = Validator(),
        authService: AuthServiceProtocol = AuthService.shared
    ) {
        self.validator = validator
        self.authService = authService
        self.validator.delegate = self
    }
    
    
    func validateInputs(name username: String?, email: String?, password: String?, confirmPassword: String?){
        self.cachedName = username
        self.cachedEmail = email
        self.cachedPassword = password
        
        self.validator.validateSignUp(
            name: username,
            email: email,
            password: password,
            confirmPassword: confirmPassword
        )
    }
    
    private func performRegistration() {
        guard let name = cachedName,
              let email = cachedEmail,
              let password = cachedPassword else {
            return
        }
        
        let userRequest = RegisterUserRequest(username: name, email: email, password: password)
        
        authService.registerUser(with: userRequest) { [weak self] success, error in
            if success {
                self?.delegate?.didRegisterSuccessfully()
            } else if let error = error {
                self?.delegate?.didFailWithError(error)
            }
        }
    }
}

extension RegisterViewModel : ValidatorDelegate {
    func validationDidComplete(results: [ValidationResult]) {
        if results.isEmpty {
            performRegistration()
        }else{
            delegate?.didValidationFail(results: results)
        }
    }
}
