//
//  LoginViewModel.swift
//  MathQuizMastery
//
//  Created by AydınKaya on 21.03.2025.
//

import Foundation

protocol LoginViewModelDelegate: AnyObject {
    func didLoginSuccessfully(userUUID: UUID)
    func didFailWithError(_ error: Error)
    func didValidationFail(results: [ValidationResult])
}

class LoginViewModel: LoginScreenViewModelProtocol {
    weak var delegate: LoginViewModelDelegate?
    private var validator: ValidatorProtocol
    private var authService: AuthServiceProtocol
    
    init(validator: ValidatorProtocol = Validator(),
         authService: AuthServiceProtocol = AuthService.shared) {
            self.validator = validator
            self.authService = authService
            self.validator.delegate = self
        
        }

    func login(email: String, password: String) {
        let loginUserRequest = LoginUserRequest(email: email, password: password)
        authService.signIn(with: loginUserRequest) { error in
            if let error = error {
                self.?.didLoginSuccessfully(userUUID: <#UUID#>)
            }
            
            
        }
    }

    func validateInputs(email: String, password: String) {
        validator.validateLogin(email: email, password: password)
    }
}

extension LoginViewModel : ValidatorDelegate {
    func validationDidComplete(results: [ValidationResult]) {
        delegate?.didValidationFail(results: results)
    }
}
