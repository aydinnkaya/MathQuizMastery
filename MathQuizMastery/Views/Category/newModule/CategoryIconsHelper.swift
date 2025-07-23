//
//  CategoryIconsHelper.swift
//  MathQuizMastery
//
//  Created by AydınKaya on 22.07.2025.
//

import UIKit
import Foundation

// MARK: - Enhanced Category Icons Helper
/// Kategori ikonlarını yönetmek için gelişmiş yardımcı sınıf
/// Direct Colored Glass sistemi için optimize edilmiş
class CategoryIconsHelper {
    
    // MARK: - Singleton
    static let shared = CategoryIconsHelper()
    private init() {
        print("✅ CategoryIconsHelper initialized for Direct Colored Glass")
    }
    
    // MARK: - Enhanced Icon Mapping
    /// Gelişmiş kategori ikonlarının mapping'i
    /// Her kategori için ikon ismi, fallback sistem ikonu ve renk tanımlanır
    private let iconMappings: [String: IconInfo] = [
        // Temel İşlemler - ENHANCED
        "addition": IconInfo(
            customIcon: "category_addition",
            systemIcon: "plus.circle.fill",
            backgroundColor: .systemBlue,
            alternativeSystemIcons: ["plus", "plus.circle"]
        ),
        
        "subtraction": IconInfo(
            customIcon: "category_subtraction",
            systemIcon: "minus.circle.fill",
            backgroundColor: .systemOrange,
            alternativeSystemIcons: ["minus", "minus.circle"]
        ),
        
        "multiplication": IconInfo(
            customIcon: "category_multiplication",
            systemIcon: "multiply.circle.fill",
            backgroundColor: .systemPurple,
            alternativeSystemIcons: ["multiply", "xmark"]
        ),
        
        "division": IconInfo(
            customIcon: "category_division",
            systemIcon: "divide.circle.fill",
            backgroundColor: .systemIndigo,
            alternativeSystemIcons: ["divide", "slash.circle"]
        ),
        
        // Özel Kategoriler - ENHANCED
        "multiplication_table": IconInfo(
            customIcon: "category_multiplication_table",
            systemIcon: "tablecells.fill",
            backgroundColor: .systemRed,
            alternativeSystemIcons: ["grid", "square.grid.3x3.fill"]
        ),
        
        "order_of_operations": IconInfo(
            customIcon: "category_order_operations",
            systemIcon: "function",
            backgroundColor: .systemBlue,
            alternativeSystemIcons: ["f.cursive", "textformat.123"]
        ),
        
        "negative_numbers": IconInfo(
            customIcon: "category_negative_numbers",
            systemIcon: "plusminus.circle.fill",
            backgroundColor: .systemGreen,
            alternativeSystemIcons: ["plusminus", "minus.plus.batteryblock"]
        ),
        
        // Kesirler ve Yüzdeler - ENHANCED
        "fractions": IconInfo(
            customIcon: "category_fractions",
            systemIcon: "f.cursive.circle.fill",
            backgroundColor: .systemIndigo,
            alternativeSystemIcons: ["f.cursive", "divide.circle"]
        ),
        
        "percentages": IconInfo(
            customIcon: "category_percentages",
            systemIcon: "percent.circle.fill",
            backgroundColor: .systemPurple,
            alternativeSystemIcons: ["percent", "p.circle"]
        ),
        
        // Geometri - ENHANCED
        "geometric_shapes": IconInfo(
            customIcon: "category_geometric_shapes",
            systemIcon: "triangle.circle.fill",
            backgroundColor: .systemYellow,
            alternativeSystemIcons: ["triangle", "pentagon", "hexagon"]
        ),
        
        // Zaman - ENHANCED
        "time_and_clock": IconInfo(
            customIcon: "category_time_clock",
            systemIcon: "clock.fill",
            backgroundColor: .systemTeal,
            alternativeSystemIcons: ["clock", "timer", "stopwatch"]
        ),
        
        // Zihinsel Matematik - ENHANCED
        "mental_math": IconInfo(
            customIcon: "category_mental_math",
            systemIcon: "brain.head.profile",
            backgroundColor: .systemGreen,
            alternativeSystemIcons: ["brain", "lightbulb.fill", "sparkles"]
        ),
        
        // Rastgele Karışık - ENHANCED
        "random_mixed": IconInfo(
            customIcon: "category_random_mixed",
            systemIcon: "shuffle.circle.fill",
            backgroundColor: .systemPink,
            alternativeSystemIcons: ["shuffle", "arrow.triangle.2.circlepath", "dice.fill"]
        ),
        
        // Ek Kategoriler için Fallback
        "category_addition": IconInfo(
            customIcon: "category_addition",
            systemIcon: "plus.circle.fill",
            backgroundColor: .systemBlue,
            alternativeSystemIcons: ["plus"]
        ),
        
        "category_subtraction": IconInfo(
            customIcon: "category_subtraction",
            systemIcon: "minus.circle.fill",
            backgroundColor: .systemOrange,
            alternativeSystemIcons: ["minus"]
        ),
        
        "category_multiplication": IconInfo(
            customIcon: "category_multiplication",
            systemIcon: "multiply.circle.fill",
            backgroundColor: .systemPurple,
            alternativeSystemIcons: ["multiply"]
        )
    ]
    
