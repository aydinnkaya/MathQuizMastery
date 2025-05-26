//
//  SettingsCell.swift
//  MathQuizMastery
//
//  Created by AydınKaya on 22.05.2025.
//

import Foundation
import UIKit


class SettingTableViewCell: UITableViewCell {
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    func configure(with item: SettingItem) {
        titleLabel.text = item.title
        iconImageView.image = UIImage(named: item.iconName)
    }
    
}
