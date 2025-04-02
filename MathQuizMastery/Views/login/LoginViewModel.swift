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

final class LoginViewModel: LoginScreenViewModelProtocol {
    weak var delegate: LoginViewModelDelegate?
    private let coreDataManager: CoreDataServiceProtocol
    
    init(coreDataManager: CoreDataServiceProtocol = CoreDataManager.shared) {
        self.coreDataManager = coreDataManager
    }
    
    func login(email: String, password: String) {
        let emailValidation = Validator.validateEmail(
            email,
            emptyMessage: "E-posta alanı boş olamaz",
            invalidMessage: "Geçersiz e-posta formatı"
        )
        let passwordValidation = Validator.validatePassword(
            password,
            emptyMessage: "Şifre alanı boş olamaz",
            weakMessage: "Şifre en az 6 karakter olmalıdır"
        )
        
        let validationResult = Validator.validate([emailValidation, passwordValidation])
        if case .invalid(let message) = validationResult {
            delegate?.didFailWithError(NSError(
                domain: "Validation",
                code: 400,
                userInfo: [NSLocalizedDescriptionKey: message]
            ))
            return
        }
        
        coreDataManager.fetchUser(email: email, password: password) { result in
            switch result {
            case .success(let user):
                if let user = user, let userUUID = user.uuid {
                    DispatchQueue.main.async {
                        self.delegate?.didLoginSuccessfully(userUUID: userUUID)
                    }
                } else {
                    let error = NSError(
                        domain: "Auth",
                        code: 403,
                        userInfo: [NSLocalizedDescriptionKey: "Geçersiz e-posta veya şifre"]
                    )
                    DispatchQueue.main.async {
                        self.delegate?.didFailWithError(error)
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.delegate?.didFailWithError(error)
                }
            }
        }
    }
}
