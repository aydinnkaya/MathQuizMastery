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
        let warpView = WarpTransitionView(frame: view.bounds)
        view.addSubview(warpView)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            warpView.removeFromSuperview()
            
            let categoryVC = CategoryVC()
            self.navigationController?.pushViewController(categoryVC, animated: false)
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
    func setupUserInfoView() {
        view.addSubview(userInfoView)
        userInfoView.translatesAutoresizingMaskIntoConstraints = false
        
        [userIDIcon, usernameLabel, avatarImageView, coinLabel, coinIcon].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            userInfoView.addSubview($0)
        }
        
        userInfoView.backgroundColor = .clear
        
        userIDIcon.image = UIImage(named: "usernameIcon")
        userIDIcon.contentMode = .scaleAspectFit
        
        usernameLabel.text = "testay1"
        usernameLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        usernameLabel.textColor = .white
        usernameLabel.textAlignment = .left
        usernameLabel.lineBreakMode = .byTruncatingTail
        usernameLabel.numberOfLines = 1
        usernameLabel.backgroundColor = .brown
        usernameLabel.layer.cornerRadius = 8
        usernameLabel.clipsToBounds = true
        
        avatarImageView.image = UIImage(named: "Ellipse")
        avatarImageView.contentMode = .scaleAspectFit
        avatarImageView.layer.cornerRadius = 50
        avatarImageView.clipsToBounds = true
        
        coinLabel.text = "1000"
        coinLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        coinLabel.textColor = .white
        coinLabel.backgroundColor = .brown
        coinLabel.textAlignment = .center
        coinLabel.lineBreakMode = .byTruncatingTail
        coinLabel.numberOfLines = 1
        coinLabel.layer.cornerRadius = 8
        coinLabel.clipsToBounds = true
        
        coinIcon.image = UIImage(named: "coinIcon2")
        coinIcon.contentMode = .scaleAspectFit
        
        layoutUserInfoView()
    }
    
    func layoutUserInfoView() {
        NSLayoutConstraint.activate([
            userInfoView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            userInfoView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            userInfoView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            userInfoView.heightAnchor.constraint(equalToConstant: 100),
            
            // Avatar ortalanmış
            avatarImageView.centerXAnchor.constraint(equalTo: userInfoView.centerXAnchor),
            avatarImageView.centerYAnchor.constraint(equalTo: userInfoView.centerYAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 100),
            avatarImageView.heightAnchor.constraint(equalToConstant: 100),
            
            // Username icon
            userIDIcon.centerYAnchor.constraint(equalTo: userInfoView.centerYAnchor),
            userIDIcon.trailingAnchor.constraint(equalTo: usernameLabel.leadingAnchor, constant: -2),
            userIDIcon.widthAnchor.constraint(equalToConstant: 36),
            userIDIcon.heightAnchor.constraint(equalToConstant: 36),
            userIDIcon.leadingAnchor.constraint(equalTo: userInfoView.leadingAnchor),
            
            // Username label
            usernameLabel.centerYAnchor.constraint(equalTo: userInfoView.centerYAnchor),
            usernameLabel.trailingAnchor.constraint(equalTo: avatarImageView.leadingAnchor, constant: 15),
            usernameLabel.heightAnchor.constraint(equalToConstant: 36),
            
            // Coin label
            coinLabel.centerYAnchor.constraint(equalTo: userInfoView.centerYAnchor),
            coinLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: -15),
            coinLabel.trailingAnchor.constraint(equalTo: coinIcon.leadingAnchor, constant: 2),
            coinLabel.heightAnchor.constraint(equalToConstant: 36),
            
            // Coin icon
            coinIcon.centerYAnchor.constraint(equalTo: userInfoView.centerYAnchor),
            coinIcon.widthAnchor.constraint(equalToConstant: 36),
            coinIcon.heightAnchor.constraint(equalToConstant: 36),
            coinIcon.trailingAnchor.constraint(equalTo: userInfoView.trailingAnchor)
        ])
    }
}

