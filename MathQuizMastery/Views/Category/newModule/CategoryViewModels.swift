//
//  CategoryViewModels.swift
//  MathQuizMastery
//
//  Created by AydınKaya on 22.07.2025.
//

import Foundation
import UIKit

// MARK: - Category View Model Protocol
/// CategoryViewModel için gerekli protokol tanımları
protocol CategoryViewModelDelegate: AnyObject {
    func categoriesDidLoad()                    // Kategoriler yüklendiğinde çağrılır
    func categorySelectionDidChange(_ category: MathCategory?)  // Kategori seçimi değiştiğinde
    func errorDidOccur(_ error: Error)         // Hata durumunda çağrılır
}

// MARK: - Category View Model
/// Kategori ekranının iş mantığını yöneten ViewModel sınıfı
class CategoryViewModel {
    
    // MARK: - Properties
    weak var delegate: CategoryViewModelDelegate?
    
    /// Tüm matematik kategorileri
    private(set) var categories: [MathCategory] = []
    
    /// Seçili kategori
    private(set) var selectedCategory: MathCategory? {
        didSet {
            // Seçili kategori değiştiğinde delegate'i bilgilendir
            delegate?.categorySelectionDidChange(selectedCategory)
        }
    }
    
    /// Loading durumu
    private(set) var isLoading: Bool = false {
        didSet {
            // Loading durumu değiştiğinde UI güncellenmesi için
            DispatchQueue.main.async { [weak self] in
                // Burada loading indicator göster/gizle işlemleri yapılabilir
            }
        }
    }
    
    /// Grid layout için hesaplanan değerler
    private(set) var gridConfiguration = GridConfiguration.default
    
    // MARK: - Initializer
    /// CategoryViewModel başlatıcı metodu
    init() {
        setupInitialData()
    }
    
    // MARK: - Public Methods
    
    /// Kategorileri yükler
    func loadCategories() {
        isLoading = true
        
        // Simüle edilmiş asenkron yükleme (gerçek projede API çağrısı olabilir)
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            
            // Kategori verilerini factory'den al
            let loadedCategories = MathCategoryFactory.shared.getAllCategories()
            
            DispatchQueue.main.async {
                self.categories = loadedCategories
                self.isLoading = false
                self.delegate?.categoriesDidLoad()
            }
        }
    }
    
    /// Belirtilen indeksteki kategoriyi döner
    /// - Parameter index: Kategori indeksi
    /// - Returns: MathCategory veya nil
    func category(at index: Int) -> MathCategory? {
        guard index >= 0 && index < categories.count else { return nil }
        return categories[index]
    }
    
    /// Kategori seçer
    /// - Parameter category: Seçilecek kategori
    func selectCategory(_ category: MathCategory) {
        selectedCategory = category
        
        // Haptic feedback ekle
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.prepare()
        impactFeedback.impactOccurred()
        
        print("📱 Seçilen kategori: \(category.title)")
    }
    
    /// Kategori seçimini temizler
    func clearSelection() {
        selectedCategory = nil
    }
    
    /// Kategoriler sayısını döner
    var numberOfCategories: Int {
        return categories.count
    }
    
    /// Yeni kategorilerin sayısını döner
    var numberOfNewCategories: Int {
        return categories.filter { $0.isNew }.count
    }
    
    /// Kategori ID'sine göre kategori bulur
    /// - Parameter id: Kategori ID'si
    /// - Returns: MathCategory veya nil
    func findCategory(byId id: Int) -> MathCategory? {
        return categories.first { $0.id == id }
    }
    
    // MARK: - Grid Configuration Methods
    
    /// Cihaz boyutuna göre grid konfigürasyonunu günceller
    /// - Parameters:
    ///   - size: Ekran boyutu
    ///   - traitCollection: UI trait collection
    func updateGridConfiguration(for size: CGSize, traitCollection: UITraitCollection) {
        let newConfiguration = calculateGridConfiguration(for: size, traitCollection: traitCollection)
        gridConfiguration = newConfiguration
    }
    
    /// Belirtilen indeks yolu için kategoriyi döner
    /// - Parameter indexPath: IndexPath
    /// - Returns: MathCategory veya nil
    func category(for indexPath: IndexPath) -> MathCategory? {
        let index = (indexPath.section * gridConfiguration.itemsPerRow) + indexPath.row
        return category(at: index)
    }
    
    // MARK: - Private Methods
    
    /// İlk veri kurulumunu yapar
    private func setupInitialData() {
        // İlk yükleme için grid konfigürasyonunu ayarla
        gridConfiguration = GridConfiguration.default
    }
    
    /// Grid konfigürasyonunu hesaplar
    /// - Parameters:
    ///   - size: Ekran boyutu
    ///   - traitCollection: UI trait collection
    /// - Returns: Hesaplanmış grid konfigürasyonu
    private func calculateGridConfiguration(for size: CGSize, traitCollection: UITraitCollection) -> GridConfiguration {
        
        // iPad ve iPhone için farklı konfigürasyonlar
        if traitCollection.userInterfaceIdiom == .pad {
            // iPad konfigürasyonu
            if size.width > size.height {
                // Landscape - 4 sütun
                return GridConfiguration(
                    itemsPerRow: 4,
                    spacing: 20,
                    sectionInsets: UIEdgeInsets(top: 30, left: 40, bottom: 30, right: 40)
                )
            } else {
                // Portrait - 3 sütun
                return GridConfiguration(
                    itemsPerRow: 3,
                    spacing: 20,
                    sectionInsets: UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)
                )
            }
        } else {
            // iPhone konfigürasyonu
            if size.width > size.height {
                // Landscape - 4 sütun (küçük kartlar)
                return GridConfiguration(
                    itemsPerRow: 4,
                    spacing: 12,
                    sectionInsets: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
                )
            } else {
                // Portrait - 3 sütun
                return GridConfiguration(
                    itemsPerRow: 3,
                    spacing: 16,
                    sectionInsets: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
                )
            }
        }
    }
}

