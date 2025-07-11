//
//  AuthService.swift
//  MathQuizMastery
//
//  Created by Aydın KAYA on 27.04.2025.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

protocol AuthServiceProtocol {
    func registerUser(with userRequest: RegisterUserRequest, completion: @escaping (Bool, Error?) -> Void)
    func signIn(with userRequest: LoginUserRequest, completion: @escaping (String?, Error?) -> Void)
    func signOut(completion: @escaping (Error?) -> Void)
    func fetchUserData(uid: String, completion: @escaping (Result<AppUser, Error>) -> Void)
    func updateUserCoin(uid: String, by amount: Int, completion: @escaping (Result<Void, Error>) -> Void)
    func incrementUserCoin(uid: String, by amount: Int, completion: @escaping (Error?) -> Void)
    func updateUserAvatar(uid: String, avatarImageName: String, completion: @escaping (Error?) -> Void)
    func fetchUserAvatar(uid: String, completion: @escaping (Result<String, Error>) -> Void)
    func updateUsername(uid: String, username: String, completion: @escaping (Error?) -> Void)
}

class AuthService: AuthServiceProtocol {
    
    public static let shared = AuthService()
    private init() {}
    let db = Firestore.firestore()
    
    /// A method to register the user
    /// - Parameters:
    ///   - userRequest: the users information (email, password, username)
    ///   - completion: A completion with two values(- Bool: wasRegistered - Determines if the user was registered and saved in the database correctly, Error?: An optional error if firebase provides once)
    ///   - Bool: wasRegistered - Determines if the user was registered and saved in the database correctly
    ///   - Error?: An optional error if firebase provides once
    public func registerUser(with userRequest: RegisterUserRequest, completion: @escaping (Bool, Error?) -> Void) {
        let username = userRequest.username
        let email = userRequest.email
        let password = userRequest.password
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(false, error)
                return
            }
            
            guard let resultUser = authResult?.user else {
                completion(false, nil)
                return
            }
            
            let defaultAvatarImageName = "profile_image_19"
            
