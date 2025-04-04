//
//  CoreDataManager.swift
//  MathQuizMastery
//
//  Created by AydınKaya on 21.03.2025.
//

import Foundation
import CoreData
import UIKit
import CryptoKit

class CoreDataManager: CoreDataServiceProtocol {
    private var persistenceService: PersistenceServiceProtocol
    
    
    init(persistenceService: PersistenceServiceProtocol = CoreDataPersistenceService()) {
        self.persistenceService = persistenceService
    }
    
    func saveUser(name: String, email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let user = Person(context: persistenceService.context)
        user.uuid = UUID()
        user.name = name
        user.email = email
        user.password = hashPassword(password)
        
        do {
            try persistenceService.save(user)
            completion(.success(()))
        } catch {
            completion(.failure(error))
        }
    }
    
    // Result -> succes or fail
    func fetchUser(email: String, password: String, completion: @escaping (Result<Person?, Error>) -> Void) {
        let request: NSFetchRequest<Person> = Person.fetchRequest()
        request.predicate = NSPredicate(format: "email == %@ AND password == %@", email, hashPassword(password))
        
        do {
            let users = try persistenceService.fetch(request: request)
            completion(.success(users.first))
        } catch {
            completion(.failure(error))
        }
    }
    
    func fetchUser(with uuid: UUID, completion: @escaping (Result<Person, Error>) -> Void) {
        let request: NSFetchRequest<Person> = Person.fetchRequest()
        request.predicate = NSPredicate(format: "uuid == %@", uuid as CVarArg)
        do {
            let users = try persistenceService.fetch(request: request)
            if let user = users.first {
                completion(.success(user))
            } else {
                let error = NSError(domain: "CoreData", code: 404, userInfo: [NSLocalizedDescriptionKey: "Kullanıcı bulunamadı"])
                completion(.failure(error))
            }
        } catch {
            completion(.failure(error))
        }
    }
    
    private func hashPassword(_ password: String) -> String {
        let data = Data(password.utf8)
        let hashed = SHA256.hash(data: data)
        return hashed.compactMap { String(format: "%02x", $0) }.joined()
    }
    
}
