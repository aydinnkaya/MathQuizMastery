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
    
    @IBOutlet weak var settingsButton: UIButton!
    
    var user: User?
    var viewModel: HomeViewModel! {
        didSet {
            viewModel.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        viewModel.notifyViewDidLoad()
        setupUI()
    }
    
    @IBAction func profileButtonTapped(_ sender: Any) {
    }
    
    
    @IBAction func playButtonTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let categoryVC = storyboard.instantiateViewController(withIdentifier: "CategoryVC") as? CategoryVC {
            self.navigationController?.pushViewController(categoryVC, animated: true)
        }else {
            print("❌ CategoryVC bulunamadı. Storyboard ID doğru mu kontrol et.")
        }
    }
    
    
}
// MARK: - Instantiate with User
extension HomeVC {
    static func instantiate(with user: User) -> HomeVC {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let homeVC = storyboard.instantiateViewController(withIdentifier: "HomeVC") as? HomeVC else {
            return HomeVC() // Default fallback view controller
        }
        let viewModel = HomeViewModel(user: user)
        homeVC.viewModel = viewModel
        return homeVC
    }
}

// MARK: - ViewModel Delegate
extension HomeVC: HomeViewModelDelegate {
    func didReceiveUser(_ user: User?) {
        guard let user = user else { return }
        usernameLabel.text = user.username
    }
}

extension HomeVC {
    
    func setupUI() {
        userInfoStackView.layer.cornerRadius = 12.0
      //  userInfoStackView.backgroundColor = .purple
    }
}
