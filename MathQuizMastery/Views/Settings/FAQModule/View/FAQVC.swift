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

    private var viewModel: FAQViewModelProtocol
    weak var delegate: FAQViewModelDelegate?
    var coordinator: AppCoordinator?
    
    init(viewModel: FAQViewModelProtocol, delegate: FAQViewModelDelegate? = nil, coordinator: AppCoordinator) {
        self.viewModel = viewModel
        self.delegate = delegate
        self.coordinator = coordinator
        super.init(nibName: "FAQVC", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
      //  setupUI()
        setupBackgroundView()
        viewModel.delegate = self
        setupTableView()
        stylePopupView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        framePopupView()
    }
    
//    private func setupUI() {
//        titleLabel.text = "Sıkça Sorulan Sorular"
//        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
//        titleLabel.textColor = .black
//        titleLabel.textAlignment = .center
//        
//        closeButton.setTitle("✕", for: .normal)
//        closeButton.setTitleColor(.gray, for: .normal)
//        closeButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
//        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
//    }
    
    @objc private func closeButtonTapped() {
        coordinator?.dismissPopup()
    }
    
    private func setupTableView() {
        let nib = UINib(nibName: "FAQTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "FAQTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        tableView.showsVerticalScrollIndicator = false
    }
}

// MARK: - FAQViewModelDelegate
extension FAQVC: FAQViewModelDelegate {
    func didUpdateFAQItems() {
        DispatchQueue.main.async {
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension FAQVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FAQTableViewCell", for: indexPath) as? FAQTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: viewModel.items[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.toggleItem(at: indexPath.row)
    }
}

// MARK: - Background Gesture
extension FAQVC {
    private func setupBackgroundView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
        backgroundView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func backgroundTapped() {
        coordinator?.dismissPopup()
    }
}

// MARK: - Styling
extension FAQVC {
    func stylePopupView() {
        popupView.layer.cornerRadius = 20
        popupView.layer.borderWidth = 3.0
        popupView.layer.borderColor = UIColor.systemBlue.cgColor
        popupView.backgroundColor = .white
        popupView.clipsToBounds = true
        
        // Shadow
        popupView.layer.shadowColor = UIColor.black.cgColor
        popupView.layer.shadowOffset = CGSize(width: 0, height: 2)
        popupView.layer.shadowRadius = 10
        popupView.layer.shadowOpacity = 0.3
    }
    
    func framePopupView() {
        let maxHeight = view.frame.height * 0.8
        let maxWidth = view.frame.width * 0.9
        
        popupView.frame.size.width = maxWidth
        popupView.frame.size.height = maxHeight
        popupView.center = view.center
    }
}
