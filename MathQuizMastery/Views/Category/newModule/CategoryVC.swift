//
//  CategoryVC.swift
//  MathQuizMastery
//
//  Created by AydınKaya on 22.07.2025.
//

import UIKit

// MARK: - Category View Controller (Modern Redesign)
/// Matematik kategorilerini gösteren ana ekran controller'ı
class CategoryVC: UIViewController {
    
    // MARK: - UI Components (Programmatic)
    private var collectionView: UICollectionView!       // Kategori collection view
    private var loadingIndicator: UIActivityIndicatorView! // Yükleme göstergesi
    
    // MARK: - Properties
    private let viewModel: CategoryViewModel                    // ViewModel referansı
    private weak var coordinator: AppCoordinator?              // Coordinator referansı
    
    /// Collection view için flow layout
    private var flowLayout: UICollectionViewFlowLayout {
        return collectionView.collectionViewLayout as! UICollectionViewFlowLayout
    }
    
    // MARK: - Lifecycle
    
    /// CategoryVC başlatıcı metodu
    init(viewModel: CategoryViewModel, coordinator: AppCoordinator) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
        print("✅ CategoryVC modern init")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupCollectionView()
        setupBindings()
        loadData()
        
        // Collection view touch behavior override
        overrideCollectionViewTouchBehavior()
        
