//
//  LoginScreenViewModelProtocol.swift
//  MathQuizMastery
//
//  Created by Aydın KAYA on 1.04.2025.
//

import Foundation

protocol LoginScreenViewModelProtocol: AnyObject {
    var delegate: LoginViewModelDelegate? { get set }
    func login(email: String, password: String)
    func validateEmail(_ email: String) -> ValidationResult
    func validatePassword(_ password: String) -> ValidationResult
}
