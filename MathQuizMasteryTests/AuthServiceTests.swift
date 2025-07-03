//
//  AuthServiceTests.swift
//  MathQuizMasteryTests
//
//  Created by AydınKaya on 2.07.2025.
//

import XCTest
import Combine
import FirebaseAuth
import FirebaseFirestore
import os.log
@testable import MathQuizMastery

// MARK: - Test Configuration

/// Configuration for test execution with different strategies
struct AuthTestConfiguration {
    let timeout: TimeInterval
    let enableLogging: Bool
    let enablePerformanceTesting: Bool
    let enableConcurrencyTesting: Bool
    let maxRetryAttempts: Int
    
    static let standard = AuthTestConfiguration(
        timeout: 1.0,
        enableLogging: false,
        enablePerformanceTesting: false,
        enableConcurrencyTesting: false,
        maxRetryAttempts: 3
    )
    
    static let performance = AuthTestConfiguration(
        timeout: 5.0,
        enableLogging: true,
        enablePerformanceTesting: true,
        enableConcurrencyTesting: true,
        maxRetryAttempts: 1
    )
    
    static let integration = AuthTestConfiguration(
        timeout: 10.0,
        enableLogging: true,
        enablePerformanceTesting: false,
        enableConcurrencyTesting: true,
        maxRetryAttempts: 5
    )
}

// MARK: - Enhanced Mock Dependencies

/// Enterprise-level mock implementation with Combine support
@available(iOS 13.0, *)
final class MockAuthService: AuthServiceProtocol {
    
    // MARK: - Publisher Support
    private let authEventSubject = PassthroughSubject<AuthEvent, Never>()
    private let performanceSubject = PassthroughSubject<AuthPerformanceMetric, Never>()
    
    var authEventPublisher: AnyPublisher<AuthEvent, Never> {
        authEventSubject.eraseToAnyPublisher()
    }
    
    var performancePublisher: AnyPublisher<AuthPerformanceMetric, Never> {
        performanceSubject.eraseToAnyPublisher()
    }
    
    // MARK: - Enhanced State Management
    struct AuthState {
        var shouldSucceedRegistration = true
        var shouldSucceedSignIn = true
        var shouldSucceedSignOut = true
        var shouldSucceedFetchUser = true
        var shouldSucceedUpdateCoin = true
        var shouldSucceedIncrementCoin = true
        var shouldSucceedUpdateAvatar = true
        var shouldSucceedFetchAvatar = true
        var shouldSucceedUpdateUsername = true
        
        var simulateNetworkDelay = false
        var networkDelayRange: ClosedRange<TimeInterval> = 0.01...0.05
        var shouldSimulateRateLimit = false
        var rateLimitThreshold = 5
        var shouldCorruptData = false
    }
    
    private var state = AuthState()
    private let stateQueue = DispatchQueue(label: "mock.auth.state", attributes: .concurrent)
    
    // MARK: - Enhanced Error Simulation
    enum MockError: Error, LocalizedError, CaseIterable {
        case registrationFailed
        case signInFailed
        case signOutFailed
        case fetchUserFailed
        case updateCoinFailed
        case incrementCoinFailed
        case updateAvatarFailed
        case fetchAvatarFailed
        case updateUsernameFailed
        case networkTimeout
        case rateLimitExceeded
        case dataCorruption
        case authTokenExpired
        case insufficientPermissions
        case serverMaintenance
        
        var errorDescription: String? {
            switch self {
            case .registrationFailed: return "Registration failed"
            case .signInFailed: return "Sign in failed"
            case .signOutFailed: return "Sign out failed"
            case .fetchUserFailed: return "Fetch user failed"
            case .updateCoinFailed: return "Update coin failed"
            case .incrementCoinFailed: return "Increment coin failed"
            case .updateAvatarFailed: return "Update avatar failed"
            case .fetchAvatarFailed: return "Fetch avatar failed"
            case .updateUsernameFailed: return "Update username failed"
            case .networkTimeout: return "Network timeout"
            case .rateLimitExceeded: return "Rate limit exceeded"
            case .dataCorruption: return "Data corruption detected"
            case .authTokenExpired: return "Authentication token expired"
            case .insufficientPermissions: return "Insufficient permissions"
            case .serverMaintenance: return "Server under maintenance"
            }
        }
        
