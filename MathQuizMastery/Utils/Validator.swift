//
//  Validator.swift
//  MathQuizMastery
//
//  Created by Aydın KAYA on 6.04.2025.
//

import Foundation

// MARK: - Protocols
protocol ValidatorProtocol {
    var delegate: ValidatorDelegate? { get set }
    func validateLogin(email: String?, password: String?)
    func validateSignUp(name: String?, email: String?, password: String?, confirmPassword: String?)
}

protocol ValidatorDelegate: AnyObject {
    func validationDidComplete(results: [ValidationResult])
}

// MARK: - Enums
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

// MARK: - Validation Rules
struct ValidationRules {
    static let minPasswordLength = 6
    static let maxPasswordLength = 128
    static let minNameLength = 2
    static let maxNameLength = 50
    static let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
}

// MARK: - Validator Implementation
final class Validator: ValidatorProtocol {
    
    // MARK: - Properties
    weak var delegate: ValidatorDelegate?
    private let validationQueue: DispatchQueue
    
    // MARK: - Initialization
    init(validationQueue: DispatchQueue = DispatchQueue(label: "com.mathquiz.validation", qos: .userInitiated)) {
        self.validationQueue = validationQueue
    }
    
    // MARK: - Public Methods
    func validateLogin(email: String?, password: String?) {
        validationQueue.async { [weak self] in
            guard let self = self else { return }
            
            var results: [ValidationResult] = []
            
            let emailResult = self.validateEmail(email)
            if case .invalid = emailResult {
                results.append(emailResult)
            }
            
            let passwordResult = self.validatePassword(password)
            if case .invalid = passwordResult {
                results.append(passwordResult)
            }
            
            DispatchQueue.main.async {
                self.delegate?.validationDidComplete(results: results)
            }
        }
    }
    
    func validateSignUp(name: String?, email: String?, password: String?, confirmPassword: String?) {
        validationQueue.async { [weak self] in
            guard let self = self else { return }
            
            var results: [ValidationResult] = []
            
            let nameResult = self.validateName(name)
            if case .invalid = nameResult {
                results.append(nameResult)
            }
            
            let emailResult = self.validateEmail(email)
            if case .invalid = emailResult {
                results.append(emailResult)
            }
            
            let passwordResult = self.validatePassword(password)
            if case .invalid = passwordResult {
                results.append(passwordResult)
            }
            
            let confirmPasswordResult = self.validatePasswordsMatch(password, confirmPassword)
            if case .invalid = confirmPasswordResult {
                results.append(confirmPasswordResult)
            }
            
            DispatchQueue.main.async {
                self.delegate?.validationDidComplete(results: results)
            }
        }
    }
}

// MARK: - Private Validation Methods
private extension Validator {
    
    func validateEmail(_ value: String?) -> ValidationResult {
        guard let email = value?.trimmingCharacters(in: .whitespacesAndNewlines), !email.isEmpty else {
            return .invalid(field: .email, message: L(.email_required))
        }
        
        guard email.count <= 254 else { // RFC 5321 limit
            return .invalid(field: .email, message: L(.email_too_long))
        }
        
        let predicate = NSPredicate(format: "SELF MATCHES %@", ValidationRules.emailRegex)
        return predicate.evaluate(with: email) ? .valid : .invalid(field: .email, message: L(.invalid_email))
    }
    
    func validatePassword(_ value: String?) -> ValidationResult {
        guard let password = value, !password.isEmpty else {
            return .invalid(field: .password, message: L(.password_required))
        }
        
        guard password.count >= ValidationRules.minPasswordLength else {
            return .invalid(field: .password, message: L(.password_too_short))
        }
        
        guard password.count <= ValidationRules.maxPasswordLength else {
            return .invalid(field: .password, message: L(.password_too_long))
        }
        
        // Check for at least one letter and one number for stronger passwords
        let hasLetter = password.rangeOfCharacter(from: .letters) != nil
        let hasNumber = password.rangeOfCharacter(from: .decimalDigits) != nil
        
        if !hasLetter || !hasNumber {
            return .invalid(field: .password, message: L(.password_weak))
        }
        
        return .valid
    }
    
    func validateName(_ value: String?) -> ValidationResult {
        guard let name = value?.trimmingCharacters(in: .whitespacesAndNewlines), !name.isEmpty else {
            return .invalid(field: .name, message: L(.name_required))
        }
        
        guard name.count >= ValidationRules.minNameLength else {
            return .invalid(field: .name, message: L(.name_required))
        }
        
        guard name.count <= ValidationRules.maxNameLength else {
            return .invalid(field: .name, message: L(.name_too_long))
        }
        
        // Check for valid characters (letters, spaces, basic punctuation)
        let allowedCharacters = CharacterSet.letters.union(.whitespaces).union(CharacterSet(charactersIn: ".-'"))
        if name.rangeOfCharacter(from: allowedCharacters.inverted) != nil {
            return .invalid(field: .name, message: L(.name_invalid_characters))
        }
        
        return .valid
    }
    
    func validatePasswordsMatch(_ password: String?, _ confirmPassword: String?) -> ValidationResult {
        guard let password = password, let confirmPassword = confirmPassword else {
            return .invalid(field: .confirmPassword, message: L(.confirm_password_required))
        }
        
        return password == confirmPassword ? .valid : .invalid(field: .confirmPassword, message: L(.passwords_do_not_match))
    }
}

// MARK: - Testable Validator for Unit Tests
protocol ValidatorTestable {
    func validateEmailSync(_ email: String?) -> ValidationResult
    func validatePasswordSync(_ password: String?) -> ValidationResult
    func validateNameSync(_ name: String?) -> ValidationResult
    func validatePasswordsMatchSync(_ password: String?, _ confirmPassword: String?) -> ValidationResult
}

extension Validator: ValidatorTestable {
    func validateEmailSync(_ email: String?) -> ValidationResult {
        return validateEmail(email)
    }
    
    func validatePasswordSync(_ password: String?) -> ValidationResult {
        return validatePassword(password)
    }
    
    func validateNameSync(_ name: String?) -> ValidationResult {
        return validateName(name)
    }
    
    func validatePasswordsMatchSync(_ password: String?, _ confirmPassword: String?) -> ValidationResult {
        return validatePasswordsMatch(password, confirmPassword)
    }
}
