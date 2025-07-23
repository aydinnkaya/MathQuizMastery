//
//  CategoryCollectionViewCell.swift
//  MathQuizMastery
//
//  Created by Aydın KAYA on 23.07.2025.
//

import UIKit

// MARK: - Default Colored Liquid Glass Cell
/// Her hücre başlangıçtan kendi renginde liquid glass efektiyle görünür
class CategoryCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI Components
    private var containerView: UIView!
    private var liquidGlassBackgroundView: UIView!
    private var iconContainerView: UIView!
    private var iconImageView: UIImageView!
    private var titleLabel: UILabel!
    private var newBadgeLabel: UILabel!
    
    // MARK: - Liquid Glass Layers
    private var baseGlassLayer: CAGradientLayer?
    private var primaryColorLayer: CAGradientLayer?
    private var secondaryColorLayer: CAGradientLayer?
    private var glassReflectionLayer: CAGradientLayer?
    private var ultraThinBlurView: UIVisualEffectView?
    private var borderGlowLayer: CAGradientLayer?
    
    // MARK: - Properties
    private var category: MathCategory?
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDefaultColoredGlassUI()
        
        // Her zaman görünür olsun
        alpha = 1.0
        transform = .identity
        
        print("✅ Default Colored Liquid Glass Cell init - Always visible")
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupDefaultColoredGlassUI()
        
        // Her zaman görünür olsun
        alpha = 1.0
        transform = .identity
        
        print("✅ Default Colored Liquid Glass Cell coder init - Always visible")
    }
    
    // MARK: - Lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()
        updateAllGlassLayers()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        resetCellState()
        
        // SELECTED STATE'İ TEMİZLE
        isSelected = false
        isHighlighted = false
        
        print("🔄 Cell prepare for reuse - STATE CLEARED")
    }
    
    // MARK: - Default Colored Glass UI Setup
    
    /// Default renkli liquid glass UI kurulumu
    private func setupDefaultColoredGlassUI() {
        // Container View
        containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = UIColor.clear
        containerView.layer.cornerRadius = 20
        containerView.layer.masksToBounds = true
        contentView.addSubview(containerView)
        
        // Liquid Glass Background View
        liquidGlassBackgroundView = UIView()
        liquidGlassBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        liquidGlassBackgroundView.layer.cornerRadius = 20
        liquidGlassBackgroundView.layer.masksToBounds = true
        containerView.addSubview(liquidGlassBackgroundView)
        
        // Icon Container (beyaz cam daire)
        iconContainerView = UIView()
        iconContainerView.translatesAutoresizingMaskIntoConstraints = false
        iconContainerView.backgroundColor = UIColor.white.withAlphaComponent(0.95)
        iconContainerView.layer.cornerRadius = 25
        iconContainerView.layer.masksToBounds = true
        containerView.addSubview(iconContainerView)
        
        // Icon ImageView
        iconImageView = UIImageView()
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.image = UIImage(systemName: "plus")
        iconContainerView.addSubview(iconImageView)
        
        // Title Label
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        titleLabel.textColor = UIColor.white
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 1
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.7
        titleLabel.text = "KATEGORI"
        containerView.addSubview(titleLabel)
        
        // New Badge Label
        newBadgeLabel = UILabel()
        newBadgeLabel.translatesAutoresizingMaskIntoConstraints = false
        newBadgeLabel.font = UIFont.systemFont(ofSize: 9, weight: .bold)
        newBadgeLabel.textColor = UIColor.white
        newBadgeLabel.backgroundColor = UIColor.systemRed
        newBadgeLabel.text = "YENİ"
        newBadgeLabel.textAlignment = .center
        newBadgeLabel.layer.cornerRadius = 8
        newBadgeLabel.layer.masksToBounds = true
        newBadgeLabel.isHidden = true
        containerView.addSubview(newBadgeLabel)
        
        setupConstraints()
        setupDefaultColoredGlassSystem()
        setupProfessionalShadow()
        setupAccessibility()
        
        print("🌈 Default colored glass sistem kuruldu")
    }
    
    /// Perfect constraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Container View
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            
            // Liquid Glass Background
            liquidGlassBackgroundView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            liquidGlassBackgroundView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            liquidGlassBackgroundView.topAnchor.constraint(equalTo: containerView.topAnchor),
            liquidGlassBackgroundView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            // Icon Container (perfect circle)
            iconContainerView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            iconContainerView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: -10),
            iconContainerView.widthAnchor.constraint(equalToConstant: 50),
            iconContainerView.heightAnchor.constraint(equalToConstant: 50),
            
            // Icon ImageView
            iconImageView.centerXAnchor.constraint(equalTo: iconContainerView.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: iconContainerView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 26),
            iconImageView.heightAnchor.constraint(equalToConstant: 26),
            
            // Title
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 6),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -6),
            titleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),
            titleLabel.heightAnchor.constraint(equalToConstant: 16),
            
            // Badge
            newBadgeLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -6),
            newBadgeLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 6),
            newBadgeLabel.widthAnchor.constraint(equalToConstant: 28),
            newBadgeLabel.heightAnchor.constraint(equalToConstant: 16)
        ])
    }
    
    /// Default renkli liquid glass sistemi
    private func setupDefaultColoredGlassSystem() {
        // 1. Ultra Thin Blur Base
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        ultraThinBlurView = UIVisualEffectView(effect: blurEffect)
        ultraThinBlurView?.frame = liquidGlassBackgroundView.bounds
        ultraThinBlurView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        ultraThinBlurView?.alpha = 0.4 // Daha az opaque - renklerin daha çok görünmesi için
        liquidGlassBackgroundView.addSubview(ultraThinBlurView!)
        
        // 2. Base Glass Layer (temel cam katmanı)
        baseGlassLayer = CAGradientLayer()
        baseGlassLayer?.cornerRadius = 20
        baseGlassLayer?.masksToBounds = true
        baseGlassLayer?.colors = [
            UIColor.white.withAlphaComponent(0.15).cgColor,
            UIColor.white.withAlphaComponent(0.08).cgColor,
            UIColor.white.withAlphaComponent(0.05).cgColor,
            UIColor.white.withAlphaComponent(0.12).cgColor
        ]
        baseGlassLayer?.locations = [0.0, 0.3, 0.7, 1.0]
        baseGlassLayer?.startPoint = CGPoint(x: 0, y: 0)
        baseGlassLayer?.endPoint = CGPoint(x: 1, y: 1)
        liquidGlassBackgroundView.layer.addSublayer(baseGlassLayer!)
        
        // 3. Primary Color Layer (ana renk katmanı - DEFAULT AKTIF)
        primaryColorLayer = CAGradientLayer()
        primaryColorLayer?.cornerRadius = 20
        primaryColorLayer?.masksToBounds = true
        liquidGlassBackgroundView.layer.addSublayer(primaryColorLayer!)
        
        // 4. Secondary Color Layer (ikincil renk derinliği)
        secondaryColorLayer = CAGradientLayer()
        secondaryColorLayer?.cornerRadius = 20
        secondaryColorLayer?.masksToBounds = true
        secondaryColorLayer?.opacity = 0.7
        liquidGlassBackgroundView.layer.addSublayer(secondaryColorLayer!)
        
        // 5. Glass Reflection Layer (cam yansıması)
        glassReflectionLayer = CAGradientLayer()
        glassReflectionLayer?.cornerRadius = 20
        glassReflectionLayer?.masksToBounds = true
        glassReflectionLayer?.colors = [
            UIColor.white.withAlphaComponent(0.35).cgColor,
            UIColor.white.withAlphaComponent(0.18).cgColor,
            UIColor.clear.cgColor,
            UIColor.black.withAlphaComponent(0.06).cgColor,
            UIColor.white.withAlphaComponent(0.08).cgColor
        ]
        glassReflectionLayer?.locations = [0.0, 0.25, 0.5, 0.75, 1.0]
        glassReflectionLayer?.startPoint = CGPoint(x: 0, y: 0)
        glassReflectionLayer?.endPoint = CGPoint(x: 1, y: 1)
        liquidGlassBackgroundView.layer.addSublayer(glassReflectionLayer!)
        
        // 6. Border Glow Layer (kenar ışıması)
        borderGlowLayer = CAGradientLayer()
        borderGlowLayer?.cornerRadius = 20
        borderGlowLayer?.masksToBounds = true
        
        // Border mask
        let borderMask = CAShapeLayer()
        let bounds = CGRect(x: 0, y: 0, width: 120, height: 140)
        let borderPath = UIBezierPath(roundedRect: bounds, cornerRadius: 20)
        let innerPath = UIBezierPath(roundedRect: bounds.insetBy(dx: 1.8, dy: 1.8), cornerRadius: 18.2)
        borderPath.append(innerPath.reversing())
        borderMask.path = borderPath.cgPath
        borderMask.fillRule = .evenOdd
        borderGlowLayer?.mask = borderMask
        
        liquidGlassBackgroundView.layer.addSublayer(borderGlowLayer!)
        
        // 7. Icon Container Glass Effects
        setupIconContainerGlassEffects()
        
        print("✨ Default colored glass layers kuruldu")
    }
    
    /// Icon container cam efektleri
    private func setupIconContainerGlassEffects() {
        // Enhanced white glass effect
        iconContainerView.layer.shadowColor = UIColor.black.cgColor
        iconContainerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        iconContainerView.layer.shadowRadius = 4
        iconContainerView.layer.shadowOpacity = 0.12
        
        // Glass border
        iconContainerView.layer.borderWidth = 1.0
        iconContainerView.layer.borderColor = UIColor.white.withAlphaComponent(0.8).cgColor
        
        // Inner light effect
        let innerLightLayer = CAGradientLayer()
        innerLightLayer.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        innerLightLayer.cornerRadius = 25
        innerLightLayer.colors = [
            UIColor.white.withAlphaComponent(0.9).cgColor,
            UIColor.white.withAlphaComponent(0.5).cgColor,
            UIColor.white.withAlphaComponent(0.2).cgColor
        ]
        innerLightLayer.locations = [0.0, 0.4, 1.0]
        innerLightLayer.startPoint = CGPoint(x: 0, y: 0)
        innerLightLayer.endPoint = CGPoint(x: 1, y: 1)
        iconContainerView.layer.insertSublayer(innerLightLayer, at: 0)
    }
    
    /// Professional shadow
    private func setupProfessionalShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 8)
        layer.shadowRadius = 20
        layer.shadowOpacity = 0.15
        layer.masksToBounds = false
    }
    
    /// Accessibility
    private func setupAccessibility() {
        isAccessibilityElement = true
        accessibilityTraits = .button
        accessibilityHint = "Matematik kategorisi"
    }
    
    // MARK: - Layer Management
    
    /// Tüm glass layer'ları günceller
    private func updateAllGlassLayers() {
        let bounds = liquidGlassBackgroundView.bounds
        
        baseGlassLayer?.frame = bounds
        primaryColorLayer?.frame = bounds
        secondaryColorLayer?.frame = bounds
        glassReflectionLayer?.frame = bounds
        borderGlowLayer?.frame = bounds
        ultraThinBlurView?.frame = bounds
        
        // Shadow path
        layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: 20).cgPath
        
        // Border mask güncelle
        if let borderMask = borderGlowLayer?.mask as? CAShapeLayer {
            let borderPath = UIBezierPath(roundedRect: bounds, cornerRadius: 20)
            let innerPath = UIBezierPath(roundedRect: bounds.insetBy(dx: 1.8, dy: 1.8), cornerRadius: 18.2)
            borderPath.append(innerPath.reversing())
            borderMask.path = borderPath.cgPath
        }
    }
    
    // MARK: - Configuration
    
    /// Cell konfigürasyonu - DEFAULT RENKLERLE - ENHANCED
    func configure(with category: MathCategory) {
        self.category = category
        
        // Title
        titleLabel.text = category.title.uppercased()
        
        // Icon configuration - ENHANCED
        configureIcon(for: category)
        
        // DEFAULT COLORED GLASS - HER ZAMAN AKTİF - BAŞLANGIÇTAN RENKLİ
        applyDefaultColoredGlass(category.backgroundColor)
        
        // Badge
        newBadgeLabel.isHidden = !category.isNew
        
        // Accessibility
        accessibilityLabel = category.title
        accessibilityValue = category.isNew ? "Yeni kategori" : nil
        
        setupAccessibilityActions()
        
        // HER ZAMAN GÖRÜNÜR VE RENKLİ
        alpha = 1.0
        transform = .identity
        
        print("🎨 Default colored glass cell configured - ALWAYS COLORED: \(category.title)")
    }
    
    /// Icon konfigürasyonu - ENHANCED WITH ICON HELPER
    private func configureIcon(for category: MathCategory) {
        // CategoryIconsHelper kullanarak ikon al
        if let icon = CategoryIconsHelper.shared.getIcon(for: category.iconName) {
            iconImageView.image = icon
        } else {
            // Fallback: Math icons mapping
            let iconMap: [String: String] = [
                "addition": "plus",
                "subtraction": "minus",
                "multiplication": "multiply",
                "division": "divide",
                "fractions": "f.cursive",
                "percentages": "percent",
                "geometry": "triangle",
                "algebra": "x.squareroot",
                "mental_math": "brain.head.profile",
                "time_and_clock": "clock",
                "random_mixed": "shuffle",
                "negative_numbers": "plusminus",
                "order_of_operations": "function"
            ]
            
            if let systemIconName = iconMap[category.iconName.lowercased()],
               let systemIcon = UIImage(systemName: systemIconName) {
                iconImageView.image = systemIcon
            } else if let customIcon = UIImage(named: category.iconName) {
                iconImageView.image = customIcon
            } else if let systemIcon = UIImage(systemName: category.iconName) {
                iconImageView.image = systemIcon
            } else {
                iconImageView.image = UIImage(systemName: "plus")
            }
        }
        
        // Icon rengi kategori renginde - HER ZAMAN AKTİF
        iconImageView.tintColor = category.backgroundColor
    }
    
    /// DEFAULT COLORED GLASS - HER HÜCRE KENDİ RENGİNDE
    private func applyDefaultColoredGlass(_ baseColor: UIColor) {
        // Primary Color Layer (ana renk - güçlü)
        let primaryColor1 = baseColor.withAlphaComponent(0.9)
        let primaryColor2 = baseColor.withAlphaComponent(0.75)
        let primaryColor3 = baseColor.withAlphaComponent(0.6)
        let primaryColor4 = baseColor.withAlphaComponent(0.8)
        
        primaryColorLayer?.colors = [
            primaryColor1.cgColor,
            primaryColor2.cgColor,
            primaryColor3.cgColor,
            primaryColor4.cgColor
        ]
        primaryColorLayer?.locations = [0.0, 0.35, 0.65, 1.0]
        primaryColorLayer?.startPoint = CGPoint(x: 0, y: 0)
        primaryColorLayer?.endPoint = CGPoint(x: 1, y: 1)
        
        // Secondary Color Layer (derinlik için)
        let secondaryColor1 = baseColor.withAlphaComponent(0.5)
        let secondaryColor2 = baseColor.withAlphaComponent(0.3)
        let secondaryColor3 = baseColor.withAlphaComponent(0.4)
        
        secondaryColorLayer?.colors = [
            UIColor.clear.cgColor,
            secondaryColor1.cgColor,
            secondaryColor2.cgColor,
            secondaryColor3.cgColor
        ]
        secondaryColorLayer?.locations = [0.0, 0.4, 0.7, 1.0]
        secondaryColorLayer?.startPoint = CGPoint(x: 0, y: 1)
        secondaryColorLayer?.endPoint = CGPoint(x: 1, y: 0)
        
        // Border Glow (kenar ışıması - kategori renginde)
        borderGlowLayer?.colors = [
            baseColor.withAlphaComponent(0.6).cgColor,
            baseColor.withAlphaComponent(0.3).cgColor,
            UIColor.clear.cgColor,
            baseColor.withAlphaComponent(0.2).cgColor
        ]
        borderGlowLayer?.locations = [0.0, 0.15, 0.85, 1.0]
        borderGlowLayer?.startPoint = CGPoint(x: 0, y: 0)
        borderGlowLayer?.endPoint = CGPoint(x: 1, y: 1)
        
        // Glass layers opacity'lerini optimize et
        baseGlassLayer?.opacity = 0.6
        glassReflectionLayer?.opacity = 0.8
        
        print("🌈 Default colors applied: \(baseColor)")
    }
    
    // MARK: - State Override (NO VISUAL CHANGE)
    
    /// Selected state override - HİÇBİR GÖRSEL DEĞİŞİKLİK YOK
    override var isSelected: Bool {
        didSet {
            // SELECTED STATE DEĞİŞSE BİLE HİÇBİR GÖRSEL DEĞİŞİKLİK YOK
            print("⚠️ Cell selected state changed: \(isSelected) - NO VISUAL CHANGE")
        }
    }
    
    /// Highlighted state override - HİÇBİR GÖRSEL DEĞİŞİKLİK YOK
    override var isHighlighted: Bool {
        didSet {
            // HIGHLIGHTED STATE DEĞİŞSE BİLE HİÇBİR GÖRSEL DEĞİŞİKLİK YOK
            print("⚠️ Cell highlighted state changed: \(isHighlighted) - NO VISUAL CHANGE")
        }
    }
    