            self.db.collection("users")
                .document(resultUser.uid)
                .setData([
                    "username": username,
                    "email": email,
                    "coin": 0,
                    "avatarImageName": defaultAvatarImageName
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
    
    public func signOut(completion: @escaping (Error?) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(nil)
        } catch let error {
            completion(error)
        }
    }
    
    /// Belirtilen UID'ye sahip kullanıcının bilgilerini Firestore'dan çeker.
    ///
    /// - Parameters:
    ///   - uid: Kullanıcının benzersiz kimliği (UID).
    ///   - completion: İşlem başarılıysa `User` modeli, aksi takdirde hata döner.
    public func fetchUserData(uid: String, completion: @escaping (Result<AppUser, Error>) -> Void) {
        db.collection("users").document(uid).getDocument() { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = snapshot?.data(),
                  let username = data["username"] as? String,
                  let email = data["email"] as? String,
                  let coin = data["coin"] as? Int else {
                let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Kullanıcı verisi eksik."])
                completion(.failure(error))
                return
            }
            
            // avatarImageName için nil check ve default değer - Force unwrap kaldırıldı
            let avatarImageName = data["avatarImageName"] as? String ?? "profile_icon_1"
            
            let user = AppUser(uid: uid, username: username, email: email, coin: coin, avatarImageName: avatarImageName)
            completion(.success(user))
        }
    }
    
    /// Kullanıcının coin bilgisini manuel olarak belirli bir değere günceller.
    ///
    /// - Parameters:
    ///   - uid: Güncellenecek kullanıcının UID'si.
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
    /// - Parameters:
    ///   - uid: Coin'i artırılacak kullanıcının UID'si.
    ///   - amount: Coin'e eklenecek değer.
    ///   - completion: İşlem tamamlandığında hata varsa `error`, yoksa `nil` döner.
    func incrementUserCoin(uid: String, by amount: Int, completion: @escaping ((any Error)?) -> Void) {
        db.collection("users").document(uid).updateData([
            "coin": FieldValue.increment(Int64(amount))
        ]) { error in
            completion(error)
        }
    }
    
    // MARK: - Avatar İşlemleri
    
    /// Kullanıcının avatar bilgisini günceller
    /// - Parameters:
    ///   - uid: Kullanıcının UID'si
    ///   - avatarImageName: Seçilen avatar'ın image name'i
    ///   - completion: İşlem tamamlandığında çağrılır
    func updateUserAvatar(uid: String, avatarImageName: String, completion: @escaping (Error?) -> Void) {
        db.collection("users").document(uid).updateData([
            "avatarImageName": avatarImageName
        ]) { error in
            completion(error)
        }
    }
    
    /// Kullanıcının avatar bilgisini getirir
    /// - Parameters:
    ///   - uid: Kullanıcının UID'si
    ///   - completion: Avatar image name'i veya hata döner
    func fetchUserAvatar(uid: String, completion: @escaping (Result<String, Error>) -> Void) {
        db.collection("users").document(uid).getDocument { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = snapshot?.data(),
                  let avatarImageName = data["avatarImageName"] as? String else {
                completion(.success("profile_icon_1"))
                return
            }
            
            completion(.success(avatarImageName))
        }
    }
    
    // MARK: - Username İşlemleri
    
    /// Kullanıcının username bilgisini günceller
    /// - Parameters:
    ///   - uid: Kullanıcının UID'si
    ///   - username: Yeni kullanıcı adı
    ///   - completion: İşlem tamamlandığında çağrılır
    func updateUsername(uid: String, username: String, completion: @escaping (Error?) -> Void) {
        let trimmedUsername = username.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedUsername.isEmpty else {
            let error = NSError(domain: "AuthService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Kullanıcı adı boş olamaz."])
            completion(error)
            return
        }
        
        guard trimmedUsername.count >= 3 else {
            let error = NSError(domain: "AuthService", code: -2, userInfo: [NSLocalizedDescriptionKey: "Kullanıcı adı en az 3 karakter olmalıdır."])
            completion(error)
            return
        }
        
        guard trimmedUsername.count <= 20 else {
            let error = NSError(domain: "AuthService", code: -3, userInfo: [NSLocalizedDescriptionKey: "Kullanıcı adı en fazla 20 karakter olabilir."])
            completion(error)
            return
        }
        
        db.collection("users").document(uid).updateData([
            "username": trimmedUsername
        ]) { error in
            completion(error)
        }
    }
}

// MARK: - User Model
struct AppUser {
    let uid: String
    let username: String
    let email: String
    let coin: Int
    let avatarImageName: String
    
    init(uid: String, username: String, email: String, coin: Int, avatarImageName: String = "profile_icon_1") {
        self.uid = uid
        self.username = username
        self.email = email
        self.coin = coin
        self.avatarImageName = avatarImageName
    }
}