    // MARK: - Enhanced Public Methods
    
    /// Belirtilen ikon ismini kullanarak UIImage döner - ENHANCED
    /// - Parameter iconName: İkon ismi (flexible matching)
    /// - Returns: UIImage veya nil
    func getIcon(for iconName: String) -> UIImage? {
        // Flexible icon name matching
        let cleanIconName = iconName.lowercased()
            .replacingOccurrences(of: "category_", with: "")
            .replacingOccurrences(of: "_", with: "")
        
        // Direct match önce dene
        if let iconInfo = iconMappings[iconName] ?? iconMappings[cleanIconName] {
            return createIcon(from: iconInfo)
        }
        
        // Partial matching dene
        for (key, iconInfo) in iconMappings {
            if key.contains(cleanIconName) || cleanIconName.contains(key) {
                return createIcon(from: iconInfo)
            }
        }
        
        // Fallback: Expression type'a göre ikon
        return getIconByExpressionType(iconName)
    }
    
    /// Icon'u IconInfo'dan oluşturur
    /// - Parameter iconInfo: Icon bilgileri
    /// - Returns: UIImage
    private func createIcon(from iconInfo: IconInfo) -> UIImage? {
        // 1. Custom icon'u dene
        if let customImage = UIImage(named: iconInfo.customIcon) {
            return customImage.withRenderingMode(.alwaysTemplate)
        }
        
        // 2. Ana sistem ikonunu dene
        if let systemImage = UIImage(systemName: iconInfo.systemIcon) {
            let config = UIImage.SymbolConfiguration(pointSize: 26, weight: .medium, scale: .large)
            return systemImage.withConfiguration(config).withRenderingMode(.alwaysTemplate)
        }
        
        // 3. Alternative sistem ikonlarını dene
        for altIcon in iconInfo.alternativeSystemIcons {
            if let systemImage = UIImage(systemName: altIcon) {
                let config = UIImage.SymbolConfiguration(pointSize: 26, weight: .medium, scale: .large)
                return systemImage.withConfiguration(config).withRenderingMode(.alwaysTemplate)
            }
        }
        
        // 4. Son çare: default icon
        return getDefaultIcon()
    }
    
    /// Expression type'a göre ikon döner
    /// - Parameter iconName: Icon name
    /// - Returns: UIImage
    private func getIconByExpressionType(_ iconName: String) -> UIImage? {
        let expressionMapping: [String: String] = [
            "addition": "plus",
            "subtraction": "minus",
            "multiplication": "multiply",
            "division": "divide",
            "fractions": "f.cursive",
            "percentages": "percent",
            "geometry": "triangle",
            "mental": "brain",
            "time": "clock",
            "random": "shuffle",
            "negative": "plusminus",
            "order": "function"
        ]
        
        for (key, systemIcon) in expressionMapping {
            if iconName.lowercased().contains(key) {
                if let image = UIImage(systemName: systemIcon) {
                    let config = UIImage.SymbolConfiguration(pointSize: 26, weight: .medium)
                    return image.withConfiguration(config).withRenderingMode(.alwaysTemplate)
                }
            }
        }
        
        return getDefaultIcon()
    }
    
