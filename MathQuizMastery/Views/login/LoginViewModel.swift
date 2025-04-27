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
    
    init(validator: ValidatorProtocol = Validator()) {
            self.validator = validator
            self.validator.delegate = self
        }

    func login(email: String, password: String) {
        
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
