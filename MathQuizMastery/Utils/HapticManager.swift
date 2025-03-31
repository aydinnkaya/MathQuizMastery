//
//  HapticManager.swift
//  MathQuizMastery
//
//  Created by Aydın KAYA on 31.03.2025.
//

import Foundation
import UIKit

final class HapticManager {
    static let shared = HapticManager()

    private let notificationGenerator = UINotificationFeedbackGenerator()
    private let impactGenerator = UIImpactFeedbackGenerator(style: .medium)

    private init() {}

    func notify(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        notificationGenerator.prepare()
        notificationGenerator.notificationOccurred(type)
    }

    func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.prepare()
        generator.impactOccurred()
    }

    func success() {
        notify(.success)
    }

    func warning() {
        notify(.warning)
    }

    func error() {
        notify(.error)
    }

    func lightImpact() {
        impact(.light)
    }

    func mediumImpact() {
        impact(.medium)
    }

    func heavyImpact() {
        impact(.heavy)
    }
}
