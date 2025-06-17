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
        fatalError("init(coder:) has not been implemented. Use init(viewModel:delegate:coordinator:) instead.")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundView.frame = view.bounds
        setupBackgroundView()
        viewModel.delegate = self
        setupTableView()
        stylePopupView()
    }
    
    override func viewDidLayoutSubviews() {
        framePopupView()
    }
    
    private func setupTableView(){
        let nib = UINib(nibName: "SettingTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "SettingTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
    }
    
}

extension SettingsPopupVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.settings.count
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
        viewModel.selectItem(at: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 16
    }
}

extension SettingsPopupVC {
    private func setupBackgroundView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
        backgroundView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func backgroundTapped() {
        coordinator?.dismissPopup()
    }
    
}

extension SettingsPopupVC: SettingsPopupDelegate {
    
    func didSelectSetting(_ item: SettingItem) {
        print("Seçilen Ayar: \(item.title)")
    }
    
    func tappedProfile() {
        coordinator?.replacePopup(with: .avatar)
    }
    
    func tappedNotifications() {
        // Bildirim ayarları ekranına yönlendir
    }
    
    func tappedFAQ() {
        coordinator?.replacePopup(with: .faq)
    }
    
    func tappedReport() {
        // Raporlama ekranına yönlendir
    }
    
    func tappedLogout() {
        let alert = UIAlertController(
            title: L(.logout_title),
            message: L(.logout_message),
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: L(.logout_cancel), style: .cancel))
        
        alert.addAction(UIAlertAction(title: L(.logout_confirm), style: .destructive, handler: { [weak self] _ in
            // Loading indicator göster (opsiyonel)
            self?.showLogoutLoading()
            
            AuthService.shared.signOut { [weak self] error in
                DispatchQueue.main.async {
                    // Loading indicator'ı gizle
                    self?.hideLogoutLoading()
                    
                    if let error = error {
                        print("Çıkış yapılamadı: \(error.localizedDescription)")
                        self?.showLogoutError(error.localizedDescription)
                    } else {
                        print("Başarıyla çıkış yapıldı")
                        // Popup'ı kapat ve login ekranına yönlendir
                        self?.coordinator?.dismissPopup()
                        self?.coordinator?.goToLogin()
                    }
                }
            }
        }))
        
        self.present(alert, animated: true)
    }
    
    // MARK: - Loading & Error Helpers
    private func showLogoutLoading() {
        view.isUserInteractionEnabled = false
    }
    
    private func hideLogoutLoading() {
        view.isUserInteractionEnabled = true
    }
    
    private func showLogoutError(_ message: String) {
        let errorAlert = UIAlertController(
            title: "Hata",
            message: "Çıkış yapılırken bir hata oluştu: \(message)",
            preferredStyle: .alert
        )
        errorAlert.addAction(UIAlertAction(title: "Tamam", style: .default))
        self.present(errorAlert, animated: true)
    }
    
}

extension SettingsPopupVC {
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
