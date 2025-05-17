//
//  StartVCV.swift
//  MathQuizMastery
//
//  Created by AydınKaya on 16.01.2025.
//

import UIKit

class HomeVC: UIViewController {
    
    @IBOutlet weak var coinInfoStackView: UIStackView!
    @IBOutlet weak var userInfoStackView: UIStackView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var profileImageButton: UIButton!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var coinLabel: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var settingsButton: UIButton!
    
    var user: User?
    private var viewModel: HomeViewModelProtocol!
    var coordinator: AppCoordinator?
    
    init?(coder: NSCoder, viewModel: HomeViewModelProtocol, coordinator: AppCoordinator) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(coder: coder)
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
    
}

// MARK: - Instantiate with User
extension HomeVC {
    static func instantiate(with user: User, coordinator: AppCoordinator, authService: AuthServiceProtocol = AuthService.shared) -> HomeVC {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewModel = HomeViewModel(user: user, authService: authService)
        let creator: (NSCoder) -> HomeVC? = { coder in
            return HomeVC(coder: coder, viewModel: viewModel, coordinator: coordinator)
        }
        return storyboard.instantiateViewController(identifier: "HomeVC", creator: creator)
    }
}

// MARK: - ViewModel Delegate
extension HomeVC: HomeViewModelDelegate {
    func navigateToCategory() {
        let categoryVC = CategoryVC.instantiate()
        navigationController?.pushViewController(categoryVC, animated: true)
    }
    
    func didReceiveUser(_ user: User?) {
        guard let user = user else { return }
        usernameLabel.text = user.username
    }
}
extension HomeVC {
    func setupUI() {
        userInfoStackView.layer.cornerRadius = 12.0
    }
}
