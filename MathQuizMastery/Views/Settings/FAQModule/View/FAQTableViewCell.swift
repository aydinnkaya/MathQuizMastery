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
        setupUI()
    }
    
    private func setupUI() {
        selectionStyle = .none
        
        // Question Label Styling
        questionLabel.font = UIFont.boldSystemFont(ofSize: 16)
        questionLabel.textColor = .black
        questionLabel.numberOfLines = 0
        
        // Answer Label Styling
        answerLabel.font = UIFont.systemFont(ofSize: 14)
        answerLabel.textColor = .darkGray
        answerLabel.numberOfLines = 0
        
        // Arrow Image Styling
        arrowImageView.tintColor = .systemBlue
        arrowImageView.contentMode = .scaleAspectFit
        
        // Answer Container Styling
//        answerContainer.backgroundColor = UIColor.systemGray6
//        answerContainer.layer.cornerRadius = 8
//        answerContainer.clipsToBounds = true
    }
    
    func configure(with item: FAQItem) {
        questionLabel.text = item.question
        answerLabel.text = item.answer
        
        // Animate the expansion/collapse
        UIView.animate(withDuration: 0.3, animations: {
            if item.isExpanded {
             //   self.answerContainer.alpha = 1
             //   self.answerHeightConstraint.priority = UILayoutPriority(999)
                self.arrowImageView.transform = CGAffineTransform(rotationAngle: .pi)
            } else {
           //     self.answerContainer.alpha = 0
            //    self.answerHeightConstraint.priority = UILayoutPriority(1000)
                self.arrowImageView.transform = .identity
            }
            self.layoutIfNeeded()
        })
    }
}