        var errorCode: Int {
            switch self {
            case .registrationFailed: return 1001
            case .signInFailed: return 1002
            case .signOutFailed: return 1003
            case .fetchUserFailed: return 1004
            case .updateCoinFailed: return 1005
            case .incrementCoinFailed: return 1006
            case .updateAvatarFailed: return 1007
            case .fetchAvatarFailed: return 1008
            case .updateUsernameFailed: return 1009
            case .networkTimeout: return 2001
            case .rateLimitExceeded: return 2002
            case .dataCorruption: return 3001
            case .authTokenExpired: return 4001
            case .insufficientPermissions: return 4002
            case .serverMaintenance: return 5001
            }
        }
    }
    
    // MARK: - Mock Data Management
    private var mockError: Error?
    private var mockUser = AppUser.makeTestUser()
    private var mockUID: String? = "test-uid-123"
    private var mockAvatarImageName = "profile_icon_1"
    
    // MARK: - Call Tracking with Analytics
    private var callTracker = CallTracker()
    private var performanceTracker = AuthPerformanceTracker()
    
    // MARK: - Rate Limiting Simulation
    private var requestCounts: [String: Int] = [:]
    private let rateLimitQueue = DispatchQueue(label: "mock.auth.ratelimit")
    
    // MARK: - Public Interface for State Control
    
    func configure(with state: AuthState) {
        stateQueue.async(flags: .barrier) {
            self.state = state
        }
    }
    
    func setMockError(_ error: Error?) {
        mockError = error
    }
    
    func setMockUser(_ user: AppUser) {
        mockUser = user
    }
    
    func resetState() {
        stateQueue.async(flags: .barrier) {
            self.state = AuthState()
            self.callTracker.reset()
            self.performanceTracker.reset()
            self.requestCounts.removeAll()
        }
    }
    
    func getCallStatistics() -> CallStatistics {
        return callTracker.getStatistics()
    }
    
    func getPerformanceMetrics() -> [AuthPerformanceMetric] {
        return performanceTracker.getMetrics()
    }
    
    // MARK: - AuthServiceProtocol Implementation
    
