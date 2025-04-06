//
//  Validator.swift
//  MathQuizMastery
//
//  Created by Aydın KAYA on 6.04.2025.
//

import Foundation

protocol ValidatorProtocol {
    var delegate: ValidatorDelegate? { get set }
    func validateLogin(email: String?, password: String?)
    func validateSignUp(name: String?, email: String?, password: String?, confirmPassword: String?)
    
}

protocol ValidatorDelegate : AnyObject {
    func validationDidComplete(results: [ValidationResult])
}

enum ValidationResult {
    case valid
    case invalid(field: FieldKey, message: String)
}

enum FieldKey {
    case email
    case password
    case name
    case confirmPassword
}


class Validator : ValidatorProtocol { //  SOLID - Dependency Inversion
    var delegate: (any ValidatorDelegate)? // retain cycle
    
    func validateLogin(email: String?, password: String?) {
        var results: [ValidationResult] = []
        
        if case .invalid = validateEmail(email) {
            results.append(validateEmail(email))
        }
        
        if case .invalid = validatePassword(password) {
            results.append(validatePassword(password))
        }
        
        delegate?.validationDidComplete(results: results)
    }
    
    func validateSignUp(name: String?, email: String?, password: String?, confirmPassword: String?) {
        var results: [ValidationResult] = []
        
        if case .invalid = validateRequiredField(name, for: .name, message: .name_required) {
            results.append(validateRequiredField(name, for: .name, message: .name_required))
        }
        
        if case .invalid = validateEmail(email) {
            results.append(validateEmail(email))
        }
        
        if case .invalid = validatePassword(password) {
            results.append(validatePassword(password))
        }
        
        if case .invalid = validatePasswordsMatch(password, confirmPassword) {
            results.append(validatePasswordsMatch(password, confirmPassword))
        }
        
        delegate?.validationDidComplete(results: results)
    }
    
    
}

extension Validator {
    
    private func validateEmail(_ value: String?) -> ValidationResult {
        guard let email = value, !email.isEmpty else {
            return .invalid(field: .email, message: L(.email_required))
        }
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}" // Regular Expression
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        
        return predicate.evaluate(with: email) ? .valid : .invalid(field: .email, message: L(.invalid_email))
    }
    
    private func validatePassword(_ value: String?) -> ValidationResult {
        guard let password = value, !password.isEmpty else {
            return .invalid(field: .password, message: L(.password_required))
        }
        return password.count < 6 ? .invalid(field: .password, message: L(.password_too_short)) : .valid
    }
    
    private func validateRequiredField(_ value: String?, for field : FieldKey, message: LocalizedKey) -> ValidationResult {
        guard let value = value, !value.isEmpty else {
            return .invalid(field: field, message: L(message))
        }
        return .valid
    }
    
    private func validatePasswordsMatch(_ password: String?, _ confirmPassword: String?) -> ValidationResult {
        return password == confirmPassword ? .valid : .invalid(field: .confirmPassword, message: L(.passwords_do_not_match))
    }
    
}
