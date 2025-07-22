//
//  CategoryCollectionViewCell.swift
//  MathQuizMastery
//
//  Created by Aydın KAYA on 23.07.2025.
//

import UIKit

// MARK: - Category Collection View Cell (PURE PROGRAMMATIC - NO XIB)
/// Matematik kategorisi kartını gösteren collection view cell'i
class CategoryCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI Components (NO @IBOutlet)
    private var containerView: UIView!
    private var backgroundGradientView: UIView!
    private var iconImageView: UIImageView!
    private var titleLabel: UILabel!
    private var newBadgeLabel: UILabel!
    
    // MARK: - Properties
    private var gradientLayer: CAGradientLayer?
    private var blurEffectView: UIVisualEffectView?
    private var category: MathCategory?
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLiquidGlass()
        print("✅ CategoryCollectionViewCell programmatic init")
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        setupLiquidGlass()
        print("✅ CategoryCollectionViewCell coder init")
    }
    
    // MARK: - Lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()
        updateGradientFrame()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        resetCellState()
    }
    
    // MARK: - Setup Methods
    
    /// UI bileşenlerini programmatik olarak oluşturur
    private func setupUI() {
        // Container View
        containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = UIColor.clear
        containerView.layer.cornerRadius = 20
        containerView.layer.masksToBounds = true
        contentView.addSubview(containerView)
        
        // Background Gradient View
        backgroundGradientView = UIView()
        backgroundGradientView.translatesAutoresizingMaskIntoConstraints = false
        backgroundGradientView.backgroundColor = UIColor.systemBlue
        backgroundGradientView.layer.cornerRadius = 20
        backgroundGradientView.layer.masksToBounds = true
        containerView.addSubview(backgroundGradientView)
        
        // Icon ImageView
        iconImageView = UIImageView()
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = UIColor.white
        iconImageView.image = UIImage(systemName: "plus.circle.fill")
        containerView.addSubview(iconImageView)
        
        // Title Label
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        titleLabel.textColor = UIColor.white
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 2
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.8
        titleLabel.text = "KATEGORI"
        containerView.addSubview(titleLabel)
        
        // New Badge Label
        newBadgeLabel = UILabel()
        newBadgeLabel.translatesAutoresizingMaskIntoConstraints = false
        newBadgeLabel.font = UIFont.systemFont(ofSize: 10, weight: .bold)
        newBadgeLabel.textColor = UIColor.white
        newBadgeLabel.backgroundColor = UIColor.systemRed
        newBadgeLabel.text = "YENİ"
        newBadgeLabel.textAlignment = .center
        newBadgeLabel.layer.cornerRadius = 9
        newBadgeLabel.layer.masksToBounds = true
        newBadgeLabel.isHidden = true
        containerView.addSubview(newBadgeLabel)
        
        // Setup Constraints
        setupConstraints()
        
        // Setup Shadow
        setupShadow()
        
        // Setup Accessibility
        setupAccessibility()
        
        print("🎨 UI bileşenleri programmatik olarak oluşturuldu")
    }
    
    /// Auto Layout constraint'lerini ayarlar
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Container View Constraints (8pt margins)
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            // Background View Constraints (fill container)
            backgroundGradientView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            backgroundGradientView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            backgroundGradientView.topAnchor.constraint(equalTo: containerView.topAnchor),
            backgroundGradientView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            // Icon Constraints (50x50, centered, top)
            iconImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            iconImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 40),
            iconImageView.widthAnchor.constraint(equalToConstant: 50),
            iconImageView.heightAnchor.constraint(equalToConstant: 50),
            
            // Title Constraints (bottom, 35pt height)
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            titleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -6),
            titleLabel.heightAnchor.constraint(equalToConstant: 35),
            
            // Badge Constraints (top-right, 35x18)
            newBadgeLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            newBadgeLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            newBadgeLabel.widthAnchor.constraint(equalToConstant: 35),
            newBadgeLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
        
        print("🔗 Constraint'ler programmatik olarak eklendi")
    }
    
    /// Liquid Glass efektini kurar
    private func setupLiquidGlass() {
        // Blur efekt view oluştur
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView?.frame = containerView?.bounds ?? .zero
        blurEffectView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView?.alpha = 0.7
        
        // Blur view'ı container'a ekle (en alta)
        if let blurView = blurEffectView, let container = containerView {
            container.insertSubview(blurView, at: 0)
        }
        
        // Gradient layer oluştur
        gradientLayer = CAGradientLayer()
        gradientLayer?.cornerRadius = 20
        gradientLayer?.masksToBounds = true
        
        // Gradient'i blur view'ın üzerine ekle
        if let gradient = gradientLayer, let container = containerView {
            container.layer.insertSublayer(gradient, above: blurEffectView?.layer)
        }
        
        print("🌟 Liquid glass efekti programmatik olarak kuruldu")
    }
    
    /// Gölge efektini ayarlar
    private func setupShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 12
        layer.shadowOpacity = 0.15
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 20).cgPath
    }
    
    /// Accessibility ayarlarını yapar
    private func setupAccessibility() {
        isAccessibilityElement = true
        accessibilityTraits = .button
    }
    
    // MARK: - Configuration
    
    /// Cell'i verilen kategori ile yapılandırır
    func configure(with category: MathCategory) {
        self.category = category
        
        // Başlık ayarla
        titleLabel.text = category.title
        
        // İkon ayarla - önce custom, sonra system icon dene
        if let customIcon = UIImage(named: category.iconName) {
            iconImageView.image = customIcon
        } else if let systemIcon = UIImage(systemName: category.iconName) {
            iconImageView.image = systemIcon
        } else {
            // Fallback icon
            iconImageView.image = UIImage(systemName: "plus.circle.fill")
        }
        
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
        
        print("🔧 Cell configure edildi: \(category.title)")
    }
    
    // MARK: - Private Methods
    
    /// Gradient renklerini günceller
    private func updateGradientColors(_ baseColor: UIColor) {
        let lightColor = baseColor.withAlphaComponent(0.9)
        let darkColor = baseColor.withAlphaComponent(0.6)
        let accentColor = baseColor.withAlphaComponent(0.8)
        
        gradientLayer?.colors = [
            lightColor.cgColor,
            accentColor.cgColor,
            darkColor.cgColor
        ]
        
        gradientLayer?.locations = [0.0, 0.5, 1.0]
        gradientLayer?.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer?.endPoint = CGPoint(x: 1.0, y: 1.0)
        
        // Background view'a da renk ver (fallback)
        backgroundGradientView.backgroundColor = baseColor
    }
    
    /// Gradient frame'ini günceller
    private func updateGradientFrame() {
        guard let container = containerView else { return }
        
        gradientLayer?.frame = container.bounds
        blurEffectView?.frame = container.bounds
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 20).cgPath
    }
    
    /// Cell durumunu sıfırlar
    private func resetCellState() {
        category = nil
        titleLabel.text = ""
        iconImageView.image = nil
        newBadgeLabel.isHidden = true
        
        transform = .identity
        alpha = 1.0
        layer.removeAllAnimations()
    }
    
    /// Animasyonları hazırlar
    private func prepareAnimations() {
        alpha = 0.0
        transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
    }
    
    // MARK: - Animation Methods
    
    /// Görünüm animasyonunu başlatır
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
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
        
        UIView.animate(withDuration: 0.1, animations: {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { _ in
            UIView.animate(withDuration: 0.1, animations: {
                self.transform = .identity
            })
        }
        
        addGlowEffect()
    }
    
    /// Glow efekti ekler
    private func addGlowEffect() {
        layer.shadowColor = category?.backgroundColor.cgColor ?? UIColor.white.cgColor
        layer.shadowRadius = 20
        layer.shadowOpacity = 0.6
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            UIView.animate(withDuration: 0.3) {
                self?.layer.shadowColor = UIColor.black.cgColor
                self?.layer.shadowRadius = 12
                self?.layer.shadowOpacity = 0.15
            }
        }
    }
    
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
        animateSelection()
        return true
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