    func registerUser(with userRequest: RegisterUserRequest, completion: @escaping (Bool, Error?) -> Void) {
        let operationId = performanceTracker.startOperation(.registration)
        callTracker.recordCall(.registerUser, parameters: ["username": userRequest.username, "email": userRequest.email])
        
        if checkRateLimit(for: "registration") {
            authEventSubject.send(.rateLimitTriggered(.registration))
            completion(false, MockError.rateLimitExceeded)
            performanceTracker.endOperation(operationId, success: false)
            return
        }
        
        let delay = getNetworkDelay()
        let shouldSucceed = getState(\.shouldSucceedRegistration)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [self] in
            authEventSubject.send(.operationStarted(.registration))
            
            if shouldSucceed {
                authEventSubject.send(.operationCompleted(.registration, success: true))
                completion(true, nil)
                performanceTracker.endOperation(operationId, success: true)
            } else {
                let error = self.mockError ?? MockError.registrationFailed
                authEventSubject.send(.operationCompleted(.registration, success: false))
                authEventSubject.send(.errorOccurred(.registration, error))
                completion(false, error)
                performanceTracker.endOperation(operationId, success: false)
            }
        }
    }
    
    func signIn(with userRequest: LoginUserRequest, completion: @escaping (String?, Error?) -> Void) {
        let operationId = performanceTracker.startOperation(.signIn)
        callTracker.recordCall(.signIn, parameters: ["email": userRequest.email])
        
        if checkRateLimit(for: "signIn") {
            authEventSubject.send(.rateLimitTriggered(.signIn))
            completion(nil, MockError.rateLimitExceeded)
            performanceTracker.endOperation(operationId, success: false)
            return
        }
        
        let delay = getNetworkDelay()
        let shouldSucceed = getState(\.shouldSucceedSignIn)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [self] in
            self.authEventSubject.send(.operationStarted(.signIn))
            
            if shouldSucceed {
                self.authEventSubject.send(.operationCompleted(.signIn, success: true))
                completion(self.mockUID, nil)
                performanceTracker.endOperation(operationId, success: true)
            } else {
                let error = self.mockError ?? MockError.signInFailed
                authEventSubject.send(.operationCompleted(.signIn, success: false))
                authEventSubject.send(.errorOccurred(.signIn, error))
                completion(nil, error)
                performanceTracker.endOperation(operationId, success: false)
            }
        }
    }
    
    func signOut(completion: @escaping (Error?) -> Void) {
        let operationId = performanceTracker.startOperation(.signOut)
        callTracker.recordCall(.signOut)
        
        let delay = getNetworkDelay()
        let shouldSucceed = getState(\.shouldSucceedSignOut)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [self] in
            authEventSubject.send(.operationStarted(.signOut))
            
            if shouldSucceed {
                authEventSubject.send(.operationCompleted(.signOut, success: true))
                completion(nil)
                performanceTracker.endOperation(operationId, success: true)
            } else {
                let error = self.mockError ?? MockError.signOutFailed
                authEventSubject.send(.operationCompleted(.signOut, success: false))
                authEventSubject.send(.errorOccurred(.signOut, error))
                completion(error)
                performanceTracker.endOperation(operationId, success: false)
            }
        }
    }
    
    func fetchUserData(uid: String, completion: @escaping (Result<AppUser, Error>) -> Void) {
        let operationId = performanceTracker.startOperation(.fetchUser)
        callTracker.recordCall(.fetchUserData, parameters: ["uid": uid])
        
        if checkRateLimit(for: "fetchUser") {
            authEventSubject.send(.rateLimitTriggered(.fetchUser))
            completion(.failure(MockError.rateLimitExceeded))
            performanceTracker.endOperation(operationId, success: false)
            return
        }
        
        let delay = getNetworkDelay()
        let shouldSucceed = getState(\.shouldSucceedFetchUser)
        let shouldCorrupt = getState(\.shouldCorruptData)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [self] in
            authEventSubject.send(.operationStarted(.fetchUser))
            
            if shouldCorrupt {
                let error = MockError.dataCorruption
                authEventSubject.send(.errorOccurred(.fetchUser, error))
                completion(.failure(error))
                performanceTracker.endOperation(operationId, success: false)
                return
            }
            
            if shouldSucceed {
                authEventSubject.send(.operationCompleted(.fetchUser, success: true))
                completion(.success(self.mockUser))
                performanceTracker.endOperation(operationId, success: true)
            } else {
                let error = self.mockError ?? MockError.fetchUserFailed
                authEventSubject.send(.operationCompleted(.fetchUser, success: false))
                authEventSubject.send(.errorOccurred(.fetchUser, error))
                completion(.failure(error))
                performanceTracker.endOperation(operationId, success: false)
            }
        }
    }
    
    func updateUserCoin(uid: String, by amount: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        let operationId = performanceTracker.startOperation(.updateCoin)
        callTracker.recordCall(.updateUserCoin, parameters: ["uid": uid, "amount": "\(amount)"])
        
        let delay = getNetworkDelay()
        let shouldSucceed = getState(\.shouldSucceedUpdateCoin)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [self] in
            authEventSubject.send(.operationStarted(.updateCoin))
            
            if shouldSucceed {
                authEventSubject.send(.operationCompleted(.updateCoin, success: true))
                completion(.success(()))
                performanceTracker.endOperation(operationId, success: true)
            } else {
                let error = self.mockError ?? MockError.updateCoinFailed
                authEventSubject.send(.operationCompleted(.updateCoin, success: false))
                authEventSubject.send(.errorOccurred(.updateCoin, error))
                completion(.failure(error))
                performanceTracker.endOperation(operationId, success: false)
            }
        }
    }
    
    func incrementUserCoin(uid: String, by amount: Int, completion: @escaping (Error?) -> Void) {
        let operationId = performanceTracker.startOperation(.incrementCoin)
        callTracker.recordCall(.incrementUserCoin, parameters: ["uid": uid, "amount": "\(amount)"])
        
        let delay = getNetworkDelay()
        let shouldSucceed = getState(\.shouldSucceedIncrementCoin)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [self] in
            authEventSubject.send(.operationStarted(.incrementCoin))
            
            if shouldSucceed {
                authEventSubject.send(.operationCompleted(.incrementCoin, success: true))
                completion(nil)
                performanceTracker.endOperation(operationId, success: true)
            } else {
                let error = self.mockError ?? MockError.incrementCoinFailed
                authEventSubject.send(.operationCompleted(.incrementCoin, success: false))
                authEventSubject.send(.errorOccurred(.incrementCoin, error))
                completion(error)
                performanceTracker.endOperation(operationId, success: false)
            }
        }
    }
    
    func updateUserAvatar(uid: String, avatarImageName: String, completion: @escaping (Error?) -> Void) {
        let operationId = performanceTracker.startOperation(.updateAvatar)
        callTracker.recordCall(.updateUserAvatar, parameters: ["uid": uid, "avatar": avatarImageName])
        
        let delay = getNetworkDelay()
        let shouldSucceed = getState(\.shouldSucceedUpdateAvatar)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [self] in
            authEventSubject.send(.operationStarted(.updateAvatar))
            
            if shouldSucceed {
                authEventSubject.send(.operationCompleted(.updateAvatar, success: true))
                completion(nil)
                performanceTracker.endOperation(operationId, success: true)
            } else {
                let error = self.mockError ?? MockError.updateAvatarFailed
                authEventSubject.send(.operationCompleted(.updateAvatar, success: false))
                authEventSubject.send(.errorOccurred(.updateAvatar, error))
                completion(error)
                performanceTracker.endOperation(operationId, success: false)
            }
        }
    }
    
    func fetchUserAvatar(uid: String, completion: @escaping (Result<String, Error>) -> Void) {
        let operationId = performanceTracker.startOperation(.fetchAvatar)
        callTracker.recordCall(.fetchUserAvatar, parameters: ["uid": uid])
        
        let delay = getNetworkDelay()
        let shouldSucceed = getState(\.shouldSucceedFetchAvatar)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [self] in
            authEventSubject.send(.operationStarted(.fetchAvatar))
            
            if shouldSucceed {
                authEventSubject.send(.operationCompleted(.fetchAvatar, success: true))
                completion(.success(self.mockAvatarImageName))
                performanceTracker.endOperation(operationId, success: true)
            } else {
                let error = self.mockError ?? MockError.fetchAvatarFailed
                authEventSubject.send(.operationCompleted(.fetchAvatar, success: false))
                authEventSubject.send(.errorOccurred(.fetchAvatar, error))
                completion(.failure(error))
                performanceTracker.endOperation(operationId, success: false)
            }
        }
    }
    
    func updateUsername(uid: String, username: String, completion: @escaping (Error?) -> Void) {
        let operationId = performanceTracker.startOperation(.updateUsername)
        callTracker.recordCall(.updateUsername, parameters: ["uid": uid, "username": username])
        
        // Validate username
        let trimmedUsername = username.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedUsername.isEmpty || trimmedUsername.count < 3 || trimmedUsername.count > 20 {
            let error = MockError.updateUsernameFailed
            authEventSubject.send(.errorOccurred(.updateUsername, error))
            completion(error)
            performanceTracker.endOperation(operationId, success: false)
            return
        }
        
        let delay = getNetworkDelay()
        let shouldSucceed = getState(\.shouldSucceedUpdateUsername)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [self] in
            authEventSubject.send(.operationStarted(.updateUsername))
            
            if shouldSucceed {
                authEventSubject.send(.operationCompleted(.updateUsername, success: true))
                completion(nil)
                performanceTracker.endOperation(operationId, success: true)
            } else {
                let error = self.mockError ?? MockError.updateUsernameFailed
                authEventSubject.send(.operationCompleted(.updateUsername, success: false))
                authEventSubject.send(.errorOccurred(.updateUsername, error))
                completion(error)
                performanceTracker.endOperation(operationId, success: false)
            }
        }
    }
    
    // MARK: - Private Helper Methods
    
    private func getState<T>(_ keyPath: KeyPath<AuthState, T>) -> T {
        return stateQueue.sync { state[keyPath: keyPath] }
    }
    
    private func getNetworkDelay() -> TimeInterval {
        guard getState(\.simulateNetworkDelay) else { return 0.01 }
        let range = getState(\.networkDelayRange)
        return TimeInterval.random(in: range)
    }
    
    private func checkRateLimit(for operation: String) -> Bool {
        guard getState(\.shouldSimulateRateLimit) else { return false }
        
        let threshold = getState(\.rateLimitThreshold)
        return rateLimitQueue.sync {
            let count = requestCounts[operation, default: 0] + 1
            requestCounts[operation] = count
            return count > threshold
        }
    }
}

