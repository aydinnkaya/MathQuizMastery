//
//  RegisterViewModel.swift
//  MathQuizMastery
//
//  Created by Aydın KAYA on 6.04.2025.
//

import Foundation
import FirebaseAuth

// MARK: - Registration State
enum RegistrationState: Equatable {
    case idle
    case validating
    case registering
    case success(AppUser)
    case failure(Error)
    
    static func == (lhs: RegistrationState, rhs: RegistrationState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle), (.validating, .validating), (.registering, .registering):
            return true
        case (.success(let user1), .success(let user2)):
            return user1.uid == user2.uid
        case (.failure(let error1), .failure(let error2)):
            return error1.localizedDescription == error2.localizedDescription
        default:
            return false
        }
    }
}

// MARK: - Registration Error
enum RegistrationError: LocalizedError {
    case invalidInput(String)
    case registrationFailed(String)
    case userDataMissing
    case networkError
    
    var errorDescription: String? {
        switch self {
        case .invalidInput(let message):
            return message
        case .registrationFailed(let message):
            return message
        case .userDataMissing:
            return "User data is missing"
        case .networkError:
            return "Network error occurred"
        }
    }
}

// MARK: - Protocols
protocol RegisterViewModelProtocol: AnyObject {
    var delegate: RegisterViewModelDelegate? { get set }
    var state: RegistrationState { get }
    
    func validateAndRegister(name: String?, email: String?, password: String?, confirmPassword: String?)
    func clearState()
}

protocol RegisterViewModelDelegate: AnyObject {
    func registrationStateDidChange(_ state: RegistrationState)
}

// MARK: - RegisterViewModel Implementation
final class RegisterViewModel: RegisterViewModelProtocol {
    
    // MARK: - Properties
    weak var delegate: RegisterViewModelDelegate?
    
    private(set) var state: RegistrationState = .idle {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.delegate?.registrationStateDidChange(self.state)
            }
        }
    }
    
    private let validator: ValidatorProtocol
    private let authService: AuthServiceProtocol
    private let dispatchQueue: DispatchQueueProtocol
    
    // Cache registration data
    private var cachedName: String?
    private var cachedEmail: String?
    private var cachedPassword: String?
    
    // MARK: - Initialization
    init(
        validator: ValidatorProtocol = Validator(),
        authService: AuthServiceProtocol = AuthService.shared,
        dispatchQueue: DispatchQueueProtocol = DispatchQueueWrapper()
    ) {
        self.validator = validator
        self.authService = authService
        self.dispatchQueue = dispatchQueue
        self.validator.delegate = self
    }
    
    // MARK: - Public Methods
    func validateAndRegister(name: String?, email: String?, password: String?, confirmPassword: String?) {
        // Check if already in progress
        switch state {
        case .validating, .registering:
            return
        default:
            break
        }
        
        // Cache the input data
        self.cachedName = name
        self.cachedEmail = email
        self.cachedPassword = password
        
        state = .validating
        
        dispatchQueue.async { [weak self] in
            self?.performValidation(
                name: name,
                email: email,
                password: password,
                confirmPassword: confirmPassword
            )
        }
    }
    
    func clearState() {
        state = .idle
        clearCachedData()
    }
    
    // MARK: - Private Methods
    private func clearCachedData() {
        cachedName = nil
        cachedEmail = nil
        cachedPassword = nil
    }
    
    private func performValidation(name: String?, email: String?, password: String?, confirmPassword: String?) {
        validator.validateSignUp(
            name: name,
            email: email,
            password: password,
            confirmPassword: confirmPassword
        )
    }
    
    private func performRegistration() {
        guard let name = cachedName,
              let email = cachedEmail,
              let password = cachedPassword else {
            state = .failure(RegistrationError.userDataMissing)
            return
        }
        
        state = .registering
        
        let userRequest = RegisterUserRequest(username: name, email: email, password: password)
        
        authService.registerUser(with: userRequest) { [weak self] success, error in
            guard let self = self else { return }
            
            if success {
                // Get the newly created user's UID from Firebase Auth
                if let currentUserUID = Auth.auth().currentUser?.uid {
                    self.fetchUserData(uid: currentUserUID)
                } else {
                    self.state = .failure(RegistrationError.userDataMissing)
                }
            } else {
                let registrationError = error ?? RegistrationError.registrationFailed("Unknown error occurred")
                self.state = .failure(registrationError)
            }
        }
    }
    
    private func fetchUserData(uid: String) {
        guard !uid.isEmpty else {
            state = .failure(RegistrationError.userDataMissing)
            return
        }
        
        authService.fetchUserData(uid: uid) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let user):
                self.state = .success(user)
                self.clearCachedData()
            case .failure(let error):
                self.state = .failure(error)
            }
        }
    }
}

// MARK: - ValidatorDelegate
extension RegisterViewModel: ValidatorDelegate {
    func validationDidComplete(results: [ValidationResult]) {
        if results.isEmpty {
            // Validation successful, proceed with registration
            switch state {
            case .validating:
                performRegistration()
            default:
                break
            }
        } else {
            // Validation failed
            let validationErrors = results.compactMap { result -> String? in
                if case .invalid(_, let message) = result {
                    return message
                }
                return nil
            }
            
            let combinedError = validationErrors.joined(separator: "\n")
            state = .failure(RegistrationError.invalidInput(combinedError))
        }
    }
}

// MARK: - Testability Protocol
protocol DispatchQueueProtocol {
    func async(execute work: @escaping () -> Void)
}

final class DispatchQueueWrapper: DispatchQueueProtocol {
    private let queue: DispatchQueue
    
    init(queue: DispatchQueue = .global(qos: .userInitiated)) {
        self.queue = queue
    }
    
    func async(execute work: @escaping () -> Void) {
        queue.async(execute: work)
    }
}