        print("🎯 CategoryVC modern viewDidLoad tamamlandı")
    }
    
    /// Collection view touch davranışını override eder
    private func overrideCollectionViewTouchBehavior() {
        // Collection view'ın tüm subview'larını kontrol et
        for subview in collectionView.subviews {
            if let scrollView = subview as? UIScrollView {
                scrollView.delaysContentTouches = false
            }
        }
        
        // Collection view'ın kendi touch handling'ini disable et
        collectionView.canCancelContentTouches = false
        
        print("🔧 Collection view touch behavior override edildi")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateContentAppearance()
        
        // Ekran görününce tüm selection'ları temizle
        clearAllSelections()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: { [weak self] context in
            guard let self = self else { return }
            self.updateLayoutForSizeChange(size)
        }, completion: nil)
    }
    
    deinit {
        print("🗑️ CategoryVC deinit edildi")
        viewModel.delegate = nil
    }
    
    // MARK: - Setup Methods
    
    /// Modern UI bileşenlerini oluşturur
    private func setupUI() {
        view.backgroundColor = UIColor.systemBackground
        
        // Modern liquid glass arka plan
        setupModernLiquidGlassBackground()
        
        // Collection view oluştur (full screen)
        let layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = UIColor.clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInsetAdjustmentBehavior = .automatic
        
        // Touch davranışını kontrol et
        collectionView.delaysContentTouches = false
        
        view.addSubview(collectionView)
        
        // Loading indicator
        loadingIndicator = UIActivityIndicatorView(style: .large)
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.color = UIColor.systemBlue
        loadingIndicator.hidesWhenStopped = true
        view.addSubview(loadingIndicator)
        
        print("🎨 Modern UI bileşenleri oluşturuldu")
    }
    
    /// Constraint'leri ayarlar (title label yok)
    private func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            // Collection View - Full Screen (title yok)
            collectionView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            
            // Loading Indicator
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        print("🔗 Modern constraint'ler eklendi")
    }
    
    /// Modern collection view setup
    private func setupCollectionView() {
        print("🔧 Modern CollectionView setup...")
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.clear
        
        // Highlight ve selection davranışını kontrol et
        collectionView.allowsSelection = true
        collectionView.allowsMultipleSelection = false
        
        // Cell registration
        collectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: "CategoryCollectionViewCell")
        
        // Responsive layout ayarları
        setupResponsiveLayout()
        
        print("✅ Modern CollectionView setup tamamlandı")
    }
    
    /// Responsive layout setup
    private func setupResponsiveLayout() {
        flowLayout.scrollDirection = .vertical
        
        // Cihaza göre dinamik spacing
        let screenWidth = UIScreen.main.bounds.width
        let isIPad = UIDevice.current.userInterfaceIdiom == .pad
        
        if isIPad {
            // iPad için daha geniş spacing
            flowLayout.minimumInteritemSpacing = 20
            flowLayout.minimumLineSpacing = 25
            flowLayout.sectionInset = UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)
        } else {
            // iPhone için kompakt spacing
            flowLayout.minimumInteritemSpacing = 12
            flowLayout.minimumLineSpacing = 16
            flowLayout.sectionInset = UIEdgeInsets(top: 20, left: 16, bottom: 20, right: 16)
        }
        
        updateCollectionViewLayout()
    }
    
    /// Navigation bar setup
    private func setupNavigationBar() {
        // Navigation bar'ı gizlemeyi kaldır - görünür olsun
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    /// Modern liquid glass arka plan efekti
    private func setupModernLiquidGlassBackground() {
        // Animated gradient background
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [
            UIColor.systemBlue.withAlphaComponent(0.08).cgColor,
            UIColor.systemPurple.withAlphaComponent(0.06).cgColor,
            UIColor.systemIndigo.withAlphaComponent(0.08).cgColor,
            UIColor.systemTeal.withAlphaComponent(0.04).cgColor
        ]
        gradientLayer.locations = [0.0, 0.3, 0.7, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        // Ultra thin material blur
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.alpha = 0.5
        
        view.insertSubview(blurEffectView, at: 1)
        
        print("🌟 Modern liquid glass arka plan kuruldu")
    }
    
    /// ViewModel bağlantıları
    private func setupBindings() {
        viewModel.delegate = self
        print("🔗 ViewModel bağlantıları kuruldu")
    }
    
    /// Veri yükleme
    private func loadData() {
        showLoadingState(true)
        viewModel.loadCategories()
        print("📊 Veri yükleme başlatıldı")
    }
    
    // MARK: - Layout Methods
    
    /// Boyut değişimi için responsive layout
    private func updateLayoutForSizeChange(_ newSize: CGSize) {
        setupResponsiveLayout()
        
        UIView.animate(withDuration: 0.3, animations: {
            self.collectionView.collectionViewLayout.invalidateLayout()
        })
    }
    
    /// Collection view layout güncelleme
    private func updateCollectionViewLayout() {
        let screenWidth = UIScreen.main.bounds.width
        let isIPad = UIDevice.current.userInterfaceIdiom == .pad
        let isLandscape = UIScreen.main.bounds.width > UIScreen.main.bounds.height
        
        // Responsive grid calculation
        let sectionInsets = flowLayout.sectionInset
        let spacing = flowLayout.minimumInteritemSpacing
        let availableWidth = screenWidth - sectionInsets.left - sectionInsets.right
        
        var itemsPerRow: Int
        var itemSize: CGSize
        
        if isIPad {
            // iPad: 4-6 columns based on orientation
            itemsPerRow = isLandscape ? 6 : 4
            let itemWidth = (availableWidth - (CGFloat(itemsPerRow - 1) * spacing)) / CGFloat(itemsPerRow)
            itemSize = CGSize(width: itemWidth, height: itemWidth * 1.1) // Slightly taller
        } else {
            // iPhone: 2-3 columns based on screen size
            if screenWidth >= 414 { // iPhone Pro Max
                itemsPerRow = isLandscape ? 4 : 3
            } else { // Regular iPhone
                itemsPerRow = isLandscape ? 3 : 2
            }
            
            let itemWidth = (availableWidth - (CGFloat(itemsPerRow - 1) * spacing)) / CGFloat(itemsPerRow)
            itemSize = CGSize(width: itemWidth, height: itemWidth * 1.15) // Card-like ratio
        }
        
        flowLayout.itemSize = itemSize
        
        print("📐 Layout güncellendi: \(itemsPerRow) columns, size: \(itemSize)")
    }
    
    // MARK: - Animation Methods
    
    /// Loading state
    private func showLoadingState(_ show: Bool) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            if show {
                self.loadingIndicator.startAnimating()
                self.collectionView.alpha = 0.3
            } else {
                self.loadingIndicator.stopAnimating()
                self.collectionView.alpha = 1.0
            }
        }
    }
    
    /// Content appearance - artık animasyon yok
    private func animateContentAppearance() {
        // Collection view direkt görünür
        collectionView.alpha = 1.0
    }
    
    /// Cell selection animation
    private func animateCategorySelection(at indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CategoryCollectionViewCell else { return }
        
        // Modern bounce effect
        UIView.animate(withDuration: 0.15, animations: {
            cell.transform = CGAffineTransform(scaleX: 0.92, y: 0.92)
        }) { _ in
            UIView.animate(withDuration: 0.15, delay: 0.05, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.8, options: [], animations: {
                cell.transform = .identity
            }, completion: nil)
        }
    }
}

