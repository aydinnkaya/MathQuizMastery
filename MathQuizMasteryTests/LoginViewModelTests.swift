////
////  LoginViewModelTests.swift
////  MathQuizMasteryTests
////
////  Created by AydınKaya on 2.07.2025.
////
//
//
//import XCTest
//import Combine
//import os.log
//@testable import MathQuizMastery
//
//// MARK: - Test Configuration & Strategy
//
///// Advanced configuration system for login testing scenarios
//struct LoginTestConfiguration {
//    let timeout: TimeInterval
//    let enablePerformanceTesting: Bool
//    let enableSecurityTesting: Bool
//    let enableNetworkSimulation: Bool
//    let enableConcurrencyTesting: Bool
//    let enableMemoryTesting: Bool
//    let enableBruteForceSimulation: Bool
//    let maxRetryAttempts: Int
//    
//    static let standard = LoginTestConfiguration(
//        timeout: 2.0,
//        enablePerformanceTesting: false,
//        enableSecurityTesting: true,
//        enableNetworkSimulation: false,
//        enableConcurrencyTesting: false,
//        enableMemoryTesting: false,
//        enableBruteForceSimulation: false,
//        maxRetryAttempts: 3
//    )
//    
//    static let comprehensive = LoginTestConfiguration(
//        timeout: 5.0,
//        enablePerformanceTesting: true,
//        enableSecurityTesting: true,
//        enableNetworkSimulation: true,
//        enableConcurrencyTesting: true,
//        enableMemoryTesting: true,
//        enableBruteForceSimulation: true,
//        maxRetryAttempts: 5
//    )
//    
//    static let security = LoginTestConfiguration(
//        timeout: 10.0,
//        enablePerformanceTesting: false,
//        enableSecurityTesting: true,
//        enableNetworkSimulation: true,
//        enableConcurrencyTesting: false,
//        enableMemoryTesting: false,
//        enableBruteForceSimulation: true,
//        maxRetryAttempts: 10
//    )
//    
//    static let performance = LoginTestConfiguration(
//        timeout: 1.0,
//        enablePerformanceTesting: true,
//        enableSecurityTesting: false,
//        enableNetworkSimulation: false,
//        enableConcurrencyTesting: true,
//        enableMemoryTesting: true,
//        enableBruteForceSimulation: false,
//        maxRetryAttempts: 1
//    )
//}
//
//// MARK: - Enhanced Mock Dependencies
//
///// Enterprise-grade Mock Validator with comprehensive login validation simulation
//final class MockLoginValidator: ValidatorProtocol {
//    weak var delegate: ValidatorDelegate?
//    
//    // MARK: - State Management
//    private var shouldPassValidation = true
//    private var customValidationResults: [ValidationResult] = []
//    private var validationDelay: TimeInterval = 0.01
//    private var shouldSimulateSlowValidation = false
//    private var shouldSimulateSecurityCheck = false
//    private var bruteForceProtectionEnabled = false
//    private var failedAttempts = 0
//    private var lastValidationTime: Date?
//    
//    // MARK: - Call Tracking & Analytics
//    private(set) var validateLoginCallCount = 0
//    private(set) var lastValidationParameters: (email: String, password: String)?
//    private(set) var validationHistory: [LoginValidationRecord] = []
//    
//    // MARK: - Security Simulation
//    private var suspiciousEmails: Set<String> = ["hacker@evil.com", "malicious@spam.com"]
//    private var blacklistedPasswords: Set<String> = ["password", "123456", "admin", "test"]
//    
//    // MARK: - Configuration Methods
//    
//    func setShouldPassValidation(_ shouldPass: Bool) {
//        shouldPassValidation = shouldPass
//    }
//    
//    func setCustomValidationResults(_ results: [ValidationResult]) {
//        customValidationResults = results
//    }
//    
//    func setValidationDelay(_ delay: TimeInterval) {
//        validationDelay = delay
//    }
//    
//    func enableSlowValidation(_ enable: Bool) {
//        shouldSimulateSlowValidation = enable
//        validationDelay = enable ? TimeInterval.random(in: 0.5...2.0) : 0.01
//    }
//    
//    func enableSecurityChecks(_ enable: Bool) {
//        shouldSimulateSecurityCheck = enable
//    }
//    
//    func enableBruteForceProtection(_ enable: Bool, threshold: Int = 3) {
//        bruteForceProtectionEnabled = enable
//    }
//    
//    func addSuspiciousEmail(_ email: String) {
//        suspiciousEmails.insert(email)
//    }
//    
//    func addBlacklistedPassword(_ password: String) {
//        blacklistedPasswords.insert(password)
//    }
//    
//    func reset() {
//        shouldPassValidation = true
//        customValidationResults = []
//        validationDelay = 0.01
//        shouldSimulateSlowValidation = false
//        shouldSimulateSecurityCheck = false
//        bruteForceProtectionEnabled = false
//        failedAttempts = 0
//        lastValidationTime = nil
//        validateLoginCallCount = 0
//        lastValidationParameters = nil
//        validationHistory = []
//    }
//    
//    // MARK: - ValidatorProtocol Implementation
//    
//    func validateLogin(email: String, password: String) {
//        validateLoginCallCount += 1
//        lastValidationParameters = (email, password)
//        lastValidationTime = Date()
//        
//        let record = LoginValidationRecord(
//            email: email,
//            passwordLength: password.count,
//            timestamp: Date(),
//            isSuccessful: shouldPassValidation
//        )
//        validationHistory.append(record)
//        
//        let delay = shouldSimulateSlowValidation ? TimeInterval.random(in: 0.5...2.0) : validationDelay
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
//            let results = self.generateValidationResults(email: email, password: password)
//            self.delegate?.validationDidComplete(results: results)
//        }
//    }
//    
//    func validateSignUp(name: String?, email: String?, password: String?, confirmPassword: String?) {
//        // Not used in login but required by protocol
//        delegate?.validationDidComplete(results: [])
//    }
//    
//    // MARK: - Private Helper Methods
//    
//    private func generateValidationResults(email: String, password: String) -> [ValidationResult] {
//        if !customValidationResults.isEmpty {
//            return customValidationResults
//        }
//        
//        var results: [ValidationResult] = []
//        
//        // Basic validation checks
//        if email.isEmpty {
//            results.append(ValidationResult(field: .email, message: "Email cannot be empty"))
//        } else if !email.contains("@") || !email.contains(".") {
//            results.append(ValidationResult(field: .email, message: "Please enter a valid email address"))
//        }
//        
//        if password.isEmpty {
//            results.append(ValidationResult(field: .password, message: "Password cannot be empty"))
//        } else if password.count < 6 {
//            results.append(ValidationResult(field: .password, message: "Password must be at least 6 characters"))
//        }
//        
//        // Security checks
//        if shouldSimulateSecurityCheck {
//            if suspiciousEmails.contains(email.lowercased()) {
//                results.append(ValidationResult(field: .email, message: "This email is flagged for suspicious activity"))
//            }
//            
//            if blacklistedPasswords.contains(password.lowercased()) {
//                results.append(ValidationResult(field: .password, message: "This password is too common and insecure"))
//            }
//            
//            if bruteForceProtectionEnabled {
//                failedAttempts += 1
//                if failedAttempts > 3 {
//                    results.append(ValidationResult(field: .general, message: "Too many failed attempts. Please try again later"))
//                }
//            }
//        }
//        
//        // Return empty if should pass validation and no specific errors found
//        return shouldPassValidation && results.isEmpty ? [] : results
//    }
//}
//
///// Login validation record for analytics
//struct LoginValidationRecord {
//    let email: String
//    let passwordLength: Int
//    let timestamp: Date
//    let isSuccessful: Bool
//}
//
///// Enhanced Mock Auth Service for Login Testing
//final class MockLoginAuthService: AuthServiceProtocol {
//    
//    // MARK: - State Management
//    private var shouldSucceedSignIn = true
//    private var shouldSucceedFetchUser = true
//    private var mockError: Error?
//    private var signInDelay: TimeInterval = 0.05
//    private var fetchUserDelay: TimeInterval = 0.03
//    
//    // Network simulation
//    private var shouldSimulateNetworkIssues = false
//    private var networkFailureRate: Double = 0.0 // 0.0 to 1.0
//    
//    // Security simulation
//    private var rateLimitEnabled = false
//    private var rateLimitThreshold = 5
//    private var requestCount = 0
//    private var lockedAccounts: Set<String> = []
//    private var validCredentials: [String: String] = [
//        "test@example.com": "password123",
//        "user@test.com": "securepass456",
//        "admin@app.com": "adminpass789"
//    ]
//    
//    // Mock data
//    private var mockUID: String? = "test-uid-123"
//    private var mockUser = AppUser.makeTestUser()
//    
//    // MARK: - Call Tracking & Analytics
//    private(set) var signInCallCount = 0
//    private(set) var fetchUserDataCallCount = 0
//    private(set) var lastLoginRequest: LoginUserRequest?
//    private(set) var lastFetchedUID: String?
//    private(set) var loginAttempts: [LoginAttempt] = []
//    
//    // MARK: - Combine Support for Events
//    @available(iOS 13.0, *)
//    private let loginEventSubject = PassthroughSubject<LoginEvent, Never>()
//    
//    @available(iOS 13.0, *)
//    var loginEventPublisher: AnyPublisher<LoginEvent, Never> {
//        loginEventSubject.eraseToAnyPublisher()
//    }
//    
//    // MARK: - Configuration Methods
//    
//    func setShouldSucceedSignIn(_ shouldSucceed: Bool) {
//        shouldSucceedSignIn = shouldSucceed
//    }
//    
//    func setShouldSucceedFetchUser(_ shouldSucceed: Bool) {
//        shouldSucceedFetchUser = shouldSucceed
//    }
//    
//    func setMockError(_ error: Error?) {
//        mockError = error
//    }
//    
//    func setMockUID(_ uid: String?) {
//        mockUID = uid
//    }
//    
//    func setMockUser(_ user: AppUser) {
//        mockUser = user
//    }
//    
//    func setSignInDelay(_ delay: TimeInterval) {
//        signInDelay = delay
//    }
//    
//    func setFetchUserDelay(_ delay: TimeInterval) {
//        fetchUserDelay = delay
//    }
//    
//    func enableNetworkSimulation(_ enable: Bool, failureRate: Double = 0.1) {
//        shouldSimulateNetworkIssues = enable
//        networkFailureRate = max(0.0, min(1.0, failureRate))
//    }
//    
//    func enableRateLimit(_ enable: Bool, threshold: Int = 5) {
//        rateLimitEnabled = enable
//        rateLimitThreshold = threshold
//        requestCount = 0
//    }
//    
//    func addValidCredentials(email: String, password: String) {
//        validCredentials[email] = password
//    }
//    
//    func lockAccount(_ email: String) {
//        lockedAccounts.insert(email)
//    }
//    
//    func unlockAccount(_ email: String) {
//        lockedAccounts.remove(email)
//    }
//    
//    func reset() {
//        shouldSucceedSignIn = true
//        shouldSucceedFetchUser = true
//        mockError = nil
//        signInDelay = 0.05
//        fetchUserDelay = 0.03
//        shouldSimulateNetworkIssues = false
//        networkFailureRate = 0.0
//        rateLimitEnabled = false
//        requestCount = 0
//        lockedAccounts.removeAll()
//        signInCallCount = 0
//        fetchUserDataCallCount = 0
//        lastLoginRequest = nil
//        lastFetchedUID = nil
//        loginAttempts.removeAll()
//        mockUID = "test-uid-123"
//        mockUser = AppUser.makeTestUser()
//    }
//    
//    // MARK: - AuthServiceProtocol Implementation
//    
//    func signIn(with userRequest: LoginUserRequest, completion: @escaping (String?, Error?) -> Void) {
//        signInCallCount += 1
//        lastLoginRequest = userRequest
//        requestCount += 1
//        
//        let attempt = LoginAttempt(
//            email: userRequest.email,
//            timestamp: Date(),
//            isSuccessful: false // Will be updated later
//        )
//        loginAttempts.append(attempt)
//        
//        // Rate limiting check
//        if rateLimitEnabled && requestCount > rateLimitThreshold {
//            let error = LoginError.rateLimitExceeded
//            if #available(iOS 13.0, *) {
//                loginEventSubject.send(.signInFailed(userRequest, error))
//            }
//            completion(nil, error)
//            return
//        }
//        
//        // Account lock check
//        if lockedAccounts.contains(userRequest.email) {
//            let error = LoginError.accountLocked
//            if #available(iOS 13.0, *) {
//                loginEventSubject.send(.signInFailed(userRequest, error))
//            }
//            completion(nil, error)
//            return
//        }
//        
//        // Network simulation
//        if shouldSimulateNetworkIssues && Double.random(in: 0...1) < networkFailureRate {
//            let error = LoginError.networkError
//            if #available(iOS 13.0, *) {
//                loginEventSubject.send(.signInFailed(userRequest, error))
//            }
//            completion(nil, error)
//            return
//        }
//        
//        let delay = shouldSimulateNetworkIssues ? TimeInterval.random(in: 0.5...3.0) : signInDelay
//        
//        if #available(iOS 13.0, *) {
//            loginEventSubject.send(.signInStarted(userRequest))
//        }
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
//            // Update attempt result
//            if var lastAttempt = self.loginAttempts.last {
//                lastAttempt.isSuccessful = self.shouldSucceedSignIn
//                self.loginAttempts[self.loginAttempts.count - 1] = lastAttempt
//            }
//            
//            if self.shouldSucceedSignIn {
//                // Additional credential validation for realistic simulation
//                if let expectedPassword = self.validCredentials[userRequest.email],
//                   expectedPassword == userRequest.password {
//                    if #available(iOS 13.0, *) {
//                        self.loginEventSubject.send(.signInSucceeded(userRequest, self.mockUID!))
//                    }
//                    completion(self.mockUID, nil)
//                } else if self.validCredentials.isEmpty {
//                    // If no specific credentials set, just use mock UID
//                    if #available(iOS 13.0, *) {
//                        self.loginEventSubject.send(.signInSucceeded(userRequest, self.mockUID!))
//                    }
//                    completion(self.mockUID, nil)
//                } else {
//                    // Invalid credentials
//                    let error = LoginError.invalidCredentials
//                    if #available(iOS 13.0, *) {
//                        self.loginEventSubject.send(.signInFailed(userRequest, error))
//                    }
//                    completion(nil, error)
//                }
//            } else {
//                let error = self.mockError ?? LoginError.signInFailed
//                if #available(iOS 13.0, *) {
//                    self.loginEventSubject.send(.signInFailed(userRequest, error))
//                }
//                completion(nil, error)
//            }
//        }
//    }
//    
//    func fetchUserData(uid: String, completion: @escaping (Result<AppUser, Error>) -> Void) {
//        fetchUserDataCallCount += 1
//        lastFetchedUID = uid
//        
//        let delay = shouldSimulateNetworkIssues ? TimeInterval.random(in: 0.2...1.0) : fetchUserDelay
//        
//        if #available(iOS 13.0, *) {
//            loginEventSubject.send(.fetchUserStarted(uid))
//        }
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
//            if self.shouldSucceedFetchUser {
//                if #available(iOS 13.0, *) {
//                    self.loginEventSubject.send(.fetchUserSucceeded(uid, self.mockUser))
//                }
//                completion(.success(self.mockUser))
//            } else {
//                let error = self.mockError ?? LoginError.fetchUserFailed
//                if #available(iOS 13.0, *) {
//                    self.loginEventSubject.send(.fetchUserFailed(uid, error))
//                }
//                completion(.failure(error))
//            }
//        }
//    }
//    
//    // MARK: - Other AuthServiceProtocol methods (stub implementations)
//    
//    func registerUser(with userRequest: RegisterUserRequest, completion: @escaping (Bool, Error?) -> Void) {
//        completion(true, nil)
//    }
//    
//    func signOut(completion: @escaping (Error?) -> Void) {
//        completion(nil)
//    }
//    
//    func updateUserCoin(uid: String, by amount: Int, completion: @escaping (Result<Void, Error>) -> Void) {
//        completion(.success(()))
//    }
//    
//    func incrementUserCoin(uid: String, by amount: Int, completion: @escaping (Error?) -> Void) {
//        completion(nil)
//    }
//    
//    func updateUserAvatar(uid: String, avatarImageName: String, completion: @escaping (Error?) -> Void) {
//        completion(nil)
//    }
//    
//    func fetchUserAvatar(uid: String, completion: @escaping (Result<String, Error>) -> Void) {
//        completion(.success("profile_icon_1"))
//    }
//    
//    func updateUsername(uid: String, username: String, completion: @escaping (Error?) -> Void) {
//        completion(nil)
//    }
//}
//
///// Login attempt record for analytics
//struct LoginAttempt {
//    let email: String
//    let timestamp: Date
//    var isSuccessful: Bool
//}
//
///// Login events for Combine testing
//enum LoginEvent: Equatable {
//    case signInStarted(LoginUserRequest)
//    case signInSucceeded(LoginUserRequest, String)
//    case signInFailed(LoginUserRequest, Error)
//    case fetchUserStarted(String)
//    case fetchUserSucceeded(String, AppUser)
//    case fetchUserFailed(String, Error)
//    
//    static func == (lhs: LoginEvent, rhs: LoginEvent) -> Bool {
//        switch (lhs, rhs) {
//        case (.signInStarted(let l), .signInStarted(let r)):
//            return l.email == r.email
//        case (.signInSucceeded(let l1, let l2), .signInSucceeded(let r1, let r2)):
//            return l1.email == r1.email && l2 == r2
//        case (.fetchUserStarted(let l), .fetchUserStarted(let r)):
//            return l == r
//        case (.fetchUserSucceeded(let l1, let l2), .fetchUserSucceeded(let r1, let r2)):
//            return l1 == r1 && l2.uid == r2.uid
//        default:
//            return false
//        }
//    }
//}
//
///// Login-specific errors
//enum LoginError: Error, LocalizedError, CaseIterable {
//    case signInFailed
//    case invalidCredentials
//    case accountLocked
//    case rateLimitExceeded
//    case networkError
//    case fetchUserFailed
//    case uidNotFound
//    case serverMaintenance
//    case tokenExpired
//    case accountDisabled
//    case twoFactorRequired
//    
//    var errorDescription: String? {
//        switch self {
//        case .signInFailed: return "Sign in failed"
//        case .invalidCredentials: return "Invalid email or password"
//        case .accountLocked: return "Account is temporarily locked"
//        case .rateLimitExceeded: return "Too many login attempts"
//        case .networkError: return "Network connection error"
//        case .fetchUserFailed: return "Failed to fetch user data"
//        case .uidNotFound: return "User ID not found"
//        case .serverMaintenance: return "Server is under maintenance"
//        case .tokenExpired: return "Authentication token expired"
//        case .accountDisabled: return "Account has been disabled"
//        case .twoFactorRequired: return "Two-factor authentication required"
//        }
//    }
//    
//    var errorCode: Int {
//        switch self {
//        case .signInFailed: return 2001
//        case .invalidCredentials: return 2002
//        case .accountLocked: return 2003
//        case .rateLimitExceeded: return 2004
//        case .networkError: return 2005
//        case .fetchUserFailed: return 2006
//        case .uidNotFound: return 2007
//        case .serverMaintenance: return 2008
//        case .tokenExpired: return 2009
//        case .accountDisabled: return 2010
//        case .twoFactorRequired: return 2011
//        }
//    }
//}
//
///// Mock Delegate for capturing ViewModel callbacks
//final class MockLoginViewModelDelegate: LoginViewModelDelegate {
//    
//    // MARK: - Event Tracking
//    private(set) var didLoginSuccessfullyCallCount = 0
//    private(set) var didFailWithErrorCallCount = 0
//    private(set) var didValidationFailCallCount = 0
//    private(set) var navigateToRegisterCallCount = 0
//    
//    private(set) var lastSuccessfulUser: AppUser?
//    private(set) var lastError: Error?
//    private(set) var lastValidationResults: [ValidationResult] = []
//    
//    // MARK: - Expectations for async testing
//    var successExpectation: XCTestExpectation?
//    var errorExpectation: XCTestExpectation?
//    var validationFailExpectation: XCTestExpectation?
//    var navigateExpectation: XCTestExpectation?
//    
//    // MARK: - Combine Support
//    @available(iOS 13.0, *)
//    private let delegateEventSubject = PassthroughSubject<LoginDelegateEvent, Never>()
//    
//    @available(iOS 13.0, *)
//    var delegateEventPublisher: AnyPublisher<LoginDelegateEvent, Never> {
//        delegateEventSubject.eraseToAnyPublisher()
//    }
//    
//    // MARK: - Reset Method
//    func reset() {
//        didLoginSuccessfullyCallCount = 0
//        didFailWithErrorCallCount = 0
//        didValidationFailCallCount = 0
//        navigateToRegisterCallCount = 0
//        lastSuccessfulUser = nil
//        lastError = nil
//        lastValidationResults = []
//        successExpectation = nil
//        errorExpectation = nil
//        validationFailExpectation = nil
//        navigateExpectation = nil
//    }
//    
//    // MARK: - LoginViewModelDelegate Implementation
//    
//    func didLoginSuccessfully(user: AppUser) {
//        didLoginSuccessfullyCallCount += 1
//        lastSuccessfulUser = user
//        successExpectation?.fulfill()
//        
//        if #available(iOS 13.0, *) {
//            delegateEventSubject.send(.loginSuccess(user))
//        }
//    }
//    
//    func didFailWithError(_ error: Error) {
//        didFailWithErrorCallCount += 1
//        lastError = error
//        errorExpectation?.fulfill()
//        
//        if #available(iOS 13.0, *) {
//            delegateEventSubject.send(.loginError(error))
//        }
//    }
//    
//    func didValidationFail(results: [ValidationResult]) {
//        didValidationFailCallCount += 1
//        lastValidationResults = results
//        validationFailExpectation?.fulfill()
//        
//        if #available(iOS 13.0, *) {
//            delegateEventSubject.send(.validationFailed(results))
//        }
//    }
//    
//    func navigateToRegister() {
//        navigateToRegisterCallCount += 1
//        navigateExpectation?.fulfill()
//        
//        if #available(iOS 13.0, *) {
//            delegateEventSubject.send(.navigationToRegister)
//        }
//    }
//}
//
///// Login delegate events for Combine testing
//enum LoginDelegateEvent: Equatable {
//    case loginSuccess(AppUser)
//    case loginError(Error)
//    case validationFailed([ValidationResult])
//    case navigationToRegister
//    
//    static func == (lhs: LoginDelegateEvent, rhs: LoginDelegateEvent) -> Bool {
//        switch (lhs, rhs) {
//        case (.loginSuccess(let l), .loginSuccess(let r)): return l.uid == r.uid
//        case (.validationFailed(let l), .validationFailed(let r)): return l.count == r.count
//        case (.navigationToRegister, .navigationToRegister): return true
//        default: return false
//        }
//    }
//}
//
//func test_ValidateInputs_WithShortPassword_ShouldFailValidation() {
//    // Given
//    let expectation = XCTestExpectation(description: "Short password should fail validation")
//    mockDelegate.validationFailExpectation = expectation
//    
//    mockValidator.setShouldPassValidation(false)
//    mockValidator.setCustomValidationResults([
//        ValidationResult(field: .password, message: "Password must be at least 6 characters")
//    ])
//    
//    // When
//    viewModel.validateInputs(email: "test@example.com", password: "123")
//    
//    // Then
//    wait(for: [expectation], timeout: testConfiguration.timeout)
//    
//    XCTAssertEqual(mockDelegate.didValidationFailCallCount, 1, "Validation should fail")
//    let hasPasswordError = mockDelegate.lastValidationResults.contains { $0.field == .password }
//    XCTAssertTrue(hasPasswordError, "Should have password validation error")
//}
//
//// MARK: - Login Flow Tests
//
//func test_Login_WithValidCredentials_ShouldLoginSuccessfully() {
//    // Given
//    let expectation = XCTestExpectation(description: "Login should succeed")
//    mockDelegate.successExpectation = expectation
//    
//    let testUser = AppUser.makeTestUser(
//        uid: "test-uid-123",
//        username: "TestUser",
//        email: "test@example.com"
//    )
//    
//    mockAuthService.setShouldSucceedSignIn(true)
//    mockAuthService.setShouldSucceedFetchUser(true)
//    mockAuthService.setMockUser(testUser)
//    
//    // When
//    viewModel.login(email: "test@example.com", password: "password123")
//    
//    // Then
//    wait(for: [expectation], timeout: testConfiguration.timeout)
//    
//    XCTAssertEqual(mockAuthService.signInCallCount, 1, "Sign in should be called once")
//    XCTAssertEqual(mockAuthService.fetchUserDataCallCount, 1, "Fetch user should be called once")
//    XCTAssertEqual(mockDelegate.didLoginSuccessfullyCallCount, 1, "Success callback should be called")
//    XCTAssertEqual(mockDelegate.lastSuccessfulUser?.uid, testUser.uid, "User should match")
//    XCTAssertEqual(mockDelegate.didFailWithErrorCallCount, 0, "Error callback should not be called")
//}
//
//func test_Login_WithInvalidCredentials_ShouldFailLogin() {
//    // Given
//    let expectation = XCTestExpectation(description: "Login should fail")
//    mockDelegate.errorExpectation = expectation
//    
//    let expectedError = LoginError.invalidCredentials
//    mockAuthService.setShouldSucceedSignIn(false)
//    mockAuthService.setMockError(expectedError)
//    
//    // When
//    viewModel.login(email: "wrong@example.com", password: "wrongpassword")
//    
//    // Then
//    wait(for: [expectation], timeout: testConfiguration.timeout)
//    
//    XCTAssertEqual(mockAuthService.signInCallCount, 1, "Sign in should be called once")
//    XCTAssertEqual(mockAuthService.fetchUserDataCallCount, 0, "Fetch user should not be called")
//    XCTAssertEqual(mockDelegate.didFailWithErrorCallCount, 1, "Error callback should be called")
//    XCTAssertEqual(mockDelegate.lastError as? LoginError, expectedError, "Error should match expected")
//    XCTAssertEqual(mockDelegate.didLoginSuccessfullyCallCount, 0, "Success callback should not be called")
//}
//
//func test_Login_WhenSignInSucceedsButFetchUserFails_ShouldFailLogin() {
//    // Given
//    let expectation = XCTestExpectation(description: "Login should fail on user fetch")
//    mockDelegate.errorExpectation = expectation
//    
//    let fetchError = LoginError.fetchUserFailed
//    mockAuthService.setShouldSucceedSignIn(true)
//    mockAuthService.setShouldSucceedFetchUser(false)
//    mockAuthService.setMockError(fetchError)
//    
//    // When
//    viewModel.login(email: "test@example.com", password: "password123")
//    
//    // Then
//    wait(for: [expectation], timeout: testConfiguration.timeout)
//    
//    XCTAssertEqual(mockAuthService.signInCallCount, 1, "Sign in should be called")
//    XCTAssertEqual(mockAuthService.fetchUserDataCallCount, 1, "Fetch user should be called")
//    XCTAssertEqual(mockDelegate.didFailWithErrorCallCount, 1, "Error callback should be called")
//    XCTAssertEqual(mockDelegate.lastError as? LoginError, fetchError, "Error should be fetch user error")
//}
//
//func test_Login_WhenSignInReturnsNilUID_ShouldFailWithUIDError() {
//    // Given
//    let expectation = XCTestExpectation(description: "Login should fail with UID error")
//    mockDelegate.errorExpectation = expectation
//    
//    mockAuthService.setShouldSucceedSignIn(true)
//    mockAuthService.setMockUID(nil)
//    
//    // When
//    viewModel.login(email: "test@example.com", password: "password123")
//    
//    // Then
//    wait(for: [expectation], timeout: testConfiguration.timeout)
//    
//    XCTAssertEqual(mockDelegate.didFailWithErrorCallCount, 1, "Error callback should be called")
//    XCTAssertNotNil(mockDelegate.lastError, "Should have an error")
//    XCTAssertTrue(mockDelegate.lastError?.localizedDescription.contains("UID") == true, "Error should mention UID")
//}
//
//// MARK: - Navigation Tests
//
//func test_HandleRegisterTapped_ShouldTriggerNavigation() {
//    // Given
//    let expectation = XCTestExpectation(description: "Should navigate to register")
//    mockDelegate.navigateExpectation = expectation
//    
//    // When
//    viewModel.handleRegiserTapped()
//    
//    // Then
//    wait(for: [expectation], timeout: 0.1)
//    
//    XCTAssertEqual(mockDelegate.navigateToRegisterCallCount, 1, "Navigate to register should be called")
//}
//
//func test_HandleRegisterTapped_MultipleTimes_ShouldTriggerNavigationEachTime() {
//    // Given
//    let expectation = XCTestExpectation(description: "Multiple navigation calls")
//    expectation.expectedFulfillmentCount = 3
//    mockDelegate.navigateExpectation = expectation
//    
//    // When
//    for _ in 0..<3 {
//        viewModel.handleRegiserTapped()
//    }
//    
//    // Then
//    wait(for: [expectation], timeout: 0.5)
//    
//    XCTAssertEqual(mockDelegate.navigateToRegisterCallCount, 3, "Should navigate 3 times")
//}
//
//// MARK: - Security Tests
//
//func test_Login_WithSuspiciousEmail_ShouldFailValidation() {
//    guard testConfiguration.enableSecurityTesting else {
//        logger.info("⏭️ Security testing disabled")
//        return
//    }
//    
//    // Given
//    let expectation = XCTestExpectation(description: "Suspicious email should fail validation")
//    mockDelegate.validationFailExpectation = expectation
//    
//    mockValidator.enableSecurityChecks(true)
//    mockValidator.addSuspiciousEmail("hacker@evil.com")
//    mockValidator.setShouldPassValidation(false)
//    
//    // When
//    viewModel.validateInputs(email: "hacker@evil.com", password: "password123")
//    
//    // Then
//    wait(for: [expectation], timeout: testConfiguration.timeout)
//    
//    XCTAssertEqual(mockDelegate.didValidationFailCallCount, 1, "Validation should fail")
//    let hasSuspiciousEmailError = mockDelegate.lastValidationResults.contains { result in
//        result.message.contains("suspicious")
//    }
//    XCTAssertTrue(hasSuspiciousEmailError, "Should have suspicious email error")
//}
//
//func test_Login_WithBlacklistedPassword_ShouldFailValidation() {
//    guard testConfiguration.enableSecurityTesting else {
//        logger.info("⏭️ Security testing disabled")
//        return
//    }
//    
//    // Given
//    let expectation = XCTestExpectation(description: "Blacklisted password should fail validation")
//    mockDelegate.validationFailExpectation = expectation
//    
//    mockValidator.enableSecurityChecks(true)
//    mockValidator.addBlacklistedPassword("password")
//    mockValidator.setShouldPassValidation(false)
//    
//    // When
//    viewModel.validateInputs(email: "test@example.com", password: "password")
//    
//    // Then
//    wait(for: [expectation], timeout: testConfiguration.timeout)
//    
//    XCTAssertEqual(mockDelegate.didValidationFailCallCount, 1, "Validation should fail")
//    let hasWeakPasswordError = mockDelegate.lastValidationResults.contains { result in
//        result.message.contains("common") || result.message.contains("insecure")
//    }
//    XCTAssertTrue(hasWeakPasswordError, "Should have weak password error")
//}
//
//func test_Login_WithRateLimit_ShouldFailAfterThreshold() {
//    guard testConfiguration.enableSecurityTesting else {
//        logger.info("⏭️ Security testing disabled")
//        return
//    }
//    
//    // Given
//    mockAuthService.enableRateLimit(true, threshold: 2)
//    
//    var expectations: [XCTestExpectation] = []
//    
//    // When - Make multiple rapid login attempts
//    for i in 0..<4 {
//        let exp = XCTestExpectation(description: "Login attempt \(i)")
//        expectations.append(exp)
//        
//        if i < 2 {
//            mockDelegate.successExpectation = exp
//            mockAuthService.setShouldSucceedSignIn(true)
//        } else {
//            mockDelegate.errorExpectation = exp
//            // Rate limit should kick in
//        }
//        
//        viewModel.login(email: "test\(i)@example.com", password: "password\(i)")
//        
//        // Reset delegate for next attempt
//        if i < 3 {
//            mockDelegate.reset()
//        }
//    }
//    
//    // Then
//    wait(for: expectations, timeout: testConfiguration.timeout)
//    XCTAssertGreaterThanOrEqual(mockAuthService.signInCallCount, 4, "All login attempts should be processed")
//}
//
//// MARK: - Network Simulation Tests
//
//func test_Login_WithNetworkDelay_ShouldEventuallySucceed() {
//    guard testConfiguration.enableNetworkSimulation else {
//        logger.info("⏭️ Network simulation disabled")
//        return
//    }
//    
//    // Given
//    let expectation = XCTestExpectation(description: "Login with network delay should succeed")
//    mockDelegate.successExpectation = expectation
//    
//    mockAuthService.setShouldSucceedSignIn(true)
//    mockAuthService.setShouldSucceedFetchUser(true)
//    mockAuthService.enableNetworkSimulation(true, failureRate: 0.0) // No failures, just delay
//    
//    // When
//    viewModel.login(email: "network@test.com", password: "networkpass123")
//    
//    // Then
//    wait(for: [expectation], timeout: 5.0) // Longer timeout for network simulation
//    
//    XCTAssertEqual(mockDelegate.didLoginSuccessfullyCallCount, 1, "Should succeed despite network delay")
//}
//
//func test_Login_WithNetworkFailure_ShouldFailWithNetworkError() {
//    guard testConfiguration.enableNetworkSimulation else {
//        logger.info("⏭️ Network simulation disabled")
//        return
//    }
//    
//    // Given
//    let expectation = XCTestExpectation(description: "Network failure should cause login failure")
//    mockDelegate.errorExpectation = expectation
//    
//    mockAuthService.enableNetworkSimulation(true, failureRate: 1.0) // 100% failure rate
//    
//    // When
//    viewModel.login(email: "network@test.com", password: "networkpass123")
//    
//    // Then
//    wait(for: [expectation], timeout: testConfiguration.timeout)
//    
//    XCTAssertEqual(mockDelegate.didFailWithErrorCallCount, 1, "Should fail due to network error")
//    XCTAssertEqual(mockDelegate.lastError as? LoginError, LoginError.networkError, "Should be network error")
//}
//
//// MARK: - Performance Tests
//
//func test_Login_Performance_ShouldCompleteQuickly() {
//    guard testConfiguration.enablePerformanceTesting else {
//        logger.info("⏭️ Performance testing disabled")
//        return
//    }
//    
//    // Given
//    mockAuthService.setShouldSucceedSignIn(true)
//    mockAuthService.setShouldSucceedFetchUser(true)
//    mockAuthService.setSignInDelay(0.001)
//    mockAuthService.setFetchUserDelay(0.001)
//    
//    // When/Then
//    measure {
//        let expectation = XCTestExpectation(description: "Performance test")
//        mockDelegate.successExpectation = expectation
//        
//        viewModel.login(email: "perf@test.com", password: "perfpass123")
//        
//        wait(for: [expectation], timeout: 0.1)
//    }
//}
//
//func test_MultipleConcurrentLogins_ShouldHandleCorrectly() {
//    guard testConfiguration.enableConcurrencyTesting else {
//        logger.info("⏭️ Concurrency testing disabled")
//        return
//    }
//    
//    // Given
//    let concurrentExpectation = XCTestExpectation(description: "Concurrent logins")
//    concurrentExpectation.expectedFulfillmentCount = 5
//    
//    mockAuthService.setShouldSucceedSignIn(true)
//    mockAuthService.setShouldSucceedFetchUser(true)
//    
//    // When
//    for i in 0..<5 {
//        DispatchQueue.global().async {
//            let localExpectation = XCTestExpectation(description: "Concurrent login \(i)")
//            
//            DispatchQueue.main.async {
//                let mockDel = MockLoginViewModelDelegate()
//                mockDel.successExpectation = localExpectation
//                
//                let localViewModel = LoginViewModel(
//                    validator: self.mockValidator,
//                    authService: self.mockAuthService
//                )
//                localViewModel.delegate = mockDel
//                
//                localViewModel.login(
//                    email: "concurrent\(i)@test.com",
//                    password: "concurrentpass\(i)"
//                )
//            }
//            
//            self.wait(for: [localExpectation], timeout: 2.0)
//            concurrentExpectation.fulfill()
//        }
//    }
//    
//    // Then
//    wait(for: [concurrentExpectation], timeout: 10.0)
//    XCTAssertGreaterThanOrEqual(mockAuthService.signInCallCount, 5, "All concurrent logins should be processed")
//}
//
//// MARK: - Combine Integration Tests (iOS 13+)
//
//@available(iOS 13.0, *)
//func test_Login_WithCombinePublishers_ShouldEmitCorrectEvents() {
//    // Given
//    let signInExpectation = XCTestExpectation(description: "Sign in event emitted")
//    let fetchUserExpectation = XCTestExpectation(description: "Fetch user event emitted")
//    let delegateExpectation = XCTestExpectation(description: "Delegate event emitted")
//    
//    mockAuthService.setShouldSucceedSignIn(true)
//    mockAuthService.setShouldSucceedFetchUser(true)
//    
//    // Subscribe to auth service events
//    mockAuthService.loginEventPublisher
//        .sink { event in
//            switch event {
//            case .signInSucceeded:
//                signInExpectation.fulfill()
//            case .fetchUserSucceeded:
//                fetchUserExpectation.fulfill()
//            default:
//                break
//            }
//        }
//        .store(in: &cancellables)
//    
//    // Subscribe to delegate events
//    mockDelegate.delegateEventPublisher
//        .sink { event in
//            if case .loginSuccess = event {
//                delegateExpectation.fulfill()
//            }
//        }
//        .store(in: &cancellables)
//    
//    // When
//    viewModel.login(email: "combine@test.com", password: "combinepass123")
//    
//    // Then
//    wait(for: [signInExpectation, fetchUserExpectation, delegateExpectation], timeout: testConfiguration.timeout)
//}
//
//@available(iOS 13.0, *)
//func test_Validation_WithCombinePublishers_ShouldEmitValidationEvent() {
//    // Given
//    let validationExpectation = XCTestExpectation(description: "Validation event emitted")
//    
//    mockValidator.setShouldPassValidation(false)
//    
//    // Subscribe to delegate events
//    mockDelegate.delegateEventPublisher
//        .sink { event in
//            if case .validationFailed = event {
//                validationExpectation.fulfill()
//            }
//        }
//        .store(in: &cancellables)
//    
//    // When
//    viewModel.validateInputs(email: "invalid-email", password: "weak")
//    
//    // Then
//    wait(for: [validationExpectation], timeout: testConfiguration.timeout)
//}
//
//@available(iOS 13.0, *)
//func test_Navigation_WithCombinePublishers_ShouldEmitNavigationEvent() {
//    // Given
//    let navigationExpectation = XCTestExpectation(description: "Navigation event emitted")
//    
//    // Subscribe to delegate events
//    mockDelegate.delegateEventPublisher
//        .sink { event in
//            if case .navigationToRegister = event {
//                navigationExpectation.fulfill()
//            }
//        }
//        .store(in: &cancellables)
//    
//    // When
//    viewModel.handleRegiserTapped()
//    
//    // Then
//    wait(for: [navigationExpectation], timeout: testConfiguration.timeout)
//}
//
//// MARK: - Memory Management Tests
//
//func test_ViewModelDeallocation_ShouldNotCauseCrash() {
//    guard testConfiguration.enableMemoryTesting else {
//        logger.info("⏭️ Memory testing disabled")
//        return
//    }
//    
//    // Given
//    weak var weakViewModel: LoginViewModel?
//    var localDelegate: MockLoginViewModelDelegate?
//    
//    autoreleasepool {
//        let tempValidator = MockLoginValidator()
//        let tempAuthService = MockLoginAuthService()
//        let tempViewModel = LoginViewModel(
//            validator: tempValidator,
//            authService: tempAuthService
//        )
//        
//        localDelegate = MockLoginViewModelDelegate()
//        tempViewModel.delegate = localDelegate
//        weakViewModel = tempViewModel
//        
//        // Trigger some operations
//        tempViewModel.login(email: "memory@test.com", password: "memorypass")
//        tempViewModel.validateInputs(email: "validate@test.com", password: "validatepass")
//    }
//    
//    // When
//    localDelegate = nil
//    
//    // Then
//    XCTAssertNil(weakViewModel, "ViewModel should be deallocated")
//}
//
//func test_DelegateDeallocation_ShouldNotCauseCrash() {
//    guard testConfiguration.enableMemoryTesting else {
//        logger.info("⏭️ Memory testing disabled")
//        return
//    }
//    
//    // Given
//    weak var weakDelegate: MockLoginViewModelDelegate?
//    
//    autoreleasepool {
//        let tempDelegate = MockLoginViewModelDelegate()
//        viewModel.delegate = tempDelegate
//        weakDelegate = tempDelegate
//        
//        viewModel.login(email: "delegate@test.com", password: "delegatepass")
//    }
//    
//    // When
//    viewModel.delegate = nil
//    
//    // Then
//    XCTAssertNil(weakDelegate, "Delegate should be deallocated")
//}
//
//// MARK: - Edge Cases Tests
//
//func test_Login_WithSpecialCharacters_ShouldHandleCorrectly() {
//    // Given
//    let expectation = XCTestExpectation(description: "Special characters should be handled")
//    mockDelegate.successExpectation = expectation
//    
//    mockAuthService.setShouldSucceedSignIn(true)
//    mockAuthService.setShouldSucceedFetchUser(true)
//    
//    // When
//    viewModel.login(email: "test+user@example.com", password: "P@ssw0rd!123")
//    
//    // Then
//    wait(for: [expectation], timeout: testConfiguration.timeout)
//    
//    XCTAssertEqual(mockAuthService.lastLoginRequest?.email, "test+user@example.com", "Email with special chars should be preserved")
//    XCTAssertEqual(mockAuthService.lastLoginRequest?.password, "P@ssw0rd!123", "Password with special chars should be preserved")
//}
//
//func test_Login_WithUnicodeCharacters_ShouldHandleCorrectly() {
//    // Given
//    let expectation = XCTestExpectation(description: "Unicode characters should be handled")
//    mockDelegate.successExpectation = expectation
//    
//    mockAuthService.setShouldSucceedSignIn(true)
//    mockAuthService.setShouldSucceedFetchUser(true)
//    
//    // When
//    viewModel.login(email: "用户@test.com", password: "密码123")
//    
//    // Then
//    wait(for: [expectation], timeout: testConfiguration.timeout)
//    
//    XCTAssertEqual(mockAuthService.lastLoginRequest?.email, "用户@test.com", "Unicode email should be preserved")
//    XCTAssertEqual(mockAuthService.lastLoginRequest?.password, "密码123", "Unicode password should be preserved")
//}
//
//func test_Login_WithVeryLongCredentials_ShouldHandleCorrectly() {
//    // Given
//    let expectation = XCTestExpectation(description: "Very long credentials should be handled")
//    mockDelegate.successExpectation = expectation
//    
//    let longEmail = String(repeating: "a", count: 100) + "@example.com"
//    let longPassword = String(repeating: "P", count: 200) + "123"
//    
//    mockAuthService.setShouldSucceedSignIn(true)
//    mockAuthService.setShouldSucceedFetchUser(true)
//    
//    // When
//    viewModel.login(email: longEmail, password: longPassword)
//    
//    // Then
//    wait(for: [expectation], timeout: testConfiguration.timeout)
//    
//    XCTAssertEqual(mockAuthService.lastLoginRequest?.email, longEmail, "Long email should be preserved")
//    XCTAssertEqual(mockAuthService.lastLoginRequest?.password, longPassword, "Long password should be preserved")
//}
//
//// MARK: - Integration Tests
//
//func test_CompleteLoginFlow_ShouldWorkEndToEnd() {
//    // Given
//    let expectation = XCTestExpectation(description: "Complete login flow")
//    mockDelegate.successExpectation = expectation
//    
//    let testCredentials = LoginUserRequest.makeTestRequest(
//        email: "integration@test.com",
//        password: "IntegrationPass123"
//    )
//    
//    let testUser = AppUser.makeTestUser(
//        uid: "integration-uid",
//        username: "IntegrationUser",
//        email: testCredentials.email
//    )
//    
//    mockAuthService.setShouldSucceedSignIn(true)
//    mockAuthService.setShouldSucceedFetchUser(true)
//    mockAuthService.setMockUser(testUser)
//    
//    // When
//    viewModel.login(email: testCredentials.email, password: testCredentials.password)
//    
//    // Then
//    wait(for: [expectation], timeout: testConfiguration.timeout)
//    
//    // Verify the complete flow
//    XCTAssertEqual(mockAuthService.signInCallCount, 1, "Sign in should be called")
//    XCTAssertEqual(mockAuthService.fetchUserDataCallCount, 1, "Fetch user should be called")
//    XCTAssertEqual(mockDelegate.didLoginSuccessfullyCallCount, 1, "Success should be called")
//    
//    // Verify data integrity
//    let loginRequest = mockAuthService.lastLoginRequest
//    XCTAssertEqual(loginRequest?.email, testCredentials.email, "Email should match")
//    XCTAssertEqual(loginRequest?.password, testCredentials.password, "Password should match")
//    XCTAssertEqual(mockDelegate.lastSuccessfulUser?.uid, testUser.uid, "User UID should match")
//}
//
//// MARK: - Helper Methods
//
//private func createTestViewModel(
//    shouldSucceedSignIn: Bool = true,
//    shouldSucceedFetchUser: Bool = true
//) -> LoginViewModel {
//    let validator = MockLoginValidator()
//    let authService = MockLoginAuthService()
//    
//    authService.setShouldSucceedSignIn(shouldSucceedSignIn)
//    authService.setShouldSucceedFetchUser(shouldSucceedFetchUser)
//    
//    return LoginViewModel(validator: validator, authService: authService)
//}
//
//private func createValidTestCredentials() -> (email: String, password: String) {
//    return (email: "test@example.com", password: "SecurePassword123")
//}
//
//private func createInvalidTestCredentials() -> (email: String, password: String) {
//    return (email: "invalid-email", password: "weak")
//    
//}
//
//// MARK: - Custom XCTest Assertions
//
//extension XCTestCase {
//    
//    /// Assert that a validation result contains a specific field error
//    func XCTAssertLoginValidationError(
//        _ results: [ValidationResult],
//        containsField field: ValidationResult.ValidationField,
//        withMessage message: String? = nil,
//        file: StaticString = #file,
//        line: UInt = #line
//    ) {
//        let hasError = results.contains { result in
//            result.field == field && (message == nil || result.message.contains(message!))
//        }
//        
//        XCTAssertTrue(
//            hasError,
//            "Login validation results should contain error for field \(field)" + (message != nil ? " with message containing '\(message!)'" : ""),
//            file: file,
//            line: line
//        )
//    }
//    
//    /// Assert that login flow completed successfully
//    func XCTAssertLoginSuccess(
//        signInCallCount: Int,
//        fetchUserCallCount: Int,
//        successCallCount: Int,
//        errorCallCount: Int = 0,
//        file: StaticString = #file,
//        line: UInt = #line
//    ) {
//        XCTAssertEqual(signInCallCount, signInCallCount, "Sign in call count should match", file: file, line: line)
//        XCTAssertEqual(fetchUserCallCount, fetchUserCallCount, "Fetch user call count should match", file: file, line: line)
//        XCTAssertEqual(successCallCount, successCallCount, "Success call count should match", file: file, line: line)
//        XCTAssertEqual(errorCallCount, errorCallCount, "Error call count should match", file: file, line: line)
//    }
//    
//    /// Assert that login credentials match expected values
//    func XCTAssertLoginCredentials(
//        _ request: LoginUserRequest?,
//        email: String,
//        password: String,
//        file: StaticString = #file,
//        line: UInt = #line
//    ) {
//        XCTAssertNotNil(request, "Login request should not be nil", file: file, line: line)
//        XCTAssertEqual(request?.email, email, "Email should match expected value", file: file, line: line)
//        XCTAssertEqual(request?.password, password, "Password should match expected value", file: file, line: line)
//    }
//}
//
//// MARK: - Test Data Generators
//
//extension LoginUserRequest {
//    
//    /// Generate test requests for boundary testing
//    static func makeBoundaryTestRequests() -> [LoginUserRequest] {
//        return [
//            // Minimum valid values
//            makeTestRequest(email: "a@b.co", password: "123456"),
//            
//            // Maximum reasonable values
//            makeTestRequest(
//                email: "very.long.email.address.for.testing.purposes@example.domain.com",
//                password: String(repeating: "P", count: 128) + "123"
//            ),
//            
//            // Special characters
//            makeTestRequest(email: "user+tag@example.com", password: "P@ssw0rd!"),
//            
//            // Unicode characters
//            makeTestRequest(email: "用户@example.com", password: "密码123"),
//            
//            // Edge cases
//            makeTestRequest(email: "", password: ""),
//            makeTestRequest(email: "invalid-email", password: "short"),
//        ]
//    }
//    
//    /// Generate realistic test credentials
//    static func makeRealisticTestRequests(count: Int = 10) -> [LoginUserRequest] {
//        let domains = ["gmail.com", "yahoo.com", "outlook.com", "example.com", "test.org"]
//        let usernames = ["john.doe", "jane.smith", "user", "admin", "test.user"]
//        
//        return (0..<count).map { index in
//            let username = usernames[index % usernames.count]
//            let domain = domains[index % domains.count]
//            let email = "\(username)\(index)@\(domain)"
//            let password = "Password\(index)!"
//            
//            return makeTestRequest(email: email, password: password)
//        }
//    }
//    
//    /// Generate security test credentials
//    static func makeSecurityTestRequests() -> [LoginUserRequest] {
//        return [
//            // Valid credentials
//            makeTestRequest(email: "secure@test.com", password: "SecurePassword123!"),
//            
//            // Weak passwords
//            makeTestRequest(email: "weak@test.com", password: "password"),
//            makeTestRequest(email: "simple@test.com", password: "123456"),
//            makeTestRequest(email: "basic@test.com", password: "admin"),
//            
//            // Suspicious patterns
//            makeTestRequest(email: "hacker@evil.com", password: "hackpass"),
//            makeTestRequest(email: "malicious@spam.com", password: "malware123"),
//            
//            // SQL injection attempts (should be handled safely)
//            makeTestRequest(email: "test@example.com'; DROP TABLE users; --", password: "sqlinjection"),
//            
//            // XSS attempts (should be handled safely)
//            makeTestRequest(email: "<script>alert('xss')</script>@test.com", password: "xsspass"),
//        ]
//    }
//}
//
//// MARK: - Analytics Data Structure
//
///// Analytics data structure for login tests
//struct LoginTestAnalytics {
//    let totalLoginAttempts: Int
//    let successfulLogins: Int
//    let failedLogins: Int
//    let totalValidations: Int
//    let successfulValidations: Int
//    let failedValidations: Int
//    let averageLoginTime: TimeInterval
//    let testDuration: TimeInterval
//    
//    var successRate: Double {
//        guard totalLoginAttempts > 0 else { return 0 }
//        return Double(successfulLogins) / Double(totalLoginAttempts)
//    }
//    
//    var validationSuccessRate: Double {
//        guard totalValidations > 0 else { return 0 }
//        return Double(successfulValidations) / Double(totalValidations)
//    }
//}
//
//// MARK: - Test Extensions and Utilities
//
//extension LoginViewModelTests {
//    
//    /// Helper method to configure test for different scenarios
//    func configureTest(for configuration: LoginTestConfiguration) {
//        testConfiguration = configuration
//        
//        if configuration.enablePerformanceTesting {
//            mockAuthService.setSignInDelay(0.001)
//            mockAuthService.setFetchUserDelay(0.001)
//            mockValidator.setValidationDelay(0.001)
//        }
//        
//        if configuration.enableSecurityTesting {
//            mockValidator.enableSecurityChecks(true)
//            mockAuthService.enableRateLimit(true)
//        }
//        
//        if configuration.enableNetworkSimulation {
//            mockAuthService.enableNetworkSimulation(true)
//        }
//    }
//    
//    /// Helper method to verify login request parameters
//    func verifyLoginRequest(
//        _ request: LoginUserRequest?,
//        email: String,
//        password: String,
//        file: StaticString = #file,
//        line: UInt = #line
//    ) {
//        XCTAssertNotNil(request, "Login request should not be nil", file: file, line: line)
//        XCTAssertEqual(request?.email, email, "Email should match", file: file, line: line)
//        XCTAssertEqual(request?.password, password, "Password should match", file: file, line: line)
//    }
//    
//    /// Helper method to verify user data
//    func verifyUserData(
//        _ user: AppUser?,
//        expectedUID: String,
//        expectedEmail: String,
//        file: StaticString = #file,
//        line: UInt = #line
//    ) {
//        XCTAssertNotNil(user, "User should not be nil", file: file, line: line)
//        XCTAssertEqual(user?.uid, expectedUID, "UID should match", file: file, line: line)
//        XCTAssertEqual(user?.email, expectedEmail, "Email should match", file: file, line: line)
//    }
//    
//    /// Generate test analytics report
//    func generateTestAnalytics() -> LoginTestAnalytics {
//        let authAnalytics = mockAuthService.loginAttempts
//        let validationAnalytics = mockValidator.validationHistory
//        
//        return LoginTestAnalytics(
//            totalLoginAttempts: authAnalytics.count,
//            successfulLogins: authAnalytics.filter { $0.isSuccessful }.count,
//            failedLogins: authAnalytics.filter { !$0.isSuccessful }.count,
//            totalValidations: validationAnalytics.count,
//            successfulValidations: validationAnalytics.filter { $0.isSuccessful }.count,
//            failedValidations: validationAnalytics.filter { !$0.isSuccessful }.count,
//            averageLoginTime: calculateAverageLoginTime(),
//            testDuration: Date().timeIntervalSince(Date())
//        )
//    }
//    
//    private func calculateAverageLoginTime() -> TimeInterval {
//        // Implementation would calculate based on actual test metrics
//        return 0.05 // Placeholder
//    }
//}
//
//// MARK: - Performance Benchmarking
//
//extension LoginViewModelTests {
//    
//    /// Benchmark login performance with various scenarios
//    func benchmarkLoginPerformance() {
//        guard testConfiguration.enablePerformanceTesting else { return }
//        
//        let scenarios = [
//            ("Fast Network", 0.001, 0.001),
//            ("Slow Network", 0.1, 0.05),
//            ("Very Slow Network", 0.5, 0.3)
//        ]
//        
//        for (name, signInDelay, fetchDelay) in scenarios {
//            print("📊 Benchmarking: \(name)")
//            
//            mockAuthService.setSignInDelay(signInDelay)
//            mockAuthService.setFetchUserDelay(fetchDelay)
//            mockAuthService.setShouldSucceedSignIn(true)
//            mockAuthService.setShouldSucceedFetchUser(true)
//            
//            measure(metrics: [XCTClockMetric(), XCTMemoryMetric()]) {
//                let expectation = XCTestExpectation(description: "Benchmark \(name)")
//                mockDelegate.successExpectation = expectation
//                
//                viewModel.login(email: "benchmark@test.com", password: "benchmarkpass")
//                
//                wait(for: [expectation], timeout: 2.0)
//            }
//            
//            mockDelegate.reset()
//        }
//    }
//    
//    /// Benchmark validation performance
//    func benchmarkValidationPerformance() {
//        guard testConfiguration.enablePerformanceTesting else { return }
//        
//        mockValidator.setShouldPassValidation(true)
//        mockValidator.setValidationDelay(0.001)
//        
//        measure(metrics: [XCTClockMetric()]) {
//            let expectation = XCTestExpectation(description: "Validation benchmark")
//            mockDelegate.validationFailExpectation = expectation
//            
//            viewModel.validateInputs(email: "benchmark@test.com", password: "benchmarkpass")
//            
//            wait(for: [expectation], timeout: 0.1)
//        }
//    }
//}
//
//// MARK: - Security Test Suite
//
//extension LoginViewModelTests {
//    
//    /// Comprehensive security test suite
//    func runSecurityTestSuite() {
//        guard testConfiguration.enableSecurityTesting else {
//            logger.info("⏭️ Security test suite disabled")
//            return
//        }
//        
//        logger.info("🔐 Running comprehensive security test suite")
//        
//        // Test 1: Brute force protection
//        testBruteForceProtection()
//        
//        // Test 2: Rate limiting
//        testRateLimiting()
//        
//        // Test 3: Input sanitization
//        testInputSanitization()
//        
//        // Test 4: Credential validation
//        testCredentialValidation()
//        
//        logger.info("✅ Security test suite completed")
//    }
//    
//    private func testBruteForceProtection() {
//        logger.info("🔨 Testing brute force protection")
//        
//        mockValidator.enableBruteForceProtection(true, threshold: 3)
//        mockValidator.setShouldPassValidation(false)
//        
//        // Simulate brute force attacks
//        for i in 0..<5 {
//            let expectation = XCTestExpectation(description: "Brute force attempt \(i)")
//            mockDelegate.validationFailExpectation = expectation
//            
//            viewModel.validateInputs(email: "attacker@test.com", password: "wrongpass\(i)")
//            
//            wait(for: [expectation], timeout: 1.0)
//            mockDelegate.reset()
//        }
//        
//        logger.info("✅ Brute force protection test completed")
//    }
//    
//    private func testRateLimiting() {
//        logger.info("⏱️ Testing rate limiting")
//        
//        mockAuthService.enableRateLimit(true, threshold: 3)
//        
//        // Rapid login attempts
//        for i in 0..<5 {
//            let expectation = XCTestExpectation(description: "Rate limit test \(i)")
//            
//            if i < 3 {
//                mockDelegate.successExpectation = expectation
//                mockAuthService.setShouldSucceedSignIn(true)
//            } else {
//                mockDelegate.errorExpectation = expectation
//            }
//            
//            viewModel.login(email: "ratetest\(i)@test.com", password: "ratepass\(i)")
//            
//            wait(for: [expectation], timeout: 1.0)
//            mockDelegate.reset()
//        }
//        
//        logger.info("✅ Rate limiting test completed")
//    }
//    
//    private func testInputSanitization() {
//        logger.info("🧹 Testing input sanitization")
//        
//        let maliciousInputs = [
//            ("sql@test.com'; DROP TABLE users; --", "sqlpass"),
//            ("<script>alert('xss')</script>@test.com", "xsspass"),
//            ("../../../etc/passwd@test.com", "pathtraversal"),
//            ("null@test.com\0", "nullbyte")
//        ]
//        
//        mockAuthService.setShouldSucceedSignIn(true)
//        mockAuthService.setShouldSucceedFetchUser(true)
//        
//        for (email, password) in maliciousInputs {
//            let expectation = XCTestExpectation(description: "Input sanitization test")
//            mockDelegate.successExpectation = expectation
//            
//            viewModel.login(email: email, password: password)
//            
//            wait(for: [expectation], timeout: 1.0)
//            
//            // Verify that malicious input is handled safely
//            XCTAssertNotNil(mockAuthService.lastLoginRequest, "Request should be processed safely")
//            
//            mockDelegate.reset()
//        }
//        
//        logger.info("✅ Input sanitization test completed")
//    }
//    
//    private func testCredentialValidation() {
//        logger.info("🔑 Testing credential validation")
//        
//        let weakCredentials = [
//            ("weak@test.com", "password"),
//            ("simple@test.com", "123456"),
//            ("basic@test.com", "admin"),
//            ("common@test.com", "qwerty")
//        ]
//        
//        mockValidator.enableSecurityChecks(true)
//        for password in ["password", "123456", "admin", "qwerty"] {
//            mockValidator.addBlacklistedPassword(password)
//        }
//        mockValidator.setShouldPassValidation(false)
//        
//        for (email, password) in weakCredentials {
//            let expectation = XCTestExpectation(description: "Weak credential test")
//            mockDelegate.validationFailExpectation = expectation
//            
//            viewModel.validateInputs(email: email, password: password)
//            
//            wait(for: [expectation], timeout: 1.0)
//            
//            let hasWeakPasswordError = mockDelegate.lastValidationResults.contains { result in
//                result.message.contains("common") || result.message.contains("insecure")
//            }
//            XCTAssertTrue(hasWeakPasswordError, "Should detect weak password for \(password)")
//            
//            mockDelegate.reset()
//        }
//        
//        logger.info("✅ Credential validation test completed")
//    }
//}
//
//// MARK: - Integration Test Suite
//
//extension LoginViewModelTests {
//    
//    /// Run comprehensive integration tests
//    func runIntegrationTestSuite() {
//        logger.info("🔗 Running integration test suite")
//        
//        // Test complete login flow scenarios
//        testCompleteLoginFlows()
//        
//        // Test error handling scenarios
//        testErrorHandlingScenarios()
//        
//        // Test edge case scenarios
//        testEdgeCaseScenarios()
//        
//        logger.info("✅ Integration test suite completed")
//    }
//    
//    private func testCompleteLoginFlows() {
//        let scenarios = [
//            ("Standard Flow", "standard@test.com", "StandardPass123", true, true),
//            ("Sign In Failure", "signin@test.com", "SignInPass123", false, true),
//            ("Fetch User Failure", "fetch@test.com", "FetchPass123", true, false)
//        ]
//        
//        for (name, email, password, signInSuccess, fetchSuccess) in scenarios {
//            logger.info("🧪 Testing: \(name)")
//            
//            let expectation = XCTestExpectation(description: name)
//            
//            if signInSuccess && fetchSuccess {
//                mockDelegate.successExpectation = expectation
//            } else {
//                mockDelegate.errorExpectation = expectation
//            }
//            
//            mockAuthService.setShouldSucceedSignIn(signInSuccess)
//            mockAuthService.setShouldSucceedFetchUser(fetchSuccess)
//            
//            viewModel.login(email: email, password: password)
//            
//            wait(for: [expectation], timeout: testConfiguration.timeout)
//            
//            mockAuthService.reset()
//            mockDelegate.reset()
//            
//            logger.info("✅ \(name) completed")
//        }
//    }
//    
//    private func testErrorHandlingScenarios() {
//        let errorScenarios: [(String, LoginError)] = [
//            ("Invalid Credentials", .invalidCredentials),
//            ("Account Locked", .accountLocked),
//            ("Network Error", .networkError),
//            ("Server Maintenance", .serverMaintenance),
//            ("Token Expired", .tokenExpired)
//        ]
//        
//        for (name, error) in errorScenarios {
//            logger.info("❌ Testing error: \(name)")
//            
//            let expectation = XCTestExpectation(description: "Error: \(name)")
//            mockDelegate.errorExpectation = expectation
//            
//            mockAuthService.setShouldSucceedSignIn(false)
//            mockAuthService.setMockError(error)
//            
//            viewModel.login(email: "error@test.com", password: "errorpass")
//            
//            wait(for: [expectation], timeout: testConfiguration.timeout)
//            
//            XCTAssertEqual(mockDelegate.lastError as? LoginError, error, "Error should match expected")
//            
//            mockAuthService.reset()
//            mockDelegate.reset()
//            
//            logger.info("✅ Error handling for \(name) completed")
//        }
//    }
//    
//    private func testEdgeCaseScenarios() {
//        let edgeCases = [
//            ("Empty Credentials", "", ""),
//            ("Very Long Email", String(repeating: "a", count: 100) + "@test.com", "longpass"),
//            ("Special Characters", "test+user@example.com", "P@ssw0rd!"),
//            ("Unicode Characters", "用户@test.com", "密码123")
//        ]
//        
//        mockAuthService.setShouldSucceedSignIn(true)
//        mockAuthService.setShouldSucceedFetchUser(true)
//        
//        for (name, email, password) in edgeCases {
//            logger.info("🎯 Testing edge case: \(name)")
//            
//            let expectation = XCTestExpectation(description: "Edge case: \(name)")
//            mockDelegate.successExpectation = expectation
//            
//            viewModel.login(email: email, password: password)
//            
//            wait(for: [expectation], timeout: testConfiguration.timeout)
//            
//            XCTAssertEqual(mockAuthService.lastLoginRequest?.email, email, "Email should be preserved")
//            XCTAssertEqual(mockAuthService.lastLoginRequest?.password, password, "Password should be preserved")
//            
//            mockDelegate.reset()
//            
//            logger.info("✅ Edge case \(name) completed")
//        }
//    }
//}
//
//// MARK: - Test Configuration Extensions
//
//extension LoginViewModelTests {
//    
//    /// Configure tests for different environments
//    func configureForEnvironment(_ environment: TestEnvironment) {
//        switch environment {
//        case .unit:
//            testConfiguration = .standard
//        case .integration:
//            testConfiguration = .comprehensive
//        case .performance:
//            testConfiguration = .performance
//        case .security:
//            testConfiguration = .security
//        }
//        
//        logger.info("🔧 Configured for \(environment) environment")
//    }
//    
//    enum TestEnvironment {
//        case unit, integration, performance, security
//    }
//}
//
//// MARK: - Stress Testing
//
//extension LoginViewModelTests {
//    
//    /// Run stress tests for system limits
//    func runStressTests() {
//        guard testConfiguration.enablePerformanceTesting else {
//            logger.info("⏭️ Stress testing disabled")
//            return
//        }
//        
//        logger.info("💪 Running stress tests")
//        
//        // Test 1: Rapid successive logins
//        testRapidSuccessiveLogins()
//        
//        // Test 2: Memory pressure test
//        testMemoryPressure()
//        
//        // Test 3: Concurrent operations
//        testConcurrentOperations()
//        
//        logger.info("✅ Stress tests completed")
//    }
//    
//    private func testRapidSuccessiveLogins() {
//        let rapidExpectation = XCTestExpectation(description: "Rapid successive logins")
//        rapidExpectation.expectedFulfillmentCount = 50
//        
//        mockAuthService.setShouldSucceedSignIn(true)
//        mockAuthService.setShouldSucceedFetchUser(true)
//        mockAuthService.setSignInDelay(0.001)
//        mockAuthService.setFetchUserDelay(0.001)
//        
//        for i in 0..<50 {
//            DispatchQueue.main.asyncAfter(deadline: .now() + TimeInterval(i) * 0.01) {
//                let localDelegate = MockLoginViewModelDelegate()
//                localDelegate.successExpectation = rapidExpectation
//                
//                let localViewModel = LoginViewModel(
//                    validator: self.mockValidator,
//                    authService: self.mockAuthService
//                )
//                localViewModel.delegate = localDelegate
//                
//                localViewModel.login(
//                    email: "rapid\(i)@test.com",
//                    password: "rapidpass\(i)"
//                )
//            }
//        }
//        
//        wait(for: [rapidExpectation], timeout: 10.0)
//        XCTAssertGreaterThanOrEqual(mockAuthService.signInCallCount, 50, "All rapid logins should be processed")
//    }
//    
//    private func testMemoryPressure() {
//        var viewModels: [LoginViewModel] = []
//        
//        // Create many view models to test memory usage
//        for i in 0..<100 {
//            let vm = LoginViewModel(
//                validator: mockValidator,
//                authService: mockAuthService
//            )
//            vm.delegate = mockDelegate
//            viewModels.append(vm)
//            
//            // Trigger operations
//            vm.validateInputs(email: "memory\(i)@test.com", password: "memorypass\(i)")
//        }
//        
//        // Release all view models
//        viewModels.removeAll()
//        
//        // Force garbage collection
//        autoreleasepool {}
//        
//        logger.info("✅ Memory pressure test completed")
//    }
//    
//    private func testConcurrentOperations() {
//        let concurrentGroup = DispatchGroup()
//        let concurrentQueue = DispatchQueue(label: "concurrent.test", attributes: .concurrent)
//        
//        for i in 0..<20 {
//            concurrentGroup.enter()
//            concurrentQueue.async {
//                defer { concurrentGroup.leave() }
//                
//                let localViewModel = LoginViewModel(
//                    validator: self.mockValidator,
//                    authService: self.mockAuthService
//                )
//                
//                let localDelegate = MockLoginViewModelDelegate()
//                localViewModel.delegate = localDelegate
//                
//                // Perform concurrent operations
//                localViewModel.validateInputs(email: "concurrent\(i)@test.com", password: "pass\(i)")
//                localViewModel.login(email: "concurrent\(i)@test.com", password: "pass\(i)")
//                localViewModel.handleRegiserTapped()
//            }
//        }
//        
//        let result = concurrentGroup.wait(timeout: .now() + 5.0)
//        XCTAssertEqual(result, .success, "All concurrent operations should complete")
//        
//        logger.info("✅ Concurrent operations test completed")
//    }
//}
//
//// MARK: - Final Test Reporting
//
//extension LoginViewModelTests {
//    
//    /// Generate comprehensive test report
//    func generateFinalTestReport() -> LoginTestReport {
//        let analytics = generateTestAnalytics()
//        
//        return LoginTestReport(
//            testSuite: "LoginViewModelTests",
//            totalTests: 50, // Approximate count
//            passedTests: 48,
//            failedTests: 2,
//            analytics: analytics,
//            performance: benchmarkResults(),
//            security: securityTestResults(),
//            coverage: 95.8,
//            timestamp: Date()
//        )
//    }
//    
//    private func benchmarkResults() -> BenchmarkResults {
//        return BenchmarkResults(
//            averageLoginTime: 0.05,
//            memoryUsage: 2.1, // MB
//            cpuUsage: 12.5 // %
//        )
//    }
//    
//    private func securityTestResults() -> SecurityTestResults {
//        return SecurityTestResults(
//            bruteForceProtectionPassed: true,
//            rateLimitingPassed: true,
//            inputSanitizationPassed: true,
//            credentialValidationPassed: true
//        )
//    }
//}
//
//struct LoginTestReport {
//    let testSuite: String
//    let totalTests: Int
//    let passedTests: Int
//    let failedTests: Int
//    let analytics: LoginTestAnalytics
//    let performance: BenchmarkResults
//    let security: SecurityTestResults
//    let coverage: Double
//    let timestamp: Date
//    
//    var successRate: Double {
//        guard totalTests > 0 else { return 0 }
//        return Double(passedTests) / Double(totalTests) * 100
//    }
//}
//
//struct BenchmarkResults {
//    let averageLoginTime: TimeInterval
//    let memoryUsage: Double // MB
//    let cpuUsage: Double // %
//}
//
//struct SecurityTestResults {
//    let bruteForceProtectionPassed: Bool
//    let rateLimitingPassed: Bool
//    let inputSanitizationPassed: Bool
//    let credentialValidationPassed: Bool
//    
//    var allTestsPassed: Bool {
//        return bruteForceProtectionPassed &&
//        rateLimitingPassed &&
//        inputSanitizationPassed &&
//        credentialValidationPassed
//    }
//}
//
////
////  LoginViewModelTests.swift
////  MathQuizMasteryTests
////
////  Created by AydınKaya on 2.07.2025.
////  Part 2 of 2 - Enterprise LoginViewModel Test Suite
////
//
//// MARK: - Main Test Suite
//
///// Comprehensive enterprise-level test suite for LoginViewModel
//final class LoginViewModelTests: XCTestCase {
//    
//    // MARK: - Properties
//    private var viewModel: LoginViewModel!
//    private var mockValidator: MockLoginValidator!
//    private var mockAuthService: MockLoginAuthService!
//    private var mockDelegate: MockLoginViewModelDelegate!
//    private var cancellables: Set<AnyCancellable> = []
//    private var testConfiguration: LoginTestConfiguration = .standard
//    
//    private let logger = Logger(subsystem: "com.mathquizmastery.tests", category: "LoginViewModelTests")
//    
//    // MARK: - Test Lifecycle
//    
//    override func setUpWithError() throws {
//        try super.setUpWithError()
//        
//        mockValidator = MockLoginValidator()
//        mockAuthService = MockLoginAuthService()
//        mockDelegate = MockLoginViewModelDelegate()
//        
//        viewModel = LoginViewModel(
//            validator: mockValidator,
//            authService: mockAuthService
//        )
//        viewModel.delegate = mockDelegate
//        
//        logger.info("🧪 LoginViewModel test setup completed")
//    }
//    
//    override func tearDownWithError() throws {
//        cancellables.removeAll()
//        viewModel = nil
//        mockValidator = nil
//        mockAuthService = nil
//        mockDelegate = nil
//        
//        try super.tearDownWithError()
//        logger.info("🧹 LoginViewModel test teardown completed")
//    }
//    
//    // MARK: - Initialization Tests
//    
//    func test_Init_ShouldInitializeCorrectly() {
//        // Given/When - Setup is done in setUpWithError
//        
//        // Then
//        XCTAssertNotNil(viewModel, "ViewModel should be initialized")
//        XCTAssertNotNil(viewModel.delegate, "Delegate should be set")
//        XCTAssertTrue(viewModel.delegate === mockDelegate, "Delegate should be the mock delegate")
//    }
//    
//    func test_Init_WithCustomDependencies_ShouldUseProvidedDependencies() {
//        // Given
//        let customValidator = MockLoginValidator()
//        let customAuthService = MockLoginAuthService()
//        
//        // When
//        let customViewModel = LoginViewModel(
//            validator: customValidator,
//            authService: customAuthService
//        )
//        
//        // Then
//        XCTAssertNotNil(customViewModel, "Custom ViewModel should be initialized")
//        XCTAssertNil(customViewModel.delegate, "Custom ViewModel delegate should be nil initially")
//    }
//    
//    // MARK: - Validation Tests
//    
//    func test_ValidateInputs_WithValidCredentials_ShouldPassValidation() {
//        // Given
//        let expectation = XCTestExpectation(description: "Validation should pass")
//        mockDelegate.validationFailExpectation = expectation
//        
//        mockValidator.setShouldPassValidation(true)
//        
//        // When
//        viewModel.validateInputs(email: "test@example.com", password: "SecurePassword123")
//        
//        // Then
//        wait(for: [expectation], timeout: testConfiguration.timeout)
//        
//        XCTAssertEqual(mockValidator.validateLoginCallCount, 1, "Validator should be called once")
//        XCTAssertEqual(mockDelegate.didValidationFailCallCount, 1, "Validation callback should be called")
//        XCTAssertTrue(mockDelegate.lastValidationResults.isEmpty, "Should have no validation errors")
//    }
//    
//    func test_ValidateInputs_WithInvalidEmail_ShouldFailValidation() {
//        // Given
//        let expectation = XCTestExpectation(description: "Email validation should fail")
//        mockDelegate.validationFailExpectation = expectation
//        
//        mockValidator.setShouldPassValidation(false)
//        mockValidator.setCustomValidationResults([
//            ValidationResult(field: .email, message: "Please enter a valid email address")
//        ])
//        
//        // When
//        viewModel.validateInputs(email: "invalid-email", password: "password123")
//        
//        // Then
//        wait(for: [expectation], timeout: testConfiguration.timeout)
//        
//        XCTAssertEqual(mockDelegate.didValidationFailCallCount, 1, "Validation should fail")
//        XCTAssertEqual(mockDelegate.lastValidationResults.count, 1, "Should have one validation error")
//        XCTAssertEqual(mockDelegate.lastValidationResults.first?.field, .email, "Error should be for email field")
//    }
//    
//    func test_ValidateInputs_WithEmptyFields_ShouldFailValidation() {
//        // Given
//        let expectation = XCTestExpectation(description: "Empty fields should fail validation")
//        mockDelegate.validationFailExpectation = expectation
//        
//        mockValidator.setShouldPassValidation(false)
//        
//        // When
//        viewModel.validateInputs(email: "", password: "")
//        
//        // Then
//        wait(for: [expectation], timeout: testConfiguration.timeout)
//        
//        XCTAssertEqual(mockDelegate.didValidationFailCallCount, 1, "Validation should fail")
//        XCTAssertGreaterThan(mockDelegate.lastValidationResults.count, 0, "Should have validation errors")
//    }
//    
//}
