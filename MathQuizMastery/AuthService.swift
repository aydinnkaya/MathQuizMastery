//
//  AuthService.swift
//  MathQuizMastery
//
//  Created by Aydın KAYA on 27.04.2025.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore


protocol AuthServiceProtocol{
    func registerUser(with userRequest: RegisterUserRequest, completion: @escaping (Bool, Error?) -> Void)
    func signIn(with userRequest: LoginUserRequest, completion: @escaping (Error?) -> Void)
    func signOut(completion: @escaping (Error?) -> Void)
}

class AuthService : AuthServiceProtocol {
    
    public static let shared = AuthService()
    private init() {}
    let db = Firestore.firestore()
    
    /// A method to register the user
    /// - Parameters:
    ///   - userRequest: the users information (email, password, username)
    ///   - completion: A completion with two values
    ///   - Bool: wasRegistered - Determines if the user was registered and saved in the database correctly
    ///   - Error?: An optional error if firebase provides once
    public func registerUser(with userRequest: RegisterUserRequest, completion: @escaping (Bool, Error?) -> Void){
        let username = userRequest.username
        let email = userRequest.email
        let password = userRequest.password
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(false, error)
                return
            }
            
            guard let resultUser = authResult?.user else{
                completion(false, nil)
                return
            }
            
            //            guard let uid = authResult?.user.uid else {
            //                completion(false, nil)
            //                return
            //            }
            
            self.db.collection("users")
                .document(resultUser.uid)
                .setData([
                    "username": username,
                    "email": email
                ], completion: { error in
                    if let error = error {
                        completion(false, error)
                        return
                    }
                    completion(true, nil)
                })
        }
    }
    
    
    public func signIn(with userRequest: LoginUserRequest, completion: @escaping ((any Error)?) -> Void) {
        Auth.auth().signIn(withEmail: userRequest.email, password: userRequest.password){ result, error in
            if let error = error {
                completion(error)
                return
            }else {
                completion(nil)
            }
            
        }
    }
    
    
    public func signOut(completion: @escaping (Error?)-> Void ){
        do {
            try Auth.auth().signOut()
            completion(nil)
            
        }catch let error {
            completion(error)
        }
    }
    
}