// MARK: - CategoryViewModelDelegate
extension CategoryVC: CategoryViewModelDelegate {
    
    func categoriesDidLoad() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.showLoadingState(false)
            self.collectionView.reloadData()
            
            // TÜM SEÇİMLERİ TEMİZLE
            self.clearAllSelections()
            
            print("✅ Kategoriler yüklendi - ALL SELECTIONS CLEARED")
        }
    }
    
    /// Tüm selection'ları temizler
    private func clearAllSelections() {
        // Tüm selected indexPath'leri al ve temizle
        for indexPath in collectionView.indexPathsForSelectedItems ?? [] {
            collectionView.deselectItem(at: indexPath, animated: false)
        }
        
        print("🧹 All selections cleared")
    }
    
    func categorySelectionDidChange(_ category: MathCategory?) {
        print("🎯 Seçili kategori: \(category?.title ?? "None")")
    }
    
    func errorDidOccur(_ error: Error) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.showLoadingState(false)
            
            print("❌ Kategori yükleme hatası: \(error.localizedDescription)")
            
            let alert = UIAlertController(
                title: "Bağlantı Hatası",
                message: "Kategoriler yüklenirken bir sorun oluştu. İnternet bağlantınızı kontrol edin.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "Tamam", style: .default))
            alert.addAction(UIAlertAction(title: "Tekrar Dene", style: .default) { _ in
                self.loadData()
            })
            self.present(alert, animated: true)
        }
    }
}

// MARK: - UICollectionViewDataSource
extension CategoryVC: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = viewModel.numberOfCategories
        print("📊 Toplam kategori: \(count)")
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath)
        
        guard let categoryCell = cell as? CategoryCollectionViewCell else {
            print("❌ Cell cast hatası: \(indexPath)")
            return UICollectionViewCell()
        }
        
        if let category = viewModel.category(at: indexPath.item) {
            categoryCell.configure(with: category)
            // Staggered animation kaldırıldı - direkt görünür
            
        } else {
            configureFallbackCell(categoryCell, at: indexPath)
        }
        
        return categoryCell
    }
    
    private func configureFallbackCell(_ cell: CategoryCollectionViewCell, at indexPath: IndexPath) {
        let fallbackCategory = MathCategory(
            id: indexPath.item,
            title: "Yükleniyor...",
            iconName: "questionmark.circle.fill",
            backgroundColor: .systemGray,
            expressionType: .addition
        )
        
        cell.configure(with: fallbackCategory)
    }
}

// MARK: - UICollectionViewDelegate
extension CategoryVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("👆 Kategori seçildi: \(indexPath)")
        
        // SEÇİMİ HEMEN KALDIR - HIGHLIGHT STATE'İ ENGELLE
        collectionView.deselectItem(at: indexPath, animated: false)
        
        // Cell'in kendi animateSelection metodunu çağır
        if let cell = collectionView.cellForItem(at: indexPath) as? CategoryCollectionViewCell {
            cell.animateSelection()
        }
        
        guard let category = viewModel.category(at: indexPath.item) else {
            print("❌ Kategori bulunamadı: \(indexPath)")
            return
        }
        
        viewModel.selectCategory(category)
        
        // Smooth transition delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) { [weak self] in // Reduced delay
            // Enhanced navigation method kullan
            if let strongSelf = self, let coordinator = strongSelf.coordinator {
                coordinator.goToGameFromCategory(
                    with: category.expressionType,
                    fromCategory: category,
                    animated: true
                )
            }
            print("🎮 Enhanced oyun geçişi: \(category.title)")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        
        UIView.animate(withDuration: 0.1, animations: {
            cell.transform = CGAffineTransform(scaleX: 0.96, y: 0.96)
            cell.alpha = 0.85
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        
        UIView.animate(withDuration: 0.1, animations: {
            cell.transform = .identity
            cell.alpha = 1.0
        })
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension CategoryVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return flowLayout.itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return flowLayout.minimumInteritemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return flowLayout.minimumLineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return flowLayout.sectionInset
    }
}
