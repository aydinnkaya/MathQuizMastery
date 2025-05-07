//
//  CategoryVC.swift
//  MathQuizMastery
//
//  Created by Aydın KAYA on 7.05.2025.
//

import UIKit

class CategoryVC: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var viewModel = CategoryViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
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
            return UIEdgeInsets(top: 30, left: 15, bottom: 30, right: 15)
        } else {
            return UIEdgeInsets(top: 30, left: 115, bottom: 30, right: 115)
        }
    }
    
}
