////
////  RegisterViewModelTests.swift
////  MathQuizMasteryTests
////
////  Created by AydınKaya on 3.07.2025.
////
//
//import XCTest
//import Combine
//import os.log
//@testable import MathQuizMastery
//
//
//// MARK: - Test Configuration
//
///// Configuration for registration test execution strategies
//struct RegisterTestConfiguration {
//    let timeout: TimeInterval
//    let enablePerformanceTesting: Bool
//    let enableConcurrencyTesting: Bool
//    let enableValidationTesting: Bool
//    let enableNetworkSimulation: Bool
//    let maxRetryAttempts: Int
//    
//    static let standard = RegisterTestConfiguration(
//        timeout: 2.0,
//        enablePerformanceTesting: false,
//        enableConcurrencyTesting: false,
//        enableValidationTesting: true,
//        enableNetworkSimulation: false,
//        maxRetryAttempts: 3
//    )
//    
//    static let comprehensive = RegisterTestConfiguration(
//        timeout: 5.0,
//        enablePerformanceTesting: true,
//        enableConcurrencyTesting: true,
//        enableValidationTesting: true,
//        enableNetworkSimulation: true,
//        maxRetryAttempts: 5
//    )
//    
//    static let performance = RegisterTestConfiguration(
//        timeout: 10.0,
//        enablePerformanceTesting: true,
//        enableConcurrencyTesting: true,
//        enableValidationTesting: false,
//        enableNetworkSimulation: true,
//        maxRetryAttempts: 1
//    )
//}
//
//// MARK: - Enhanced Mock Dependencies
//
///// Mock Validator with comprehensive validation simulation
//final class MockValidator: ValidatorProtocol {
//    weak var delegate: ValidatorDelegate?
//    
//    // MARK: - State Management
//    private var shouldPassValidation = true
//    private var customValidationResults: [ValidationResult] = []
//    private var validationDelay: TimeInterval = 0.01
//    private var shouldSimulateSlowValidation = false
//    
//    // MARK: - Call Tracking
//    private(set) var validateSignUpCallCount = 0
//    private(set) var lastValidationParameters: (name: String?, email: String?, password: String?, confirmPassword: String?)?
//    
//    // MARK: - Configuration Methods
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
//    func setSimulateSlowValidation(_ simulate: Bool) {
//        shouldSimulateSlowValidation = simulate
//        validationDelay = simulate ? 1.0 : 0.01
//    }
//    
//    func reset() {
//        shouldPassValidation = true
//        customValidationResults = []
//        validationDelay = 0.01
//        shouldSimulateSlowValidation = false
//        validateSignUpCallCount = 0
//        lastValidationParameters = nil
//    }
//    
//    // MARK: - ValidatorProtocol Implementation
//    func validateSignUp(name: String?, email: String?, password: String?, confirmPassword: String?) {
//        validateSignUpCallCount += 1
//        lastValidationParameters = (name, email, password, confirmPassword)
//        
//        let delay = shouldSimulateSlowValidation ? TimeInterval.random(in: 0.5...2.0) : validationDelay
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
//            let results = self.generateValidationResults(
//                name: name,
//                email: email,
//                password: password,
//                confirmPassword: confirmPassword
//            )
//            self.delegate?.validationDidComplete(results: results)
//        }
//    }
//    
//    // MARK: - Private Helper Methods
//    private func generateValidationResults(name: String?, email: String?, password: String?, confirmPassword: String?) -> [ValidationResult] {
//        if !customValidationResults.isEmpty {
//            return customValidationResults
//        }
//        
//        if shouldPassValidation {
//            return []
//        }
//        
//        var results: [ValidationResult] = []
//        
//        // Simulate real validation logic
//        if let name = name, name.isEmpty {
//            results.append(ValidationResult(field: .name, message: "Name cannot be empty"))
//        }
//        
//        if let name = name, name.count < 2 {
//            results.append(ValidationResult(field: .name, message: "Name must be at least 2 characters"))
//        }
//        
//        if let email = email, email.isEmpty {
//            results.append(ValidationResult(field: .email, message: "Email cannot be empty"))
//        }
//        
//        if let email = email, !email.contains("@") {
//            results.append(ValidationResult(field: .email, message: "Invalid email format"))
//        }
//        
//        if let password = password, password.isEmpty {
//            results.append(ValidationResult(field: .password, message: "Password cannot be empty"))
//        }
//        
//        if let password = password, password.count < 6 {
//            results.append(ValidationResult(field: .password, message: "Password must be at least 6 characters"))
//        }
//        
//        if password != confirmPassword {
//            results.append(ValidationResult(field: .confirmPassword, message: "Passwords do not match"))
//        }
//        
//        return results
//    }
//}
//
///// Mock Auth Service with enhanced registration simulation
//final class MockRegisterAuthService: AuthServiceProtocol {
//    
//    // MARK: - State Management
//    private var shouldSucceedRegistration = true
//    private var mockError: Error?
//    private var registrationDelay: TimeInterval = 0.05
//    private var shouldSimulateNetworkIssues = false
//    private var rateLimitEnabled = false
//    private var rateLimitThreshold = 3
//    private var requestCount = 0
//    
//    // MARK: - Call Tracking
//    private(set) var registerUserCallCount = 0
//    private(set) var lastRegisterRequest: RegisterUserRequest?
//    private(set) var registrationAttempts: [Date] = []
//    
//    // MARK: - Event Tracking (Combine Support)
//    @available(iOS 13.0, *)
//    private let registrationEventSubject = PassthroughSubject<RegistrationEvent, Never>()
//    
//    @available(iOS 13.0, *)
//    var registrationEventPublisher: AnyPublisher<RegistrationEvent, Never> {
//        registrationEventSubject.eraseToAnyPublisher()
//    }
//    
//    // MARK: - Configuration Methods
//    func setShouldSucceedRegistration(_ shouldSucceed: Bool) {
//        shouldSucceedRegistration = shouldSucceed
//    }
//    
//    func setMockError(_ error: Error?) {
//        mockError = error
//    }
//    
//    func setRegistrationDelay(_ delay: TimeInterval) {
//        registrationDelay = delay
//    }
//    
//    func setSimulateNetworkIssues(_ simulate: Bool) {
//        shouldSimulateNetworkIssues = simulate
//        registrationDelay = simulate ? TimeInterval.random(in: 1.0...3.0) : 0.05
//    }
//    
//    func enableRateLimit(threshold: Int = 3) {
//        rateLimitEnabled = true
//        rateLimitThreshold = threshold
//    }
//    
//    func disableRateLimit() {
//        rateLimitEnabled = false
//        requestCount = 0
//    }
//    
//    func reset() {
//        shouldSucceedRegistration = true
//        mockError = nil
//        registrationDelay = 0.05
//        shouldSimulateNetworkIssues = false
//        rateLimitEnabled = false
//        requestCount = 0
//        registerUserCallCount = 0
//        lastRegisterRequest = nil
//        registrationAttempts = []
//    }
//    
//    // MARK: - AuthServiceProtocol Implementation
//    func registerUser(with userRequest: RegisterUserRequest, completion: @escaping (Bool, Error?) -> Void) {
//        registerUserCallCount += 1
//        lastRegisterRequest = userRequest
//        registrationAttempts.append(Date())
//        requestCount += 1
//        
//        // Rate limiting simulation
//        if rateLimitEnabled && requestCount > rateLimitThreshold {
//            let error = RegistrationError.rateLimitExceeded
//            if #available(iOS 13.0, *) {
//                registrationEventSubject.send(.rateLimitHit)
//            }
//            completion(false, error)
//            return
//        }
//        
//        let delay = shouldSimulateNetworkIssues ? TimeInterval.random(in: 0.5...2.0) : registrationDelay
//        
//        if #available(iOS 13.0, *) {
//            registrationEventSubject.send(.registrationStarted(userRequest))
//        }
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
//            if self.shouldSucceedRegistration {
//                if #available(iOS 13.0, *) {
//                    self.registrationEventSubject.send(.registrationSucceeded(userRequest))
//                }
//                completion(true, nil)
//            } else {
//                let error = self.mockError ?? RegistrationError.registrationFailed
//                if #available(iOS 13.0, *) {
//                    self.registrationEventSubject.send(.registrationFailed(userRequest, error))
//                }
//                completion(false, error)
//            }
//        }
//    }
//    
//    // MARK: - Other AuthServiceProtocol methods (stub implementations)
//    func signIn(with userRequest: LoginUserRequest, completion: @escaping (String?, Error?) -> Void) {
//        completion("test-uid", nil)
//    }
//    
//    func signOut(completion: @escaping (Error?) -> Void) {
//        completion(nil)
//    }
//    
//    func fetchUserData(uid: String, completion: @escaping (Result<AppUser, Error>) -> Void) {
//        completion(.success(AppUser.makeTestUser()))
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
///// Registration events for Combine testing
//enum RegistrationEvent: Equatable {
//    case registrationStarted(RegisterUserRequest)
//    case registrationSucceeded(RegisterUserRequest)
//    case registrationFailed(RegisterUserRequest, Error)
//    case rateLimitHit
//    
//    static func == (lhs: RegistrationEvent, rhs: RegistrationEvent) -> Bool {
//        switch (lhs, rhs) {
//        case (.registrationStarted(let l), .registrationStarted(let r)):
//            return l.email == r.email && l.username == r.username
//        case (.registrationSucceeded(let l), .registrationSucceeded(let r)):
//            return l.email == r.email && l.username == r.username
//        case (.registrationFailed(let l1, _), .registrationFailed(let r1, _)):
//            return l1.email == r1.email && l1.username == r1.username
//        case (.rateLimitHit, .rateLimitHit):
//            return true
//        default:
//            return false
//        }
//    }
//}
//
///// Registration-specific errors
//enum RegistrationError: Error, LocalizedError {
//    case registrationFailed
//    case emailAlreadyExists
//    case weakPassword
//    case invalidEmail
//    case rateLimitExceeded
//    case networkTimeout
//    case serverError
//    
//    var errorDescription: String? {
//        switch self {
//        case .registrationFailed: return "Registration failed"
//        case .emailAlreadyExists: return "Email already exists"
//        case .weakPassword: return "Password is too weak"
//        case .invalidEmail: return "Invalid email format"
//        case .rateLimitExceeded: return "Too many registration attempts"
//        case .networkTimeout: return "Network timeout"
//        case .serverError: return "Server error"
//        }
//    }
//}
//
///// Mock Delegate for capturing ViewModel callbacks
//final class MockRegisterViewModelDelegate: RegisterViewModelDelegate {
//    
//    // MARK: - Event Tracking
//    private(set) var didRegisterSuccessfullyCallCount = 0
//    private(set) var didFailWithErrorCallCount = 0
//    private(set) var didValidationFailCallCount = 0
//    
//    private(set) var lastError: Error?
//    private(set) var lastValidationResults: [ValidationResult] = []
//    
//    // MARK: - Expectations for async testing
//    var successExpectation: XCTestExpectation?
//    var errorExpectation: XCTestExpectation?
//    var validationFailExpectation: XCTestExpectation?
//    
//    // MARK: - Combine Support
//    @available(iOS 13.0, *)
//    private let delegateEventSubject = PassthroughSubject<DelegateEvent, Never>()
//    
//    @available(iOS 13.0, *)
//    var delegateEventPublisher: AnyPublisher<DelegateEvent, Never> {
//        delegateEventSubject.eraseToAnyPublisher()
//    }
//    
//    // MARK: - Reset Method
//    func reset() {
//        didRegisterSuccessfullyCallCount = 0
//        didFailWithErrorCallCount = 0
//        didValidationFailCallCount = 0
//        lastError = nil
//        lastValidationResults = []
//        successExpectation = nil
//        errorExpectation = nil
//        validationFailExpectation = nil
//    }
//    
//    // MARK: - RegisterViewModelDelegate Implementation
//    func didRegisterSuccessfully() {
//        didRegisterSuccessfullyCallCount += 1
//        successExpectation?.fulfill()
//        
//        if #available(iOS 13.0, *) {
//            delegateEventSubject.send(.registrationSuccess)
//        }
//    }
//    
//    func didFailWithError(_ error: Error) {
//        didFailWithErrorCallCount += 1
//        lastError = error
//        errorExpectation?.fulfill()
//        
//        if #available(iOS 13.0, *) {
//            delegateEventSubject.send(.registrationError(error))
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
//}
//
///// Delegate events for Combine testing
//enum DelegateEvent: Equatable {
//    case registrationSuccess
//    case registrationError(Error)
//    case validationFailed([ValidationResult])
//    
//    static func == (lhs: DelegateEvent, rhs: DelegateEvent) -> Bool {
//        switch (lhs, rhs) {
//        case (.registrationSuccess, .registrationSuccess): return true
//        case (.validationFailed(let l), .validationFailed(let r)): return l.count == r.count
//        default: return false
//        }
//    }
//}
//
//// MARK: - Main Test Suite
//
///// Comprehensive test suite for RegisterViewModel
//final class RegisterViewModelTests: XCTestCase {
//    
//    // MARK: - Properties
//    private var viewModel: RegisterViewModel!
//    private var mockValidator: MockValidator!
//    private var mockAuthService: MockRegisterAuthService!
//    private var mockDelegate: MockRegisterViewModelDelegate!
//    private var cancellables: Set<AnyCancellable> = []
//    private var testConfiguration: RegisterTestConfiguration = .standard
//    
//    private let logger = Logger(subsystem: "com.mathquizmastery.tests", category: "RegisterViewModelTests")
//    
//    // MARK: - Setup & Teardown
//    
//    override func setUpWithError() throws {
//        try super.setUpWithError()
//        
//        mockValidator = MockValidator()
//        mockAuthService = MockRegisterAuthService()
//        mockDelegate = MockRegisterViewModelDelegate()
//        
//        viewModel = RegisterViewModel(
//            validator: mockValidator,
//            authService: mockAuthService
//        )
//        viewModel.delegate = mockDelegate
//        
//        logger.info("🧪 Test setup completed")
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
//        logger.info("🧹 Test teardown completed")
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
//        let customValidator = MockValidator()
//        let customAuthService = MockRegisterAuthService()
//        
//        // When
//        let customViewModel = RegisterViewModel(
//            validator: customValidator,
//            authService: customAuthService
//        )
//        
//        // Then
//        XCTAssertNotNil(customViewModel, "Custom ViewModel should be initialized")
//        // Note: We can't directly test the private properties, but we can test behavior
//    }
//    
//    // MARK: - Validation Tests
//    
//    func test_ValidateInputs_WithValidData_ShouldTriggerRegistration() {
//        // Given
//        let expectation = XCTestExpectation(description: "Registration should succeed")
//        mockDelegate.successExpectation = expectation
//        
//        mockValidator.setShouldPassValidation(true)
//        mockAuthService.setShouldSucceedRegistration(true)
//        
//        // When
//        viewModel.validateInputs(
//            name: "TestUser",
//            email: "test@example.com",
//            password: "SecurePassword123",
//            confirmPassword: "SecurePassword123"
//        )
//        
//        // Then
//        wait(for: [expectation], timeout: testConfiguration.timeout)
//        
//        XCTAssertEqual(mockValidator.validateSignUpCallCount, 1, "Validator should be called once")
//        XCTAssertEqual(mockAuthService.registerUserCallCount, 1, "Auth service should be called once")
//        XCTAssertEqual(mockDelegate.didRegisterSuccessfullyCallCount, 1, "Success callback should be called")
//        XCTAssertEqual(mockDelegate.didFailWithErrorCallCount, 0, "Error callback should not be called")
//        XCTAssertEqual(mockDelegate.didValidationFailCallCount, 0, "Validation fail callback should not be called")
//    }
//    
//    func test_ValidateInputs_WithInvalidData_ShouldTriggerValidationFailure() {
//        // Given
//        let expectation = XCTestExpectation(description: "Validation should fail")
//        mockDelegate.validationFailExpectation = expectation
//        
//        let validationResults = [
//            ValidationResult(field: .email, message: "Invalid email format"),
//            ValidationResult(field: .password, message: "Password too weak")
//        ]
//        
//        mockValidator.setShouldPassValidation(false)
//        mockValidator.setCustomValidationResults(validationResults)
//        
//        // When
//        viewModel.validateInputs(
//            name: "TestUser",
//            email: "invalid-email",
//            password: "weak",
//            confirmPassword: "weak"
//        )
//        
//        // Then
//        wait(for: [expectation], timeout: testConfiguration.timeout)
//        
//        XCTAssertEqual(mockValidator.validateSignUpCallCount, 1, "Validator should be called once")
//        XCTAssertEqual(mockAuthService.registerUserCallCount, 0, "Auth service should not be called")
//        XCTAssertEqual(mockDelegate.didValidationFailCallCount, 1, "Validation fail callback should be called")
//        XCTAssertEqual(mockDelegate.lastValidationResults.count, 2, "Should have 2 validation errors")
//        XCTAssertEqual(mockDelegate.didRegisterSuccessfullyCallCount, 0, "Success callback should not be called")
//    }
//    
//    func test_ValidateInputs_WithEmptyFields_ShouldFailValidation() {
//        // Given
//        let expectation = XCTestExpectation(description: "Validation should fail for empty fields")
//        mockDelegate.validationFailExpectation = expectation
//        
//        mockValidator.setShouldPassValidation(false)
//        
//        // When
//        viewModel.validateInputs(
//            name: "",
//            email: "",
//            password: "",
//            confirmPassword: ""
//        )
//        
//        // Then
//        wait(for: [expectation], timeout: testConfiguration.timeout)
//        
//        XCTAssertEqual(mockValidator.validateSignUpCallCount, 1, "Validator should be called")
//        XCTAssertEqual(mockDelegate.didValidationFailCallCount, 1, "Validation should fail")
//        XCTAssertGreaterThan(mockDelegate.lastValidationResults.count, 0, "Should have validation errors")
//    }
//    
//    func test_ValidateInputs_WithMismatchedPasswords_ShouldFailValidation() {
//        // Given
//        let expectation = XCTestExpectation(description: "Password mismatch should fail validation")
//        mockDelegate.validationFailExpectation = expectation
//        
//        mockValidator.setShouldPassValidation(false)
//        
//        // When
//        viewModel.validateInputs(
//            name: "TestUser",
//            email: "test@example.com",
//            password: "Password123",
//            confirmPassword: "DifferentPassword123"
//        )
//        
//        // Then
//        wait(for: [expectation], timeout: testConfiguration.timeout)
//        
//        XCTAssertEqual(mockDelegate.didValidationFailCallCount, 1, "Validation should fail")
//        let hasPasswordMismatchError = mockDelegate.lastValidationResults.contains { result in
//            result.field == .confirmPassword && result.message.contains("match")
//        }
//        XCTAssertTrue(hasPasswordMismatchError, "Should have password mismatch error")
//    }
//    
//    // MARK: - Registration Tests
//    
//    func test_Registration_WhenSuccessful_ShouldCallSuccessDelegate() {
//        // Given
//        let expectation = XCTestExpectation(description: "Registration success")
//        mockDelegate.successExpectation = expectation
//        
//        mockValidator.setShouldPassValidation(true)
//        mockAuthService.setShouldSucceedRegistration(true)
//        
//        // When
//        viewModel.validateInputs(
//            name: "TestUser",
//            email: "test@example.com",
//            password: "SecurePassword123",
//            confirmPassword: "SecurePassword123"
//        )
//        
//        // Then
//        wait(for: [expectation], timeout: testConfiguration.timeout)
//        
//        XCTAssertEqual(mockDelegate.didRegisterSuccessfullyCallCount, 1, "Success delegate should be called")
//        XCTAssertNotNil(mockAuthService.lastRegisterRequest, "Should have registration request")
//        XCTAssertEqual(mockAuthService.lastRegisterRequest?.username, "TestUser", "Username should match")
//        XCTAssertEqual(mockAuthService.lastRegisterRequest?.email, "test@example.com", "Email should match")
//    }
//    
//    func test_Registration_WhenFailed_ShouldCallErrorDelegate() {
//        // Given
//        let expectation = XCTestExpectation(description: "Registration failure")
//        mockDelegate.errorExpectation = expectation
//        
//        let expectedError = RegistrationError.emailAlreadyExists
//        
//        mockValidator.setShouldPassValidation(true)
//        mockAuthService.setShouldSucceedRegistration(false)
//        mockAuthService.setMockError(expectedError)
//        
//        // When
//        viewModel.validateInputs(
//            name: "TestUser",
//            email: "existing@example.com",
//            password: "SecurePassword123",
//            confirmPassword: "SecurePassword123"
//        )
//        
//        // Then
//        wait(for: [expectation], timeout: testConfiguration.timeout)
//        
//        XCTAssertEqual(mockDelegate.didFailWithErrorCallCount, 1, "Error delegate should be called")
//        XCTAssertNotNil(mockDelegate.lastError, "Should have error")
//        XCTAssertEqual(mockDelegate.lastError as? RegistrationError, expectedError, "Error should match expected")
//    }
//    
//    // MARK: - Edge Cases Tests
//    
//    func test_ValidateInputs_WithNilValues_ShouldHandleGracefully() {
//        // Given
//        let expectation = XCTestExpectation(description: "Should handle nil values")
//        mockDelegate.validationFailExpectation = expectation
//        
//        mockValidator.setShouldPassValidation(false)
//        
//        // When
//        viewModel.validateInputs(
//            name: nil,
//            email: nil,
//            password: nil,
//            confirmPassword: nil
//        )
//        
//        // Then
//        wait(for: [expectation], timeout: testConfiguration.timeout)
//        
//        XCTAssertEqual(mockValidator.validateSignUpCallCount, 1, "Validator should be called")
//        XCTAssertNotNil(mockValidator.lastValidationParameters, "Validation parameters should be recorded")
//    }
//    
//    func test_ValidateInputs_WithSpecialCharacters_ShouldHandleCorrectly() {
//        // Given
//        let expectation = XCTestExpectation(description: "Special characters handling")
//        mockDelegate.successExpectation = expectation
//        
//        mockValidator.setShouldPassValidation(true)
//        mockAuthService.setShouldSucceedRegistration(true)
//        
//        // When
//        viewModel.validateInputs(
//            name: "Test User@123",
//            email: "test+user@example.com",
//            password: "P@ssw0rd!123",
//            confirmPassword: "P@ssw0rd!123"
//        )
//        
//        // Then
//        wait(for: [expectation], timeout: testConfiguration.timeout)
//        
//        XCTAssertEqual(mockDelegate.didRegisterSuccessfullyCallCount, 1, "Should handle special characters")
//        XCTAssertEqual(mockAuthService.lastRegisterRequest?.username, "Test User@123", "Username with special chars should be preserved")
//    }
//    
//    func test_ValidateInputs_WithUnicodeCharacters_ShouldHandleCorrectly() {
//        // Given
//        let expectation = XCTestExpectation(description: "Unicode characters handling")
//        mockDelegate.successExpectation = expectation
//        
//        mockValidator.setShouldPassValidation(true)
//        mockAuthService.setShouldSucceedRegistration(true)
//        
//        // When
//        viewModel.validateInputs(
//            name: "用户名",
//            email: "unicode@test.com",
//            password: "密码123",
//            confirmPassword: "密码123"
//        )
//        
//        // Then
//        wait(for: [expectation], timeout: testConfiguration.timeout)
//        
//        XCTAssertEqual(mockDelegate.didRegisterSuccessfullyCallCount, 1, "Should handle unicode characters")
//        XCTAssertEqual(mockAuthService.lastRegisterRequest?.username, "用户名", "Unicode username should be preserved")
//    }
//    
//    // MARK: - Performance Tests
//    
//    func test_ValidateInputs_Performance_ShouldCompleteQuickly() {
//        guard testConfiguration.enablePerformanceTesting else {
//            logger.info("⏭️ Performance testing disabled")
//            return
//        }
//        
//        // Given
//        mockValidator.setShouldPassValidation(true)
//        mockAuthService.setShouldSucceedRegistration(true)
//        mockAuthService.setRegistrationDelay(0.001) // Very fast
//        
//        // When/Then
//        measure {
//            let expectation = XCTestExpectation(description: "Performance test")
//            mockDelegate.successExpectation = expectation
//            
//            viewModel.validateInputs(
//                name: "PerfTestUser",
//                email: "perf@test.com",
//                password: "PerfPassword123",
//                confirmPassword: "PerfPassword123"
//            )
//            
//            wait(for: [expectation], timeout: 0.1)
//        }
//    }
//    
//    func test_MultipleConcurrentValidations_ShouldHandleCorrectly() {
//        guard testConfiguration.enableConcurrencyTesting else {
//            logger.info("⏭️ Concurrency testing disabled")
//            return
//        }
//        
//        // Given
//        let concurrentExpectation = XCTestExpectation(description: "Concurrent validations")
//        concurrentExpectation.expectedFulfillmentCount = 5
//        
//        mockValidator.setShouldPassValidation(true)
//        mockAuthService.setShouldSucceedRegistration(true)
//        
//        // When
//        for i in 0..<5 {
//            DispatchQueue.global().async {
//                let localExpectation = XCTestExpectation(description: "Concurrent validation \(i)")
//                
//                DispatchQueue.main.async {
//                    let mockDel = MockRegisterViewModelDelegate()
//                    mockDel.successExpectation = localExpectation
//                    
//                    let localViewModel = RegisterViewModel(
//                        validator: self.mockValidator,
//                        authService: self.mockAuthService
//                    )
//                    localViewModel.delegate = mockDel
//                    
//                    localViewModel.validateInputs(
//                        name: "ConcurrentUser\(i)",
//                        email: "concurrent\(i)@test.com",
//                        password: "ConcurrentPass\(i)",
//                        confirmPassword: "ConcurrentPass\(i)"
//                    )
//                }
//                
//                self.wait(for: [localExpectation], timeout: 2.0)
//                concurrentExpectation.fulfill()
//            }
//        }
//        
//        // Then
//        wait(for: [concurrentExpectation], timeout: 10.0)
//        XCTAssertGreaterThanOrEqual(mockAuthService.registerUserCallCount, 5, "All concurrent registrations should be processed")
//    }
//    
//    // MARK: - Network Simulation Tests
//    
//    func test_Registration_WithNetworkDelay_ShouldEventuallySucceed() {
//        guard testConfiguration.enableNetworkSimulation else {
//            logger.info("⏭️ Network simulation disabled")
//            return
//        }
//        
//        // Given
//        let expectation = XCTestExpectation(description: "Network delay registration")
//        mockDelegate.successExpectation = expectation
//        
//        mockValidator.setShouldPassValidation(true)
//        mockAuthService.setShouldSucceedRegistration(true)
//        mockAuthService.setSimulateNetworkIssues(true)
//        
//        // When
//        viewModel.validateInputs(
//            name: "NetworkTestUser",
//            email: "network@test.com",
//            password: "NetworkPass123",
//            confirmPassword: "NetworkPass123"
//        )
//        
//        // Then
//        wait(for: [expectation], timeout: 5.0) // Longer timeout for network simulation
//        
//        XCTAssertEqual(mockDelegate.didRegisterSuccessfullyCallCount, 1, "Should succeed despite network delay")
//    }
//    
//    func test_Registration_WithRateLimit_ShouldFailAfterThreshold() {
//        guard testConfiguration.enableNetworkSimulation else {
//            logger.info("⏭️ Network simulation disabled")
//            return
//        }
//        
//        // Given
//        mockValidator.setShouldPassValidation(true)
//        mockAuthService.setShouldSucceedRegistration(true)
//        mockAuthService.enableRateLimit(threshold: 2)
//        
//        var expectations: [XCTestExpectation] = []
//        
//        // When - Make multiple rapid requests
//        for i in 0..<4 {
//            let exp = XCTestExpectation(description: "Rate limit test \(i)")
//            expectations.append(exp)
//            
//            let localDelegate = MockRegisterViewModelDelegate()
//            if i < 2 {
//                localDelegate.successExpectation = exp
//            } else {
//                localDelegate.errorExpectation = exp
//            }
//            
//            let localViewModel = RegisterViewModel(
//                validator: mockValidator,
//                authService: mockAuthService
//            )
//            localViewModel.delegate = localDelegate
//            
//            localViewModel.validateInputs(
//                name: "RateLimitUser\(i)",
//                email: "ratelimit\(i)@test.com",
//                password: "RatePass\(i)",
//                confirmPassword: "RatePass\(i)"
//            )
//        }
//        
//        // Then
//        wait(for: expectations, timeout: testConfiguration.timeout)
//        XCTAssertGreaterThanOrEqual(mockAuthService.registerUserCallCount, 4, "All requests should be processed")
//    }
//    
//    // MARK: - Combine Integration Tests (iOS 13+)
//    
//    @available(iOS 13.0, *)
//    func test_Registration_WithCombinePublishers_ShouldEmitCorrectEvents() {
//        // Given
//        let registrationExpectation = XCTestExpectation(description: "Registration event emitted")
//        let delegateExpectation = XCTestExpectation(description: "Delegate event emitted")
//        
//        mockValidator.setShouldPassValidation(true)
//        mockAuthService.setShouldSucceedRegistration(true)
//        
//        // Subscribe to auth service events
//        mockAuthService.registrationEventPublisher
//            .sink { event in
//                if case .registrationSucceeded = event {
//                    registrationExpectation.fulfill()
//                }
//            }
//            .store(in: &cancellables)
//        
//        // Subscribe to delegate events
//        mockDelegate.delegateEventPublisher
//            .sink { event in
//                if case .registrationSuccess = event {
//                    delegateExpectation.fulfill()
//                }
//            }
//            .store(in: &cancellables)
//        
//        // When
//        viewModel.validateInputs(
//            name: "CombineTestUser",
//            email: "combine@test.com",
//            password: "CombinePass123",
//            confirmPassword: "CombinePass123"
//        )
//        
//        // Then
//        wait(for: [registrationExpectation, delegateExpectation], timeout: testConfiguration.timeout)
//    }
//    
//    @available(iOS 13.0, *)
//    func test_ValidationFailure_WithCombinePublishers_ShouldEmitValidationEvent() {
//        // Given
//        let validationExpectation = XCTestExpectation(description: "Validation failure event emitted")
//        
//        mockValidator.setShouldPassValidation(false)
//        
//        // Subscribe to delegate events
//        mockDelegate.delegateEventPublisher
//            .sink { event in
//                if case .validationFailed = event {
//                    validationExpectation.fulfill()
//                }
//            }
//            .store(in: &cancellables)
//        
//        // When
//        viewModel.validateInputs(
//            name: "",
//            email: "invalid-email",
//            password: "weak",
//            confirmPassword: "different"
//        )
//        
//        // Then
//        wait(for: [validationExpectation], timeout: testConfiguration.timeout)
//    }
//    
//    // MARK: - Memory Management Tests
//    
//    func test_ViewModelDeallocation_ShouldNotCauseCrash() {
//        // Given
//        weak var weakViewModel: RegisterViewModel?
//        var localDelegate: MockRegisterViewModelDelegate?
//        
//        autoreleasepool {
//            let tempValidator = MockValidator()
//            let tempAuthService = MockRegisterAuthService()
//            let tempViewModel = RegisterViewModel(
//                validator: tempValidator,
//                authService: tempAuthService
//            )
//            
//            localDelegate = MockRegisterViewModelDelegate()
//            tempViewModel.delegate = localDelegate
//            weakViewModel = tempViewModel
//            
//            // Trigger some operations
//            tempViewModel.validateInputs(
//                name: "MemoryTestUser",
//                email: "memory@test.com",
//                password: "MemoryPass123",
//                confirmPassword: "MemoryPass123"
//            )
//        }
//        
//        // When
//        localDelegate = nil
//        
//        // Then
//        XCTAssertNil(weakViewModel, "ViewModel should be deallocated")
//    }
//    
//    func test_DelegateDeallocation_ShouldNotCauseCrash() {
//        // Given
//        weak var weakDelegate: MockRegisterViewModelDelegate?
//        
//        autoreleasepool {
//            let tempDelegate = MockRegisterViewModelDelegate()
//            viewModel.delegate = tempDelegate
//            weakDelegate = tempDelegate
//            
//            viewModel.validateInputs(
//                name: "DelegateTestUser",
//                email: "delegate@test.com",
//                password: "DelegatePass123",
//                confirmPassword: "DelegatePass123"
//            )
//        }
//        
//        // When
//        viewModel.delegate = nil
//        
//        // Then
//        XCTAssertNil(weakDelegate, "Delegate should be deallocated")
//    }
//    
//    // MARK: - Integration Tests
//    
//    func test_CompleteRegistrationFlow_ShouldWorkEndToEnd() {
//        // Given
//        let expectation = XCTestExpectation(description: "Complete registration flow")
//        mockDelegate.successExpectation = expectation
//        
//        mockValidator.setShouldPassValidation(true)
//        mockAuthService.setShouldSucceedRegistration(true)
//        
//        let testData = RegisterUserRequest.makeTestRequest(
//            username: "IntegrationTestUser",
//            email: "integration@test.com",
//            password: "IntegrationPass123"
//        )
//        
//        // When
//        viewModel.validateInputs(
//            name: testData.username,
//            email: testData.email,
//            password: testData.password,
//            confirmPassword: testData.password
//        )
//        
//        // Then
//        wait(for: [expectation], timeout: testConfiguration.timeout)
//        
//        // Verify the complete flow
//        XCTAssertEqual(mockValidator.validateSignUpCallCount, 1, "Validation should be called")
//        XCTAssertEqual(mockAuthService.registerUserCallCount, 1, "Registration should be called")
//        XCTAssertEqual(mockDelegate.didRegisterSuccessfullyCallCount, 1, "Success should be called")
//        
//        // Verify data integrity
//        let registeredRequest = mockAuthService.lastRegisterRequest
//        XCTAssertEqual(registeredRequest?.username, testData.username, "Username should match")
//        XCTAssertEqual(registeredRequest?.email, testData.email, "Email should match")
//        XCTAssertEqual(registeredRequest?.password, testData.password, "Password should match")
//    }
//    
//    func test_RegistrationFlow_WithVariousInputScenarios_ShouldHandleCorrectly() {
//        // Test data scenarios
//        let testScenarios: [(name: String, email: String, password: String, confirmPassword: String, shouldSucceed: Bool, description: String)] = [
//            ("ValidUser", "valid@test.com", "ValidPass123", "ValidPass123", true, "Valid data should succeed"),
//            ("", "empty@test.com", "EmptyNamePass", "EmptyNamePass", false, "Empty name should fail"),
//            ("User", "invalid-email", "InvalidEmailPass", "InvalidEmailPass", false, "Invalid email should fail"),
//            ("User", "user@test.com", "weak", "weak", false, "Weak password should fail"),
//            ("User", "user@test.com", "StrongPass123", "DifferentPass123", false, "Mismatched passwords should fail"),
//            ("VeryLongUsernameThatExceedsReasonableLimits", "long@test.com", "LongPass123", "LongPass123", false, "Very long username should fail")
//        ]
//        
//        for (index, scenario) in testScenarios.enumerated() {
//            // Given
//            let expectation = XCTestExpectation(description: "Scenario \(index): \(scenario.description)")
//            
//            if scenario.shouldSucceed {
//                mockDelegate.successExpectation = expectation
//                mockValidator.setShouldPassValidation(true)
//            } else {
//                mockDelegate.validationFailExpectation = expectation
//                mockValidator.setShouldPassValidation(false)
//            }
//            
//            mockAuthService.setShouldSucceedRegistration(true)
//            
//            // When
//            viewModel.validateInputs(
//                name: scenario.name,
//                email: scenario.email,
//                password: scenario.password,
//                confirmPassword: scenario.confirmPassword
//            )
//            
//            // Then
//            wait(for: [expectation], timeout: testConfiguration.timeout)
//            
//            // Reset for next scenario
//            mockValidator.reset()
//            mockAuthService.reset()
//            mockDelegate.reset()
//        }
//    }
//    
//    // MARK: - Stress Tests
//    
//    func test_RapidSuccessiveValidations_ShouldHandleCorrectly() {
//        guard testConfiguration.enablePerformanceTesting else {
//            logger.info("⏭️ Performance testing disabled")
//            return
//        }
//        
//        // Given
//        let rapidExpectation = XCTestExpectation(description: "Rapid successive validations")
//        rapidExpectation.expectedFulfillmentCount = 10
//        
//        mockValidator.setShouldPassValidation(true)
//        mockAuthService.setShouldSucceedRegistration(true)
//        mockAuthService.setRegistrationDelay(0.001)
//        
//        // When
//        for i in 0..<10 {
//            DispatchQueue.main.asyncAfter(deadline: .now() + TimeInterval(i) * 0.01) {
//                let localDelegate = MockRegisterViewModelDelegate()
//                localDelegate.successExpectation = rapidExpectation
//                
//                let localViewModel = RegisterViewModel(
//                    validator: self.mockValidator,
//                    authService: self.mockAuthService
//                )
//                localViewModel.delegate = localDelegate
//                
//                localViewModel.validateInputs(
//                    name: "RapidUser\(i)",
//                    email: "rapid\(i)@test.com",
//                    password: "RapidPass\(i)",
//                    confirmPassword: "RapidPass\(i)"
//                )
//            }
//        }
//        
//        // Then
//        wait(for: [rapidExpectation], timeout: 5.0)
//        XCTAssertGreaterThanOrEqual(mockAuthService.registerUserCallCount, 10, "All rapid validations should be processed")
//    }
//    
//    // MARK: - Helper Methods
//    
//    private func createTestViewModel(
//        shouldPassValidation: Bool = true,
//        shouldSucceedRegistration: Bool = true
//    ) -> RegisterViewModel {
//        let validator = MockValidator()
//        let authService = MockRegisterAuthService()
//        
//        validator.setShouldPassValidation(shouldPassValidation)
//        authService.setShouldSucceedRegistration(shouldSucceedRegistration)
//        
//        return RegisterViewModel(validator: validator, authService: authService)
//    }
//    
//    private func createValidTestInputs() -> (name: String, email: String, password: String, confirmPassword: String) {
//        return (
//            name: "TestUser",
//            email: "test@example.com",
//            password: "SecurePassword123",
//            confirmPassword: "SecurePassword123"
//        )
//    }
//    
//    private func createInvalidTestInputs() -> (name: String, email: String, password: String, confirmPassword: String) {
//        return (
//            name: "",
//            email: "invalid-email",
//            password: "weak",
//            confirmPassword: "different"
//        )
//    }
//}
//
//// MARK: - Test Extensions and Utilities
//
//extension RegisterViewModelTests {
//    
//    /// Helper method to wait for async operations with custom timeout
//    func waitForAsyncOperation(
//        timeout: TimeInterval = 1.0,
//        description: String = "Async operation",
//        operation: @escaping () -> Void
//    ) {
//        let expectation = XCTestExpectation(description: description)
//        
//        DispatchQueue.main.async {
//            operation()
//            expectation.fulfill()
//        }
//        
//        wait(for: [expectation], timeout: timeout)
//    }
//    
//    /// Helper method to create and configure test scenarios
//    func runTestScenario(
//        name: String,
//        setup: () -> Void,
//        action: () -> Void,
//        verification: () -> Void
//    ) {
//        logger.info("🎬 Running test scenario: \(name)")
//        
//        setup()
//        action()
//        verification()
//        
//        logger.info("✅ Completed test scenario: \(name)")
//    }
//}
//
//// MARK: - Custom XCTest Assertions
//
//extension XCTestCase {
//    
//    /// Assert that a validation result contains a specific field error
//    func XCTAssertValidationError(
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
//            "Validation results should contain error for field \(field)" + (message != nil ? " with message containing '\(message!)'" : ""),
//            file: file,
//            line: line
//        )
//    }
//    
//    /// Assert that registration request matches expected values
//    func XCTAssertRegisterRequest(
//        _ request: RegisterUserRequest?,
//        matchesUsername username: String,
//        email: String,
//        password: String,
//        file: StaticString = #file,
//        line: UInt = #line
//    ) {
//        XCTAssertNotNil(request, "Register request should not be nil", file: file, line: line)
//        XCTAssertEqual(request?.username, username, "Username should match", file: file, line: line)
//        XCTAssertEqual(request?.email, email, "Email should match", file: file, line: line)
//        XCTAssertEqual(request?.password, password, "Password should match", file: file, line: line)
//    }
//}
//
//// MARK: - Performance Test Configuration
//
//extension RegisterViewModelTests {
//    
//    /// Configure test for performance testing
//    func configureForPerformanceTesting() {
//        testConfiguration = .performance
//        mockValidator.setValidationDelay(0.001)
//        mockAuthService.setRegistrationDelay(0.001)
//    }
//    
//    /// Configure test for comprehensive testing
//    func configureForComprehensiveTesting() {
//        testConfiguration = .comprehensive
//        mockValidator.setSimulateSlowValidation(false)
//        mockAuthService.setSimulateNetworkIssues(false)
//    }
//    
//    /// Configure test for network simulation
//    func configureForNetworkTesting() {
//        testConfiguration = .comprehensive
//        mockValidator.setSimulateSlowValidation(true)
//        mockAuthService.setSimulateNetworkIssues(true)
//    }
//}
//
//// MARK: - Test Data Generators
//
//extension RegisterUserRequest {
//    
//    /// Generate test requests for boundary testing
//    static func makeBoundaryTestRequests() -> [RegisterUserRequest] {
//        return [
//            // Minimum valid values
//            makeTestRequest(username: "ab", email: "a@b.co", password: "123456"),
//            
//            // Maximum reasonable values
//            makeTestRequest(
//                username: String(repeating: "a", count: 50),
//                email: "very.long.email.address.for.testing@example.com",
//                password: String(repeating: "P", count: 128) + "123"
//            ),
//            
//            // Special characters
//            makeTestRequest(username: "user@123", email: "user+tag@example.com", password: "P@ssw0rd!"),
//            
//            // Unicode characters
//            makeTestRequest(username: "用户", email: "用户@example.com", password: "密码123"),
//            
//            // Empty/nil simulation
//            makeTestRequest(username: "", email: "", password: ""),
//        ]
//    }
//    
//    /// Generate realistic test data
//    static func makeRealisticTestRequests(count: Int = 10) -> [RegisterUserRequest] {
//        let firstNames = ["John", "Jane", "Alice", "Bob", "Charlie", "Diana", "Eve", "Frank"]
//        let lastNames = ["Smith", "Johnson", "Williams", "Brown", "Jones", "Garcia", "Miller"]
//        let domains = ["gmail.com", "yahoo.com", "outlook.com", "example.com"]
//        
//        return (0..<count).map { index in
//            let firstName = firstNames[index % firstNames.count]
//            let lastName = lastNames[index % lastNames.count]
//            let domain = domains[index % domains.count]
//            
//            return makeTestRequest(
//                username: "\(firstName)\(lastName)\(index)",
//                email: "\(firstName.lowercased()).\(lastName.lowercased())\(index)@\(domain)",
//                password: "\(firstName)\(lastName)Pass\(index)!"
//            )
//        }
//    }
//}
