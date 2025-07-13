//
//  Localizer.swift
//  MathQuizMastery
//
//  Created by Aydın KAYA on 31.03.2025.
//

import Foundation

final class Localizer {
    static let shared = Localizer()
    
    // Uygulama içi dil değiştirme desteği için
    private(set) var currentLanguage: String = Locale.preferredLanguages.first?.components(separatedBy: "-").first ?? "en" {
        didSet {
            loadTranslations()
        }
    }
    
    private var translations: [String: [String: String]] = [:]
    private let localizationFileName = "LocalizableTexts"
    private let localizationFileExtension = "json"
    private let debugMode = true
    private(set) var isLoaded: Bool = false
    private var onLoadedBlocks: [() -> Void] = []
    
    private init() {
        loadTranslations()
    }
    
    func setLanguage(_ language: String) {
        currentLanguage = language
    }
    
    private func loadTranslations() {
        print("[Localizer-DEBUG] Bundle path: \(Bundle.main.bundlePath)")
        if let url = Bundle.main.url(forResource: self.localizationFileName, withExtension: self.localizationFileExtension) {
            print("[Localizer-DEBUG] LocalizableTexts.json bulundu: \(url)")
        } else {
            print("[Localizer-DEBUG] LocalizableTexts.json bulunamadı!")
        }
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            guard let url = Bundle.main.url(forResource: self.localizationFileName, withExtension: self.localizationFileExtension) else {
                self.log("[Localizer] Error: \(self.localizationFileName).\(self.localizationFileExtension) not found in bundle.")
                DispatchQueue.main.async {
                    self.translations = [:]
                    self.isLoaded = true
                    self.notifyLoaded()
                }
                return
            }
            do {
                let data = try Data(contentsOf: url)
                let decoded = try JSONDecoder().decode([String: [String: String]].self, from: data)
                DispatchQueue.main.async {
                    self.translations = decoded
                    self.isLoaded = true
                    self.notifyLoaded()
                    self.log("[Localizer] Translations loaded. Available keys: \(self.translations.keys.count)")
                    print("[Localizer-DEBUG] Available keys: \(self.translations.keys.sorted())")
                }
            } catch {
                DispatchQueue.main.async {
                    self.log("[Localizer] JSON decode error: \(error.localizedDescription)")
                    print("[Localizer-DEBUG] JSON decode error: \(error.localizedDescription)")
                    self.translations = [:]
                    self.isLoaded = true
                    self.notifyLoaded()
                }
            }
        }
    }
    
    private func notifyLoaded() {
        onLoadedBlocks.forEach { $0() }
        onLoadedBlocks.removeAll()
    }
    
    func onLoaded(_ block: @escaping () -> Void) {
        if isLoaded {
            block()
        } else {
            onLoadedBlocks.append(block)
        }
    }
    
    func localized(for key: LocalizedKey) -> String {
        guard let values = translations[key.rawValue] else {
            log("[Localizer] Missing key: \(key.rawValue)")
            return key.rawValue
        }
        // Önce tam dil kodu (örn: tr-TR) ile dene
        if let exact = values[currentLanguage] {
            return exact
        }
        // Sadece dil kodu (örn: tr) ile dene
        let langCode = currentLanguage.components(separatedBy: "-").first ?? currentLanguage
        if let fallback = values[langCode] {
            return fallback
        }
        // İngilizce fallback
        if let en = values["en"] {
            return en
        }
        // Hiçbiri yoksa anahtarın kendisi
        log("[Localizer] No translation for key: \(key.rawValue) in language: \(currentLanguage)")
        return key.rawValue
    }
    
    private func log(_ message: String) {
        if debugMode {
            print(message)
        }
    }
    
    // DEBUG: Test fonksiyonu
    func debugCheckLocalization() {
        print("[Localizer-DEBUG] Current language: \(currentLanguage)")
        if let url = Bundle.main.url(forResource: self.localizationFileName, withExtension: self.localizationFileExtension) {
            print("[Localizer-DEBUG] LocalizableTexts.json bulundu: \(url)")
        } else {
            print("[Localizer-DEBUG] LocalizableTexts.json bulunamadı!")
        }
        print("[Localizer-DEBUG] Loaded keys: \(translations.keys.sorted())")
        if let value = translations["result_score_text"] {
            print("[Localizer-DEBUG] result_score_text: \(value)")
        } else {
            print("[Localizer-DEBUG] result_score_text anahtarı bulunamadı!")
        }
    }
}

func L(_ key: LocalizedKey) -> String {
    return Localizer.shared.localized(for: key)
}
