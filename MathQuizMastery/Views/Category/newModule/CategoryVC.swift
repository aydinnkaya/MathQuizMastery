//
//  CategoryVC.swift
//  MathQuizMastery
//
//  Created by AydınKaya on 22.07.2025.
//

import UIKit

// MARK: - Category View Controller (XIB'siz)
/// Matematik kategorilerini gösteren ana ekran controller'ı
class CategoryVC: UIViewController {
    
    // MARK: - UI Components (Programmatic)
    private var titleLabel: UILabel!                    // Ana başlık etiketi
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
    /// - Parameters:
    ///   - viewModel: CategoryViewModel instance
    ///   - coordinator: AppCoordinator referansı
    init(viewModel: CategoryViewModel, coordinator: AppCoordinator) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil) // XIB YOK
        print("✅ CategoryVC programmatic init")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()                    // UI bileşenlerini ayarla
        setupConstraints()           // Constraint'leri ayarla
        setupCollectionView()        // Collection view'ı yapılandır
        setupBindings()              // ViewModel bağlantılarını kur
        loadData()                   // Veri yüklemeyi başlat
        print("🎯 CategoryVC viewDidLoad tamamlandı")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()         // Navigation bar ayarlarını yap
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateContentAppearance()   // İçerik görünüm animasyonu
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        // Orientation değişiminde grid'i güncelle
        coordinator.animate(alongsideTransition: { [weak self] context in
            guard let self = self else { return }
            self.updateLayoutForSizeChange(size)
        }, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("⚠️ CategoryVC: Memory warning alındı")
        
        // Gerekirse cache temizlik işlemleri yapılabilir
    }
    
    deinit {
        print("🗑️ CategoryVC deinit edildi")
        viewModel.delegate = nil
    }
    
    // MARK: - Setup Methods
    
    /// UI bileşenlerini programmatik olarak oluşturur
    private func setupUI() {
        view.backgroundColor = UIColor.systemBackground
        
        // Ana başlık oluştur
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "MATH QUIZ MASTERY"
        titleLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        titleLabel.textColor = UIColor.label
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 1
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.8
        view.addSubview(titleLabel)
        
        // Collection view oluştur
        let layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = UIColor.clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        view.addSubview(collectionView)
        
        // Loading indicator oluştur
        loadingIndicator = UIActivityIndicatorView(style: .large)
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.color = UIColor.systemBlue
        loadingIndicator.hidesWhenStopped = true
        view.addSubview(loadingIndicator)
        
        // Liquid Glass efekti için arka plan
        setupLiquidGlassBackground()
        
        print("🎨 UI bileşenleri programmatik olarak oluşturuldu")
    }
    
    /// Auto Layout constraint'lerini ayarlar
    private func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            // Title Label Constraints
            titleLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            titleLabel.heightAnchor.constraint(equalToConstant: 40),
            
            // Collection View Constraints
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            
            // Loading Indicator Constraints (centered)
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        print("🔗 Constraint'ler programmatik olarak eklendi")
    }
    
    /// Collection view'ı yapılandırır
    private func setupCollectionView() {
        print("🔧 CollectionView setup başlatılıyor (XIB'siz)...")
        
        // Collection view temizle ve ayarla
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.clear
        
        // SADECE PROGRAMMATIC CELL REGISTRATION
        collectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: "CategoryCollectionViewCell")
        print("✅ Programmatic cell register edildi")
        
        // Flow layout ayarları
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumInteritemSpacing = 16
        flowLayout.minimumLineSpacing = 20
        flowLayout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        
        // Initial grid configuration
        updateCollectionViewLayout()
        
        print("🎯 CollectionView setup tamamlandı")
    }
    
    /// Navigation bar ayarlarını yapar
    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.title = ""
        
        // Navigation bar şeffaf yap
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
    }
    
    /// Liquid Glass arka plan efekti kurar
    private func setupLiquidGlassBackground() {
        // Gradient arka plan oluştur
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [
            UIColor.systemBlue.withAlphaComponent(0.1).cgColor,
            UIColor.systemPurple.withAlphaComponent(0.05).cgColor,
            UIColor.systemIndigo.withAlphaComponent(0.1).cgColor
        ]
        gradientLayer.locations = [0.0, 0.5, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        
        // Arka plana gradient ekle
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        // Blur efekti ekle
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.alpha = 0.3
        
        view.insertSubview(blurEffectView, at: 1)
        
        print("🌟 Liquid glass arka plan efekti kuruldu")
    }
    
    /// ViewModel ile bağlantıları kurar
    private func setupBindings() {
        viewModel.delegate = self
        print("🔗 ViewModel bağlantıları kuruldu")
    }
    
    /// Veri yüklemeyi başlatır
    private func loadData() {
        showLoadingState(true)
        viewModel.loadCategories()
        print("📊 Veri yükleme başlatıldı")
    }
    
    // MARK: - Layout Methods
    
    /// Boyut değişimi için layout'u günceller
    /// - Parameter newSize: Yeni ekran boyutu
    private func updateLayoutForSizeChange(_ newSize: CGSize) {
        viewModel.updateGridConfiguration(for: newSize, traitCollection: traitCollection)
        updateCollectionViewLayout()
        
        // Layout güncellemeyi animate et
        UIView.animate(withDuration: 0.3, animations: {
            self.collectionView.collectionViewLayout.invalidateLayout()
        })
    }
    
    /// Collection view layout'unu günceller
    private func updateCollectionViewLayout() {
        let config = viewModel.gridConfiguration
        let itemSize = config.itemSize(for: view.bounds.width)
        
        flowLayout.itemSize = itemSize
        flowLayout.minimumInteritemSpacing = config.spacing
        flowLayout.minimumLineSpacing = config.spacing
        flowLayout.sectionInset = config.sectionInsets
    }
    
    // MARK: - Animation Methods
    
    /// Loading durumunu gösterir/gizler
    /// - Parameter show: Gösterilecek mi?
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
    
    /// İçerik görünüm animasyonu
    private func animateContentAppearance() {
        // Başlık animasyonu
        titleLabel.transform = CGAffineTransform(translationX: 0, y: -50)
        titleLabel.alpha = 0
        
        // Collection view animasyonu
        collectionView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        collectionView.alpha = 0
        
        UIView.animate(withDuration: 0.8, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: [.allowUserInteraction], animations: {
            // Başlık animasyonu
            self.titleLabel.transform = .identity
            self.titleLabel.alpha = 1.0
        }, completion: nil)
        
        UIView.animate(withDuration: 0.8, delay: 0.2, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: [.allowUserInteraction], animations: {
            // Collection view animasyonu
            self.collectionView.transform = .identity
            self.collectionView.alpha = 1.0
        }, completion: nil)
    }
    
    /// Kategori seçim animasyonu
    /// - Parameter indexPath: Seçilen cell'in index path'i
    private func animateCategorySelection(at indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CategoryCollectionViewCell else { return }
        
        // Bounce animasyon efekti
        UIView.animate(withDuration: 0.1, animations: {
            cell.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { _ in
            UIView.animate(withDuration: 0.1, animations: {
                cell.transform = .identity
            })
        }
    }
    
    // MARK: - Helper Methods
    
    /// Kategori sayısına göre section sayısını hesaplar
    /// - Returns: Section sayısı
    private func numberOfSections() -> Int {
        return 1 // Basit grid için tek section
    }
    
    /// Section'daki öğe sayısını hesaplar
    /// - Parameter section: Section indeksi
    /// - Returns: O section'daki öğe sayısı
    private func numberOfItemsInSection(_ section: Int) -> Int {
        return viewModel.numberOfCategories
    }
}

// MARK: - CategoryViewModelDelegate
extension CategoryVC: CategoryViewModelDelegate {
    
    func categoriesDidLoad() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.showLoadingState(false)
            self.collectionView.reloadData()
            
            // Kategoriler yüklendikten sonra görünüm animasyonu
            self.animateContentAppearance()
            
            print("✅ Kategoriler yüklendi ve UI güncellendi")
        }
    }
    
    func categorySelectionDidChange(_ category: MathCategory?) {
        // Kategori seçimi değiştiğinde yapılacak işlemler
        print("🎯 Seçili kategori değişti: \(category?.title ?? "None")")
    }
    
    func errorDidOccur(_ error: Error) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.showLoadingState(false)
            
            print("❌ Kategori yükleme hatası: \(error.localizedDescription)")
            
            // Hata durumunda kullanıcıya alert göster
            let alert = UIAlertController(
                title: "Hata",
                message: "Kategoriler yüklenirken bir hata oluştu. Lütfen tekrar deneyin.",
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
        return numberOfSections()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = numberOfItemsInSection(section)
        print("📊 Kategori sayısı: \(count)")
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        print("🔄 Cell oluşturuluyor: \(indexPath)")
        
        // Programmatic cell'i dequeue et
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath)
        
        // CategoryCollectionViewCell'e cast et
        guard let categoryCell = cell as? CategoryCollectionViewCell else {
            print("❌ Cell cast hatası: \(indexPath) - \(type(of: cell))")
            
            // Emergency fallback cell
            let fallbackCell = UICollectionViewCell()
            fallbackCell.backgroundColor = .systemGray
            fallbackCell.layer.cornerRadius = 20
            return fallbackCell
        }
        
        // Index path'e göre kategoriyi al
        if let category = viewModel.category(at: indexPath.item) {
            print("✅ Kategori yüklendi: \(category.title)")
            
            categoryCell.configure(with: category)
            
            // Cell animasyonu (ilk görünümde)
            if !collectionView.visibleCells.contains(categoryCell) {
                categoryCell.animateAppearance(withDelay: Double(indexPath.item) * 0.05)
            }
            
        } else {
            print("⚠️ Kategori yok: \(indexPath.item)")
            configureFallbackCell(categoryCell, at: indexPath)
        }
        
        return categoryCell
    }
    
    /// Fallback cell konfigürasyonu
    private func configureFallbackCell(_ cell: CategoryCollectionViewCell, at indexPath: IndexPath) {
        let fallbackCategory = MathCategory(
            id: indexPath.item,
            title: "Yükleniyor...",
            iconName: "questionmark.circle.fill",
            backgroundColor: .systemGray,
            expressionType: .addition
        )
        
        cell.configure(with: fallbackCategory)
        print("🔄 Fallback cell yapılandırıldı: \(indexPath)")
    }
}

