//
//  Person+CoreDataProperties.swift
//  MathQuizMastery
//
//  Created by AydınKaya on 21.03.2025.
//

import Foundation
import CoreData


extension Person{
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person>{
        return NSFetchRequest<Person>(entityName: "Person")
    }
    
    @nonobjc public class func fetchPersonByEmailAndPassword(email: String, password: String, context: NSManagedObjectContext) ->Person?{
        let fetchRequest: NSFetchRequest<Person> = Person.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "email == %@ AND password == %@", email, password)
        
        do{
            let person = try context.fetch(fetchRequest)
            return person.first
        }catch{
            print("Error fetching person: \(error.localizedDescription)")
            return nil
        }
        
    }
    
    @NSManaged public var uuid: UUID?
    @NSManaged public var name: String?
    @NSManaged public var email: String?
    @NSManaged public var password: String?
}
