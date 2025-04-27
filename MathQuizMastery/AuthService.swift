//
//  AuthService.swift
//  MathQuizMastery
//
//  Created by Aydın KAYA on 27.04.2025.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class AuthService {
    
    public static let shared = AuthService()
    private init() {}
    
    
    /// A method to register the user
    /// - Parameters:
    ///   - userRequest: the users information (email, password, username)
    ///   - completion: A completion with two values
    ///   - Bool: wasRegistered - Determines if the user was registered and saved in the database correctly
    ///   - Error?: An optional error if firebase provides once
    public func registerUser(with userRequest: RegiserUserRequest, completion: @escaping (Bool, Error?) -> Void){
        let username = userRequest.username
        let email = userRequest.email
        let password = userRequest.password
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(false, error)
                return
            }
            
            guard let uid = authResult?.user.uid else {
                completion(false, nil)
                return
            }   
        }
    }
    
}

