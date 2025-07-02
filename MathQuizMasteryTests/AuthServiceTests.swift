//
//  AuthServiceTests.swift
//  MathQuizMasteryTests
//
//  Created by AydınKaya on 2.07.2025.
//

import XCTest
import FirebaseAuth
import FirebaseFirestore
@testable import MathQuizMastery

// MARK: - Mock Dependencies

/// Mock implementation of Firebase Auth for testing purposes
class MockFirebaseAuth: AuthServiceProtocol {
    
    // MARK: - Test State Properties
    var shouldSucceedRegistration = true
    var shouldSucceedSignIn = true
    var shouldSucceedSignOut = true
    var shouldSucceedFetchUser = true
    var shouldSucceedUpdateCoin = true
    var shouldSucceedIncrementCoin = true
    var shouldSucceedUpdateAvatar = true
    var shouldSucceedFetchAvatar = true
    var shouldSucceedUpdateUsername = true
    
    var mockError: Error?
    typealias AppUser = MathQuizMastery.AppUser
    var mockUser: MathQuizMastery.AppUser = AppUser.makeTestUser()
    var mockUID: String? = "test-uid-123"
    var mockAvatarImageName: String = "profile_icon_1"
    var mockCurrentUser: MockFirebaseAuthUser?
    
    // MARK: - Captured Method Calls
    var registerUserCallCount = 0
    var signInCallCount = 0
    var signOutCallCount = 0
    var fetchUserDataCallCount = 0
    var updateUserCoinCallCount = 0
    var incrementUserCoinCallCount = 0
    var updateUserAvatarCallCount = 0
    var fetchUserAvatarCallCount = 0
    var updateUsernameCallCount = 0
    
    // MARK: - Captured Parameters
    var capturedRegisterRequest: RegisterUserRequest?
    var capturedLoginRequest: LoginUserRequest?
    var capturedUID: String?
    var capturedCoinAmount: Int?
    var capturedAvatarImageName: String?
    var capturedUsername: String?
    
    // MARK: - AuthServiceProtocol Implementation
    func registerUser(with userRequest: RegisterUserRequest, completion: @escaping (Bool, Error?) -> Void) {
        registerUserCallCount += 1
        capturedRegisterRequest = userRequest
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            if self.shouldSucceedRegistration {
                completion(true, nil)
            } else {
                completion(false, self.mockError ?? AuthTestError.registrationFailed)
            }
        }
    }
    
    func signIn(with userRequest: LoginUserRequest, completion: @escaping (String?, Error?) -> Void) {
        signInCallCount += 1
        capturedLoginRequest = userRequest
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            if self.shouldSucceedSignIn {
                completion(self.mockUID, nil)
            } else {
                completion(nil, self.mockError ?? AuthTestError.signInFailed)
            }
        }
    }
    
    func signOut(completion: @escaping (Error?) -> Void) {
        signOutCallCount += 1
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            if self.shouldSucceedSignOut {
                completion(nil)
            } else {
                completion(self.mockError ?? AuthTestError.signOutFailed)
            }
        }
    }
    
    func fetchUserData(uid: String, completion: @escaping (Result<AppUser, Error>) -> Void) {
        fetchUserDataCallCount += 1
        capturedUID = uid
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            if self.shouldSucceedFetchUser {
                completion(.success(self.mockUser))
            } else {
                completion(.failure(self.mockError ?? AuthTestError.fetchUserFailed))
            }
        }
    }
    
    func updateUserCoin(uid: String, by amount: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        updateUserCoinCallCount += 1
        capturedUID = uid
        capturedCoinAmount = amount
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            if self.shouldSucceedUpdateCoin {
                completion(.success(()))
            } else {
                completion(.failure(self.mockError ?? AuthTestError.updateCoinFailed))
            }
        }
    }
    
    func incrementUserCoin(uid: String, by amount: Int, completion: @escaping (Error?) -> Void) {
        incrementUserCoinCallCount += 1
        capturedUID = uid
        capturedCoinAmount = amount
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            if self.shouldSucceedIncrementCoin {
                completion(nil)
            } else {
                completion(self.mockError ?? AuthTestError.incrementCoinFailed)
            }
        }
    }
    
    func updateUserAvatar(uid: String, avatarImageName: String, completion: @escaping (Error?) -> Void) {
        updateUserAvatarCallCount += 1
        capturedUID = uid
        capturedAvatarImageName = avatarImageName
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            if self.shouldSucceedUpdateAvatar {
                completion(nil)
            } else {
                completion(self.mockError ?? AuthTestError.updateAvatarFailed)
            }
        }
    }
    
    func fetchUserAvatar(uid: String, completion: @escaping (Result<String, Error>) -> Void) {
        fetchUserAvatarCallCount += 1
        capturedUID = uid
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            if self.shouldSucceedFetchAvatar {
                completion(.success(self.mockAvatarImageName))
            } else {
                completion(.failure(self.mockError ?? AuthTestError.fetchAvatarFailed))
            }
        }
    }
    
    func updateUsername(uid: String, username: String, completion: @escaping (Error?) -> Void) {
        updateUsernameCallCount += 1
        capturedUID = uid
        capturedUsername = username
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            if self.shouldSucceedUpdateUsername {
                completion(nil)
            } else {
                completion(self.mockError ?? AuthTestError.updateUsernameFailed)
            }
        }
    }
}

// MARK: - Mock Firebase Auth User

class MockFirebaseAuthUser: NSObject {
    var uid: String
    
    init(uid: String) {
        self.uid = uid
        super.init()
    }
}

// MARK: - Test Errors

enum AuthTestError: Error, LocalizedError {
    case registrationFailed
    case signInFailed
    case signOutFailed
    case fetchUserFailed
    case updateCoinFailed
    case incrementCoinFailed
    case updateAvatarFailed
    case fetchAvatarFailed
    case updateUsernameFailed
    
    var errorDescription: String? {
        switch self {
        case .registrationFailed:
            return "Registration failed"
        case .signInFailed:
            return "Sign in failed"
        case .signOutFailed:
            return "Sign out failed"
        case .fetchUserFailed:
            return "Fetch user failed"
        case .updateCoinFailed:
            return "Update coin failed"
        case .incrementCoinFailed:
            return "Increment coin failed"
        case .updateAvatarFailed:
            return "Update avatar failed"
        case .fetchAvatarFailed:
            return "Fetch avatar failed"
        case .updateUsernameFailed:
            return "Update username failed"
        }
    }
}

// MARK: - Test Data Builders

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
                coin: index * 10
            )
        }
    }
}
