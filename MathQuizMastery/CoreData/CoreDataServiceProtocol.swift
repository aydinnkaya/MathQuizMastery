//
//  CoreDataServiceProtocol.swift
//  MathQuizMastery
//
//  Created by AydınKaya on 21.03.2025.
//

import Foundation
import CoreData

protocol CoreDataServiceProtocol {
    func saveUser(name: String, email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void)
    func fetchUser(email: String, password: String, completion: @escaping (Result<Person?, Error>) -> Void)
    func fetchUser(with uuid: UUID, completion: @escaping (Result<Person, Error>) -> Void)
}

