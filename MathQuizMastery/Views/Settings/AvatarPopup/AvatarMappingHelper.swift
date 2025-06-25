//
//  AvatarMappingHelper.swift
//  MathQuizMastery
//
//  Created by AydınKaya on 17.06.2025.
//

import Foundation

struct AvatarMappingHelper {
    
    // MARK: - Avatar Icon'dan Image'e Dönüştürme Sözlüğü
    private static let iconToImageMapping: [String: String] = [
        "profile_icon_1": "profile_image_1",
        "profile_icon_2": "profile_image_2",
        "profile_icon_3": "profile_image_3",
        "profile_icon_4": "profile_image_4",
        "profile_icon_5": "profile_image_5",
        "profile_icon_6": "profile_image_6",
        "profile_icon_7": "profile_image_7",
        "profile_icon_8": "profile_image_8",
        "profile_icon_9": "profile_image_9",
        "profile_icon_10": "profile_image_10",
        "profile_icon_11": "profile_image_11",
        "profile_icon_12": "profile_image_12",
        "profile_icon_13": "profile_image_13",
        "profile_icon_14": "profile_image_14",
        "profile_icon_15": "profile_image_15",
        "profile_icon_16": "profile_image_16",
        "profile_icon_17": "profile_image_17",
        "profile_icon_18": "profile_image_18",
        "profile_icon_19": "profile_image_19"
    ]
    
    // MARK: - Image'dan Icon'a Dönüştürme Sözlüğü
    private static let imageToIconMapping: [String: String] = [
        "profile_image_1": "profile_icon_1",
        "profile_image_2": "profile_icon_2",
        "profile_image_3": "profile_icon_3",
        "profile_image_4": "profile_icon_4",
        "profile_image_5": "profile_icon_5",
        "profile_image_6": "profile_icon_6",
        "profile_image_7": "profile_icon_7",
        "profile_image_8": "profile_icon_8",
        "profile_image_9": "profile_icon_9",
        "profile_image_10": "profile_icon_10",
        "profile_image_11": "profile_icon_11",
        "profile_image_12": "profile_icon_12",
        "profile_image_13": "profile_icon_13",
        "profile_image_14": "profile_icon_14",
        "profile_image_15": "profile_icon_15",
        "profile_image_16": "profile_icon_16",
        "profile_image_17": "profile_icon_17",
        "profile_image_18": "profile_icon_18",
        "profile_image_19": "profile_icon_19"
    ]
    
    // MARK: - Public Methods
    
    /// Avatar icon ismini büyük image ismine dönüştürür
    /// - Parameter iconName: Küçük avatar icon ismi (örn: "profile_icon_1")
    /// - Returns: Büyük avatar image ismi (örn: "profile_image_1")
    static func getImageName(from iconName: String) -> String {
        return iconToImageMapping[iconName] ?? "profile_image_1" // Varsayılan değer
    }
    
    /// Avatar image ismini küçük icon ismine dönüştürür
    /// - Parameter imageName: Büyük avatar image ismi (örn: "profile_image_1")
    /// - Returns: Küçük avatar icon ismi (örn: "profile_icon_1")
    static func getIconName(from imageName: String) -> String {
        return imageToIconMapping[imageName] ?? "profile_icon_1" // Varsayılan değer
    }
    
    /// Tüm mevcut icon isimlerini döndürür
    /// - Returns: Tüm avatar icon isimleri dizisi
    static func getAllIconNames() -> [String] {
        return Array(iconToImageMapping.keys).sorted { icon1, icon2 in
            let number1 = extractNumber(from: icon1)
            let number2 = extractNumber(from: icon2)
            return number1 < number2
        }
    }
    
    /// Tüm mevcut image isimlerini döndürür
    /// - Returns: Tüm avatar image isimleri dizisi
    static func getAllImageNames() -> [String] {
        return Array(imageToIconMapping.keys).sorted { image1, image2 in
            let number1 = extractNumber(from: image1)
            let number2 = extractNumber(from: image2)
            return number1 < number2
        }
    }
    
    /// Avatar isminin geçerli olup olmadığını kontrol eder
    /// - Parameter name: Kontrol edilecek avatar ismi
    /// - Returns: Geçerli ise true, değilse false
    static func isValidAvatarName(_ name: String) -> Bool {
        return iconToImageMapping.keys.contains(name) || imageToIconMapping.keys.contains(name)
    }
    
    // MARK: - Private Helper Methods
    
    /// String'den sayı çıkarır (sıralama için)
    private static func extractNumber(from string: String) -> Int {
        let numbers = string.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        return Int(numbers) ?? 0
    }
}

// MARK: - Extension for Easy Usage
extension String {
    
    /// Avatar icon ismini image ismine dönüştürür
    var toAvatarImageName: String {
        return AvatarMappingHelper.getImageName(from: self)
    }
    
    /// Avatar image ismini icon ismine dönüştürür
    var toAvatarIconName: String {
        return AvatarMappingHelper.getIconName(from: self)
    }
    
    /// Avatar isminin geçerli olup olmadığını kontrol eder
    var isValidAvatarName: Bool {
        return AvatarMappingHelper.isValidAvatarName(self)
    }
}

