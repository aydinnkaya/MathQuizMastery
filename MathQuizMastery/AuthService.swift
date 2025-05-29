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
    func signIn(with userRequest: LoginUserRequest, completion: @escaping (String?, Error?) -> Void)
    func signOut(completion: @escaping (Error?) -> Void)
    func fetchUserData(uid: String, completion: @escaping (Result<User,Error>)-> Void)
    func updateUserCoin(uid: String, by amount: Int, completion: @escaping (Result<Void, Error>) -> Void)
    func incrementUserCoin(uid: String, by amount: Int, completion: @escaping (Error?) -> Void)
}

class AuthService : AuthServiceProtocol {
    
    public static let shared = AuthService()
    private init() {}
    let db = Firestore.firestore()
    
    /// A method to register the user
    /// - Parameters:
    ///   - userRequest: the users information (email, password, username)
    ///   - completion: A completion with two values(- Bool: wasRegistered - Determines if the user was registered and saved in the database correctly, Error?: An optional error if firebase provides once)
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
            
            self.db.collection("users")
                .document(resultUser.uid)
                .setData([
                    "username": username,
                    "email": email,
                    "coin": 0
                ], completion: { error in
                    if let error = error {
                        completion(false, error)
                        return
                    }
                    completion(true, nil)
                })
        }
    }
    
    /// A method signIn the user
    /// - Parameters:
    ///   - userRequest: the users information (email, password)
    ///   - completion: A completion with two values(String?:  uid information ,Error?: An optional error if firebase provides once)
    ///   - String?:  uid information
    ///   - Error?: An optional error if firebase provides once
    public func signIn(with userRequest: LoginUserRequest, completion: @escaping (String?, Error?) -> Void) {
        Auth.auth().signIn(withEmail: userRequest.email, password: userRequest.password) { result, error in
            if let error = error {
                completion(nil, error)
                return
            }
            if let user = result?.user {
                completion(user.uid, nil)
            } else {
                completion(nil, nil)
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
    
    
    /// Belirtilen UID'ye sahip kullanıcının bilgilerini Firestore'dan çeker.
    ///
    /// - Parameters:
    ///   - uid: Kullanıcının benzersiz kimliği (UID).
    ///   - completion: İşlem başarılıysa `User` modeli, aksi takdirde hata döner.
    public func fetchUserData(uid: String, completion: @escaping (Result<User,Error>)-> Void) {
        db.collection("users").document(uid).getDocument(){ snapshot,error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = snapshot?.data(),
                  let username = data["username"] as? String,
                  let email = data["email"] as? String,
                  let coin = data["coin"] as? Int else {
                let error = NSError(domain: "", code: -1, userInfo:[NSLocalizedDescriptionKey: "Kullanıcı verisi eksik."])
                completion(.failure(error))
                return
            }
            
            let user = User(uid: uid, username: username, email: email, coin: coin)
            completion(.success(user))
        }
    }
    
    /// Kullanıcının coin bilgisini manuel olarak belirli bir değere günceller.
    ///
    /// - Parameters:
    ///   - uid: Güncellenecek kullanıcının UID’si.
    ///   - newCoin: Yeni coin değeri.
    ///   - completion: İşlem tamamlandığında hata varsa `error`, yoksa `nil` döner.
    func updateUserCoin(uid: String, by amount: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        let userRef = db.collection("users").document(uid)

        userRef.getDocument { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = snapshot?.data(),
                  let currentCoin = data["coin"] as? Int else {
                let dataError = NSError(domain: "Firestore", code: -1, userInfo: [NSLocalizedDescriptionKey: "Geçersiz kullanıcı verisi"])
                completion(.failure(dataError))
                return
            }

            let updatedCoin = currentCoin + amount
            userRef.updateData(["coin": updatedCoin]) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        }
    }

    
    /// Kullanıcının coin bilgisini belirtilen miktar kadar artırır.
    ///
    /// - Parameters:
    ///   - uid: Coin’i artırılacak kullanıcının UID’si.
    ///   - amount: Coin’e eklenecek değer.
    ///   - completion: İşlem tamamlandığında hata varsa `error`, yoksa `nil` döner.
    func incrementUserCoin(uid: String, by amount: Int, completion: @escaping ((any Error)?) -> Void) {
        db.collection("users").document(uid).updateData([
            "coin": FieldValue.increment(Int64(amount))
        ]) { error in
            completion(error)
        }
    }
    
}
