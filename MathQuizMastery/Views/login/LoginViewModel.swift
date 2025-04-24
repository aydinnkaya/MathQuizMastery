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
    private var coreDataManager: CoreDataServiceProtocol
    private var validator: ValidatorProtocol
    
    init(coreDataManager: CoreDataServiceProtocol = CoreDataManager(persistenceService: CoreDataPersistenceService()),
             validator: ValidatorProtocol = Validator()) {
            self.coreDataManager = coreDataManager
            self.validator = validator
            self.validator.delegate = self
        }

    func login(email: String, password: String) {
        coreDataManager.fetchUser(email: email, password: password) { result in
            switch result {
            case .success(let person):
                if let user = person, let uuid = user.uuid {
                    self.delegate?.didLoginSuccessfully(userUUID: uuid)
                } else {
                    let error = NSError(domain: "LoginError",
                                        code: 401,
                                        userInfo: [NSLocalizedDescriptionKey: L(.registration_failed)])
                    self.delegate?.didFailWithError(error)
                }
            case .failure(let error):
                self.delegate?.didFailWithError(error)
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
