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
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "CategoryCell")
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
        return CGSize(width: 130, height: 130)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        
        if section == 0 {
            // Ana kategoriler (üstteki dört işlem)
            let sideInset = screenWidth <= 375 ? 16 : 32
            return UIEdgeInsets(top: 100, left: CGFloat(sideInset), bottom: 100, right: CGFloat(sideInset))
        } else {
            // Random Buton (Alttaki tek buton)
            
            // 🔍 1️⃣ collectionView genişliği
            let collectionViewWidth = collectionView.frame.width
            
            // 🔍 2️⃣ Hücre genişliği (130)
            let totalCellWidth: CGFloat = 130
            
            // 🔍 3️⃣ Sol ve sağ eşit aralığı hesapla
            let inset = (collectionViewWidth - totalCellWidth) / 2
            
            // 🔍 4️⃣ Negatif inset olursa en az 0 olarak ayarla
            let safeInset = max(inset, 0)
            
            // 🔍 5️⃣ Küçük ekranlarda ek bir alt boşluk ayarla
            let bottomInset: CGFloat = screenHeight <= 700 ? 100 : 50
            
            print("🔍 Hesaplanan inset değeri: \(safeInset)")
            
            // 🔍 6️⃣ Tam ortalanmış şekilde döndür
            return UIEdgeInsets(top: 10, left: safeInset, bottom: bottomInset, right: safeInset)
        }
    }
}

extension UICollectionViewCell {
    
    func configureCategoryCell(with viewModel: CategoryViewModelProtocol, at indexPath: IndexPath) {
        if contentView.viewWithTag(10) == nil {
            let imageView = UIImageView(frame: contentView.bounds)
            imageView.contentMode = .scaleAspectFit
            imageView.layer.cornerRadius = frame.width / 2
            imageView.clipsToBounds = true
            imageView.tag = 10
            contentView.addSubview(imageView)
        }
        
        if let imageView = contentView.viewWithTag(10) as? UIImageView {
            let category = viewModel.category(at: indexPath.row)
            if let image = UIImage(named: category.iconName) {
                imageView.image = image
            }
        }
    }
    
    func configureRandomIcon() {
        if contentView.viewWithTag(10) == nil {
            let imageView = UIImageView(frame: contentView.bounds)
            imageView.contentMode = .scaleAspectFit
            imageView.layer.cornerRadius = frame.width / 2
            imageView.clipsToBounds = true
            imageView.tag = 10
            contentView.addSubview(imageView)
        }
        
        if let imageView = contentView.viewWithTag(10) as? UIImageView {
            imageView.image = UIImage(named: "random_icon")
        }
    }
    
}
