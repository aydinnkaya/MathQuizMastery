//
//  CategoryIconsHelper.swift
//  MathQuizMastery
//
//  Created by AydınKaya on 22.07.2025.
//

import UIKit
import Foundation

// MARK: - Category Icons Helper
/// Kategori ikonlarını yönetmek için yardımcı sınıf
/// Bu sınıf hem sistemsel ikonları hem de özel ikon dosyalarını destekler
class CategoryIconsHelper {
    
    // MARK: - Singleton
    static let shared = CategoryIconsHelper()
    private init() {}
    
    // MARK: - Icon Mapping
    /// Kategori ikonlarının mapping'i
    /// Her kategori için ikon ismi ve fall-back sistem ikonu tanımlanır
    private let iconMappings: [String: IconInfo] = [
        // Temel İşlemler
        "category_addition": IconInfo(
            customIcon: "category_addition",
            systemIcon: "plus.circle.fill",
            backgroundColor: .systemBlue
        ),
        
        "category_subtraction": IconInfo(
            customIcon: "category_subtraction",
            systemIcon: "minus.circle.fill",
            backgroundColor: .systemOrange
        ),
        
        "category_multiplication": IconInfo(
            customIcon: "category_multiplication",
            systemIcon: "multiply.circle.fill",
            backgroundColor: .systemPurple
        ),
        
        // Özel Kategoriler
        "category_multiplication_table": IconInfo(
            customIcon: "category_multiplication_table",
            systemIcon: "tablecells.fill",
            backgroundColor: .systemRed
        ),
        
        "category_order_operations": IconInfo(
            customIcon: "category_order_operations",
            systemIcon: "function",
            backgroundColor: .systemBlue
        ),
        
        "category_negative_numbers": IconInfo(
            customIcon: "category_negative_numbers",
            systemIcon: "minus.plus.batteryblock.fill",
            backgroundColor: .systemGreen
        ),
        
        // Kesirler ve Yüzdeler
        "category_fractions": IconInfo(
            customIcon: "category_fractions",
            systemIcon: "divide.circle.fill",
            backgroundColor: .systemIndigo
        ),
        
        "category_percentages": IconInfo(
            customIcon: "category_percentages",
            systemIcon: "percent",
            backgroundColor: .systemPurple
        ),
        
        // Geometri
        "category_geometric_shapes": IconInfo(
            customIcon: "category_geometric_shapes",
            systemIcon: "triangle.circle.fill",
            backgroundColor: .systemYellow
        ),
        
        // Zaman
        "category_time_clock": IconInfo(
            customIcon: "category_time_clock",
            systemIcon: "clock.fill",
            backgroundColor: .systemTeal
        ),
        
        // Zihinsel Matematik
        "category_mental_math": IconInfo(
            customIcon: "category_mental_math",
            systemIcon: "brain.head.profile",
            backgroundColor: .systemGreen
        ),
        
        // Rastgele Karışık
        "category_random_mixed": IconInfo(
            customIcon: "category_random_mixed",
            systemIcon: "shuffle.circle.fill",
            backgroundColor: .systemPink
        )
    ]
    
    // MARK: - Public Methods
    
    /// Belirtilen ikon ismini kullanarak UIImage döner
    /// - Parameter iconName: İkon ismi
    /// - Returns: UIImage veya nil
    func getIcon(for iconName: String) -> UIImage? {
        guard let iconInfo = iconMappings[iconName] else {
            // Mapping bulunamazsa varsayılan ikon döndür
            return getDefaultIcon()
        }
        
        // Önce custom ikonu dene
        if let customImage = UIImage(named: iconInfo.customIcon) {
            return customImage.withRenderingMode(.alwaysTemplate)
        }
        
        // Custom ikon bulunamazsa sistem ikonunu kullan
        if let systemImage = UIImage(systemName: iconInfo.systemIcon) {
            let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .medium)
            return systemImage.withConfiguration(config).withRenderingMode(.alwaysTemplate)
        }
        
