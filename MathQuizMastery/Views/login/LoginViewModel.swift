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
    func didValidationFail(message: String)
}

class LoginViewModel: LoginScreenViewModelProtocol {
    var delegate: LoginViewModelDelegate?
    private var coreDataManager: CoreDataServiceProtocol

    init(coreDataManager: CoreDataServiceProtocol = CoreDataManager()) {
        self.coreDataManager = coreDataManager
    }

    func login(email: String, password: String) {
        coreDataManager.fetchUser(email: email, password: password) { result in
            switch result {
            case .success(let person):
                if let user = person {
                    self.delegate?.didLoginSuccessfully(userUUID: user.uuid!)
                } else {
                    self.delegate?.didFailWithError(NSError(domain: "LoginError", code: 401, userInfo: [NSLocalizedDescriptionKey: "Invalid credentials."]))
                }
            case .failure(let error):
                self.delegate?.didFailWithError(error)
            }
        }
    }

    func validateEmail(_ email: String) -> ValidationResult {
        if email.isEmpty {
            return .invalid(L(.field_required))
        } else if !email.contains("@") {
            return .invalid(L(.invalid_email))
        }
        return .valid
    }

    func validatePassword(_ password: String) -> ValidationResult {
        if password.isEmpty {
            return .invalid(L(.password_mismatch))
        }
        return .valid
    }
}
