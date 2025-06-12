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
       // setupBackgroundView()
        viewModel.delegate = self
        setupTableView()
        stylePopupView()
    }
    
    override func viewDidLayoutSubviews() {
        framePopupView()
    }
    
    private func setupTableView(){
        let nib = UINib(nibName: "FAQTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "FAQTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
    }
    
}
extension FAQVC: FAQViewModelDelegate {
    func didUpdateFAQItems() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension FAQVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.items.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.toggleItem(at: indexPath.row)
        tableView.beginUpdates()
        tableView.reloadRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FAQTableViewCell", for: indexPath) as? FAQTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: viewModel.items[indexPath.row])
        return cell
    }
}

extension FAQVC {
    private func setupBackgroundView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
        backgroundView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func backgroundTapped() {
        coordinator?.dismissPopup()
    }
}

extension FAQVC {
    func stylePopupView() {
        popupView.layer.cornerRadius = 20
        popupView.layer.borderWidth = 8.0
        popupView.layer.borderColor = UIColor("#7B61FF")?.cgColor
        popupView.clipsToBounds = true
    }
    
    func framePopupView(){
        tableView.layoutIfNeeded()
        let contentHeight = tableView.contentSize.height
        let maxHeight = view.frame.height * 0.8
        let finalHeight = min(contentHeight, maxHeight)
        popupView.frame.size.height = finalHeight
        popupView.center = view.center
    }
}