    /// Kategori için renk bilgisini döner - ENHANCED
    /// - Parameter iconName: İkon ismi
    /// - Returns: UIColor
    func getBackgroundColor(for iconName: String) -> UIColor {
        let cleanIconName = iconName.lowercased()
            .replacingOccurrences(of: "category_", with: "")
            .replacingOccurrences(of: "_", with: "")
        
        // Direct match
        if let iconInfo = iconMappings[iconName] ?? iconMappings[cleanIconName] {
            return iconInfo.backgroundColor
        }
        
        // Partial matching
        for (key, iconInfo) in iconMappings {
            if key.contains(cleanIconName) || cleanIconName.contains(key) {
                return iconInfo.backgroundColor
            }
        }
        
        // Fallback colors by category type
        if iconName.lowercased().contains("addition") { return .systemBlue }
        if iconName.lowercased().contains("subtraction") { return .systemOrange }
        if iconName.lowercased().contains("multiplication") { return .systemPurple }
        if iconName.lowercased().contains("division") { return .systemIndigo }
        if iconName.lowercased().contains("fraction") { return .systemIndigo }
        if iconName.lowercased().contains("percentage") { return .systemPurple }
        if iconName.lowercased().contains("geometry") { return .systemYellow }
        if iconName.lowercased().contains("mental") { return .systemGreen }
        if iconName.lowercased().contains("time") { return .systemTeal }
        if iconName.lowercased().contains("random") { return .systemPink }
        
        return .systemBlue // Ultimate fallback
    }
    
    /// Enhanced icon validation
    /// - Returns: Detailed validation report
    func validateIcons() -> EnhancedIconValidationReport {
        var missingCustomIcons: [String] = []
        var availableIcons: [String] = []
        var systemFallbacks: [String] = []
        var coloredGlassReady: [String] = []
        
        for (iconName, iconInfo) in iconMappings {
            if UIImage(named: iconInfo.customIcon) != nil {
                availableIcons.append(iconName)
                coloredGlassReady.append(iconName)
            } else {
                missingCustomIcons.append(iconName)
                if UIImage(systemName: iconInfo.systemIcon) != nil {
                    systemFallbacks.append(iconName)
                    coloredGlassReady.append(iconName)
                }
            }
        }
        
        return EnhancedIconValidationReport(
            totalIcons: iconMappings.count,
            availableCustomIcons: availableIcons.count,
            missingCustomIcons: missingCustomIcons,
            systemFallbacks: systemFallbacks,
            coloredGlassReady: coloredGlassReady
        )
    }
    
    /// Varsayılan ikonu döner - ENHANCED
    /// - Returns: Enhanced varsayılan UIImage
    private func getDefaultIcon() -> UIImage? {
        let config = UIImage.SymbolConfiguration(pointSize: 26, weight: .medium, scale: .large)
        return UIImage(systemName: "questionmark.circle.fill")?
            .withConfiguration(config)
            .withRenderingMode(.alwaysTemplate)
    }
    
    /// Tüm mevcut icon name'leri döner
    /// - Returns: Icon name listesi
    func getAllAvailableIconNames() -> [String] {
        return Array(iconMappings.keys).sorted()
    }
}

// MARK: - Enhanced Icon Info Structure
/// Gelişmiş ikon bilgilerini tutan yapı
struct IconInfo {
    let customIcon: String              // Özel ikon dosya adı
    let systemIcon: String              // Ana sistem ikonu adı
    let backgroundColor: UIColor        // Arka plan rengi
    let alternativeSystemIcons: [String] // Alternative sistem ikonları
    
    init(customIcon: String, systemIcon: String, backgroundColor: UIColor, alternativeSystemIcons: [String] = []) {
        self.customIcon = customIcon
        self.systemIcon = systemIcon
        self.backgroundColor = backgroundColor
        self.alternativeSystemIcons = alternativeSystemIcons
    }
}

// MARK: - Enhanced Icon Validation Report
/// Gelişmiş ikon doğrulama raporu yapısı
struct EnhancedIconValidationReport {
    let totalIcons: Int                    // Toplam ikon sayısı
    let availableCustomIcons: Int          // Mevcut custom ikon sayısı
    let missingCustomIcons: [String]       // Eksik custom ikonlar
    let systemFallbacks: [String]          // Sistem ikonu kullanılan kategoriler
    let coloredGlassReady: [String]        // Colored glass için hazır olanlar
    
    /// Validasyon başarılı mı?
    var isValid: Bool {
        return missingCustomIcons.isEmpty
    }
    
    /// Colored glass support yüzdesi
    var coloredGlassSupport: Double {
        return totalIcons > 0 ? (Double(coloredGlassReady.count) / Double(totalIcons)) * 100 : 0
    }
    
    /// Enhanced raporu konsola yazdır
    func printReport() {
        print("🔍 Enhanced İkon Validasyon Raporu (Direct Colored Glass):")
        print("📊 Toplam İkon: \(totalIcons)")
        print("✅ Mevcut Custom İkonlar: \(availableCustomIcons)")
        print("🔄 Sistem Fallback'leri: \(systemFallbacks.count)")
        print("🌈 Colored Glass Ready: \(coloredGlassReady.count) (\(String(format: "%.1f", coloredGlassSupport))%)")
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
        
        let status = coloredGlassSupport >= 90 ? "🌟 Excellent" :
                    coloredGlassSupport >= 70 ? "✅ Good" : "⚠️ Needs Improvement"
        print("🏁 Colored Glass Status: \(status)")
    }
}

