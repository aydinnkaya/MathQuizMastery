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
    
    init?(coder: NSCoder, viewModel: HomeViewModelProtocol) {
        self.viewModel = viewModel
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
        
        // XIB'den yükleme işlemi
        let avatarPopupVC = AvatarPopupVC(nibName: "AvatarPopupVC", bundle: nil)

        // ViewModel'i initialize et
        let viewModel = AvatarPopupViewModel()
        avatarPopupVC.configure(with: viewModel)

        // Geçiş ayarları
        avatarPopupVC.modalPresentationStyle = .overCurrentContext
        avatarPopupVC.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        avatarPopupVC.modalTransitionStyle = .coverVertical

        // Geçiş işlemi
        self.present(avatarPopupVC, animated: true, completion: nil)
        
        
        //        let viewModel = AvatarPopupViewModel()
        //        let avatarPopupVC = AvatarPopupVC(viewModel: viewModel)
        //        avatarPopupVC.modalPresentationStyle = .overCurrentContext
        //        avatarPopupVC.modalTransitionStyle = .coverVertical
        //        self.present(avatarPopupVC, animated: true, completion: nil)
        
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        if let avatarPopupVC = storyboard.instantiateViewController(withIdentifier: "AvatarPopupVC") as? AvatarPopupVC{
//            let viewModel = AvatarPopupViewModel()
//            avatarPopupVC.configure(with: viewModel)
//            
//            avatarPopupVC.modalPresentationStyle = .overCurrentContext
//            avatarPopupVC.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
//            avatarPopupVC.modalTransitionStyle = .coverVertical
//            self.present(avatarPopupVC, animated: true, completion: nil)
//        }
    }
    
    @IBAction func playButtonTapped(_ sender: UIButton) {
        viewModel.playButtonTapped()
    }
    
}

// MARK: - Instantiate with User
extension HomeVC {
    static func instantiate(with user: User, authService: AuthServiceProtocol = AuthService.shared) -> HomeVC {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewModel = HomeViewModel(user: user, authService: authService)
        let creator: (NSCoder) -> HomeVC? = { coder in
            return HomeVC(coder: coder, viewModel: viewModel)
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
