//
//  UniversalPopupView.swift
//  MathQuizMastery
//
//  Created by Aydın KAYA on 20.07.2025.
//

import UIKit

import UIKit

protocol UniversalPopupDelegate: AnyObject {
    func universalPopupPrimaryTapped()
    func universalPopupSecondaryTapped()
}

class UniversalPopupView: UIViewController {
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var primaryButton: UIButton!
    @IBOutlet weak var secondaryButton: UIButton!
    
    // MARK: - Properties
    weak var delegate: UniversalPopupDelegate?
    
    private var viewModel: UniversalPopupViewModel?
    
     init() {
        super.init(nibName: "UniversalPopupView", bundle: nil)
    }
    override func viewDidLoad() {
       
        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        framePopupView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration
    func configure(with viewModel: UniversalPopupViewModel) {
        self.viewModel = viewModel
        messageLabel.text = viewModel.messageText
        primaryButton.setTitle(viewModel.primaryButtonText, for: .normal)
        secondaryButton.setTitle(viewModel.secondaryButtonText, for: .normal)
        iconImageView.image = viewModel.iconImage
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        iconImageView.clipsToBounds = true
        
        // Ortak mavi-mor renk
        let bluePurple = UIColor(red: 108/255, green: 77/255, blue: 1, alpha: 1) // #6C4DFF
        // Turuncuya yakın renk
        let orangeText = UIColor(red: 1, green: 152/255, blue: 0, alpha: 1) // #FF9800
        
        // Secondary button styling (İptal)
        secondaryButton.layer.cornerRadius = 8
        secondaryButton.layer.borderWidth = 2
        secondaryButton.backgroundColor = bluePurple
        secondaryButton.layer.borderColor = bluePurple.cgColor
        secondaryButton.setTitleColor(orangeText, for: .normal)
        secondaryButton.clipsToBounds = true
        
        // Primary button styling (Giriş Yap)
        primaryButton.layer.cornerRadius = 8
        primaryButton.backgroundColor = bluePurple
        primaryButton.setTitleColor(.white, for: .normal)
        primaryButton.layer.borderWidth = 2
        primaryButton.layer.borderColor = bluePurple.cgColor
        primaryButton.clipsToBounds = true
        
        popupView.layer.cornerRadius = 20
        popupView.layer.borderWidth = 4.0
        popupView.layer.borderColor = UIColor("#7B61FF")?.cgColor;
        popupView.clipsToBounds = true
    }
    
    func framePopupView(){
//        let maxHeight = view.frame.height * 0.35
//        let maxWidth = view.frame.width * 0.87
//        popupView.frame.size = CGSize(width: maxWidth, height: maxHeight)
//        popupView.center = view.center
//        if let gradientLayer = popupView.layer.sublayers?.first as? CAGradientLayer {
//            gradientLayer.frame = popupView.bounds
//            gradientLayer.cornerRadius = popupView.layer.cornerRadius
//            gradientLayer.masksToBounds = true
//        }
//        view.bringSubviewToFront(popupView)
    }
    // MARK: - Actions
    @IBAction func primaryButtonTapped(_ sender: UIButton) {
        delegate?.universalPopupPrimaryTapped()
    }
    
    @IBAction func secondaryButtonTapped(_ sender: UIButton) {
        delegate?.universalPopupSecondaryTapped()
    }
    
    
}
