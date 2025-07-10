//
//  RegiserUserRequest.swift
//  MathQuizMastery
//
//  Created by Aydın KAYA on 27.04.2025.
//

import Foundation

struct RegisterUserRequest {
    let username: String
    let email: String
    let password: String
    
    // Validation
    var isValid: Bool {
        return !username.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
               !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
               !password.isEmpty &&
               username.count >= 3 &&
               username.count <= 20
    }
}