// MARK: - Supporting Types for Enhanced Testing

/// Events emitted by the mock auth service
enum AuthEvent: Equatable {
    case operationStarted(AuthOperation)
    case operationCompleted(AuthOperation, success: Bool)
    case errorOccurred(AuthOperation, Error)
    case rateLimitTriggered(AuthOperation)
    case dataCorrupted(AuthOperation)
    
    static func == (lhs: AuthEvent, rhs: AuthEvent) -> Bool {
        switch (lhs, rhs) {
        case (.operationStarted(let l), .operationStarted(let r)): return l == r
        case (.operationCompleted(let l1, let l2), .operationCompleted(let r1, let r2)): return l1 == r1 && l2 == r2
        case (.rateLimitTriggered(let l), .rateLimitTriggered(let r)): return l == r
        case (.dataCorrupted(let l), .dataCorrupted(let r)): return l == r
        default: return false
        }
    }
}

/// Auth operations for tracking
enum AuthOperation: String, CaseIterable, Equatable {
    case registration, signIn, signOut, fetchUser, updateCoin, incrementCoin, updateAvatar, fetchAvatar, updateUsername
}

/// Performance metrics for auth operations
struct AuthPerformanceMetric: Equatable {
    let operation: AuthOperation
    let duration: TimeInterval
    let success: Bool
    let timestamp: Date
    let operationId: UUID
    
