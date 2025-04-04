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

// MARK: - Validator Sınıfı (MVVM ve Delegate Tabanlı)
class Validator {
    private var rules: [ValidationRule]
    weak var delegate: ValidatorDelegate?
    
    // Dependency Injection constructor
    init(rules: [ValidationRule]) {
        self.rules = rules
    }
    
    // Tek bir alanı doğrulama
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
    
    // Birden fazla alanı doğrulama
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

// MARK: - Safe Array Extension (Index Out of Range hatasını önlemek için)
extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