        // Her şey başarısız olursa varsayılan ikon
        return getDefaultIcon()
    }
    
    /// Kategori için renk bilgisini döner
    /// - Parameter iconName: İkon ismi
    /// - Returns: UIColor
    func getBackgroundColor(for iconName: String) -> UIColor {
        return iconMappings[iconName]?.backgroundColor ?? .systemBlue
    }
    
    /// Tüm kategori ikonlarının mevcut olup olmadığını kontrol eder
    /// - Returns: Kontrol raporu
    func validateIcons() -> IconValidationReport {
        var missingCustomIcons: [String] = []
        var availableIcons: [String] = []
        var systemFallbacks: [String] = []
        
        for (iconName, iconInfo) in iconMappings {
            if UIImage(named: iconInfo.customIcon) != nil {
                availableIcons.append(iconName)
            } else {
                missingCustomIcons.append(iconName)
                if UIImage(systemName: iconInfo.systemIcon) != nil {
                    systemFallbacks.append(iconName)
                }
            }
        }
        
        return IconValidationReport(
            totalIcons: iconMappings.count,
            availableCustomIcons: availableIcons.count,
            missingCustomIcons: missingCustomIcons,
            systemFallbacks: systemFallbacks
        )
    }
    
    /// Varsayılan ikonu döner
    /// - Returns: Varsayılan UIImage
    private func getDefaultIcon() -> UIImage? {
        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .medium)
        return UIImage(systemName: "questionmark.circle.fill")?
            .withConfiguration(config)
            .withRenderingMode(.alwaysTemplate)
    }
}

// MARK: - Icon Info Structure
/// İkon bilgilerini tutan yapı
struct IconInfo {
    let customIcon: String          // Özel ikon dosya adı
    let systemIcon: String          // Sistem ikonu adı (fallback)
    let backgroundColor: UIColor    // Arka plan rengi
}

// MARK: - Icon Validation Report
/// İkon doğrulama raporu yapısı
struct IconValidationReport {
    let totalIcons: Int                    // Toplam ikon sayısı
    let availableCustomIcons: Int          // Mevcut custom ikon sayısı
    let missingCustomIcons: [String]       // Eksik custom ikonlar
    let systemFallbacks: [String]          // Sistem ikonu kullanılan kategoriler
    
    /// Validasyon başarılı mı?
    var isValid: Bool {
        return missingCustomIcons.isEmpty
    }
    
    /// Raporu konsola yazdır
    func printReport() {
        print("🔍 İkon Validasyon Raporu:")
        print("📊 Toplam İkon: \(totalIcons)")
        print("✅ Mevcut Custom İkonlar: \(availableCustomIcons)")
        print("⚠️ Eksik Custom İkonlar: \(missingCustomIcons.count)")
        
        if !missingCustomIcons.isEmpty {
            print("🚨 Eksik İkonlar:")
            missingCustomIcons.forEach { iconName in
                print("   - \(iconName)")
            }
        }
        
        if !systemFallbacks.isEmpty {
            print("🔄 Sistem İkonu Kullanılanlar:")
            systemFallbacks.forEach { iconName in
                print("   - \(iconName)")
            }
        }
        
        print("🏁 Durum: \(isValid ? "✅ Tüm ikonlar mevcut" : "⚠️ Bazı ikonlar eksik")")
    }
}

// MARK: - Category Icons Extension
/// MathCategory için ikon yardımcı extension'ı
extension MathCategory {
    
    /// Kategorinin ikonunu döner
    var icon: UIImage? {
        return CategoryIconsHelper.shared.getIcon(for: iconName)
    }
    
    /// Kategorinin arka plan rengini döner (IconHelper'dan)
    var helperBackgroundColor: UIColor {
        return CategoryIconsHelper.shared.getBackgroundColor(for: iconName)
    }
}

