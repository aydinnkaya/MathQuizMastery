//
//  CategoryViewModel.swift
//  MathQuizMastery
//
//  Created by Aydın KAYA on 7.05.2025.
//

import Foundation

class CategoryViewModel {
    
    private let categories: [CategoryModel] = [
        CategoryModel(iconName: "subtract_icon", categoryName: "Addition"),
        CategoryModel(iconName: "minus_icon", categoryName: "Subtraction"),
        CategoryModel(iconName: "multiply_icon", categoryName: "Multiplication"),
        CategoryModel(iconName: "divide_icon", categoryName: "Division"),
        CategoryModel(iconName: "random_icon", categoryName: "Random")
    ]
    
    var numberOfItems: Int {
        return categories.count
    }
    
    func category(at index: Int) -> CategoryModel {
        return categories[index]
    }
}
