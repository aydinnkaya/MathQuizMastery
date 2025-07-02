//
//  CategoryViewModelTests.swift
//  MathQuizMasteryTests
//
//  Created by AydınKaya on 2.07.2025.
//

import XCTest
@testable import MathQuizMastery

// MARK: - Mock Dependencies

/// Mock implementation of CategoryViewModelDelegate for testing purposes
class MockCategoryViewModelDelegate: CategoryViewModelDelegate {
    
    // MARK: - Captured Method Calls
    var navigateToGameVCCallCount = 0
    
    // MARK: - Captured Parameters
    var capturedExpressionTypes: [MathExpression.ExpressionType] = []
    
    // MARK: - CategoryViewModelDelegate Implementation
    
    func navigateToGameVC(with type: MathExpression.ExpressionType) {
        navigateToGameVCCallCount += 1
        capturedExpressionTypes.append(type)
    }
}

// MARK: - CategoryViewModel Tests

final class CategoryViewModelTests: XCTestCase {
    
    // MARK: - Properties
    
    private var viewModel: CategoryViewModel!
    private var mockDelegate: MockCategoryViewModelDelegate!
    
    // MARK: - Setup & Teardown
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        viewModel = CategoryViewModel()
        mockDelegate = MockCategoryViewModelDelegate()
        viewModel.delegate = mockDelegate
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
        mockDelegate = nil
        try super.tearDownWithError()
    }
    
    // MARK: - Initialization Tests
    
    func test_Init_ShouldInitializeWithCorrectNumberOfCategories() {
        // Given/When - Setup is done in setUpWithError
        
        // Then
        XCTAssertNotNil(viewModel, "ViewModel should be initialized")
        XCTAssertEqual(viewModel.numberOfItems, 5, "Should have exactly 5 categories")
        XCTAssertTrue(viewModel.delegate === mockDelegate, "Delegate should be set correctly")
    }
    
    // MARK: - Category Data Tests
    
    func test_NumberOfItems_ShouldReturnCorrectCount() {
        // Given/When
        let numberOfItems = viewModel.numberOfItems
        
        // Then
        XCTAssertEqual(numberOfItems, 5, "Should return exactly 5 categories")
    }
    
    func test_CategoryAtIndex_ShouldReturnCorrectCategoryForAllIndices() {
        // Given
        let expectedCategories = [
            ("add_icon", "addition", MathExpression.ExpressionType.addition),
            ("minus_icon", "subtraction", MathExpression.ExpressionType.subtraction),
            ("multiply_icon", "multiplication", MathExpression.ExpressionType.multiplication),
            ("divide_icon", "division", MathExpression.ExpressionType.division),
            ("random_icon", "mixed", MathExpression.ExpressionType.mixed)
        ]
        
        // When/Then
        for (index, expectedCategory) in expectedCategories.enumerated() {
            let category = viewModel.category(at: index)
            
            XCTAssertEqual(category.iconName, expectedCategory.0, "Icon name should match for index \(index)")
            XCTAssertEqual(category.categoryName, expectedCategory.1, "Category name should match for index \(index)")
            XCTAssertEqual(category.expressionType, expectedCategory.2, "Expression type should match for index \(index)")
        }
    }
    
    func test_CategoryAtIndex_Addition_ShouldReturnCorrectData() {
        // Given
        let index = 0
        
        // When
        let category = viewModel.category(at: index)
        
        // Then
        XCTAssertEqual(category.iconName, "add_icon")
        XCTAssertEqual(category.categoryName, "addition")
        XCTAssertEqual(category.expressionType, .addition)
    }
    
    func test_CategoryAtIndex_Subtraction_ShouldReturnCorrectData() {
        // Given
        let index = 1
        
        // When
        let category = viewModel.category(at: index)
        
        // Then
        XCTAssertEqual(category.iconName, "minus_icon")
        XCTAssertEqual(category.categoryName, "subtraction")
        XCTAssertEqual(category.expressionType, .subtraction)
    }
    
    func test_CategoryAtIndex_Multiplication_ShouldReturnCorrectData() {
        // Given
        let index = 2
        
        // When
        let category = viewModel.category(at: index)
        
        // Then
        XCTAssertEqual(category.iconName, "multiply_icon")
        XCTAssertEqual(category.categoryName, "multiplication")
        XCTAssertEqual(category.expressionType, .multiplication)
    }
    
    func test_CategoryAtIndex_Division_ShouldReturnCorrectData() {
        // Given
        let index = 3
        
        // When
        let category = viewModel.category(at: index)
        
        // Then
        XCTAssertEqual(category.iconName, "divide_icon")
        XCTAssertEqual(category.categoryName, "division")
        XCTAssertEqual(category.expressionType, .division)
    }
    
    func test_CategoryAtIndex_Mixed_ShouldReturnCorrectData() {
        // Given
        let index = 4
        
        // When
        let category = viewModel.category(at: index)
        
        // Then
        XCTAssertEqual(category.iconName, "random_icon")
        XCTAssertEqual(category.categoryName, "mixed")
        XCTAssertEqual(category.expressionType, .mixed)
    }
    
    // MARK: - Category Selection Tests
    
    func test_CategorySelected_Addition_ShouldNotifyDelegateWithCorrectType() {
        // Given
        let index = 0
        
        // When
        viewModel.categorySelected(at: index)
        
        // Then
        XCTAssertEqual(mockDelegate.navigateToGameVCCallCount, 1, "Delegate should be called exactly once")
        XCTAssertEqual(mockDelegate.capturedExpressionTypes.count, 1, "Should capture exactly one expression type")
        XCTAssertEqual(mockDelegate.capturedExpressionTypes.first, .addition, "Should navigate with addition type")
    }
    
    func test_CategorySelected_Subtraction_ShouldNotifyDelegateWithCorrectType() {
        // Given
        let index = 1
        
        // When
        viewModel.categorySelected(at: index)
        
        // Then
        XCTAssertEqual(mockDelegate.navigateToGameVCCallCount, 1, "Delegate should be called exactly once")
        XCTAssertEqual(mockDelegate.capturedExpressionTypes.first, .subtraction, "Should navigate with subtraction type")
    }
    
    func test_CategorySelected_Multiplication_ShouldNotifyDelegateWithCorrectType() {
        // Given
        let index = 2
        
        // When
        viewModel.categorySelected(at: index)
        
        // Then
        XCTAssertEqual(mockDelegate.navigateToGameVCCallCount, 1, "Delegate should be called exactly once")
        XCTAssertEqual(mockDelegate.capturedExpressionTypes.first, .multiplication, "Should navigate with multiplication type")
    }
    
    func test_CategorySelected_Division_ShouldNotifyDelegateWithCorrectType() {
        // Given
        let index = 3
        
        // When
        viewModel.categorySelected(at: index)
        
        // Then
        XCTAssertEqual(mockDelegate.navigateToGameVCCallCount, 1, "Delegate should be called exactly once")
        XCTAssertEqual(mockDelegate.capturedExpressionTypes.first, .division, "Should navigate with division type")
    }
    
    func test_CategorySelected_Mixed_ShouldNotifyDelegateWithCorrectType() {
        // Given
        let index = 4
        
        // When
        viewModel.categorySelected(at: index)
        
        // Then
        XCTAssertEqual(mockDelegate.navigateToGameVCCallCount, 1, "Delegate should be called exactly once")
        XCTAssertEqual(mockDelegate.capturedExpressionTypes.first, .mixed, "Should navigate with mixed type")
    }
    
    func test_CategorySelected_MultipleSelections_ShouldHandleCorrectly() {
        // Given
        let selections = [0, 2, 4, 1, 3] // addition, multiplication, mixed, subtraction, division
        let expectedTypes: [MathExpression.ExpressionType] = [.addition, .multiplication, .mixed, .subtraction, .division]
        
        // When
        for index in selections {
            viewModel.categorySelected(at: index)
        }
        
        // Then
        XCTAssertEqual(mockDelegate.navigateToGameVCCallCount, 5, "Delegate should be called five times")
        XCTAssertEqual(mockDelegate.capturedExpressionTypes.count, 5, "Should capture five expression types")
        
        for (index, expectedType) in expectedTypes.enumerated() {
            XCTAssertEqual(mockDelegate.capturedExpressionTypes[index], expectedType, "Expression type at index \(index) should match")
        }
    }
    
    // MARK: - Edge Cases Tests
    
    func test_CategorySelected_SameIndexMultipleTimes_ShouldHandleCorrectly() {
        // Given
        let index = 2 // multiplication
        
        // When
        viewModel.categorySelected(at: index)
        viewModel.categorySelected(at: index)
        viewModel.categorySelected(at: index)
        
        // Then
        XCTAssertEqual(mockDelegate.navigateToGameVCCallCount, 3, "Delegate should be called three times")
        XCTAssertEqual(mockDelegate.capturedExpressionTypes.count, 3, "Should capture three expression types")
        
        for expressionType in mockDelegate.capturedExpressionTypes {
            XCTAssertEqual(expressionType, .multiplication, "All captured types should be multiplication")
        }
    }
    
    func test_CategorySelected_AllIndicesInSequence_ShouldHandleCorrectly() {
        // Given
        let expectedSequence: [MathExpression.ExpressionType] = [.addition, .subtraction, .multiplication, .division, .mixed]
        
        // When
        for index in 0..<viewModel.numberOfItems {
            viewModel.categorySelected(at: index)
        }
        
        // Then
        XCTAssertEqual(mockDelegate.navigateToGameVCCallCount, 5, "Delegate should be called five times")
        XCTAssertEqual(mockDelegate.capturedExpressionTypes, expectedSequence, "Should capture all expression types in correct order")
    }
    
    func test_CategorySelected_RandomOrder_ShouldHandleCorrectly() {
        // Given
        let randomIndices = [3, 1, 4, 0, 2] // division, subtraction, mixed, addition, multiplication
        let expectedTypes: [MathExpression.ExpressionType] = [.division, .subtraction, .mixed, .addition, .multiplication]
        
        // When
        for index in randomIndices {
            viewModel.categorySelected(at: index)
        }
        
        // Then
        XCTAssertEqual(mockDelegate.navigateToGameVCCallCount, 5, "Delegate should be called five times")
        XCTAssertEqual(mockDelegate.capturedExpressionTypes, expectedTypes, "Should capture expression types in selection order")
    }
    
    // MARK: - Boundary Tests
    
    func test_CategoryAtIndex_FirstIndex_ShouldReturnCorrectCategory() {
        // Given
        let firstIndex = 0
        
        // When
        let category = viewModel.category(at: firstIndex)
        
        // Then
        XCTAssertEqual(category.iconName, "add_icon")
        XCTAssertEqual(category.categoryName, "addition")
        XCTAssertEqual(category.expressionType, .addition)
    }
    
    func test_CategoryAtIndex_LastIndex_ShouldReturnCorrectCategory() {
        // Given
        let lastIndex = viewModel.numberOfItems - 1
        
        // When
        let category = viewModel.category(at: lastIndex)
        
        // Then
        XCTAssertEqual(category.iconName, "random_icon")
        XCTAssertEqual(category.categoryName, "mixed")
        XCTAssertEqual(category.expressionType, .mixed)
    }
    
    func test_CategorySelected_FirstIndex_ShouldWork() {
        // Given
        let firstIndex = 0
        
        // When
        viewModel.categorySelected(at: firstIndex)
        
        // Then
        XCTAssertEqual(mockDelegate.navigateToGameVCCallCount, 1)
        XCTAssertEqual(mockDelegate.capturedExpressionTypes.first, .addition)
    }
    
    func test_CategorySelected_LastIndex_ShouldWork() {
        // Given
        let lastIndex = viewModel.numberOfItems - 1
        
        // When
        viewModel.categorySelected(at: lastIndex)
        
        // Then
        XCTAssertEqual(mockDelegate.navigateToGameVCCallCount, 1)
        XCTAssertEqual(mockDelegate.capturedExpressionTypes.first, .mixed)
    }
    
    // MARK: - Memory Management Tests
    
    func test_ViewModelDeallocation_ShouldNotCauseCrash() {
        // Given
        weak var weakViewModel: CategoryViewModel?
        var localDelegate: MockCategoryViewModelDelegate?
        
        autoreleasepool {
            let tempViewModel = CategoryViewModel()
            localDelegate = MockCategoryViewModelDelegate()
            tempViewModel.delegate = localDelegate
            weakViewModel = tempViewModel
            
            tempViewModel.categorySelected(at: 0)
        }
        
        // When
        localDelegate = nil
        
        // Then
        XCTAssertNil(weakViewModel, "ViewModel should be deallocated")
    }
    
    func test_DelegateDeallocation_ShouldNotCauseCrash() {
        // Given
        weak var weakDelegate: MockCategoryViewModelDelegate?
        
        autoreleasepool {
            let tempDelegate = MockCategoryViewModelDelegate()
            viewModel.delegate = tempDelegate
            weakDelegate = tempDelegate
            
            viewModel.categorySelected(at: 0)
        }
        
        // When
        viewModel.delegate = nil
        
        // Then
        XCTAssertNil(weakDelegate, "Delegate should be deallocated")
    }
    
    // MARK: - Performance Tests
    
    func test_CategoryAtIndex_PerformanceTest() {
        // When/Then
        measure {
            for _ in 0..<1000 {
                for index in 0..<viewModel.numberOfItems {
                    _ = viewModel.category(at: index)
                }
            }
        }
    }
    
    func test_CategorySelected_PerformanceTest() {
        // When/Then
        measure {
            for _ in 0..<1000 {
                for index in 0..<viewModel.numberOfItems {
                    viewModel.categorySelected(at: index)
                }
            }
        }
        
        // Verify all selections were processed
        XCTAssertEqual(mockDelegate.navigateToGameVCCallCount, 5000, "All 5000 selections should be processed")
    }
    
    // MARK: - Thread Safety Tests
    
    func test_ConcurrentCategorySelection_ShouldHandleCorrectly() {
        // Given
        let concurrentExpectation = XCTestExpectation(description: "Concurrent category selections")
        concurrentExpectation.expectedFulfillmentCount = 5
        
        // When
        for index in 0..<5 {
            DispatchQueue.global().async {
                self.viewModel.categorySelected(at: index)
                concurrentExpectation.fulfill()
            }
        }
        
        // Then
        wait(for: [concurrentExpectation], timeout: 1.0)
        
        XCTAssertEqual(mockDelegate.navigateToGameVCCallCount, 5, "All concurrent selections should be handled")
        XCTAssertEqual(mockDelegate.capturedExpressionTypes.count, 5, "Should capture all expression types")
    }
    
    func test_ConcurrentCategoryAccess_ShouldHandleCorrectly() {
        // Given
        let concurrentExpectation = XCTestExpectation(description: "Concurrent category access")
        concurrentExpectation.expectedFulfillmentCount = 10
        
        var capturedCategories: [CategoryModel] = []
        let lock = NSLock()
        
        // When
        for index in 0..<10 {
            DispatchQueue.global().async {
                let category = self.viewModel.category(at: index % self.viewModel.numberOfItems)
                
                lock.lock()
                capturedCategories.append(category)
                lock.unlock()
                
                concurrentExpectation.fulfill()
            }
        }
        
        // Then
        wait(for: [concurrentExpectation], timeout: 1.0)
        
        XCTAssertEqual(capturedCategories.count, 10, "All concurrent accesses should return categories")
    }
    
    // MARK: - State Consistency Tests
    
    func test_CategoryData_ShouldBeConsistentAcrossMultipleAccesses() {
        // Given
        let index = 2 // multiplication
        
        // When
        let firstAccess = viewModel.category(at: index)
        let secondAccess = viewModel.category(at: index)
        let thirdAccess = viewModel.category(at: index)
        
        // Then
        XCTAssertEqual(firstAccess.iconName, secondAccess.iconName, "Icon name should be consistent")
        XCTAssertEqual(firstAccess.categoryName, secondAccess.categoryName, "Category name should be consistent")
        XCTAssertEqual(firstAccess.expressionType, secondAccess.expressionType, "Expression type should be consistent")
        
        XCTAssertEqual(secondAccess.iconName, thirdAccess.iconName, "Icon name should be consistent")
        XCTAssertEqual(secondAccess.categoryName, thirdAccess.categoryName, "Category name should be consistent")
        XCTAssertEqual(secondAccess.expressionType, thirdAccess.expressionType, "Expression type should be consistent")
    }
    
    func test_NumberOfItems_ShouldBeConsistentAcrossMultipleAccesses() {
        // When
        let firstAccess = viewModel.numberOfItems
        let secondAccess = viewModel.numberOfItems
        let thirdAccess = viewModel.numberOfItems
        
        // Then
        XCTAssertEqual(firstAccess, 5, "Number of items should be 5")
        XCTAssertEqual(secondAccess, 5, "Number of items should be consistent")
        XCTAssertEqual(thirdAccess, 5, "Number of items should be consistent")
        XCTAssertEqual(firstAccess, secondAccess, "Number of items should be consistent between accesses")
        XCTAssertEqual(secondAccess, thirdAccess, "Number of items should be consistent between accesses")
    }
    
    // MARK: - Integration Tests
    
    func test_CompleteWorkflow_ShouldWorkCorrectly() {
        // Given
        let testScenarios = [
            (index: 0, expectedType: MathExpression.ExpressionType.addition),
            (index: 1, expectedType: MathExpression.ExpressionType.subtraction),
            (index: 2, expectedType: MathExpression.ExpressionType.multiplication),
            (index: 3, expectedType: MathExpression.ExpressionType.division),
            (index: 4, expectedType: MathExpression.ExpressionType.mixed)
        ]
        
        // When/Then
        for (scenarioIndex, scenario) in testScenarios.enumerated() {
            // Get category data
            let category = viewModel.category(at: scenario.index)
            
            // Verify category data
            XCTAssertNotNil(category.iconName, "Icon name should not be nil for index \(scenario.index)")
            XCTAssertNotNil(category.categoryName, "Category name should not be nil for index \(scenario.index)")
            XCTAssertEqual(category.expressionType, scenario.expectedType, "Expression type should match for index \(scenario.index)")
            
            // Select category
            viewModel.categorySelected(at: scenario.index)
            
            // Verify selection
            XCTAssertEqual(mockDelegate.navigateToGameVCCallCount, scenarioIndex + 1, "Navigation should be called for selection \(scenarioIndex + 1)")
            XCTAssertEqual(mockDelegate.capturedExpressionTypes.last, scenario.expectedType, "Last captured type should match for index \(scenario.index)")
        }
        
        // Final verification
        XCTAssertEqual(mockDelegate.navigateToGameVCCallCount, testScenarios.count, "Total navigation calls should match scenario count")
        XCTAssertEqual(mockDelegate.capturedExpressionTypes.count, testScenarios.count, "Total captured types should match scenario count")
    }
}

