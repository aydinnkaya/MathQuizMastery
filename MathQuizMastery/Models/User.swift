//
//  User.swift
//  MathQuizMastery
//
//  Created by AydınKaya on 21.03.2025.
//

import Foundation


struct User : Codable {
    let id: String
    let email: String
    let fullName: String
    let passwordHash: String
}
