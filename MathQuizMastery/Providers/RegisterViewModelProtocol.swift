//
//  RegisterViewModelProtocol.swift
//  MathQuizMastery
//
//  Created by Aydın KAYA on 6.04.2025.
//

import Foundation


protocol RegisterViewModelProtocol{
    var delegate : RegisterViewModelDelegate? {get set}
    func validateInputs(name: String?, email: String?, password: String?, confirmPassword: String?)
}
