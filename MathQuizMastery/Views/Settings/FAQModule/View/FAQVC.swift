//
//  FAQVC.swift
//  MathQuizMastery
//
//  Created by AydınKaya on 12.06.2025.
//

import UIKit


class FAQVC: UIViewController {
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!

    private let viewModel: FAQViewModel
    weak var coordinator: AppCoordinator?
    private var lastAnimatedIndexPath: IndexPath?
    
    init(coordinator: AppCoordinator) {
        self.viewModel = FAQViewModel()
        self.coordinator = coordinator
        super.init(nibName: "FAQVC", bundle: nil)
        self.viewModel.delegate = self
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        setupGestures()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animateIn()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Arka plan view'unu tam ekran yap
        backgroundView.frame = view.bounds
        // PopupView'u responsive olarak boyutlandır
        let maxHeight = view.frame.height * 0.7
        let maxWidth = view.frame.width * 0.9
        popupView.frame.size = CGSize(width: maxWidth, height: maxHeight)
        popupView.center = view.center
        // Gradient layer frame ve köşe yuvarlatma güncelle
        if let gradientLayer = popupView.layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.frame = popupView.bounds
            gradientLayer.cornerRadius = popupView.layer.cornerRadius
            gradientLayer.masksToBounds = true
        }
        // PopupView'u öne getir
        view.bringSubviewToFront(popupView)
    }
    
    private func setupUI() {
        view.backgroundColor = .clear
        backgroundView.alpha = 0
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        popupView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        popupView.alpha = 0
        
        // Apply space theme styling
        stylePopupView()
        
        // Set up title label
        titleLabel.text = "Sıkça Sorulan Sorular"
        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        
        // Set up close button
        closeButton.tintColor = UIColor(red: 0.455, green: 0.816, blue: 0.988, alpha: 1.0)
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        
        // Register FAQTableViewCell with its nib
        let nib = UINib(nibName: "FAQTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "FAQTableViewCell")
        
        // Set estimated row height for better performance
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        
        // Add some padding to the tableView
        tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
    }
    
    private func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
        backgroundView.addGestureRecognizer(tapGesture)
        backgroundView.isUserInteractionEnabled = true
    }
    
    private func animateIn() {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .curveEaseOut) {
            self.backgroundView.alpha = 1
            self.popupView.transform = .identity
            self.popupView.alpha = 1
        }
    }
    
    private func animateOut(completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn) {
            self.backgroundView.alpha = 0
            self.popupView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            self.popupView.alpha = 0
        } completion: { _ in
            completion()
        }
    }
    
    @objc private func backgroundTapped() {
        dismissPopup()
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        dismissPopup()
    }
    
    private func dismissPopup() {
        animateOut { [weak self] in
            self?.coordinator?.dismissCurrentPopup {
                self?.coordinator?.replacePopup(with: .settings)
            }
        }
    }
}

// MARK: - FAQViewModelDelegate
extension FAQVC: FAQViewModelDelegate {
    func didUpdateFAQItems() {
        tableView.reloadData()
    }
    func didUpdateFAQItem(at index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        lastAnimatedIndexPath = indexPath
        tableView.reloadRows(at: [indexPath], with: .none)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension FAQVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FAQTableViewCell", for: indexPath) as? FAQTableViewCell else {
            return UITableViewCell()
        }
        
        let item = viewModel.item(at: indexPath.row)
        let animated = (indexPath == lastAnimatedIndexPath)
        cell.configure(with: item, animated: animated)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.toggleExpansion(at: indexPath.row)
    }
}

// MARK: - Styling
extension FAQVC {
    func stylePopupView() {
        popupView.layer.cornerRadius = 20
        popupView.clipsToBounds = true

        // Space theme styling
        let gradientLayer: CAGradientLayer
        if let existing = popupView.layer.sublayers?.first as? CAGradientLayer {
            gradientLayer = existing
        } else {
            gradientLayer = CAGradientLayer()
            popupView.layer.insertSublayer(gradientLayer, at: 0)
        }
        gradientLayer.frame = popupView.bounds
        gradientLayer.colors = [
            UIColor(red: 0.1, green: 0.1, blue: 0.2, alpha: 0.95).cgColor,
            UIColor(red: 0.05, green: 0.05, blue: 0.1, alpha: 0.95).cgColor
        ]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.cornerRadius = popupView.layer.cornerRadius
        gradientLayer.masksToBounds = true

        // Border
        popupView.layer.borderWidth = 1.0
        popupView.layer.borderColor = UIColor(red: 0.455, green: 0.816, blue: 0.988, alpha: 0.3).cgColor

        // Shadow
        popupView.layer.shadowColor = UIColor(red: 0.455, green: 0.816, blue: 0.988, alpha: 0.5).cgColor
        popupView.layer.shadowOffset = CGSize(width: 0, height: 2)
        popupView.layer.shadowRadius = 15
        popupView.layer.shadowOpacity = 0.5
        popupView.layer.masksToBounds = false // Shadow için gerekli
    }
    
    func framePopupView() {
        let maxHeight = view.frame.height * 0.7
        let maxWidth = view.frame.width * 0.9
        
        popupView.frame.size.width = maxWidth
        popupView.frame.size.height = maxHeight
        popupView.center = view.center
        
        // Update gradient layer frame
        if let gradientLayer = popupView.layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.frame = popupView.bounds
        }
    }
}