////
////  AuthService.swift
////  MathQuizMastery
////
////  Created by Aydın KAYA on 27.04.2025.
////
//
//import Foundation
//import FirebaseAuth
//import FirebaseFirestore
//
//
//protocol AuthServiceProtocol{
//    func registerUser(with userRequest: RegisterUserRequest, completion: @escaping (Bool, Error?) -> Void)
//    func signIn(with userRequest: LoginUserRequest, completion: @escaping (String?, Error?) -> Void)
//    func signOut(completion: @escaping (Error?) -> Void)
//    func fetchUserData(uid: String, completion: @escaping (Result<AppUser,Error>)-> Void)
//    func updateUserCoin(uid: String, by amount: Int, completion: @escaping (Result<Void, Error>) -> Void)
//    func incrementUserCoin(uid: String, by amount: Int, completion: @escaping (Error?) -> Void)
//    func updateUserAvatar(uid: String, avatarImageName: String, completion: @escaping (Error?) -> Void)
//    func fetchUserAvatar(uid: String, completion: @escaping (Result<String, Error>) -> Void)
//    func updateUsername(uid: String, username: String, completion: @escaping (Error?) -> Void)
//}
//
//class AuthService : AuthServiceProtocol {
//
//    public static let shared = AuthService()
//    private init() {}
//    let db = Firestore.firestore()
//
//    /// A method to register the user
//    /// - Parameters:
//    ///   - userRequest: the users information (email, password, username)
//    ///   - completion: A completion with two values(- Bool: wasRegistered - Determines if the user was registered and saved in the database correctly, Error?: An optional error if firebase provides once)
//    ///   - Bool: wasRegistered - Determines if the user was registered and saved in the database correctly
//    ///   - Error?: An optional error if firebase provides once
//    public func registerUser(with userRequest: RegisterUserRequest, completion: @escaping (Bool, Error?) -> Void){
//        let username = userRequest.username
//        let email = userRequest.email
//        let password = userRequest.password
//
//        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
//            if let error = error {
//                completion(false, error)
//                return
//            }
//
//            guard let resultUser = authResult?.user else{
//                completion(false, nil)
//                return
//            }
//
//            self.db.collection("users")
//                .document(resultUser.uid)
//                .setData([
//                    "username": username,
//                    "email": email,
//                    "coin": 0
//                ], completion: { error in
//                    if let error = error {
//                        completion(false, error)
//                        return
//                    }
//                    completion(true, nil)
//                })
//        }
//    }
//
//    /// A method signIn the user
//    /// - Parameters:
//    ///   - userRequest: the users information (email, password)
//    ///   - completion: A completion with two values(String?:  uid information ,Error?: An optional error if firebase provides once)
//    ///   - String?:  uid information
//    ///   - Error?: An optional error if firebase provides once
//    public func signIn(with userRequest: LoginUserRequest, completion: @escaping (String?, Error?) -> Void) {
//        Auth.auth().signIn(withEmail: userRequest.email, password: userRequest.password) { result, error in
//            if let error = error {
//                completion(nil, error)
//                return
//            }
//            if let user = result?.user {
//                completion(user.uid, nil)
//            } else {
//                completion(nil, nil)
//            }
//        }
//    }
//
//    public func signOut(completion: @escaping (Error?)-> Void ){
//        do {
//            try Auth.auth().signOut()
//            completion(nil)
//
//        }catch let error {
//            completion(error)
//        }
//    }
//
//
//    /// Belirtilen UID'ye sahip kullanıcının bilgilerini Firestore'dan çeker.
//    ///
//    /// - Parameters:
//    ///   - uid: Kullanıcının benzersiz kimliği (UID).
//    ///   - completion: İşlem başarılıysa `User` modeli, aksi takdirde hata döner.
//    public func fetchUserData(uid: String, completion: @escaping (Result<AppUser,Error>)-> Void) {
//        db.collection("users").document(uid).getDocument(){ snapshot,error in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//
//            guard let data = snapshot?.data(),
//                  let username = data["username"] as? String,
//                  let email = data["email"] as? String,
//                  let coin = data["coin"] as? Int else {
//                let error = NSError(domain: "", code: -1, userInfo:[NSLocalizedDescriptionKey: "Kullanıcı verisi eksik."])
//                completion(.failure(error))
//                return
//            }
//
//            let avatarImageName = data["avatarImageName"] as? String
//            let user = AppUser(uid: uid, username: username, email: email, coin: coin, avatarImageName: avatarImageName!)
//            completion(.success(user))
//        }
//    }
//
//    /// Kullanıcının coin bilgisini manuel olarak belirli bir değere günceller.
//    ///
//    /// - Parameters:
//    ///   - uid: Güncellenecek kullanıcının UID'si.
//    ///   - newCoin: Yeni coin değeri.
//    ///   - completion: İşlem tamamlandığında hata varsa `error`, yoksa `nil` döner.
//    func updateUserCoin(uid: String, by amount: Int, completion: @escaping (Result<Void, Error>) -> Void) {
//        let userRef = db.collection("users").document(uid)
//
//        userRef.getDocument { snapshot, error in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//
//            guard let data = snapshot?.data(),
//                  let currentCoin = data["coin"] as? Int else {
//                let dataError = NSError(domain: "Firestore", code: -1, userInfo: [NSLocalizedDescriptionKey: "Geçersiz kullanıcı verisi"])
//                completion(.failure(dataError))
//                return
//            }
//
//            let updatedCoin = currentCoin + amount
//            userRef.updateData(["coin": updatedCoin]) { error in
//                if let error = error {
//                    completion(.failure(error))
//                } else {
//                    completion(.success(()))
//                }
//            }
//        }
//    }
//
//
//    /// Kullanıcının coin bilgisini belirtilen miktar kadar artırır.
//    /// - Parameters:
//    ///   - uid: Coin'i artırılacak kullanıcının UID'si.
//    ///   - amount: Coin'e eklenecek değer.
//    ///   - completion: İşlem tamamlandığında hata varsa `error`, yoksa `nil` döner.
//    func incrementUserCoin(uid: String, by amount: Int, completion: @escaping ((any Error)?) -> Void) {
//        db.collection("users").document(uid).updateData([
//            "coin": FieldValue.increment(Int64(amount))
//        ]) { error in
//            completion(error)
//        }
//    }
//
//    // MARK: - Avatar İşlemleri
//
//    /// Kullanıcının avatar bilgisini günceller
//    /// - Parameters:
//    ///   - uid: Kullanıcının UID'si
//    ///   - avatarImageName: Seçilen avatar'ın image name'i
//    ///   - completion: İşlem tamamlandığında çağrılır
//    func updateUserAvatar(uid: String, avatarImageName: String, completion: @escaping (Error?) -> Void) {
//        db.collection("users").document(uid).updateData([
//            "avatarImageName": avatarImageName
//        ]) { error in
//            completion(error)
//        }
//    }
//
//    /// Kullanıcının avatar bilgisini getirir
//    /// - Parameters:
//    ///   - uid: Kullanıcının UID'si
//    ///   - completion: Avatar image name'i veya hata döner
//    func fetchUserAvatar(uid: String, completion: @escaping (Result<String, Error>) -> Void) {
//        db.collection("users").document(uid).getDocument { snapshot, error in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//
//            guard let data = snapshot?.data(),
//                  let avatarImageName = data["avatarImageName"] as? String else {
//                completion(.success("profile_icon_1"))
//                return
//            }
//
//            completion(.success(avatarImageName))
//        }
//    }
//
//    // MARK: - Username İşlemleri
//
//    /// Kullanıcının username bilgisini günceller
//    /// - Parameters:
//    ///   - uid: Kullanıcının UID'si
//    ///   - username: Yeni kullanıcı adı
//    ///   - completion: İşlem tamamlandığında çağrılır
//    func updateUsername(uid: String, username: String, completion: @escaping (Error?) -> Void) {
//        let trimmedUsername = username.trimmingCharacters(in: .whitespacesAndNewlines)
//
//        guard !trimmedUsername.isEmpty else {
//            let error = NSError(domain: "AuthService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Kullanıcı adı boş olamaz."])
//            completion(error)
//            return
//        }
//
//        guard trimmedUsername.count >= 3 else {
//            let error = NSError(domain: "AuthService", code: -2, userInfo: [NSLocalizedDescriptionKey: "Kullanıcı adı en az 3 karakter olmalıdır."])
//            completion(error)
//            return
//        }
//
//        guard trimmedUsername.count <= 20 else {
//            let error = NSError(domain: "AuthService", code: -3, userInfo: [NSLocalizedDescriptionKey: "Kullanıcı adı en fazla 20 karakter olabilir."])
//            completion(error)
//            return
//        }
//
//        db.collection("users").document(uid).updateData([
//            "username": trimmedUsername
//        ]) { error in
//            completion(error)
//        }
//
//    }
//}
//
//// MARK: - User Model
//struct AppUser {
//    let uid: String
//    let username: String
//    let email: String
//    let coin: Int
//    let avatarImageName: String
//
//    init(uid: String, username: String, email: String, coin: Int, avatarImageName: String = "profile_icon_1") {
//        self.uid = uid
//        self.username = username
//        self.email = email
//        self.coin = coin
//        self.avatarImageName = avatarImageName
//    }
//}
