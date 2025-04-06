//
//  Localizer.swift
//  MathQuizMastery
//
//  Created by Aydın KAYA on 31.03.2025.
//

import Foundation

import Foundation

final class Localizer {
    static let shared = Localizer()
    
    private var currentLanguage: String {
        if #available(iOS 16, *) {
            return Locale.current.language.languageCode?.identifier ?? "en"
        } else {
            return "en"
        }
    }

    private var translations: [String: [String: String]] = [:]

    private init() {
        loadTranslations()
    }

    private func loadTranslations() {
        guard let url = Bundle.main.url(forResource: "LocalizableTexts", withExtension: "json") else {
            print("LocalizableTexts.json bulunamadı.")
            return
        }

        do {
            let data = try Data(contentsOf: url)
            translations = try JSONDecoder().decode([String: [String: String]].self, from: data)
        } catch {
            print("JSON decode hatası: \(error.localizedDescription)")
        }
    }

    func localized(for key: LocalizedKey) -> String {
        return translations[key.rawValue]?[currentLanguage] ?? key.rawValue
    }
}

func L(_ key: LocalizedKey) -> String {
    if #available(iOS 16, *) {
        return Localizer.shared.localized(for: key)
    } else {
        return NSLocalizedString(key.rawValue, comment: "")
    }
}