    init(operation: AuthOperation, duration: TimeInterval, success: Bool, operationId: UUID) {
        self.operation = operation
        self.duration = duration
        self.success = success
        self.operationId = operationId
        self.timestamp = Date()
    }
}

/// Call tracking for method invocations
final class CallTracker {
    private var calls: [CallRecord] = []
    private let queue = DispatchQueue(label: "call.tracker", attributes: .concurrent)
    
    struct CallRecord {
        let method: AuthMethod
        let parameters: [String: String]
        let timestamp: Date
        
        init(method: AuthMethod, parameters: [String: String] = [:]) {
            self.method = method
            self.parameters = parameters
            self.timestamp = Date()
        }
    }
    
    enum AuthMethod: String, CaseIterable {
        case registerUser, signIn, signOut, fetchUserData, updateUserCoin, incrementUserCoin, updateUserAvatar, fetchUserAvatar, updateUsername
    }
    
    func recordCall(_ method: AuthMethod, parameters: [String: String] = [:]) {
        queue.async(flags: .barrier) {
            self.calls.append(CallRecord(method: method, parameters: parameters))
        }
    }
    
    func getStatistics() -> CallStatistics {
        return queue.sync {
            CallStatistics(
                totalCalls: calls.count,
                callsByMethod: Dictionary(grouping: calls, by: \.method).mapValues { $0.count },
                firstCall: calls.first?.timestamp,
                lastCall: calls.last?.timestamp,
                averageTimeBetweenCalls: calculateAverageTimeBetweenCalls()
            )
        }
    }
    
    func reset() {
        queue.async(flags: .barrier) {
            self.calls.removeAll()
        }
    }
    
    private func calculateAverageTimeBetweenCalls() -> TimeInterval? {
        guard calls.count > 1 else { return nil }
        
        let intervals = zip(calls, calls.dropFirst()).map { current, next in
            next.timestamp.timeIntervalSince(current.timestamp)
        }
        
        return intervals.reduce(0, +) / Double(intervals.count)
    }
}

/// Statistics about method calls
struct CallStatistics {
    let totalCalls: Int
    let callsByMethod: [CallTracker.AuthMethod: Int]
    let firstCall: Date?
    let lastCall: Date?
    let averageTimeBetweenCalls: TimeInterval?
}

/// Performance tracking for auth operations
private final class AuthPerformanceTracker {
    private var activeOperations: [UUID: (operation: AuthOperation, startTime: Date)] = [:]
    private var completedMetrics: [AuthPerformanceMetric] = []
    private let queue = DispatchQueue(label: "performance.tracker", attributes: .concurrent)
    
    func startOperation(_ operation: AuthOperation) -> UUID {
        let operationId = UUID()
        queue.async(flags: .barrier) {
            self.activeOperations[operationId] = (operation, Date())
        }
        return operationId
    }
    
    func endOperation(_ operationId: UUID, success: Bool) {
        queue.async(flags: .barrier) {
            guard let (operation, startTime) = self.activeOperations.removeValue(forKey: operationId) else { return }
            
            let duration = Date().timeIntervalSince(startTime)
            let metric = AuthPerformanceMetric(
                operation: operation,
                duration: duration,
                success: success,
                operationId: operationId
            )
            
            self.completedMetrics.append(metric)
            
            // Keep only last 1000 metrics to prevent memory bloat
            if self.completedMetrics.count > 1000 {
                self.completedMetrics.removeFirst()
            }
        }
    }
    
