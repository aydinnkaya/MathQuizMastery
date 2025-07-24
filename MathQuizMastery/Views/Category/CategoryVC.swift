//
//  CategoryVC.swift
//  MathQuizMastery
//
//  Created by Aydın KAYA on 17.05.2025.
//

import UIKit

class CategoryVC: UIViewController{
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var backgroundView: UIImageView!
    
    var viewModel: CategoryViewModelProtocol?
    var coordinator: AppCoordinator!
    
    private var _numerOfIndexPaths: Int = 0
    
    init(viewModel: CategoryViewModelProtocol, coordinator: AppCoordinator) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName:"CategoryVC", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func commonInit() {
        if let view = Bundle.main.loadNibNamed("CategoryVC", owner: self, options: nil)?.first as? UIView {
            self.view = view
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.delegate = self
        setupCollectionView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Layout'u yeniden hesapla
        DispatchQueue.main.async {
            self.collectionView.collectionViewLayout.invalidateLayout()
        }
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "CategoryCell")
        
        // CollectionView için güvenli alan ayarları
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.automaticallyAdjustsScrollIndicatorInsets = false
    }
    
    // Cihaz tipini belirleme yardımcı fonksiyonu
    private func getDeviceType() -> (isIpad: Bool, screenSize: CGSize, safeAreaInsets: UIEdgeInsets) {
        let bounds = UIScreen.main.bounds
        let safeArea = view.safeAreaInsets
        let isIpad = UIDevice.current.userInterfaceIdiom == .pad
        
        return (isIpad, bounds.size, safeArea)
    }
}

extension CategoryVC: CategoryViewModelDelegate {
    func navigateToGameVC(with type: MathExpression.ExpressionType) {
        coordinator.goToGameVC(with: type)
    }
}

extension CategoryVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("🔄 numberOfItemsInSection çağrıldı. Section: \(section)")
        if section == 0 {
            return (viewModel?.numberOfItems ?? 0) - 1
        } else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath)
        
        if let viewModel = viewModel {
            if indexPath.section == 0 {
                let adjustedIndex = indexPath.row
                cell.configureCategoryCell(with: viewModel, at: IndexPath(row: adjustedIndex, section: 0))
            } else {
                cell.configureRandomIcon()
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            viewModel?.categorySelected(at: indexPath.row)
        } else {
            viewModel?.categorySelected(at: viewModel!.numberOfItems - 1)
        }
    }
}

