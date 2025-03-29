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



// Core Data -> persistentContainer -> Managed Object Context

final class CoreDataManager: CoreDataServiceProtocol {
    static let shared = CoreDataManager()
    
    // MARK: - Singleton yerine bağımsız instance
    private let persistentContainer: NSPersistentContainer
    
    private init() {
        self.persistentContainer =  NSPersistentContainer(name:"dataModel")
        self.persistentContainer.loadPersistentStores { _, error in
            if let error = error as NSError? {
                print("❌ Core Data yükleme hatası: \(error), \(error.userInfo)")
            }
        }
    }
    
    private var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // MARK: - Kullanıcı Kaydetme
    func saveUser(name: String, email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        context.perform {
            let user = Person(context: self.context)
            user.uuid = UUID()
            user.name = name
            user.email = email
            user.password = self.hashPassword(password)
            
            do {
                try self.context.save()
                completion(.success(()))
                
            } catch {
                print("❌ Kullanıcı kaydedilirken hata oluştu: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - Kullanıcı Getirme
    func fetchUser(email: String, password: String,completion: @escaping (Result<Person?, Error>) -> Void) {
        let request: NSFetchRequest<Person> = Person.fetchRequest()
        request.predicate = NSPredicate(format: "email == %@ AND password == %@", email, hashPassword(password)) // Predicate => Filter data
        request.fetchLimit = 1  // En fazla bir kullanıcı getir
        
        do {
            let user = try self.context.fetch(request).first
            completion(.success(user))
        } catch {
            print("❌ Kullanıcı getirme hatası: \(error.localizedDescription)")
            completion(.failure(error))
        }
    }
    
    private func hashPassword(_ password: String) -> String {
        let data = Data(password.utf8)
        let hashed = SHA256.hash(data: data)
        return hashed.compactMap { String(format: "%02x", $0) }.joined()
    }
}
