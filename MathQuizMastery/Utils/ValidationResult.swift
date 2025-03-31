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

struct Validations {

    static func validateRequired(_ value: String?, messageKey: LocalizedKey) -> ValidationResult {
        guard let text = value?.trimmingCharacters(in: .whitespacesAndNewlines), !text.isEmpty else {
            return .invalid(message: L(messageKey))
        }
        return .valid
    }

    static func validateEmail(_ email: String?) -> ValidationResult {
        guard let email = email, !email.isEmpty else {
            return .invalid(message: L(.field_required))
        }
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let test = NSPredicate(format: "SELF MATCHES[c] %@", regex)
        return test.evaluate(with: email) ? .valid : .invalid(message: L(.invalid_email))
    }

    static func validatePassword(_ password: String?) -> ValidationResult {
        guard let password = password, !password.isEmpty else {
            return .invalid(message: L(.field_required))
        }
        return password.count >= 6 ? .valid : .invalid(message: L(.weak_password))
    }

    static func validatePasswordMatch(_ password: String?, _ confirmPassword: String?) -> ValidationResult {
        return password == confirmPassword ? .valid : .invalid(message: L(.password_mismatch))
    }
}

