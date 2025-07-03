//
//  TestRunner.swift
//  MathQuizMasteryTests
//
//  Created by AydınKaya on 3.07.2025.
//

import XCTest
import Combine
import FirebaseAuth
import FirebaseFirestore

final class TestRunner: XCTestCase {
    
    var cancellables = Set<AnyCancellable>()
    
    func testRunAllSuites() {
        let manager = TestSuiteManager()
        
      //  let expectation = XCTestExpectation(description: "All tests completed")
        
        manager.runTestSuite(named: "AuthService")
        

        
        
//        manager.runAllTests()
//            .sink { report in
//                print("All tests completed. Pass rate: \(report.overallPassRate)%")
//                expectation.fulfill()
//            }
//            .store(in: &cancellables)
//        
//        wait(for: [expectation], timeout: 10)
    }
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    //sadsa
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
