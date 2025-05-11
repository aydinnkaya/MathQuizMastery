//
//  CategoryViewModel.swift
//  MathQuizMastery
//
//  Created by Aydın KAYA on 7.05.2025.
//

import Foundation

protocol CategoryViewModelProtocol {
    var delegate: CategoryViewModelDelegate? { get set }
    var coordinator: CategoryCoordinatorProtocol? { get set }
    var numberOfItems: Int { get }
    func categorySelected(at index: Int)
    func category(at index: Int) -> CategoryModel
}

protocol CategoryViewModelDelegate: AnyObject {
}

class CategoryViewModel : CategoryViewModelProtocol {
     
    var delegate: (any CategoryViewModelDelegate)?
    var coordinator: (any CategoryCoordinatorProtocol)?
        
    private let categories: [CategoryModel] = [
        CategoryModel(iconName: "subtract_icon", categoryName: "addition"),
        CategoryModel(iconName: "minus_icon", categoryName: "subtraction"),
        CategoryModel(iconName: "multiply_icon", categoryName: "multiplication"),
        CategoryModel(iconName: "divide_icon", categoryName: "division"),
        CategoryModel(iconName: "random_icon", categoryName: "mixed")
    ]
    
    var numberOfItems: Int {
        return categories.count
    }
    
    func category(at index: Int) -> CategoryModel {
        return categories[index]
    }
    
    
    func categorySelected(at index: Int) {
        switch index {
        case 0:
            coordinator?.navigateToGameVC(with: .addition)
        case 1:
            coordinator?.navigateToGameVC(with: .subtraction)
        case 2:
            coordinator?.navigateToGameVC(with: .multiplication)
        case 3:
            coordinator?.navigateToGameVC(with: .division)
        case 4:
            coordinator?.navigateToGameVC(with: .mixed)
        default:
            break
        }
    }
    
}
