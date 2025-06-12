//
//  FAQTableViewCell.swift
//  MathQuizMastery
//
//  Created by AydınKaya on 12.06.2025.
//

import UIKit

class FAQTableViewCell: UITableViewCell {
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var questionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        answerLabel.numberOfLines = 0
    }
    
    func configure(with item: FAQItem) {
        questionLabel.text = item.question
        answerLabel.text = item.answer

        answerLabel.isHidden = !item.isExpanded

        UIView.animate(withDuration: 0.25) {
            self.arrowImageView.transform = item.isExpanded ? CGAffineTransform(rotationAngle: .pi) : .identity
        }
    }

    
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//        
//    }
    
}