// MARK: - Test Extensions

extension CategoryViewModelTests {
    
    /// Helper method to verify category data
    private func verifyCategoryData(
        _ category: CategoryModel,
        expectedIconName: String,
        expectedCategoryName: String,
        expectedExpressionType: MathExpression.ExpressionType,
        at index: Int,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        XCTAssertEqual(category.iconName, expectedIconName, "Icon name mismatch at index \(index)", file: file, line: line)
        XCTAssertEqual(category.categoryName, expectedCategoryName, "Category name mismatch at index \(index)", file: file, line: line)
        XCTAssertEqual(category.expressionType, expectedExpressionType, "Expression type mismatch at index \(index)", file: file, line: line)
    }
    
    /// Helper method to verify delegate call counts
    private func verifyDelegateCallCounts(
        expectedNavigationCount: Int,
        expectedCapturedTypesCount: Int,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        XCTAssertEqual(mockDelegate.navigateToGameVCCallCount, expectedNavigationCount, "Navigation call count mismatch", file: file, line: line)
        XCTAssertEqual(mockDelegate.capturedExpressionTypes.count, expectedCapturedTypesCount, "Captured types count mismatch", file: file, line: line)
    }
    
    /// Helper method to test category selection with expected type
    private func testCategorySelection(
        at index: Int,
        expectedType: MathExpression.ExpressionType,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        // Reset delegate state
        mockDelegate.navigateToGameVCCallCount = 0
        mockDelegate.capturedExpressionTypes.removeAll()
        
        // Perform selection
        viewModel.categorySelected(at: index)
        
        // Verify results
        XCTAssertEqual(mockDelegate.navigateToGameVCCallCount, 1, "Navigation should be called exactly once for index \(index)", file: file, line: line)
        XCTAssertEqual(mockDelegate.capturedExpressionTypes.count, 1, "Should capture exactly one type for index \(index)", file: file, line: line)
        XCTAssertEqual(mockDelegate.capturedExpressionTypes.first, expectedType, "Should capture correct type for index \(index)", file: file, line: line)
    }
}