//// MARK: - UI Setup
//private extension HomeVC {
//    func setupUserInfoView() {
//        setGradientBackground()
//        configureUserInfoStackView()
//        configureAvatarImageView()
//        configureUsernameStackView()
//        configureGoldStackView()
//        layoutUserInfoView()
//    }
//}
//
//// MARK: - UI Configuration
//private extension HomeVC {
//    func configureUserInfoStackView() {
//        userInfoStackView.axis = .horizontal
//        userInfoStackView.alignment = .center
//        userInfoStackView.distribution = .fill
//        userInfoStackView.spacing = 0
//        userInfoStackView.translatesAutoresizingMaskIntoConstraints = false
//        userInfoStackView.isLayoutMarginsRelativeArrangement = false
//        userInfoStackView.layoutMargins = .zero
//    }
//
//    func configureAvatarImageView() {
//        avatarImageView.image = UIImage(named: "Ellipse")
//        avatarImageView.contentMode = .scaleAspectFit
//        avatarImageView.layer.cornerRadius = 50
//        avatarImageView.clipsToBounds = true
//        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
//
//        avatarImageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
//        avatarImageView.setContentCompressionResistancePriority(.required, for: .horizontal)
//    }
//
//    func configureUsernameStackView() {
//        usernameStackView.axis = .horizontal
//        usernameStackView.alignment = .center
//        usernameStackView.distribution = .fill
//        usernameStackView.spacing = 0
//        usernameStackView.backgroundColor = UIColor("2F2F72")
//        usernameStackView.layer.cornerRadius = 20
//        usernameStackView.clipsToBounds = true
//        usernameStackView.isLayoutMarginsRelativeArrangement = false
//        usernameStackView.layoutMargins = .zero
//        usernameStackView.translatesAutoresizingMaskIntoConstraints = false
//
//        usernameLabel.text = "userName**"
//        usernameLabel.textAlignment = .left
//        usernameLabel.font = .systemFont(ofSize: 16, weight: .semibold)
//        usernameLabel.textColor = .white
//        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
//
//        userIDIcon.image = UIImage(named: "usernameIcon");
//        userIDIcon.clipsToBounds = true
//        userIDIcon.translatesAutoresizingMaskIntoConstraints = false
//
//        userIDIcon.contentMode = .scaleAspectFit
//
//
//
//        usernameStackView.addArrangedSubview(userIDIcon)
//        usernameStackView.addArrangedSubview(usernameLabel)
//    }
//
//    func configureGoldStackView() {
//        coinStackView.axis = .horizontal
//        coinStackView.alignment = .center
//        coinStackView.distribution = .fill
//        coinStackView.spacing = 0
//        coinStackView.layer.cornerRadius = 20
//        coinStackView.backgroundColor = UIColor("2F2F72")
//        coinStackView.isLayoutMarginsRelativeArrangement = false
//        coinStackView.layoutMargins = .zero
//        coinStackView.translatesAutoresizingMaskIntoConstraints = false
//
//        coinLabel.text = "1000"
//        coinLabel.textAlignment = .center
//        coinLabel.font = .systemFont(ofSize: 18, weight: .semibold)
//        coinLabel.textColor = .white
//        coinLabel.translatesAutoresizingMaskIntoConstraints = false
//
//
//        coinIcon.image = UIImage(named: "coinIcon")
//        coinIcon.translatesAutoresizingMaskIntoConstraints = false
//
//        coinStackView.addArrangedSubview(coinLabel)
//        coinStackView.addArrangedSubview(coinIcon)
//    }
//}
//
//// MARK: - Layout Configuration
//private extension HomeVC {
//
//    func layoutUserInfoView() {
//        userInfoStackView.addArrangedSubview(usernameStackView)
//        userInfoStackView.addArrangedSubview(avatarImageView)
//        userInfoStackView.addArrangedSubview(coinStackView)
//
//        NSLayoutConstraint.activate([
//            userInfoStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
//            userInfoStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            userInfoStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
//
//            avatarImageView.widthAnchor.constraint(equalToConstant: 100),
//            avatarImageView.heightAnchor.constraint(equalToConstant: 100),
//
//
//            userIDIcon.widthAnchor.constraint(equalToConstant: 36),
//            userIDIcon.heightAnchor.constraint(equalToConstant: 36),
//
//            coinIcon.widthAnchor.constraint(equalToConstant: 36),
//            coinIcon.heightAnchor.constraint(equalToConstant: 36),
//
//            usernameStackView.heightAnchor.constraint(equalToConstant: 36),
//       //     usernameStackView.trailingAnchor.constraint(equalTo: avatarImageView.leadingAnchor, constant: -8),
//
//            coinStackView.heightAnchor.constraint(equalToConstant: 36),
//         //   coinStackView.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 8),
//
//            usernameStackView.trailingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
//            coinStackView.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor),
//
//            usernameStackView.widthAnchor.constraint(equalTo: coinStackView.widthAnchor)
//
//
//        ])
//    }
//}

// MARK: - Button Configuration
private extension HomeVC {
    func configureButton(_ button: UIButton) {
        button.layer.cornerRadius = 12
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor(red: 1.0, green: 0.8627, blue: 0.0, alpha: 1.0).cgColor
        button.backgroundColor = .clear
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.purple.cgColor,
            UIColor.red.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        
        if let superview = button.superview {
            let adjustedFrame = superview.convert(button.frame, to: superview)
            let backgroundView = UIView(frame: adjustedFrame)
            gradientLayer.frame = CGRect(origin: .zero, size: adjustedFrame.size)
            gradientLayer.cornerRadius = button.layer.cornerRadius
            
            backgroundView.layer.insertSublayer(gradientLayer, at: 0)
            backgroundView.layer.cornerRadius = button.layer.cornerRadius
            backgroundView.layer.shadowColor = UIColor.purple.cgColor
            backgroundView.layer.shadowOffset = CGSize(width: 0, height: 3)
            backgroundView.layer.shadowOpacity = 0.3
            backgroundView.layer.shadowRadius = 6
            backgroundView.layer.masksToBounds = false
            
            superview.addSubview(backgroundView)
            superview.bringSubviewToFront(button)
        }
    }
}


private extension HomeVC {
    private func setGradientBackground() {
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor.Custom.background.cgColor,
            UIColor.Custom.buttonPrimary.cgColor
        ]
        gradient.startPoint = CGPoint(x: 0.5, y: 1)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        gradient.frame = view.bounds
        view.layer.insertSublayer(gradient, at: 0)
    }
}