extension CategoryVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let deviceInfo = getDeviceType()
        
        if deviceInfo.isIpad {
            // iPad için daha büyük hücreler
            return CGSize(width: 180, height: 180)
        } else {
            // iPhone için mevcut boyutlar
            let screenWidth = deviceInfo.screenSize.width
            if screenWidth <= 375 {
                // iPhone SE, 6, 7, 8 için küçük boyut
                return CGSize(width: 110, height: 110)
            } else if screenWidth <= 414 {
                // iPhone 6+, 7+, 8+, XR, 11 için orta boyut
                return CGSize(width: 130, height: 130)
            } else {
                // iPhone X, XS, 11 Pro, 12, 13, 14 ve üzeri için büyük boyut
                return CGSize(width: 140, height: 140)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        let deviceInfo = getDeviceType()
        let screenWidth = deviceInfo.screenSize.width
        let screenHeight = deviceInfo.screenSize.height
        let safeAreaBottom = deviceInfo.safeAreaInsets.bottom
        let safeAreaTop = deviceInfo.safeAreaInsets.top
        let isIpad = deviceInfo.isIpad
        
        if section == 0 {
            // Ana kategoriler (üstteki dört işlem)
            if isIpad {
                // iPad için büyük margin'ler
                let sideInset: CGFloat = screenWidth * 0.15 // Ekran genişliğinin %15'i
                let topInset: CGFloat = safeAreaTop + 120
                let bottomInset: CGFloat = 120
                return UIEdgeInsets(top: topInset, left: sideInset, bottom: bottomInset, right: sideInset)
            } else {
                // iPhone için responsive margin'ler
                let sideInset: CGFloat
                let topInset: CGFloat
                let bottomInset: CGFloat = 60  // Section 0 için daha az alt boşluk
                
                switch screenWidth {
                case 0...375:
                    // iPhone SE, 6, 7, 8
                    sideInset = 20
                    topInset = safeAreaTop + 30
                case 376...389:
                    // iPhone 6+, 7+, 8+, XR, 11
                    sideInset = 32
                    topInset = safeAreaTop + 40
                case 390...414:
                    // iPhone 12, 13, 14, 15, 16 Pro
                    sideInset = 45
                    topInset = safeAreaTop + 50  // Daha da yukarı
                case 415...430:
                    // iPhone 12 Pro Max, 13 Pro Max, 14 Pro Max, 15 Pro Max, 16 Pro Max
                    sideInset = 50
                    topInset = safeAreaTop + 40  // Daha da yukarı
                default:
                    // iPhone X, XS, 11 Pro, 12, 13, 14, 15, 16 ve diğerleri
                    sideInset = 40
                    topInset = safeAreaTop + 45
                }
                
                return UIEdgeInsets(top: topInset, left: sideInset, bottom: bottomInset, right: sideInset)
            }
        } else {
            // Random Buton (Alttaki tek buton)
            let collectionViewWidth = collectionView.frame.width
            let cellWidth: CGFloat = isIpad ? 180 : (screenWidth <= 375 ? 110 : (screenWidth <= 414 ? 130 : 140))
            
            // Sol ve sağ eşit aralığı hesapla
            let horizontalInset = max((collectionViewWidth - cellWidth) / 2, 16)
            
            // Alt boşluk hesaplama - tüm cihazlar için güvenli alan dikkate alınarak
            let bottomInset: CGFloat
            if isIpad {
                bottomInset = max(safeAreaBottom + 60, 80)
            } else {
                // iPhone için daha detaylı hesaplama
                switch screenHeight {
                case 0...667:
                    // iPhone SE, 6, 7, 8 (küçük ekranlar)
                    bottomInset = max(safeAreaBottom + 80, 100)
                case 668...736:
                    // iPhone 6+, 7+, 8+ (orta ekranlar)
                    bottomInset = max(safeAreaBottom + 70, 90)
                case 737...812:
                    // iPhone X, XS, 11 Pro (notch'lu ekranlar)
                    bottomInset = max(safeAreaBottom + 60, 80)
                case 813...896:
                    // iPhone XR, 11, 12, 13 mini
                    bottomInset = max(safeAreaBottom + 60, 80)
                default:
                    // iPhone 12, 13, 14 Pro Max ve üzeri (büyük ekranlar)
                    bottomInset = max(safeAreaBottom + 50, 70)
                }
            }
            
            let topInset: CGFloat = 20
            
            print("🔍 Cihaz: \(isIpad ? "iPad" : "iPhone"), Ekran: \(screenWidth)x\(screenHeight)")
            print("🔍 SafeArea Bottom: \(safeAreaBottom), Hesaplanan Bottom Inset: \(bottomInset)")
            print("🔍 Horizontal Inset: \(horizontalInset)")
            
            return UIEdgeInsets(top: topInset, left: horizontalInset, bottom: bottomInset, right: horizontalInset)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        let deviceInfo = getDeviceType()
        let screenWidth = deviceInfo.screenSize.width
        
        if section == 0 {
            // Ana kategoriler arası dikey boşluk - iPhone 16 Pro Max için özel ayar
            if deviceInfo.isIpad {
                return 60
            } else {
                switch screenWidth {
                case 415...430:
                    // iPhone 12 Pro Max, 13 Pro Max, 14 Pro Max, 15 Pro Max, 16 Pro Max
                    return 100  // Çok daha fazla dikey boşluk
                case 390...414:
                    // iPhone 12, 13, 14, 15, 16 Pro
                    return 90   // Çok daha fazla dikey boşluk
                default:
                    return 70   // Diğer cihazlar için daha da artırıldı
                }
            }
        } else {
            // Random buton için boşluk
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        let deviceInfo = getDeviceType()
        let screenWidth = deviceInfo.screenSize.width
        
        if section == 0 {
            // Ana kategoriler arası yatay boşluk - iPhone 16 Pro Max için özel ayar
            if deviceInfo.isIpad {
                return 40
            } else {
                switch screenWidth {
                case 415...430:
                    // iPhone 12 Pro Max, 13 Pro Max, 14 Pro Max, 15 Pro Max, 16 Pro Max
                    return 50  // Yatay boşluk da artırıldı
                case 390...414:
                    // iPhone 12, 13, 14, 15, 16 Pro
                    return 40  // Yatay boşluk da artırıldı
                default:
                    return 30  // Diğer cihazlar için artırıldı
                }
            }
        } else {
            // Random buton için boşluk
            return 0
        }
    }
}

extension UICollectionViewCell {
    
    func configureCategoryCell(with viewModel: CategoryViewModelProtocol, at indexPath: IndexPath) {
        // Mevcut imageView'ı temizle
        contentView.subviews.forEach { $0.removeFromSuperview() }
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = frame.width / 2
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)
        
        // AutoLayout ile tam merkezleme
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: contentView.heightAnchor)
        ])
        
        let category = viewModel.category(at: indexPath.row)
        if let image = UIImage(named: category.iconName) {
            imageView.image = image
        }
    }
    
    func configureRandomIcon() {
        // Mevcut imageView'ı temizle
        contentView.subviews.forEach { $0.removeFromSuperview() }
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = frame.width / 2
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)
        
        // AutoLayout ile tam merkezleme
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: contentView.heightAnchor)
        ])
        
        imageView.image = UIImage(named: "random_icon")
    }
}