// MARK: - UICollectionViewDelegate
extension CategoryVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("👆 Cell seçildi: \(indexPath)")
        
        // Seçim animasyonu
        animateCategorySelection(at: indexPath)
        
        // Seçilen kategoriyi al ve işle
        guard let category = viewModel.category(at: indexPath.item) else {
            print("❌ Seçilen kategori bulunamadı: \(indexPath)")
            return
        }
        
        // ViewModel'de seçimi kaydet
        viewModel.selectCategory(category)
        
        // Coordinator'a kategori seçimini bildir (0.3 saniye gecikme ile animasyon tamamlandıktan sonra)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            self?.coordinator?.goToGameVC(with: category.expressionType)
            print("🎮 Oyun ekranına geçiş: \(category.title)")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        // Highlight animasyonu
        guard let cell = collectionView.cellForItem(at: indexPath) as? CategoryCollectionViewCell else { return }
        
        UIView.animate(withDuration: 0.1, animations: {
            cell.transform = CGAffineTransform(scaleX: 0.98, y: 0.98)
            cell.alpha = 0.8
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        // Unhighlight animasyonu
        guard let cell = collectionView.cellForItem(at: indexPath) as? CategoryCollectionViewCell else { return }
        
        UIView.animate(withDuration: 0.1, animations: {
            cell.transform = .identity
            cell.alpha = 1.0
        })
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension CategoryVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let config = viewModel.gridConfiguration
        let size = config.itemSize(for: collectionView.bounds.width)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return viewModel.gridConfiguration.spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return viewModel.gridConfiguration.spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return viewModel.gridConfiguration.sectionInsets
    }
}

// MARK: - Memory Management
extension CategoryVC {
    

}
