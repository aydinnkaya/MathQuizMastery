//
//  Validator.swift
//  MathQuizMastery
//
//  Created by Aydın KAYA on 31.03.2025.
//

import Foundation

// MARK: - ValidationResult
enum ValidationResult {
    case valid
    case invalid(String)
}

// MARK: - ValidationMessages
enum ValidationMessages {
    static let fieldRequired = "Bu alan zorunludur."
    static let invalidEmailFormat = "Geçersiz e-posta formatı."
    static let shortPassword = "Şifre en az 6 karakter olmalıdır."
}

// MARK: - ValidationRule Protokolü
protocol ValidationRule {
    func validate(_ value: String?) -> ValidationResult
}

// MARK: - EmailValidator
class EmailValidator: ValidationRule {
    func validate(_ value: String?) -> ValidationResult {
        guard let email = value, !email.isEmpty else {
            return .invalid(ValidationMessages.fieldRequired)
        }
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        if emailTest.evaluate(with: email) {
            return .valid
        } else {
            return .invalid(ValidationMessages.invalidEmailFormat)
        }
    }
}

// MARK: - PasswordValidator
class PasswordValidator: ValidationRule {
    func validate(_ value: String?) -> ValidationResult {
        guard let password = value, !password.isEmpty else {
            return .invalid(ValidationMessages.fieldRequired)
        }

        if password.count < 6 {
            return .invalid(ValidationMessages.shortPassword)
        }

        return .valid
    }
}

// MARK: - RequiredFieldValidator
class RequiredFieldValidator: ValidationRule {
    private let message: String
    
    init(message: String) {
        self.message = message
    }
    
    func validate(_ value: String?) -> ValidationResult {
        guard let value = value, !value.isEmpty else {
            return .invalid(message)
        }
        return .valid
    }
}

// MARK: - Validator Sınıfı
class Validator {
    private var rules: [ValidationRule]
    
    // Dependency Injection constructor
    init(rules: [ValidationRule]) {
        self.rules = rules
    }
    
    // Tüm validation kurallarını sırayla çalıştırır
    func validate() -> ValidationResult {
        for rule in rules {
            if case .invalid(let message) = rule.validate(nil) {
                return .invalid(message)
            }
        }
        return .valid
    }
}
