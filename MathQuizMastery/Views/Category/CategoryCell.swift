//
//  CategoryCell.swift
//  MathQuizMastery
//
//  Created by Aydın KAYA on 7.05.2025.
//

import Foundation
import UIKit

class CategoryCell: UICollectionViewCell {
    
    @IBOutlet weak var iconImageView: UIImageView!
    
    func configure(with icon: UIImage) {
        iconImageView.image = icon
       
    }
    
}
