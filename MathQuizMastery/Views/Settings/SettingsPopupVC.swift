//
//  SettingsPopupVC.swift
//  MathQuizMastery
//
//  Created by AydınKaya on 27.05.2025.
//

import UIKit

class SettingsPopupVC: UIViewController {
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel : SettingsPopupViewModelProtocol!
    weak var delegate: SettingsPopupDelegate?
    var coordinator: AppCoordinator?

    
    init(viewModel: SettingsPopupViewModelProtocol, delegate: SettingsPopupDelegate? = nil, coordinator: AppCoordinator) {
        self.viewModel = viewModel
        self.delegate = delegate
        self.coordinator = coordinator 
        super.init(nibName: "SettingsPopupVC", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackgroundView()
        setupTableView()
        stylePopupView()
    }

    private func setupTableView(){
        let nib = UINib(nibName: "SettingTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "SettingTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
    }

}

extension SettingsPopupVC {
    private func setupBackgroundView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
        backgroundView.addGestureRecognizer(tapGesture)
        backgroundView.frame = view.bounds
    }
    
    @objc private func backgroundTapped() {
        coordinator?.dismissPopup()
    }
    
}

extension SettingsPopupVC : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingTableViewCell", for: indexPath) as? SettingTableViewCell else {
            return UITableViewCell()
        }
        
        let item = viewModel.settings[indexPath.row]
        cell.configure(with: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return viewModel.settings.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = viewModel.settings[indexPath.row]
        delegate?.didSelectSetting(item)
    }
}

extension SettingsPopupVC {
    
    func stylePopupView() {
        popupView.translatesAutoresizingMaskIntoConstraints = false
        
        // Stil
        popupView.layer.cornerRadius = 20
        popupView.layer.borderWidth = 8.0
        popupView.layer.borderColor = UIColor("#7B61FF")?.cgColor
        popupView.clipsToBounds = true
        
        // Oranlı ve ortalı constraint’ler
        NSLayoutConstraint.activate([
            popupView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            popupView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            popupView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            popupView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5)
        ])
    }
}