    func getMetrics() -> [AuthPerformanceMetric] {
        return queue.sync { completedMetrics }
    }
    
    func reset() {
        queue.async(flags: .barrier) {
            self.activeOperations.removeAll()
            self.completedMetrics.removeAll()
        }
    }
}

// MARK: - Enhanced Test Data Builders with Combine

extension RegisterUserRequest {
    static func makeTestRequest(
        username: String = "testuser",
        email: String = "test@example.com",
        password: String = "testPassword123"
    ) -> RegisterUserRequest {
        return RegisterUserRequest(username: username, email: email, password: password)
    }
    
    static func makeTestRequests(count: Int) -> [RegisterUserRequest] {
        return (0..<count).map { index in
            makeTestRequest(
                username: "testuser\(index)",
                email: "test\(index)@example.com",
                password: "testPassword\(index)"
            )
        }
    }
    
    /// Create requests with various validation scenarios
    static func makeValidationTestRequests() -> [RegisterUserRequest] {
        return [
            // Valid requests
            makeTestRequest(username: "validuser", email: "valid@test.com", password: "ValidPass123"),
            makeTestRequest(username: "anotheruser", email: "another@test.com", password: "AnotherPass456"),
            
            // Edge cases
            makeTestRequest(username: "u", email: "short@test.com", password: "ShortPass1"), // Short username
            makeTestRequest(username: "verylongusernamethatexceedslimits", email: "long@test.com", password: "LongPass123"), // Long username
            makeTestRequest(username: "testuser", email: "invalid-email", password: "TestPass123"), // Invalid email
            makeTestRequest(username: "testuser", email: "test@valid.com", password: "weak"), // Weak password
        ]
    }
}

extension LoginUserRequest {
    static func makeTestRequest(
        email: String = "test@example.com",
        password: String = "testPassword123"
    ) -> LoginUserRequest {
        return LoginUserRequest(email: email, password: password)
    }
    
    static func makeTestRequests(count: Int) -> [LoginUserRequest] {
        return (0..<count).map { index in
            makeTestRequest(
                email: "test\(index)@example.com",
                password: "testPassword\(index)"
            )
        }
    }
    
    /// Create requests for different authentication scenarios
    static func makeAuthTestRequests() -> [LoginUserRequest] {
        return [
            // Valid credentials
            makeTestRequest(email: "valid@test.com", password: "ValidPassword123"),
            
            // Invalid scenarios
            makeTestRequest(email: "invalid@test.com", password: "WrongPassword"),
            makeTestRequest(email: "nonexistent@test.com", password: "AnyPassword"),
            makeTestRequest(email: "", password: "EmptyEmailPassword"),
            makeTestRequest(email: "test@valid.com", password: ""),
        ]
    }
}

extension AppUser {
    static func makeTestUser(
        uid: String = "test-uid-123",
        username: String = "TestUser",
        email: String = "test@example.com",
        coin: Int = 100,
        avatarImageName: String = "profile_icon_1"
    ) -> AppUser {
        return AppUser(uid: uid, username: username, email: email, coin: coin, avatarImageName: avatarImageName)
    }
    
    static func makeTestUsers(count: Int) -> [AppUser] {
        return (0..<count).map { index in
            makeTestUser(
                uid: "test-uid-\(index)",
                username: "TestUser\(index)",
                email: "test\(index)@example.com",
                coin: index * 10,
                avatarImageName: "profile_icon_\((index % 5) + 1)"
            )
        }
    }
    
    /// Create users with various data scenarios for testing
    static func makeVariedTestUsers() -> [AppUser] {
        return [
            // Standard users
            makeTestUser(uid: "standard-1", username: "StandardUser1", coin: 100),
            makeTestUser(uid: "standard-2", username: "StandardUser2", coin: 250),
            
            // Edge cases
            makeTestUser(uid: "new-user", username: "NewUser", coin: 0), // New user with no coins
            makeTestUser(uid: "rich-user", username: "RichUser", coin: 99999), // User with many coins
            makeTestUser(uid: "premium-user", username: "PremiumUser", coin: 1000, avatarImageName: "premium_avatar"),
            
            // Special characters in data
            makeTestUser(uid: "special-user", username: "User@123", email: "special+user@test.com"),
            makeTestUser(uid: "unicode-user", username: "用户", email: "unicode@test.com"),
        ]
    }
}

