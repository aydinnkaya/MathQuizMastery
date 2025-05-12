//
//  CategoryViewModel.swift
//  MathQuizMastery
//
//  Created by Aydın KAYA on 7.05.2025.
//

import Foundation

protocol CategoryViewModelProtocol {
    var delegate: CategoryViewModelDelegate? { get set }
    var numberOfItems: Int { get }
    func categorySelected(at index: Int)
    func category(at index: Int) -> CategoryModel
}

protocol CategoryViewModelDelegate: AnyObject {
    func navigateToGameVC(with type: MathExpression.ExpressionType)
}

class CategoryViewModel : CategoryViewModelProtocol {
    
    var delegate: (any CategoryViewModelDelegate)?
    
    private let categories: [CategoryModel] = [
        CategoryModel(iconName: "subtract_icon", categoryName: "addition", expressionType: .addition),
        CategoryModel(iconName: "minus_icon", categoryName: "subtraction", expressionType: .subtraction),
        CategoryModel(iconName: "multiply_icon", categoryName: "multiplication", expressionType: .multiplication),
        CategoryModel(iconName: "divide_icon", categoryName: "division", expressionType: .division),
        CategoryModel(iconName: "random_icon", categoryName: "mixed", expressionType: .mixed)
    ]
    
    var numberOfItems: Int {
        return categories.count
    }
    
    func category(at index: Int) -> CategoryModel {
        return categories[index]
    }
    
    func categorySelected(at index: Int) {
        let selectedCategory = categories[index]
        delegate?.navigateToGameVC(with: selectedCategory.expressionType)
    }
    
}
