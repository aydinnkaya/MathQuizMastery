//
//  StartVCV.swift
//  MathQuizMastery
//
//  Created by AydınKaya on 16.01.2025.
//

import UIKit

class HomeVC: UIViewController {
    
    @IBOutlet weak var userInfoView: UIView!
    @IBOutlet weak var userInfoStackView: UIStackView!
    @IBOutlet weak var buttonStartLabel: UIButton!
    @IBOutlet weak var userIDIcon: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var usernameStackView: UIStackView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var coinStackView: UIStackView!
    @IBOutlet weak var coinLabel: UILabel!
    @IBOutlet weak var coinIcon: UIImageView!
    
    
    var user: User?
    var viewModel: HomeViewModel! {
        didSet {
            viewModel.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        configureButton(buttonStartLabel)
        setGradientBackground()
        setupUserInfoView()
        viewModel.notifyViewDidLoad()
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

private extension HomeVC {
    func setGradientBackground() {
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor.Custom.backgroundDark1.cgColor,
            UIColor.Custom.backgroundDark2.cgColor,
            UIColor.Custom.backgroundDark3.cgColor
        ]
        gradient.startPoint = CGPoint(x: 0.5, y: 1)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        gradient.frame = view.bounds
        view.layer.insertSublayer(gradient, at: 0)
    }
}
