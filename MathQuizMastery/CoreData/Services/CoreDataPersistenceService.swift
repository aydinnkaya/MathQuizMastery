//
//  CoreDataPersistenceService.swift
//  MathQuizMastery
//
//  Created by AydınKaya on 2.04.2025.
//

import Foundation
import CoreData

class CoreDataPersistenceService: PersistenceServiceProtocol {
    private let persistentContainer: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        persistentContainer = NSPersistentContainer(name: "DataModel")
        
        if inMemory {
            let description = NSPersistentStoreDescription()
            description.type = NSInMemoryStoreType
            persistentContainer.persistentStoreDescriptions = [description]
        }
        
        persistentContainer.loadPersistentStores { (description, error) in
            if let error = error as NSError? {
                print("❌ Core Data yükleme hatası: \(error), \(error.userInfo)")
            } else {
                print("✅ Persistent Store Yükleme Başarılı (\(inMemory ? "Memory" : "Disk"))")
            }
        }
    }
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func save<T: NSManagedObject>(_ object: T) throws {
        try context.save()
    }
    
    // <T: NSManagedObject> -> generics Belirli bir veri türüne uygulanmasını sağlar (NSManagedObject ve onun alt sınıflarına)
    func fetch<T: NSManagedObject>(request: NSFetchRequest<T>) throws -> [T] {
        return try context.fetch(request)
    }
    
    func delete<T: NSManagedObject>(_ object: T) throws {
        context.delete(object)
        try context.save()
    }
}
