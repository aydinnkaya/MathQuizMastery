//
//  CategoryVC.swift
//  MathQuizMastery
//
//  Created by Aydın KAYA on 7.05.2025.
//

import UIKit

class CategoryVC: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var viewModel: CategoryViewModelProtocol!
    private var coordinator: CategoryCoordinatorProtocol!
    private var _numerOfIndexPaths: Int = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        coordinator = CategoryCoordinator(navigationController: self.navigationController!)
        viewModel = CategoryViewModel()
        viewModel.coordinator = coordinator
    }
    
}

extension CategoryVC: CategoryViewModelDelegate{
  
}

extension CategoryVC: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 4
        }
        else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as? CategoryCell else {
            fatalError("CategoryCell bulunamadı.")
        }
        
        if indexPath.section == 0 {
            let category = viewModel.category(at: indexPath.row)
            cell.iconImageView.image = UIImage(named: category.iconName)
        } else {
            cell.iconImageView.image = UIImage(named: "random_icon")
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.categorySelected(at: indexPath.row)
    }
    
}

extension CategoryVC: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: 130, height: 130)
        }else{
            return CGSize(width: 130, height: 130)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            return UIEdgeInsets(top: 100, left: 44, bottom: 100, right: 44)
        } else {
            return UIEdgeInsets(top: 50, left: 115, bottom: 20, right: 115)
        }
    }
}

