//
//  AvatarPopupCell.swift
//  MathQuizMastery
//
//  Created by AydınKaya on 14.05.2025.
//

import Foundation
import UIKit

class AvatarPopupCell:UICollectionViewCell{
    
    @IBOutlet weak var iconImageView: UIImageView!
    
    func configure(with icon: UIImage) {
        iconImageView.image = icon
    }
}

