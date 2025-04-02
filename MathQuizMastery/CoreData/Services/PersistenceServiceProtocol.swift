//
//  PersistenceServiceProtocol.swift
//  MathQuizMastery
//
//  Created by AydınKaya on 2.04.2025.
//

import Foundation
import CoreData

protocol PersistenceServiceProtocol {
    var context: NSManagedObjectContext { get }
    func save<T: NSManagedObject>(_ object: T) throws
    func fetch<T: NSManagedObject>(request: NSFetchRequest<T>) throws -> [T]
    func delete<T: NSManagedObject>(_ object: T) throws
}
