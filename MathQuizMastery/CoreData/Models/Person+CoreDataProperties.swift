//
//  Person+CoreDataProperties.swift
//  MathQuizMastery
//
//  Created by AydınKaya on 8.04.2025.
//
//

import Foundation
import CoreData


extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var email: String?
    @NSManaged public var name: String?
    @NSManaged public var password: String?
    @NSManaged public var uuid: UUID?

}

extension Person : Identifiable {

}