////
////  AuthServiceTests.swift
////  MathQuizMasteryTests
////
////  Created by AydınKaya on 2.07.2025.
////
//
//import XCTest
//import FirebaseAuth
//import FirebaseFirestore
//@testable import MathQuizMastery
//
//// MARK: - Mock Dependencies
//
///// Mock implementation of Firebase Auth for testing purposes
//class MockFirebaseAuth: AuthServiceProtocol {
//
//    // MARK: - Test State Properties
//    var shouldSucceedRegistration = true
//    var shouldSucceedSignIn = true
//    var shouldSucceedSignOut = true
//    var shouldSucceedFetchUser = true
//    var shouldSucceedUpdateCoin = true
//    var shouldSucceedIncrementCoin = true
//    var shouldSucceedUpdateAvatar = true
//    var shouldSucceedFetchAvatar = true
//    var shouldSucceedUpdateUsername = true
//
//    var mockError: Error?
//    typealias AppUser = MathQuizMastery.AppUser
//    var mockUser: MathQuizMastery.AppUser = AppUser.makeTestUser()
//    var mockUID: String? = "test-uid-123"
//    var mockAvatarImageName: String = "profile_icon_1"
//    var mockCurrentUser: MockFirebaseAuthUser?
//
//    // MARK: - Captured Method Calls
//    var registerUserCallCount = 0
//    var signInCallCount = 0
//    var signOutCallCount = 0
//    var fetchUserDataCallCount = 0
//    var updateUserCoinCallCount = 0
//    var incrementUserCoinCallCount = 0
//    var updateUserAvatarCallCount = 0
//    var fetchUserAvatarCallCount = 0
//    var updateUsernameCallCount = 0
//
//    // MARK: - Captured Parameters
//    var capturedRegisterRequest: RegisterUserRequest?
//    var capturedLoginRequest: LoginUserRequest?
//    var capturedUID: String?
//    var capturedCoinAmount: Int?
//    var capturedAvatarImageName: String?
//    var capturedUsername: String?
//
//    // MARK: - AuthServiceProtocol Implementation
//    func registerUser(with userRequest: RegisterUserRequest, completion: @escaping (Bool, Error?) -> Void) {
//        registerUserCallCount += 1
//        capturedRegisterRequest = userRequest
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
//            if self.shouldSucceedRegistration {
//                completion(true, nil)
//            } else {
//                completion(false, self.mockError ?? AuthTestError.registrationFailed)
//            }
//        }
//    }
//
//    func signIn(with userRequest: LoginUserRequest, completion: @escaping (String?, Error?) -> Void) {
//        signInCallCount += 1
//        capturedLoginRequest = userRequest
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
//            if self.shouldSucceedSignIn {
//                completion(self.mockUID, nil)
//            } else {
//                completion(nil, self.mockError ?? AuthTestError.signInFailed)
//            }
//        }
//    }
//
//    func signOut(completion: @escaping (Error?) -> Void) {
//        signOutCallCount += 1
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
//            if self.shouldSucceedSignOut {
//                completion(nil)
//            } else {
//                completion(self.mockError ?? AuthTestError.signOutFailed)
//            }
//        }
//    }
//
//    func fetchUserData(uid: String, completion: @escaping (Result<AppUser, Error>) -> Void) {
//        fetchUserDataCallCount += 1
//        capturedUID = uid
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
//            if self.shouldSucceedFetchUser {
//                completion(.success(self.mockUser))
//            } else {
//                completion(.failure(self.mockError ?? AuthTestError.fetchUserFailed))
//            }
//        }
//    }
//
//    func updateUserCoin(uid: String, by amount: Int, completion: @escaping (Result<Void, Error>) -> Void) {
//        updateUserCoinCallCount += 1
//        capturedUID = uid
//        capturedCoinAmount = amount
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
//            if self.shouldSucceedUpdateCoin {
//                completion(.success(()))
//            } else {
//                completion(.failure(self.mockError ?? AuthTestError.updateCoinFailed))
//            }
//        }
//    }
//
//    func incrementUserCoin(uid: String, by amount: Int, completion: @escaping (Error?) -> Void) {
//        incrementUserCoinCallCount += 1
//        capturedUID = uid
//        capturedCoinAmount = amount
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
//            if self.shouldSucceedIncrementCoin {
//                completion(nil)
//            } else {
//                completion(self.mockError ?? AuthTestError.incrementCoinFailed)
//            }
//        }
//    }
//
//    func updateUserAvatar(uid: String, avatarImageName: String, completion: @escaping (Error?) -> Void) {
//        updateUserAvatarCallCount += 1
//        capturedUID = uid
//        capturedAvatarImageName = avatarImageName
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
//            if self.shouldSucceedUpdateAvatar {
//                completion(nil)
//            } else {
//                completion(self.mockError ?? AuthTestError.updateAvatarFailed)
//            }
//        }
//    }
//
//    func fetchUserAvatar(uid: String, completion: @escaping (Result<String, Error>) -> Void) {
//        fetchUserAvatarCallCount += 1
//        capturedUID = uid
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
//            if self.shouldSucceedFetchAvatar {
//                completion(.success(self.mockAvatarImageName))
//            } else {
//                completion(.failure(self.mockError ?? AuthTestError.fetchAvatarFailed))
//            }
//        }
//    }
//
//    func updateUsername(uid: String, username: String, completion: @escaping (Error?) -> Void) {
//        updateUsernameCallCount += 1
//        capturedUID = uid
//        capturedUsername = username
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
//            if self.shouldSucceedUpdateUsername {
//                completion(nil)
//            } else {
//                completion(self.mockError ?? AuthTestError.updateUsernameFailed)
//            }
//        }
//    }
//}
//
//// MARK: - Mock Firebase Auth User
//
//class MockFirebaseAuthUser: NSObject {
//    var uid: String
//
//    init(uid: String) {
//        self.uid = uid
//        super.init()
//    }
//}
//
//// MARK: - Test Errors
//
//enum AuthTestError: Error, LocalizedError {
//    case registrationFailed
//    case signInFailed
//    case signOutFailed
//    case fetchUserFailed
//    case updateCoinFailed
//    case incrementCoinFailed
//    case updateAvatarFailed
//    case fetchAvatarFailed
//    case updateUsernameFailed
//
//    var errorDescription: String? {
//        switch self {
//        case .registrationFailed:
//            return "Registration failed"
//        case .signInFailed:
//            return "Sign in failed"
//        case .signOutFailed:
//            return "Sign out failed"
//        case .fetchUserFailed:
//            return "Fetch user failed"
//        case .updateCoinFailed:
//            return "Update coin failed"
//        case .incrementCoinFailed:
//            return "Increment coin failed"
//        case .updateAvatarFailed:
//            return "Update avatar failed"
//        case .fetchAvatarFailed:
//            return "Fetch avatar failed"
//        case .updateUsernameFailed:
//            return "Update username failed"
//        }
//    }
//}
//
//// MARK: - Test Data Builders
//
//extension RegisterUserRequest {
//    static func makeTestRequest(
//        username: String = "testuser",
//        email: String = "test@example.com",
//        password: String = "testPassword123"
//    ) -> RegisterUserRequest {
//        return RegisterUserRequest(username: username, email: email, password: password)
//    }
//
//    static func makeTestRequests(count: Int) -> [RegisterUserRequest] {
//        return (0..<count).map { index in
//            makeTestRequest(
//                username: "testuser\(index)",
//                email: "test\(index)@example.com",
//                password: "testPassword\(index)"
//            )
//        }
//    }
//}
//
//extension LoginUserRequest {
//    static func makeTestRequest(
//        email: String = "test@example.com",
//        password: String = "testPassword123"
//    ) -> LoginUserRequest {
//        return LoginUserRequest(email: email, password: password)
//    }
//
//    static func makeTestRequests(count: Int) -> [LoginUserRequest] {
//        return (0..<count).map { index in
//            makeTestRequest(
//                email: "test\(index)@example.com",
//                password: "testPassword\(index)"
//            )
//        }
//    }
//}
//
//extension AppUser {
//    static func makeTestUser(
//        uid: String = "test-uid-123",
//        username: String = "TestUser",
//        email: String = "test@example.com",
//        coin: Int = 100,
//        avatarImageName: String = "profile_icon_1"
//    ) -> AppUser {
//        return AppUser(uid: uid, username: username, email: email, coin: coin, avatarImageName: avatarImageName)
//    }
//
//    static func makeTestUsers(count: Int) -> [AppUser] {
//        return (0..<count).map { index in
//            makeTestUser(
//                uid: "test-uid-\(index)",
//                username: "TestUser\(index)",
//                email: "test\(index)@example.com",
//                coin: index * 10
//            )
//        }
//    }
//}
