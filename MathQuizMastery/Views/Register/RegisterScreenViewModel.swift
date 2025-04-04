//
//  RegisterScreenViewModel.swift
//  MathQuizMastery
//
//  Created by AydınKaya on 21.03.2025.
//

import Foundation
import CoreData
import UIKit

// MARK: - Register Screen View Model Delegate
protocol RegisterScreenViewModelDelegate : AnyObject{
    func registrationSucceeded()
    func registrationFailed(_ error : Error )
    func validationFailed(message: String)
}

// MARK: - Register Screen View Model
final class RegisterScreenViewModel: RegisterScreenViewModelProtocol {
    private let coreDataManager: CoreDataServiceProtocol
    weak var delegate: RegisterScreenViewModelDelegate?
    
    init(coreDataManager: CoreDataServiceProtocol = CoreDataManager()) {
        self.coreDataManager = coreDataManager
    }
    
    func savePerson(name: String, email: String, password: String) {
        if case .invalid(let message) = validateName(name) {
            delegate?.validationFailed(message: message)
            return
        }
        
        if case .invalid(let message) = validateEmail(email) {
            delegate?.validationFailed(message: message)
            return
        }
        
        if case .invalid(let message) = validatePassword(password) {
            delegate?.validationFailed(message: message)
            return
        }
        
        coreDataManager.saveUser(name: name, email: email, password: password) { result in
            DispatchQueue.main.async {
                switch result {
                case .success():
                    self.delegate?.registrationSucceeded()
                case .failure(let error):
                    let userFriendlyError = NSError(
                        domain: "com.mathquizmastery.registration",
                        code: 1002,
                        userInfo: [NSLocalizedDescriptionKey: L(.registration_failed) + "\n(\(error.localizedDescription))"]
                    )
                    self.delegate?.registrationFailed(userFriendlyError)
                }
            }
        }
    }
    
    func validateEmail(_ email: String) -> ValidationResult {
        if email.isEmpty {
            return .invalid(L(.email_required))
        } else if !email.contains("@") {
            return .invalid(L(.invalid_email))
        }
        return .valid
    }
    
    func validatePassword(_ password: String) -> ValidationResult {
        if password.isEmpty {
            return .invalid(L(.password_required))
        } else if password.count < 6 {
            return .invalid(L(.password_too_short))
        }
        return .valid
    }
    
    func validateName(_ name: String) -> ValidationResult {
        if name.isEmpty {
            return .invalid(L(.name_required))
        }
        return .valid
    }
}
