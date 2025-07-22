//
//  MathCategory.swift
//  MathQuizMastery
//
//  Created by AydınKaya on 22.07.2025.
//

import Foundation
import UIKit

// MARK: - Math Category Model
/// Matematik kategorilerini temsil eden model yapısı
struct MathCategory {
    // MARK: - Properties
    let id: Int                    // Benzersiz kategori ID'si
    let title: String             // Kategori başlığı
    let iconName: String          // İkon dosya adı
    let backgroundColor: UIColor  // Arka plan rengi
    let expressionType: MathExpression.ExpressionType  // İşlem tipi
    let isNew: Bool               // Yeni kategori işareti
    
    // MARK: - Initializer
    /// MathCategory başlatıcı metodu
    /// - Parameters:
    ///   - id: Kategori ID'si
    ///   - title: Kategori başlığı
    ///   - iconName: İkon adı
    ///   - backgroundColor: Arka plan rengi
    ///   - expressionType: Matematik işlem tipi
    ///   - isNew: Yeni kategori mi
    init(id: Int, title: String, iconName: String, backgroundColor: UIColor, expressionType: MathExpression.ExpressionType, isNew: Bool = false) {
        self.id = id
        self.title = title
        self.iconName = iconName
        self.backgroundColor = backgroundColor
        self.expressionType = expressionType
        self.isNew = isNew
    }
}

// MARK: - Category Factory
/// Kategori üretici sınıfı - Tüm matematik kategorilerini sağlar
class MathCategoryFactory {
    
    // MARK: - Singleton
    static let shared = MathCategoryFactory()
    private init() {}
    
    // MARK: - Categories Data
    /// Tüm matematik kategorilerinin listesini döner
    /// - Returns: MathCategory dizisi
    func getAllCategories() -> [MathCategory] {
        return [
            // Temel İşlemler
            MathCategory(
                id: 1,
                title: L(.addition), // "TOPLAMA"
                iconName: "category_addition",
                backgroundColor: UIColor.systemBlue,
                expressionType: .addition
            ),
            
            MathCategory(
                id: 2,
                title: L(.subtraction), // "ÇIKARMA"
                iconName: "category_subtraction",
                backgroundColor: UIColor.systemOrange,
                expressionType: .subtraction
            ),
            
            MathCategory(
                id: 3,
                title: L(.multiplication), // "ÇARPMA"
                iconName: "category_multiplication",
                backgroundColor: UIColor.systemPurple,
                expressionType: .multiplication
            ),
            
            // Özel Kategoriler
            MathCategory(
                id: 4,
                title: L(.multiplication_table), // "ÇARPIM TABLOSU"
                iconName: "category_multiplication_table",
                backgroundColor: UIColor.systemRed,
                expressionType: .multiplicationTable,
                isNew: true
            ),
            
            MathCategory(
                id: 5,
                title: L(.order_of_operations), // "İŞLEM ÖNCELİĞİ"
                iconName: "category_order_operations",
                backgroundColor: UIColor.systemBlue,
                expressionType: .orderOfOperations
            ),
            
            MathCategory(
                id: 6,
                title: L(.negative_numbers), // "NEGATİF SAYILAR"
                iconName: "category_negative_numbers",
                backgroundColor: UIColor.systemGreen,
                expressionType: .negativeNumbers
            ),
            
            // Kesirler ve Yüzdeler
            MathCategory(
                id: 7,
                title: L(.fractions), // "KESİRLER"
                iconName: "category_fractions",
                backgroundColor: UIColor.systemIndigo,
                expressionType: .fractions
            ),
            
            MathCategory(
                id: 8,
                title: L(.percentages), // "YÜZDELER"
                iconName: "category_percentages",
                backgroundColor: UIColor.systemPurple,
                expressionType: .percentages
            ),
            
            // Geometri ve Şekiller
            MathCategory(
                id: 9,
                title: L(.geometric_shapes), // "GEOMETRİK ŞEKİLLER"
                iconName: "category_geometric_shapes",
                backgroundColor: UIColor.systemYellow,
                expressionType: .geometricShapes
            ),
            
            // Zaman ve Saat
            MathCategory(
                id: 10,
                title: L(.time_and_clock), // "SAAT VE ZAMAN"
                iconName: "category_time_clock",
                backgroundColor: UIColor.systemTeal,
                expressionType: .timeAndClock
            ),
            
            // Zihinsel Matematik
            MathCategory(
                id: 11,
                title: L(.mental_math), // "ZİHİNSEL MATEMATİK"
                iconName: "category_mental_math",
                backgroundColor: UIColor.systemGreen,
                expressionType: .mentalMath
            ),
            
            // Rastgele Karışık
            MathCategory(
                id: 12,
                title: L(.random_mixed), // "RASTGELE KARIŞTIR"
                iconName: "category_random_mixed",
                backgroundColor: UIColor.systemPink,
                expressionType: .randomMixed
            )
        ]
    }
    
    // MARK: - Helper Methods
    /// ID'ye göre kategori bulur
    /// - Parameter id: Kategori ID'si
    /// - Returns: MathCategory veya nil
    func getCategoryById(_ id: Int) -> MathCategory? {
        return getAllCategories().first { $0.id == id }
    }
    
    /// Yeni kategorileri döner
    /// - Returns: Yeni işaretli kategoriler
    func getNewCategories() -> [MathCategory] {
        return getAllCategories().filter { $0.isNew }
    }
}

// MARK: - Extensions
extension MathCategory: Equatable {
    static func == (lhs: MathCategory, rhs: MathCategory) -> Bool {
        return lhs.id == rhs.id
    }
}

extension MathCategory: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

//// MARK: - Localization Helper (Örnek)
///// Çoklu dil desteği için yardımcı fonksiyon
///// Bu fonksiyonu projenizin lokalizasyon yapısına göre güncelleyin
//private func L(_ key: LocalizedKey) -> String {
//    // Şu an için statik değerler, gerçek projede NSLocalizedString kullanın
//    switch key {
//    case .addition: return "TOPLAMA"
//    case .subtraction: return "ÇIKARMA"
//    case .multiplication: return "ÇARPMA"
//    case .multiplication_table: return "ÇARPIM TABLOSU"
//    case .order_of_operations: return "İŞLEM ÖNCELİĞİ"
//    case .negative_numbers: return "NEGATİF SAYILAR"
//    case .fractions: return "KESİRLER"
//    case .percentages: return "YÜZDELER"
//    case .geometric_shapes: return "GEOMETRİK ŞEKİLLER"
//    case .time_and_clock: return "SAAT VE ZAMAN"
//    case .mental_math: return "ZİHİNSEL MATEMATİK"
//    case .random_mixed: return "RASTGELE KARIŞTIR"
//    }
//}
//
//// MARK: - Localization Keys
//private enum LocalizedKey {
//    case addition
//    case subtraction
//    case multiplication
//    case multiplication_table
//    case order_of_operations
//    case negative_numbers
//    case fractions
//    case percentages
//    case geometric_shapes
//    case time_and_clock
//    case mental_math
//    case random_mixed
//}