// MARK: - Enhanced Category Icons Extension
/// MathCategory için gelişmiş ikon yardımcı extension'ı
extension MathCategory {
    
    /// Kategorinin enhanced ikonunu döner
    var enhancedIcon: UIImage? {
        return CategoryIconsHelper.shared.getIcon(for: iconName)
    }
    
    /// Kategorinin helper arka plan rengini döner
    var helperBackgroundColor: UIColor {
        return CategoryIconsHelper.shared.getBackgroundColor(for: iconName)
    }
    
    /// Icon'un mevcut olup olmadığını kontrol eder
    var hasCustomIcon: Bool {
        return UIImage(named: iconName) != nil
    }
    
    /// Kategori için debug bilgilerini döner
    var iconDebugInfo: String {
        let hasCustom = hasCustomIcon ? "✅" : "❌"
        let color = backgroundColor.hexString ?? "Unknown"
        return "Icon: \(iconName) \(hasCustom) | Color: \(color)"
    }
}

// MARK: - Enhanced Icon Assets Generator
/// Development amaçlı - gelişmiş ikon asset generator
class EnhancedCategoryIconGenerator {
    
    /// Kategori için gelişmiş programlı ikon oluşturur
    /// - Parameters:
    ///   - category: Kategori bilgisi
    ///   - size: İkon boyutu
    ///   - style: İkon stili
    /// - Returns: Oluşturulan UIImage
    static func generateEnhancedIcon(
        for category: MathCategory,
        size: CGSize = CGSize(width: 80, height: 80),
        style: IconStyle = .liquidGlass
    ) -> UIImage? {
        
        let renderer = UIGraphicsImageRenderer(size: size)
        
        return renderer.image { context in
            let cgContext = context.cgContext
            
            switch style {
            case .liquidGlass:
                drawLiquidGlassIcon(context: cgContext, category: category, size: size)
            case .flat:
                drawFlatIcon(context: cgContext, category: category, size: size)
            case .gradient:
                drawGradientIcon(context: cgContext, category: category, size: size)
            }
        }
    }
    
    /// Liquid glass style ikon çizer
    private static func drawLiquidGlassIcon(context: CGContext, category: MathCategory, size: CGSize) {
        // Liquid glass background
        let baseColor = category.backgroundColor
        let gradient = CGGradient(
            colorsSpace: CGColorSpaceCreateDeviceRGB(),
            colors: [
                baseColor.withAlphaComponent(0.9).cgColor,
                baseColor.withAlphaComponent(0.7).cgColor,
                baseColor.withAlphaComponent(0.5).cgColor
            ] as CFArray,
            locations: [0.0, 0.5, 1.0]
        )
        
        // Draw gradient circle
        context.drawRadialGradient(
            gradient!,
            startCenter: CGPoint(x: size.width * 0.3, y: size.height * 0.3),
            startRadius: 0,
            endCenter: CGPoint(x: size.width * 0.5, y: size.height * 0.5),
            endRadius: size.width * 0.5,
            options: []
        )
        
        // Add glass reflection
        let reflectionGradient = CGGradient(
            colorsSpace: CGColorSpaceCreateDeviceRGB(),
            colors: [
                UIColor.white.withAlphaComponent(0.4).cgColor,
                UIColor.clear.cgColor
            ] as CFArray,
            locations: [0.0, 1.0]
        )
        
        context.drawLinearGradient(
            reflectionGradient!,
            start: CGPoint(x: 0, y: 0),
            end: CGPoint(x: size.width, y: size.height * 0.6),
            options: []
        )
        
        // Draw symbol
        drawCategorySymbol(context: context, category: category, size: size)
    }
    
    /// Flat style ikon çizer
    private static func drawFlatIcon(context: CGContext, category: MathCategory, size: CGSize) {
        // Simple solid background
        context.setFillColor(category.backgroundColor.cgColor)
        context.fillEllipse(in: CGRect(origin: .zero, size: size))
        
        // Draw symbol
        drawCategorySymbol(context: context, category: category, size: size)
    }
    
