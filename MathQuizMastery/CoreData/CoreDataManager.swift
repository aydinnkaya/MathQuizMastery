//
//  CoreDataManager.swift
//  MathQuizMastery
//
//  Created by AydınKaya on 21.03.2025.
//

import Foundation
import CoreData
import UIKit

final class CoreDataManager: CoreDataServiceProtocol {
    static let shared = CoreDataManager( )
   
    // MARK: - Singleton yerine bağımsız instance
    private let persistentContainer: NSPersistentContainer
    
    init(container: NSPersistentContainer = NSPersistentContainer(name: "MathQuizMastery")) {
        self.persistentContainer = container
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
            user.password = password
            
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
    func fetchUser(email: String, password: String) -> Person? {
        let request: NSFetchRequest<Person> = Person.fetchRequest()
        request.predicate = NSPredicate(format: "email == %@ AND password == %@", email, password)
        request.fetchLimit = 1  // En fazla bir kullanıcı getir
        
        do {
            return try context.fetch(request).first
        } catch {
            print("❌ Kullanıcı getirme hatası: \(error.localizedDescription)")
            return nil
        }
    }
}
