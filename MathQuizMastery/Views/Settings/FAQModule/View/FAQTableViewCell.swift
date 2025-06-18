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
    @IBOutlet weak var answerContainer: UIView!
    @IBOutlet weak var answerHeightConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear
        
        // Question Label Styling
        questionLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        questionLabel.textColor = .white
        questionLabel.numberOfLines = 0
        
        // Answer Label Styling
        answerLabel.font = .systemFont(ofSize: 14, weight: .regular)
        answerLabel.textColor = UIColor(red: 0.455, green: 0.816, blue: 0.988, alpha: 1.0)
        answerLabel.numberOfLines = 0
        
        // Arrow Image Styling
        arrowImageView.tintColor = UIColor(red: 0.455, green: 0.816, blue: 0.988, alpha: 1.0)
        arrowImageView.contentMode = .scaleAspectFit
        
        // Answer Container Styling
        answerContainer.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.5)
        answerContainer.layer.cornerRadius = 8
        answerContainer.clipsToBounds = true
        answerContainer.alpha = 0
    }
    
    func configure(with item: FAQItem) {
        questionLabel.text = item.question
        answerLabel.text = item.answer
        
        // Pre-calculate the height before animation
        let targetHeight = item.isExpanded ? calculateAnswerHeight() : 0
        
        // Update constraint immediately if not expanded
        if !item.isExpanded {
            answerHeightConstraint.constant = 0
            answerContainer.alpha = 0
            arrowImageView.transform = .identity
            layoutIfNeeded()
        }
        
        // Animate changes
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .curveEaseInOut) {
            self.answerContainer.alpha = item.isExpanded ? 1 : 0
            self.answerHeightConstraint.constant = targetHeight
            self.arrowImageView.transform = item.isExpanded ? CGAffineTransform(rotationAngle: .pi) : .identity
            self.layoutIfNeeded()
        }
    }
    
    private func calculateAnswerHeight() -> CGFloat {
        guard let text = answerLabel.text else { return 0 }
        
        // Get the available width for the answer label
        let availableWidth = answerContainer.bounds.width - 16 // 8pt padding on each side
        
        let font = answerLabel.font ?? .systemFont(ofSize: 14)
        let constraintRect = CGSize(width: availableWidth, height: .greatestFiniteMagnitude)
        
        // Calculate text height
        let boundingBox = text.boundingRect(with: constraintRect,
                                          options: [.usesLineFragmentOrigin, .usesFontLeading],
                                          attributes: [.font: font],
                                          context: nil)
        
        // Add vertical padding (8pt top + 8pt bottom)
        return ceil(boundingBox.height) + 16
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Update answer height if expanded
        if answerHeightConstraint.constant > 0 {
            let newHeight = calculateAnswerHeight()
            if newHeight != answerHeightConstraint.constant {
                answerHeightConstraint.constant = newHeight
                layoutIfNeeded()
            }
        }
    }
}