// MARK: - Icon Assets Generator
/// Development amaçlı - ikon asset'lerini programlı olarak oluşturmak için
class CategoryIconGenerator {
    
    /// Kategori için programlı ikon oluşturur (özel ikon dosyası yoksa)
    /// - Parameters:
    ///   - category: Kategori bilgisi
    ///   - size: İkon boyutu
    /// - Returns: Oluşturulan UIImage
    static func generateIcon(for category: MathCategory, size: CGSize = CGSize(width: 60, height: 60)) -> UIImage? {
        
        // Canvas oluştur
        let renderer = UIGraphicsImageRenderer(size: size)
        
        return renderer.image { context in
            let cgContext = context.cgContext
            
            // Arka plan circle
            cgContext.setFillColor(category.backgroundColor.cgColor)
            cgContext.fillEllipse(in: CGRect(origin: .zero, size: size))
            
            // İkon için sistem sembolü
            let symbolName = getSymbolName(for: category)
            let config = UIImage.SymbolConfiguration(pointSize: size.width * 0.4, weight: .medium)
            
            if let symbolImage = UIImage(systemName: symbolName)?.withConfiguration(config) {
                let symbolSize = symbolImage.size
                let symbolOrigin = CGPoint(
                    x: (size.width - symbolSize.width) / 2,
                    y: (size.height - symbolSize.height) / 2
                )
                
                // Beyaz renkte symbol çiz
                cgContext.saveGState()
                cgContext.translateBy(x: symbolOrigin.x, y: symbolOrigin.y)
                cgContext.scaleBy(x: 1, y: -1)
                cgContext.translateBy(x: 0, y: -symbolSize.height)
                
                if let cgImage = symbolImage.cgImage {
                    cgContext.setFillColor(UIColor.white.cgColor)
                    cgContext.draw(cgImage, in: CGRect(origin: .zero, size: symbolSize))
                }
                
                cgContext.restoreGState()
            }
        }
    }
    
    /// Kategori tipine göre uygun sistem sembol ismini döner
    /// - Parameter category: Kategori
    /// - Returns: Sistem sembol ismi
    private static func getSymbolName(for category: MathCategory) -> String {
        switch category.expressionType {
        case .addition:
            return "plus"
        case .subtraction:
            return "minus"
        case .multiplication:
            return "multiply"
        case .multiplicationTable:
            return "grid"
        case .orderOfOperations:
            return "function"
        case .negativeNumbers:
            return "plusminus"
        case .fractions:
            return "divide"
        case .percentages:
            return "percent"
        case .geometricShapes:
            return "triangle"
        case .timeAndClock:
            return "clock"
        case .mentalMath:
            return "brain"
        case .randomMixed:
            return "shuffle"
        default:
            return "questionmark"
        }
    }
}

// MARK: - Usage Example and Setup
extension CategoryIconsHelper {
    
    /// Geliştirme ortamında ikon kontrolü yapmak için yardımcı method
    func performIconCheck() {
        print("🔧 Kategori İkonları Kontrol Ediliyor...")
        
        let report = validateIcons()
        report.printReport()
        
        // Eğer custom ikonlar eksikse, programlı ikonları oluştur
        if !report.isValid {
            print("🎨 Eksik ikonlar için programlı ikonlar oluşturuluyor...")
            generateMissingIcons(report.missingCustomIcons)
        }
    }
    
    /// Eksik ikonları programlı olarak oluşturur (development için)
    private func generateMissingIcons(_ missingIcons: [String]) {
        let categories = MathCategoryFactory.shared.getAllCategories()
        
        for iconName in missingIcons {
            if let category = categories.first(where: { $0.iconName == iconName }) {
                if let generatedIcon = CategoryIconGenerator.generateIcon(for: category) {
                    print("✨ Programlı ikon oluşturuldu: \(iconName)")
                    // Burada ikon'u kaydetme işlemi yapılabilir
                    // saveGeneratedIcon(generatedIcon, name: iconName)
                }
            }
        }
    }
}
