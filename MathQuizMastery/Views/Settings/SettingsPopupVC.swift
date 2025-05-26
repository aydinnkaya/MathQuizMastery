//
//  SettingsVC.swift
//  MathQuizMastery
//
//  Created by AydınKaya on 22.05.2025.
//

import Foundation
import UIKit


class SettingsPopupVC : UIViewController{
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var saveButton: UIButton!
    
    var viewModel: SettingsPopupViewModelProtocol!
    weak var delegate: SettingsPopupDelegate?
    var coordinator: AppCoordinator?

    
    init(viewModel: SettingsPopupViewModelProtocol, coordinator: AppCoordinator) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: "SettingsPopupVC", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    private func setupTableView() {
        let nib = UINib(nibName: "SettingTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "SettingTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @IBAction func CloseButtonTapped(_ sender: Any) {
    }
    
}

extension SettingsPopupVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.settings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingTableViewCell", for: indexPath) as? SettingTableViewCell else {
            return UITableViewCell()
        }
        
        let item = viewModel.settings[indexPath.row]
        cell.configure(with: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = viewModel.settings[indexPath.row]
        delegate?.didSelectSetting(item)
    }
    
}
