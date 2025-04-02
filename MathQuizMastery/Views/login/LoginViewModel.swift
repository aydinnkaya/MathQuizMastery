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
        guard case .valid = Validator.validateEmail(email) else {
            notifyFailure(with: "Geçersiz e-posta formatı")
            return
        }
        
        guard case .valid = Validator.validatePassword(password) else {
            notifyFailure(with: "Şifre gereksinimleri karşılanmıyor")
            return
        }
        
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
