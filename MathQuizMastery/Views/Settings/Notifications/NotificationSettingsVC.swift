//
//  NotificationSettingsVC.swift
//  MathQuizMastery
//
//  Created by System on 19.06.2025.
//

import UIKit
import UserNotifications

class NotificationSettingsVC: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    // MARK: - Properties
    private let viewModel: NotificationSettingsViewModel
    weak var coordinator: AppCoordinator?
    
    // MARK: - Initialization
    init(viewModel: NotificationSettingsViewModel, coordinator: AppCoordinator) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: "NotificationSettingsVC", bundle: nil)
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        setupViewModel()
        checkNotificationPermission()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        framePopupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.refreshSettings()
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        backgroundView.frame = view.bounds
        setupBackgroundView()
        stylePopupView()
        setupLabels()
        setupButtons()
    }
    
    private func setupTableView() {
        let nib = UINib(nibName: "NotificationSettingCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "NotificationSettingCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
    }
    
    private func setupViewModel() {
        viewModel.delegate = self
        viewModel.loadSettings()
    }
    
    private func setupLabels() {
        titleLabel.text = L(.notification_settings_title)
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textColor = UIColor("#333333")
    }
    
    private func setupButtons() {
        closeButton.setTitle("", for: .normal)
        closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeButton.tintColor = UIColor("#666666")
        
        saveButton.setTitle(L(.save), for: .normal)
        saveButton.backgroundColor = UIColor("#7B61FF")
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.layer.cornerRadius = 8
        saveButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
    }
    
    private func setupBackgroundView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
        backgroundView.addGestureRecognizer(tapGesture)
    }
    
    private func checkNotificationPermission() {
        NotificationPermissionService.shared.checkPermissionStatus { [weak self] status in
            DispatchQueue.main.async {
                self?.viewModel.updatePermissionStatus(status)
            }
        }
    }
    
    // MARK: - Actions
    @IBAction func closeButtonTapped(_ sender: UIButton) {
        coordinator?.dismissPopup()
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        viewModel.saveSettings()
        showSaveSuccessAlert()
    }
    
    @objc private func backgroundTapped() {
        coordinator?.dismissPopup()
    }
    
    // MARK: - Private Methods
    private func showSaveSuccessAlert() {
        let alert = UIAlertController(
            title: L(.success),
            message: L(.notification_settings_saved),
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: L(.ok), style: .default) { [weak self] _ in
            self?.coordinator?.dismissPopup()
        })
        
        present(alert, animated: true)
    }
    
    private func showPermissionDeniedAlert() {
        let alert = UIAlertController(
            title: L(.notification_permission_denied_title),
            message: L(.notification_permission_denied_message),
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: L(.cancel), style: .cancel))
        
        alert.addAction(UIAlertAction(title: L(.open_settings), style: .default) { _ in
            NotificationPermissionService.shared.openSettings()
        })
        
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension NotificationSettingsVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "NotificationSettingCell",
            for: indexPath
        ) as? NotificationSettingCell else {
            return UITableViewCell()
        }
        
        let setting = viewModel.setting(at: indexPath)
        cell.configure(with: setting)
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.sectionTitle(for: section)
    }
}

// MARK: - UITableViewDelegate
extension NotificationSettingsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        
        let titleLabel = UILabel()
        titleLabel.text = viewModel.sectionTitle(for: section)
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.textColor = UIColor("#7B61FF")
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        headerView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
        ])
        
        return headerView
    }
}

// MARK: - NotificationSettingCellDelegate
extension NotificationSettingsVC: NotificationSettingCellDelegate {
    func notificationSettingCell(_ cell: NotificationSettingCell, didToggle isEnabled: Bool, for setting: NotificationSetting) {
        if isEnabled && !viewModel.hasNotificationPermission {
            // İzin yoksa izin iste
            cell.setEnabled(false, animated: true)
            showPermissionDeniedAlert()
            return
        }
        
        viewModel.updateSetting(setting, isEnabled: isEnabled)
    }
    
    func notificationSettingCell(_ cell: NotificationSettingCell, didTapInfo setting: NotificationSetting) {
        showInfoAlert(for: setting)
    }
    
    private func showInfoAlert(for setting: NotificationSetting) {
        let alert = UIAlertController(
            title: setting.title,
            message: setting.description,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: L(.ok), style: .default))
        present(alert, animated: true)
    }
}

// MARK: - NotificationSettingsViewModelDelegate
extension NotificationSettingsVC: NotificationSettingsViewModelDelegate {
    func notificationSettingsDidUpdate() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    func notificationPermissionDidChange(_ hasPermission: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
            if !hasPermission {
                self?.showPermissionDeniedAlert()
            }
        }
    }
}

// MARK: - Styling
extension NotificationSettingsVC {
    private func stylePopupView() {
        popupView.layer.cornerRadius = 20
        popupView.layer.borderWidth = 2.0
        popupView.layer.borderColor = UIColor("#7B61FF")?.cgColor
        popupView.backgroundColor = .white
        popupView.clipsToBounds = true
        
        popupView.layer.shadowColor = UIColor.black.cgColor
        popupView.layer.shadowOpacity = 0.1
        popupView.layer.shadowOffset = CGSize(width: 0, height: 4)
        popupView.layer.shadowRadius = 8
    }
    
    private func framePopupView() {
        tableView.layoutIfNeeded()
        let contentHeight = tableView.contentSize.height + 120 // Title + buttons için extra space
        let maxHeight = view.frame.height * 0.8
        let finalHeight = min(contentHeight, maxHeight)
        
        popupView.frame.size.height = finalHeight
        popupView.center = view.center
    }
}
