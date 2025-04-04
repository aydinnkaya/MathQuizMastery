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

// MARK: - ValidatorDelegate
protocol ValidatorDelegate: AnyObject {
    func validationDidComplete(result: ValidationResult)
}


// MARK: - Validator
class Validator {
    private var rules: [ValidationRule]
    weak var delegate: ValidatorDelegate?
    
    init(rules: [ValidationRule]) {
        self.rules = rules
    }
    
    func validate(value: String?) {
        for rule in rules {
            let result = rule.validate(value)
            if case .invalid = result {
                delegate?.validationDidComplete(result: result)
                return
            }
        }
        delegate?.validationDidComplete(result: .valid)
    }
    
    func validateAll(values: [String?]) {
        for (index, rule) in rules.enumerated() {
            let result = rule.validate(values[safe: index] ?? nil)
            if case .invalid = result {
                delegate?.validationDidComplete(result: result)
                return
            }
        }
        delegate?.validationDidComplete(result: .valid)
    }
}

extension Validator {
    func validateEmail(_ value: String?) -> ValidationResult {
        guard let email = value, !email.isEmpty else {
            return .invalid(L(.email_required))
        }
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        if emailTest.evaluate(with: email) {
            return .valid
        } else {
            return .invalid(L(.invalid_email))
        }
    }

    func validatePassword(_ value: String?) -> ValidationResult {
        guard let password = value, !password.isEmpty else {
            return .invalid(L(.password_required))
        }
        if password.count < 6 {
            return .invalid(L(.password_too_short))
        }
        return .valid
    }

    func validateRequiredField(_ value: String?, message: LocalizedKey) -> ValidationResult {
        guard let value = value, !value.isEmpty else {
            return .invalid(L(message))
        }
        return .valid
    }
}

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
