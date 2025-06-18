//
//  Localizer.swift
//  MathQuizMastery
//
//  Created by Aydın KAYA on 31.03.2025.
//

import Foundation

final class Localizer {
    static let shared = Localizer()
    
    private var currentLanguage: String {
        if #available(iOS 16, *) {
            let languageCode = Locale.current.language.languageCode?.identifier ?? "en"
            let regionCode = Locale.current.region?.identifier
            
            // Check if we have a translation for the full language-region code
            let fullCode = regionCode != nil ? "\(languageCode)-\(regionCode!)" : languageCode
            if translations.values.first?[fullCode] != nil {
                return fullCode
            }
            
            // Fallback to just the language code
            return languageCode
        } else {
            // For older iOS versions, try to get the preferred language
            let preferredLanguage = Bundle.main.preferredLocalizations.first ?? "en"
            return preferredLanguage
        }
    }

    private var translations: [String: [String: String]] = [:]

    private init() {
        loadTranslations()
    }

    private func loadTranslations() {
        guard let url = Bundle.main.url(forResource: "LocalizableTexts", withExtension: "json") else {
            print("Error: LocalizableTexts.json not found.")
            return
        }

        do {
            let data = try Data(contentsOf: url)
            translations = try JSONDecoder().decode([String: [String: String]].self, from: data)
        } catch {
            print("JSON decode error: \(error.localizedDescription)")
        }
    }

    func localized(for key: LocalizedKey) -> String {
        guard let translations = translations[key.rawValue] else {
            return key.rawValue
        }
        
        // Try exact match first
        if let exactMatch = translations[currentLanguage] {
            return exactMatch
        }
        
        // If no exact match, try language code without region
        let languageCode = currentLanguage.split(separator: "-").first.map(String.init) ?? currentLanguage
        if let languageMatch = translations[languageCode] {
            return languageMatch
        }
        
        // Fallback to English
        return translations["en"] ?? key.rawValue
    }
}

func L(_ key: LocalizedKey) -> String {
    return Localizer.shared.localized(for: key)
}
