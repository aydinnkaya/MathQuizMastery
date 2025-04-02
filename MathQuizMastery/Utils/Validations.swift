//
//  Validator.swift
//  MathQuizMastery
//
//  Created by Aydın KAYA on 31.03.2025.
//

import Foundation

enum ValidationResult {
    case valid
    case invalid(message: String)

    var isValid: Bool {
        switch self {
        case .valid: return true
        case .invalid: return false
        }
    }
}

struct ValidationMessages {
    static let fieldRequired = "Bu alan zorunludur."
    static let invalidEmail = "Geçersiz e-posta formatı."
    static let weakPassword = "Şifre en az 6 karakter olmalıdır."
}

class Validations {
    
    static func validateEmail(_ email: String?) -> ValidationResult {
        guard let email = email, !email.isEmpty else {
            return .invalid(message: ValidationMessages.fieldRequired)
        }
        
        let emailRegex = "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email) ? .valid : .invalid(message: ValidationMessages.invalidEmail)
    }
    
    static func validateRequired(_ field: String?, message: String) -> ValidationResult {
        guard let field = field, !field.isEmpty else {
            return .invalid(message: message)
        }
        return .valid
    }
    
    static func validatePassword(_ password: String?) -> ValidationResult {
        guard let password = password, !password.isEmpty else {
            return .invalid(message: ValidationMessages.fieldRequired)
        }
        
        return password.count >= 6 ? .valid : .invalid(message: ValidationMessages.weakPassword)
    }
}
