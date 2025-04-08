//
//  CoreDataManagerTests.swift
//  MathQuizMasteryTests
//
//  Created by AydınKaya on 8.04.2025.
//

import XCTest
import CoreData
@testable import MathQuizMastery

final class CoreDataManagerTests: XCTestCase {
    
    var coreDataManager: CoreDataManager!
    var mockPersistenceService: MockPersistenceService!
    var context: NSManagedObjectContext!
    
    override func setUpWithError() throws {
        mockPersistenceService = MockPersistenceService()
        coreDataManager = CoreDataManager(persistenceService: mockPersistenceService)
        context = mockPersistenceService.context
    }
    
    override func tearDownWithError() throws {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Person")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        try context.execute(deleteRequest)
    }
    
    func testSaveUser() throws {
        let expectation = self.expectation(description: "Kullanıcı kaydedildi")
        
        coreDataManager.saveUser(name: "Aydın Kaya", email: "aydin@example.com", password: "password123") { result in
            switch result {
            case .success:
                let fetchRequest: NSFetchRequest<Person> = Person.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "email == %@", "aydin@example.com")
                
                do {
                    let users = try self.context.fetch(fetchRequest)
                    XCTAssertEqual(users.count, 1)
                    XCTAssertEqual(users.first?.name, "Aydın Kaya")
                    XCTAssertEqual(users.first?.email, "aydin@example.com")
                    expectation.fulfill()
                } catch {
                    XCTFail("Kullanıcı verisi alınamadı: \(error)")
                }
            case .failure(let error):
                XCTFail("Kullanıcı kaydedilemedi: \(error)")
            }
        }
        
        waitForExpectations(timeout: 100, handler: nil)
    }
    
    func testFetchUser() throws {
        let expectation = self.expectation(description: "Kullanıcı başarıyla çekildi")
        
        coreDataManager.saveUser(name: "Aydın Kaya", email: "aydin@example.com", password: "password123") { result in
            switch result {
            case .success:
                self.coreDataManager.fetchUser(email: "aydin@example.com", password: "password123") { result in
                    switch result {
                    case .success(let user):
                        XCTAssertNotNil(user)
                        XCTAssertEqual(user?.name, "Aydın Kaya")
                        XCTAssertEqual(user?.email, "aydin@example.com")
                    case .failure(let error):
                        XCTFail("Kullanıcı çekilemedi: \(error)")
                    }
                    expectation.fulfill()
                }
            case .failure(let error):
                XCTFail("Kullanıcı kaydedilemedi: \(error)")
            }
        }
        
        waitForExpectations(timeout: 100, handler: nil)
    }
    
    func testFetchUserWithUUID() throws {
        let expectation = self.expectation(description: "UUID ile kullanıcı başarıyla çekildi")
        
        coreDataManager.saveUser(name: "Aydın Kaya", email: "aydin@example.com", password: "password123") { result in
            switch result {
            case .success:
                self.coreDataManager.fetchUser(email: "aydin@example.com", password: "password123") { result in
                    switch result {
                    case .success(let user):
                        if let user = user {
                            self.coreDataManager.fetchUser(with: user.uuid!) { result in
                                switch result {
                                case .success(let fetchedUser):
                                    XCTAssertEqual(fetchedUser.uuid, user.uuid)
                                case .failure(let error):
                                    XCTFail("UUID ile kullanıcı çekilemedi: \(error)")
                                }
                                expectation.fulfill()
                            }
                        } else {
                            XCTFail("Kullanıcı bulunamadı")
                            expectation.fulfill()
                        }
                    case .failure(let error):
                        XCTFail("Kullanıcı çekilemedi: \(error)")
                        expectation.fulfill()
                    }
                }
            case .failure(let error):
                XCTFail("Kullanıcı kaydedilemedi: \(error)")
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 100, handler: nil)
    }
    
    class MockPersistenceService: PersistenceServiceProtocol {
        private var mockContext: NSManagedObjectContext
        
        init() {
            let container = NSPersistentContainer(name: "DataModel")
            container.loadPersistentStores { (description, error) in
                if let error = error as NSError? {
                    print("❌ Core Data yükleme hatası: \(error), \(error.userInfo)")
                }
            }
            mockContext = container.viewContext
        }
        
        var context: NSManagedObjectContext {
            return mockContext
        }
        
        func save<T: NSManagedObject>(_ object: T) throws {
            try context.save()
        }
        
        func fetch<T: NSManagedObject>(request: NSFetchRequest<T>) throws -> [T] {
            return try context.fetch(request)
        }
        
        func delete<T: NSManagedObject>(_ object: T) throws {
            context.delete(object)
            try context.save()
        }
    }
}

