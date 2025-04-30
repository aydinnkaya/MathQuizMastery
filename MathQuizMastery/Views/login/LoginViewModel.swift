//
//  LoginViewModel.swift
//  MathQuizMastery
//
//  Created by AydınKaya on 21.03.2025.
//

import Foundation

protocol LoginViewModelDelegate: AnyObject {
    func didLoginSuccessfully(user: User)
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
        
        authService.signIn(with: loginUserRequest) { [weak self] uid, error  in
            guard let self = self else {return}
            
            if let error = error {
                self.delegate?.didFailWithError(error)
            }
            
            guard let uid = uid else {
                let unknownError = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "UID alınamadı."])
                self.delegate?.didFailWithError(unknownError)
                return
            }
            
            AuthService.shared.fetchUserData(uid: uid) { result in
                switch result {
                    
                case .success(let user):
                    self.delegate?.didLoginSuccessfully(user: user)
                case .failure(let error):
                    self.delegate?.didFailWithError(error)
                    
                }
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
