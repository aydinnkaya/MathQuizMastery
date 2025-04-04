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
}

final class LoginViewModel: LoginScreenViewModelProtocol, ValidatorDelegate {
    weak var delegate: LoginViewModelDelegate?
    private let coreDataManager: CoreDataServiceProtocol
    private var validator: Validator
    
    init(coreDataManager: CoreDataServiceProtocol = CoreDataManager.shared) {
        self.coreDataManager = coreDataManager
        self.validator = Validator(rules: [EmailValidator(), PasswordValidator()])
        self.validator.delegate = self
    }
    
    func login(email: String, password: String) {
        validator.validateAll(values: [email, password])
    }
    
    func validationDidComplete(result: ValidationResult) {
        switch result {
        case .valid:
            performLogin()
        case .invalid(let message):
            notifyFailure(with: message)
        }
    }
    
    private func performLogin() {
        coreDataManager.fetchUser(email: email, password: password) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let user) where user?.uuid != nil:
                    self.delegate?.didLoginSuccessfully(userUUID: user!.uuid!)
                case .success:
                    self.notifyFailure(with: "Geçersiz e-posta veya şifre")
                case .failure(let error):
                    self.delegate?.didFailWithError(error)
                }
            }
        }
    }
    
    private func notifyFailure(with message: String) {
        let error = NSError(
            domain: "Auth",
            code: 403,
            userInfo: [NSLocalizedDescriptionKey: message]
        )
        delegate?.didFailWithError(error)
    }
}
