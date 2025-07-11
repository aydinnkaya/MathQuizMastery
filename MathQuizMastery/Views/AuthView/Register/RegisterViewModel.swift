//
//  RegisterViewModel.swift
//  MathQuizMastery
//
//  Created by Aydın KAYA on 6.04.2025.
//

import Foundation
import FirebaseAuth

// MARK: - Protocols
protocol RegisterViewModelProtocol: AnyObject {
    var delegate: RegisterViewModelDelegate? { get set }
    func register(name: String, email: String, password: String)
    func validateInputs(name: String, email: String, password: String, confirmPassword: String)
}

protocol RegisterViewModelDelegate: AnyObject {
    func didRegisterSuccessfully(user: AppUser)
    func didFailWithError(_ error: Error)
    func didValidationFail(results: [ValidationResult])
}

// MARK: - RegisterViewModel Implementation
final class RegisterViewModel: RegisterViewModelProtocol {
    
    // MARK: - Properties
    weak var delegate: RegisterViewModelDelegate?
    private var validator: ValidatorProtocol
    private var authService: AuthServiceProtocol
    
    // MARK: - Initialization
    init(
        validator: ValidatorProtocol = Validator(),
        authService: AuthServiceProtocol = AuthService.shared
    ) {
        self.validator = validator
        self.authService = authService
        self.validator.delegate = self
    }
    
    deinit {
        validator.delegate = nil
        print("🗑️ RegisterViewModel deallocated")
    }
    
    // MARK: - Public Methods
    func register(name: String, email: String, password: String) {
        let registerUserRequest = RegisterUserRequest(username: name, email: email, password: password)
        
        authService.registerUser(with: registerUserRequest) { [weak self] success, error in
            guard let self = self else { return }
            
            if let error = error {
                self.delegate?.didFailWithError(error)
                return
            }
            
            guard success else {
                let unknownError = NSError(
                    domain: "RegisterViewModel",
                    code: -1,
                    userInfo: [NSLocalizedDescriptionKey: "Registration failed with unknown error."]
                )
                self.delegate?.didFailWithError(unknownError)
                return
            }
            
            // Get the newly created user's UID from Firebase Auth
            guard let uid = Auth.auth().currentUser?.uid else {
                let uidError = NSError(
                    domain: "RegisterViewModel",
                    code: -2,
                    userInfo: [NSLocalizedDescriptionKey: "Could not retrieve user UID after registration."]
                )
                self.delegate?.didFailWithError(uidError)
                return
            }
            
            // Fetch user data from Firestore
            self.authService.fetchUserData(uid: uid) { result in
                switch result {
                case .success(let user):
                    self.delegate?.didRegisterSuccessfully(user: user)
                case .failure(let error):
                    self.delegate?.didFailWithError(error)
                }
            }
        }
    }
    
    func validateInputs(name: String, email: String, password: String, confirmPassword: String) {
        validator.validateSignUp(
            name: name,
            email: email,
            password: password,
            confirmPassword: confirmPassword
        )
    }
}

// MARK: - ValidatorDelegate
extension RegisterViewModel: ValidatorDelegate {
    func validationDidComplete(results: [ValidationResult]) {
        delegate?.didValidationFail(results: results)
    }
}
