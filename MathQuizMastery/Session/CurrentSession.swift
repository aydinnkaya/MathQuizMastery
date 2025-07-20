//
//  CurrentSession.swift
//  MathQuizMastery
//
//  Created by Aydın KAYA on 20.07.2025.
//

import Foundation

final class CurrentSession {
    static let shared = CurrentSession()
    
    private init() {}
    
    var user: AppUser?
    
    var isGuest: Bool {
        return user?.isGuest ?? false
    }

    var uid: String? {
        return user?.uid
    }

    var username: String? {
        return user?.username
    }

    var avatarImageName: String? {
        return user?.avatarImageName
    }

    var coin: Int {
        return user?.coin ?? 0
    }
}
