//
//  SettingTableViewCell.swift
//  MathQuizMastery
//
//  Created by AydınKaya on 27.05.2025.
//

import UIKit

class SettingTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCellStyle()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
        titleLabel.text = nil
    }
    
    func configure(with item: SettingItem) {
        titleLabel.text = item.title
        iconImageView.image = UIImage(named: item.iconName)
    }
    
    private func setupCellStyle() {
        selectionStyle = .none
        titleLabel.font = UIFont(name: "Mansalva", size: 18)
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = .white
    }
    
}
