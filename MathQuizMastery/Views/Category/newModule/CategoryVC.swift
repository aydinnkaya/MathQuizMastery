//
//  CategoryVC.swift
//  MathQuizMastery
//
//  Created by AydınKaya on 22.07.2025.
//

import UIKit

// MARK: - Category View Controller
/// Matematik kategorilerini gösteren ana ekran controller'ı
class CategoryVC: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var titleLabel: UILabel!                    // Ana başlık etiketi
    @IBOutlet weak var collectionView: UICollectionView!       // Kategori collection view
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView! // Yükleme göstergesi
    
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
        super.init(nibName: "CategoryVC", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()                    // UI bileşenlerini ayarla
        setupCollectionView()        // Collection view'ı yapılandır
        setupBindings()              // ViewModel bağlantılarını kur
        loadData()                   // Veri yüklemeyi başlat
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
    
    // MARK: - Setup Methods
    
    /// UI bileşenlerini yapılandırır
    private func setupUI() {
        view.backgroundColor = UIColor.systemBackground
        
        // Ana başlık ayarları
        titleLabel.text = "MATH QUIZ MASTERY"
        titleLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        titleLabel.textColor = UIColor.label
        titleLabel.textAlignment = .center
        
        // Loading indicator ayarları
        loadingIndicator.style = .large
        loadingIndicator.color = UIColor.systemBlue
        loadingIndicator.hidesWhenStopped = true
        
        // Liquid Glass efekti için arka plan
        setupLiquidGlassBackground()
    }
    
    /// Collection view'ı yapılandırır
    private func setupCollectionView() {
        // Collection view temizle ve ayarla
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.clear
        
        // Cell register et
        let cellNib = UINib(nibName: "CategoryCollectionViewCell", bundle: nil)
        collectionView.register(cellNib, forCellWithReuseIdentifier: "CategoryCollectionViewCell")
        
        // Flow layout ayarları
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumInteritemSpacing = 16
        flowLayout.minimumLineSpacing = 20
        flowLayout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        
        // Initial grid configuration
        updateCollectionViewLayout()
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
    }
    
    /// ViewModel ile bağlantıları kurar
    private func setupBindings() {
        viewModel.delegate = self
    }
    
    /// Veri yüklemeyi başlatır
    private func loadData() {
        showLoadingState(true)
        viewModel.loadCategories()
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
        let itemsPerRow = viewModel.gridConfiguration.itemsPerRow
        let totalItems = viewModel.numberOfCategories
        return Int(ceil(Double(totalItems) / Double(itemsPerRow)))
    }
    
    /// Section'daki öğe sayısını hesaplar
    /// - Parameter section: Section indeksi
    /// - Returns: O section'daki öğe sayısı
    private func numberOfItemsInSection(_ section: Int) -> Int {
        let itemsPerRow = viewModel.gridConfiguration.itemsPerRow
        let totalItems = viewModel.numberOfCategories
        let startIndex = section * itemsPerRow
        let remainingItems = totalItems - startIndex
        return min(remainingItems, itemsPerRow)
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
        return numberOfItemsInSection(section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as! CategoryCollectionViewCell
        
        // Index path'e göre kategoriyi al
        if let category = viewModel.category(for: indexPath) {
            cell.configure(with: category)
            
            // Cell animasyonu (ilk görünümde)
            if collectionView.visibleCells.contains(cell) == false {
                cell.alpha = 0
                cell.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                
                UIView.animate(withDuration: 0.5, delay: Double(indexPath.item) * 0.1, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: [.allowUserInteraction], animations: {
                    cell.alpha = 1.0
                    cell.transform = .identity
                }, completion: nil)
            }
        }
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension CategoryVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Seçim animasyonu
        animateCategorySelection(at: indexPath)
        
        // Seçilen kategoriyi al ve işle
        guard let category = viewModel.category(for: indexPath) else { return }
        
        // ViewModel'de seçimi kaydet
        viewModel.selectCategory(category)
        
        // Coordinator'a kategori seçimini bildir (0.3 saniye gecikme ile animasyon tamamlandıktan sonra)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            self?.coordinator?.goToGameVC(with: category.expressionType)
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
        return viewModel.gridConfiguration.itemSize(for: collectionView.bounds.width)
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("⚠️ CategoryVC: Memory warning alındı")
        
        // Gerekirse cache temizlik işlemleri yapılabilir
    }
    
//    deinit {
//        print("🗑️ CategoryVC deinit edildi")
//        viewModel.delegate = nil
//    }
}
