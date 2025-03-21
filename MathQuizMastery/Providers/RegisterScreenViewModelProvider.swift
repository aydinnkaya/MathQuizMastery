//
//  RegisterScreenViewModelProvider.swift
//  MathQuizMastery
//
//  Created by AydınKaya on 21.03.2025.
//

import Foundation


protocol RegisterScreenViewModelProtocol : AnyObject {
    func savePerson(name: String, email: String, password: String)
}
