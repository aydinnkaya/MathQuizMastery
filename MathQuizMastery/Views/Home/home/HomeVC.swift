//
//  StartVCV.swift
//  MathQuizMastery
//
//  Created by AydınKaya on 16.01.2025.
//

import UIKit

class HomeVC: UIViewController {
    
    @IBOutlet weak var userInfoStackView: UIStackView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var coinInfoStackView: UIStackView!
    @IBOutlet weak var coinLabel: UILabel!
    @IBOutlet weak var profileImageButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var settingsButton: UIButton!
    
    
    var user: User?
    private var viewModel: HomeViewModelProtocol!
    var coordinator: AppCoordinator?
    
    init(user: User, coordinator: AppCoordinator, authService: AuthServiceProtocol = AuthService.shared) {
        self.viewModel = HomeViewModel(authService: authService)
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
        self.viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        viewModel.notifyViewDidLoad()
        setupUI()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleAvatarUpdate),
                                               name: .avatarDidUpdate,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleUsernameUpdate),
                                               name: .usernameDidUpdate,
                                               object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    @objc private func handleAvatarUpdate() {
        viewModel.notifyViewDidLoad()
    }
    
    @objc private func handleUsernameUpdate() {
        viewModel.notifyViewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundImage.frame = view.bounds
        
    }
    
    
    @IBAction func profileButtonTapped(_ sender: Any) {
        coordinator?.goToAvatarPopup()
    }
    
    @IBAction func playButtonTapped(_ sender: UIButton) {
        viewModel.playButtonTapped()
    }
    
    
    @IBAction func settingsButtonTapped(_ sender: Any) {
        coordinator?.goToSettingsPopup()
    }
    
}


// MARK: - ViewModel Delegate
extension HomeVC: HomeViewModelDelegate {
    func navigateToCategory() {
        coordinator?.goToCategory()
    }
    
    func didReceiveUser(_ user: User?) {
        guard let user = user else { return }
        
        // Kullanıcı bilgilerini güncelle
        usernameLabel.text = user.username
        coinLabel.text = "\(user.coin)"
        
        // Profil fotoğrafını güncelle
        updateProfileImage(with: user.avatarImageName)
        
        // User referansını güncelle
        self.user = user
    }
    
    // Profil fotoğrafını güncelleyen yardımcı metod
    private func updateProfileImage(with avatarImageName: String) {
        // Profil fotoğrafını güncelle
        if let avatarImage = UIImage(named: avatarImageName) {
            profileImageButton.setImage(avatarImage, for: .normal)
        } else {
            // Varsayılan avatar kullan
            if let defaultImage = UIImage(named: "profile_icon_1") {
                profileImageButton.setImage(defaultImage, for: .normal)
            }
        }
    }
}

extension HomeVC {
    func setupUI() {
        userInfoStackView.layer.cornerRadius = 12.0
    }
}
