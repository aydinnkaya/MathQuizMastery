//
//  CategoryCollectionViewCell.swift
//  MathQuizMastery
//
//  Created by AydınKaya on 22.07.2025.
//

import UIKit

// MARK: - Category Collection View Cell
/// Matematik kategorisi kartını gösteren collection view cell'i
class CategoryCollectionViewCell: UICollectionViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var containerView: UIView!          // Ana container view
    @IBOutlet weak var iconImageView: UIImageView!     // Kategori ikonu
    @IBOutlet weak var titleLabel: UILabel!            // Kategori başlığı
    @IBOutlet weak var newBadgeLabel: UILabel!         // "YENİ" etiketi
    @IBOutlet weak var backgroundGradientView: UIView! // Gradient arka plan view
    
    // MARK: - Properties
    private var gradientLayer: CAGradientLayer?        // Gradient katmanı
    private var blurEffectView: UIVisualEffectView?    // Blur efekt view
    private var category: MathCategory?                // İlişkili kategori
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()           // UI bileşenlerini ayarla
        setupLiquidGlass()  // Liquid glass efekti kur
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // Cell yeniden kullanılmadan önce temizlik yap
        resetCellState()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Layout değiştiğinde gradient'i güncelle
        updateGradientFrame()
    }
    
    // MARK: - Setup Methods
    
    /// UI bileşenlerini yapılandırır
    private func setupUI() {
        // Container view ayarları
        containerView.layer.cornerRadius = 20
        containerView.layer.masksToBounds = true
        containerView.backgroundColor = UIColor.clear
        
        // İkon ayarları
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = UIColor.white
        
        // Başlık ayarları
        titleLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        titleLabel.textColor = UIColor.white
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 2
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.8
        
        // "YENİ" etiketi ayarları
        newBadgeLabel.font = UIFont.systemFont(ofSize: 8, weight: .bold)
        newBadgeLabel.textColor = UIColor.white
        newBadgeLabel.backgroundColor = UIColor.systemRed
        newBadgeLabel.text = "YENİ"
        newBadgeLabel.textAlignment = .center
        newBadgeLabel.layer.cornerRadius = 8
        newBadgeLabel.layer.masksToBounds = true
        newBadgeLabel.isHidden = true
        
        // Shadow efekti
        setupShadow()
        
        // Accessibility ayarları
        setupAccessibility()
    }
    
    /// Liquid Glass efektini kurar
    private func setupLiquidGlass() {
        // Blur efekt view oluştur
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView?.frame = containerView.bounds
        blurEffectView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView?.alpha = 0.7
        
        // Blur view'ı container'a ekle (en alta)
        if let blurView = blurEffectView {
            containerView.insertSubview(blurView, at: 0)
        }
        
        // Gradient layer oluştur
        gradientLayer = CAGradientLayer()
        gradientLayer?.frame = containerView.bounds
        gradientLayer?.cornerRadius = 20
        gradientLayer?.masksToBounds = true
        
        // Gradient'i blur view'ın üzerine ekle
        if let gradient = gradientLayer {
            containerView.layer.insertSublayer(gradient, above: blurEffectView?.layer)
        }
    }
    
    /// Gölge efektini ayarlar
    private func setupShadow() {
        // Cell gölge ayarları
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 12
        layer.shadowOpacity = 0.15
        layer.masksToBounds = false
        
        // Shadow path performance için
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 20).cgPath
    }
    
    /// Accessibility ayarlarını yapar
    private func setupAccessibility() {
        isAccessibilityElement = true
        accessibilityTraits = .button
    }
    
    // MARK: - Configuration
    
    /// Cell'i verilen kategori ile yapılandırır
    /// - Parameter category: MathCategory objesi
    func configure(with category: MathCategory) {
        self.category = category
        
        // Başlık ayarla
        titleLabel.text = category.title
        
        // İkon ayarla
        iconImageView.image = UIImage(named: category.iconName) ?? UIImage(systemName: "questionmark.circle.fill")
        
        // Gradient renklerini ayarla
        updateGradientColors(category.backgroundColor)
        
        // "YENİ" etiketini göster/gizle
        newBadgeLabel.isHidden = !category.isNew
        
        // Accessibility ayarları
        accessibilityLabel = category.title
        accessibilityHint = category.isNew ? "\(category.title), yeni kategori" : category.title
        
        // Accessibility action'larını ayarla
        setupAccessibilityActions()
        
        // Animasyon efektlerini hazırla
        prepareAnimations()
    }
    
    // MARK: - Private Methods
    
    /// Gradient renklerini günceller
    /// - Parameter baseColor: Temel renk
    private func updateGradientColors(_ baseColor: UIColor) {
        // Renk tonlarını oluştur
        let lightColor = baseColor.withAlphaComponent(0.8)
        let darkColor = baseColor.withAlphaComponent(0.4)
        let accentColor = baseColor.withAlphaComponent(0.6)
        
        // Gradient renklerini ayarla
        gradientLayer?.colors = [
            lightColor.cgColor,
            accentColor.cgColor,
            darkColor.cgColor
        ]
        
        gradientLayer?.locations = [0.0, 0.6, 1.0]
        gradientLayer?.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer?.endPoint = CGPoint(x: 1.0, y: 1.0)
    }
    
    /// Gradient frame'ini günceller
    private func updateGradientFrame() {
        gradientLayer?.frame = containerView.bounds
        blurEffectView?.frame = containerView.bounds
        
        // Shadow path güncelle
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 20).cgPath
    }
    
    /// Cell durumunu sıfırlar
    private func resetCellState() {
        category = nil
        titleLabel.text = ""
        iconImageView.image = nil
        newBadgeLabel.isHidden = true
        
        // Transform ve alpha değerlerini sıfırla
        transform = .identity
        alpha = 1.0
    }
    
    /// Animasyonları hazırlar
    private func prepareAnimations() {
        // İlk load animation için hazırlık
        alpha = 0.0
        transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
    }
    
    // MARK: - Animation Methods
    
    /// Görünüm animasyonunu başlatır
    /// - Parameter delay: Animasyon gecikmesi
    func animateAppearance(withDelay delay: TimeInterval = 0.0) {
        UIView.animate(
            withDuration: 0.6,
            delay: delay,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 0.5,
            options: [.allowUserInteraction, .curveEaseOut],
            animations: {
                self.alpha = 1.0
                self.transform = .identity
            },
            completion: nil
        )
    }
    
    /// Seçim animasyonunu başlatır
    func animateSelection() {
        // Haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
        
        // Visual feedback animasyonu
        UIView.animate(withDuration: 0.1, animations: {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { _ in
            UIView.animate(withDuration: 0.1, animations: {
                self.transform = .identity
            })
        }
        
        // Glow efekti
        addGlowEffect()
    }
    
    /// Glow efekti ekler
    private func addGlowEffect() {
        layer.shadowColor = category?.backgroundColor.cgColor ?? UIColor.white.cgColor
        layer.shadowRadius = 20
        layer.shadowOpacity = 0.6
        
        // Glow efektini yavaşça kaldır
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            UIView.animate(withDuration: 0.3) {
                self?.layer.shadowColor = UIColor.black.cgColor
                self?.layer.shadowRadius = 12
                self?.layer.shadowOpacity = 0.15
            }
        }
    }
    
    /// Hover efektini başlatır (iPad için)
    func animateHover(_ isHovering: Bool) {
        UIView.animate(withDuration: 0.2, animations: {
            if isHovering {
                self.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
                self.layer.shadowRadius = 16
                self.layer.shadowOpacity = 0.25
            } else {
                self.transform = .identity
                self.layer.shadowRadius = 12
                self.layer.shadowOpacity = 0.15
            }
        })
    }
}

// MARK: - Extensions
extension CategoryCollectionViewCell {
    
    /// Cell'in mevcut kategorisini döner
    var currentCategory: MathCategory? {
        return category
    }
    
    /// Cell'in seçilebilir olup olmadığını kontrol eder
    var isSelectable: Bool {
        return category != nil
    }
}

// MARK: - Accessibility
extension CategoryCollectionViewCell {
    
    /// Accessibility action'larını ayarlar
    private func setupAccessibilityActions() {
        guard let category = category else {
            accessibilityCustomActions = nil
            return
        }
        
        let selectAction = UIAccessibilityCustomAction(
            name: "\(category.title) kategorisini seç",
            target: self,
            selector: #selector(accessibilitySelect)
        )
        
        accessibilityCustomActions = [selectAction]
    }
    
    /// Accessibility select action'ı
    @objc private func accessibilitySelect() -> Bool {
        // Seçim animasyonu başlat
        animateSelection()
        return true
    }
}