//    /// setSelected override - HİÇBİR GÖRSEL DEĞİŞİKLİK YOK
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//        // STATE DEĞİŞSE BİLE GÖRÜNÜMÜ ETKİLEME
//        print("⚠️ setSelected called: \(selected) - NO VISUAL CHANGE")
//    }
//    
//    /// setHighlighted override - HİÇBİR GÖRSEL DEĞİŞİKLİK YOK
//    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
//        super.setHighlighted(highlighted, animated: animated)
//        // STATE DEĞİŞSE BİLE GÖRÜNÜMÜ ETKİLEME
//        print("⚠️ setHighlighted called: \(highlighted) - NO VISUAL CHANGE")
//    }
    
    // MARK: - State Management
    
    /// Cell state reset - FULL RESET
    private func resetCellState() {
        category = nil
        titleLabel.text = ""
        iconImageView.image = nil
        iconImageView.tintColor = UIColor.systemBlue
        newBadgeLabel.isHidden = true
        
        // STATE RESET
        isSelected = false
        isHighlighted = false
        
        // VISUAL RESET
        transform = .identity
        alpha = 1.0
        layer.removeAllAnimations()
        
        print("🔄 Full cell state reset")
    }
    
    /// Animation preparation
    private func prepareAnimations() {
        alpha = 0.0
        transform = CGAffineTransform(scaleX: 0.88, y: 0.88)
    }
    
    // MARK: - Animations
    
    /// Default appearance - artık animasyon yok, direkt görünür
    func animateAppearance(withDelay delay: TimeInterval = 0.0) {
        // Animasyon yok - her zaman görünür
        alpha = 1.0
        transform = .identity
    }
    
    /// Selection animation (sadece interactive feedback)
    func animateSelection() {
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.prepare()
        impactFeedback.impactOccurred()
        
        // Subtle selection feedback (renk değişmez)
        UIView.animate(withDuration: 0.1, animations: {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { _ in
            UIView.animate(withDuration: 0.15, delay: 0.02, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: [], animations: {
                self.transform = .identity
            }, completion: nil)
        }
        
        // Subtle glow enhancement (renk değiştirmez, sadece parlaklık)
        //addSubtleGlowEffect()
    }
    
    // MARK: - Accessibility
    
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
    
    @objc private func accessibilitySelect() -> Bool {
        animateSelection()
        return true
    }
}

// MARK: - Extensions
extension CategoryCollectionViewCell {
    
    var currentCategory: MathCategory? {
        return category
    }
    
    var isSelectable: Bool {
        return category != nil
    }
    
    /// Performance optimization
    func optimizeForScrolling() {
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
    
    func removeScrollOptimization() {
        layer.shouldRasterize = false
    }
    
    /// Debug info
    var glassInfo: String {
        return "Colored Glass Cell: \(category?.title ?? "Unknown") - Layers: \(liquidGlassBackgroundView.layer.sublayers?.count ?? 0)"
    }
}
