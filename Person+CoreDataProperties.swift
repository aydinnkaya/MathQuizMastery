//
//  Person+CoreDataProperties.swift
//  MathQuizMastery
//
//  Created by Aydın KAYA on 29.03.2025.
//
//

import Foundation
import CoreData

extension Person {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }
    
    @nonobjc public class func fetchPersonByEmailAndPassword(email: String, hashedPassword: String, in context: NSManagedObjectContext) -> Person? {
        let request: NSFetchRequest<Person> = Person.fetchRequest()
        request.predicate = NSPredicate(format: "email == %@ AND password == %@", email, hashedPassword)
        request.fetchLimit = 1
        
        do {
            return try context.fetch(request).first
        } catch {
            print("❌ Email & Password ile kullanıcı çekme hatası: \(error.localizedDescription)")
            return nil
        }
    }
    
    @nonobjc public class func fetchPersonByUUID(_ uuid: UUID, in context: NSManagedObjectContext) -> Person? {
        let request: NSFetchRequest<Person> = Person.fetchRequest()
        request.predicate = NSPredicate(format: "uuid == %@", uuid as CVarArg)
        request.fetchLimit = 1
        
        do {
            return try context.fetch(request).first
        } catch {
            print("❌ UUID ile kullanıcı çekme hatası: \(error.localizedDescription)")
            return nil
        }
    }
    
    @NSManaged public var email: String?
    @NSManaged public var name: String?
    @NSManaged public var password: String?
    @NSManaged public var uuid: UUID?
}

extension Person: Identifiable {}