// MARK: - Grid Configuration
/// Grid layout konfigürasyon yapısı
struct GridConfiguration {
    let itemsPerRow: Int           // Satır başına öğe sayısı
    let spacing: CGFloat           // Öğeler arası boşluk
    let sectionInsets: UIEdgeInsets // Kenar boşlukları
    
    /// Varsayılan grid konfigürasyonu
    static let `default` = GridConfiguration(
        itemsPerRow: 3,
        spacing: 16,
        sectionInsets: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    )
    
    /// Öğe boyutunu hesaplar
    /// - Parameter containerWidth: Container genişliği
    /// - Returns: Hesaplanmış öğe boyutu
    func itemSize(for containerWidth: CGFloat) -> CGSize {
        let totalSpacing = spacing * CGFloat(itemsPerRow - 1)
        let totalInsets = sectionInsets.left + sectionInsets.right
        let availableWidth = containerWidth - totalSpacing - totalInsets
        let itemWidth = availableWidth / CGFloat(itemsPerRow)
        
        // Öğe boyutunu kare olarak ayarla (1:1 aspect ratio)
        return CGSize(width: itemWidth, height: itemWidth)
    }
}

// MARK: - ViewModel Extensions
extension CategoryViewModel {
    
    /// Analytics için kategori seçim olayını kaydeder
    /// - Parameter category: Seçilen kategori
    private func trackCategorySelection(_ category: MathCategory) {
        // Firebase Analytics veya başka analytics servisine olay gönder
        print("🔍 Analytics: Kategori seçildi - \(category.title)")
    }
    
    /// Kategori için istatistik bilgilerini döner
    /// - Parameter category: Kategori
    /// - Returns: İstatistik string'i veya nil
    func getStatistics(for category: MathCategory) -> String? {
        // Gerçek projede UserDefaults veya Core Data'dan istatistik çek
        return nil // Şu an için nil döndür
    }
    
    /// Kategorinin kilitli olup olmadığını kontrol eder
    /// - Parameter category: Kontrol edilecek kategori
    /// - Returns: Kilitli mi?
    func isCategoryLocked(_ category: MathCategory) -> Bool {
        // Premium kategoriler için kilit kontrollü yapılabilir
        return false // Şu an için tüm kategoriler açık
    }
}
