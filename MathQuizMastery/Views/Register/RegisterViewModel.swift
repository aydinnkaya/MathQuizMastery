//
//  RegisterViewModel.swift
//  MathQuizMastery
//
//  Created by Aydın KAYA on 6.04.2025.
//

import Foundation

protocol RegisterViewModelDelegate : AnyObject {
    func didRegisterSuccessfully()
    func didFailWithError(_ error: Error)
    func didValidationFail(results: [ValidationResult])
}

class RegisterViewModel : RegisterViewModelProtocol {
    weak var delegate : RegisterViewModelDelegate?
    private var coreDataManager: CoreDataServiceProtocol
    private var validator: ValidatorProtocol
    
    private var cachedName: String?
    private var cachedEmail: String?
    private var cachedPassword: String?
    
    init(coreDataManager: CoreDataServiceProtocol = CoreDataManager(), validator: ValidatorProtocol = Validator()) {
        self.coreDataManager = coreDataManager
        self.validator = Validator()
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
        
        coreDataManager.saveUser(name: name, email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success():
                    self?.delegate?.didRegisterSuccessfully()
                case .failure(let error):
                    let error = NSError(
                        domain: "com.mathquizmastery.registration",
                        code: 1002,
                        userInfo: [NSLocalizedDescriptionKey: L(.registration_failed) + "\n(\(error.localizedDescription))"]
                    )
                    self?.delegate?.didFailWithError(error)
                }
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
