//
//  SettingItem.swift
//  MathQuizMastery
//
//  Created by Aydın KAYA on 25.05.2025.
//

import Foundation

enum SettingType {
    case profile
    case notifications
    case faq
    case report
    case logout
}

struct SettingItem {
    let title: String
    let iconName: String
    let type: SettingType
}
