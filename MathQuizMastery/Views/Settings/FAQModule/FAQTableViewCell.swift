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
        
        questionLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        questionLabel.textColor = .white
        questionLabel.numberOfLines = 0
        
        answerLabel.font = .systemFont(ofSize: 14, weight: .regular)
        answerLabel.textColor = UIColor(red: 0.455, green: 0.816, blue: 0.988, alpha: 1.0)
        answerLabel.numberOfLines = 0
        
        arrowImageView.tintColor = UIColor(red: 0.455, green: 0.816, blue: 0.988, alpha: 1.0)
        arrowImageView.contentMode = .scaleAspectFit
        
        answerContainer.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.5)
        answerContainer.layer.cornerRadius = 8
        answerContainer.clipsToBounds = true
        answerContainer.alpha = 0
    }
    
    // MARK: - Hücreyi Yapılandır
    func configure(with item: FAQItem, animated: Bool = true) {
        questionLabel.text = item.question
        answerLabel.text = item.answer
        let targetHeight = item.isExpanded ? calculateAnswerHeight() : 0
        
        if animated {
            if item.isExpanded {
                answerHeightConstraint.constant = targetHeight
                layoutIfNeeded()
                answerContainer.transform = CGAffineTransform(translationX: 0, y: 16).scaledBy(x: 0.98, y: 0.98)
                answerContainer.alpha = 0
                UIView.animate(withDuration: 0.32, delay: 0, usingSpringWithDamping: 0.85, initialSpringVelocity: 0.5, options: [.curveEaseOut]) {
                    self.answerContainer.alpha = 1
                    self.answerContainer.transform = .identity
                    self.arrowImageView.transform = CGAffineTransform(rotationAngle: .pi)
                }
            } else {
                UIView.animate(withDuration: 0.22, delay: 0, options: [.curveEaseIn], animations: {
                    self.answerContainer.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
                    self.answerContainer.alpha = 0
                    self.arrowImageView.transform = .identity
                }) { _ in
                    self.answerHeightConstraint.constant = 0
                    self.answerContainer.transform = .identity
                    self.layoutIfNeeded()
                }
            }
        } else {
            self.answerContainer.alpha = item.isExpanded ? 1 : 0
            self.answerHeightConstraint.constant = targetHeight
            self.answerContainer.transform = .identity
            self.arrowImageView.transform = item.isExpanded ? CGAffineTransform(rotationAngle: .pi) : .identity
            self.layoutIfNeeded()
        }
    }
    
    // MARK: - Cevap Yüksekliğini Hesapla
    private func calculateAnswerHeight() -> CGFloat {
        guard let text = answerLabel.text else { return 0 }
        let availableWidth = answerContainer.bounds.width - 16
        let font = answerLabel.font ?? .systemFont(ofSize: 14)
        let constraintRect = CGSize(width: availableWidth, height: .greatestFiniteMagnitude)
        
        let boundingBox = text.boundingRect(with: constraintRect,
                                            options: [.usesLineFragmentOrigin, .usesFontLeading],
                                            attributes: [.font: font],
                                            context: nil)
        return ceil(boundingBox.height) + 16
    }
}