    /// Gradient style ikon çizer
    private static func drawGradientIcon(context: CGContext, category: MathCategory, size: CGSize) {
        let baseColor = category.backgroundColor
        let gradient = CGGradient(
            colorsSpace: CGColorSpaceCreateDeviceRGB(),
            colors: [
                baseColor.cgColor,
                baseColor.withBrightnessDelta(-0.2).cgColor
            ] as CFArray,
            locations: [0.0, 1.0]
        )
        
        context.drawLinearGradient(
            gradient!,
            start: CGPoint(x: 0, y: 0),
            end: CGPoint(x: size.width, y: size.height),
            options: []
        )
        
        drawCategorySymbol(context: context, category: category, size: size)
    }
    
    /// Kategori sembolü çizer
    private static func drawCategorySymbol(context: CGContext, category: MathCategory, size: CGSize) {
        let symbolName = getEnhancedSymbolName(for: category)
        let config = UIImage.SymbolConfiguration(pointSize: size.width * 0.4, weight: .medium)
        
        if let symbolImage = UIImage(systemName: symbolName)?.withConfiguration(config) {
            let symbolSize = symbolImage.size
            let symbolOrigin = CGPoint(
                x: (size.width - symbolSize.width) / 2,
                y: (size.height - symbolSize.height) / 2
            )
            
            // Draw white symbol
            context.saveGState()
            context.setFillColor(UIColor.white.cgColor)
            context.translateBy(x: symbolOrigin.x, y: symbolOrigin.y + symbolSize.height)
            context.scaleBy(x: 1, y: -1)
            
            if let cgImage = symbolImage.cgImage {
                context.draw(cgImage, in: CGRect(origin: .zero, size: symbolSize))
            }
            
            context.restoreGState()
        }
    }
    
    /// Enhanced sembol ismi döner
    private static func getEnhancedSymbolName(for category: MathCategory) -> String {
        switch category.expressionType {
        case .addition: return "plus"
        case .subtraction: return "minus"
        case .multiplication: return "multiply"
        case .multiplicationTable: return "grid"
        case .orderOfOperations: return "function"
        case .negativeNumbers: return "plusminus"
        case .fractions: return "f.cursive"
        case .percentages: return "percent"
        case .geometricShapes: return "triangle"
        case .timeAndClock: return "clock"
        case .mentalMath: return "brain"
        case .randomMixed: return "shuffle"
        default: return "questionmark"
        }
    }
}

// MARK: - Icon Style Enum
enum IconStyle {
    case liquidGlass
    case flat
    case gradient
}

// MARK: - Enhanced Usage Example and Setup
extension CategoryIconsHelper {
    
    /// Enhanced geliştirme ortamında ikon kontrolü
    func performEnhancedIconCheck() {
        print("🔧 Enhanced Kategori İkonları Kontrol Ediliyor (Direct Colored Glass)...")
        
        let report = validateIcons()
        report.printReport()
        
        // Performance test
        performIconPerformanceTest()
        
        // Auto-generate missing icons if needed
        if !report.isValid {
            print("🎨 Eksik ikonlar için liquid glass ikonlar oluşturuluyor...")
            generateMissingLiquidGlassIcons(report.missingCustomIcons)
        }
    }
    
    /// Icon performance test
    private func performIconPerformanceTest() {
        let startTime = CFAbsoluteTimeGetCurrent()
        
        for iconName in getAllAvailableIconNames() {
            _ = getIcon(for: iconName)
        }
        
        let endTime = CFAbsoluteTimeGetCurrent()
        let totalTime = endTime - startTime
        
        print("⚡ Icon Performance: \(String(format: "%.3f", totalTime * 1000))ms for \(iconMappings.count) icons")
    }
    
    /// Eksik liquid glass ikonları oluştur
    private func generateMissingLiquidGlassIcons(_ missingIcons: [String]) {
        let categories = MathCategoryFactory.shared.getAllCategories()
        
        for iconName in missingIcons {
            if let category = categories.first(where: { $0.iconName == iconName }) {
                if let generatedIcon = EnhancedCategoryIconGenerator.generateEnhancedIcon(
                    for: category,
                    style: .liquidGlass
                ) {
                    print("✨ Liquid Glass ikon oluşturuldu: \(iconName)")
                    // Save generated icon if needed
                }
            }
        }
    }
}

// MARK: - UIColor Extension for Icon Generation
extension UIColor {
    /// Brightness değiştiren yardımcı method
    func withBrightnessDelta(_ delta: CGFloat) -> UIColor {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        
        if getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
            return UIColor(
                hue: hue,
                saturation: saturation,
                brightness: max(0, min(1, brightness + delta)),
                alpha: alpha
            )
        }
        
        return self
    }
}