// MARK: - CategoryModel Tests

extension CategoryViewModelTests {
    
    /// Test CategoryModel initialization and properties
    func test_CategoryModel_Initialization() {
        // Given
        let iconName = "test_icon"
        let categoryName = "test_category"
        let expressionType = MathExpression.ExpressionType.addition
        
        // When
        let categoryModel = CategoryModel(
            iconName: iconName,
            categoryName: categoryName,
            expressionType: expressionType
        )
        
        // Then
        XCTAssertEqual(categoryModel.iconName, iconName, "Icon name should be set correctly")
        XCTAssertEqual(categoryModel.categoryName, categoryName, "Category name should be set correctly")
        XCTAssertEqual(categoryModel.expressionType, expressionType, "Expression type should be set correctly")
    }
    
    /// Test CategoryModel with different expression types
    func test_CategoryModel_WithDifferentExpressionTypes() {
        // Given
        let expressionTypes: [MathExpression.ExpressionType] = [.addition, .subtraction, .multiplication, .division, .mixed]
        
        // When/Then
        for (index, expressionType) in expressionTypes.enumerated() {
            let categoryModel = CategoryModel(
                iconName: "icon_\(index)",
                categoryName: "category_\(index)",
                expressionType: expressionType
            )
            
            XCTAssertEqual(categoryModel.expressionType, expressionType, "Expression type should match for index \(index)")
        }
    }
}

// MARK: - CategoryModel Test Helpers

extension CategoryModel {
    /// Creates a test category model with default or custom values
    static func makeTestCategory(
        iconName: String = "test_icon",
        categoryName: String = "test_category",
        expressionType: MathExpression.ExpressionType = .addition
    ) -> CategoryModel {
        return CategoryModel(
            iconName: iconName,
            categoryName: categoryName,
            expressionType: expressionType
        )
    }
    
    /// Creates all available categories for testing
    static func makeAllCategories() -> [CategoryModel] {
        return [
            CategoryModel(iconName: "add_icon", categoryName: "addition", expressionType: .addition),
            CategoryModel(iconName: "minus_icon", categoryName: "subtraction", expressionType: .subtraction),
            CategoryModel(iconName: "multiply_icon", categoryName: "multiplication", expressionType: .multiplication),
            CategoryModel(iconName: "divide_icon", categoryName: "division", expressionType: .division),
            CategoryModel(iconName: "random_icon", categoryName: "mixed", expressionType: .mixed)
        ]
    }
}
