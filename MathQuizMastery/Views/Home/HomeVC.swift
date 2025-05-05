//
//  StartVCV.swift
//  MathQuizMastery
//
//  Created by AydınKaya on 16.01.2025.
//

import UIKit

class HomeVC: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
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
        setupUserInfoView()
        viewModel.notifyViewDidLoad()
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

// MARK: - UI Setup
private extension HomeVC {
    func setupUserInfoView() {
        setGradientBackground()
        configureUserInfoStackView()
        configureAvatarImageView()
        configureUsernameStackView()
        configureGoldStackView()
        layoutUserInfoView()
    }
}

private extension HomeVC {
    private func setGradientBackground() {
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor.Custom.background.cgColor,
            UIColor.Custom.buttonPrimary.cgColor
        ]
        gradient.startPoint = CGPoint(x: 0.5, y: 0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1)
        gradient.frame = view.bounds
        view.layer.insertSublayer(gradient, at: 0)
    }
}

private extension HomeVC {
    
    func setupUserInfoViews() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        
        // Username StackView (left of avatar)
        userIDIcon.image = UIImage(systemName: "usernameIcon")
        userIDIcon.contentMode = .scaleAspectFit
        userIDIcon.translatesAutoresizingMaskIntoConstraints = false
        userIDIcon.widthAnchor.constraint(equalToConstant: 24).isActive = true
        userIDIcon.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        usernameLabel.text = "userName**"
        usernameLabel.textColor = .white
        usernameLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        usernameLabel.textAlignment = .left
        
        usernameStackView.axis = .horizontal
        usernameStackView.spacing = 8
        usernameStackView.alignment = .center
        usernameStackView.translatesAutoresizingMaskIntoConstraints = false
        usernameStackView.addArrangedSubview(userIDIcon)
        usernameStackView.addArrangedSubview(usernameLabel)
        containerView.addSubview(usernameStackView)
        
        // Avatar Setup (Centered)
        avatarImageView.image = UIImage(named: "Ellipse")
        avatarImageView.layer.cornerRadius = 50
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.borderColor = UIColor.yellow.cgColor
        avatarImageView.layer.borderWidth = 3
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(avatarImageView)

        // Coin StackView (right of avatar)
        coinIcon.image = UIImage(systemName: "coinIcon")
        coinIcon.contentMode = .scaleAspectFit
        coinIcon.translatesAutoresizingMaskIntoConstraints = false
        coinIcon.widthAnchor.constraint(equalToConstant: 24).isActive = true
        coinIcon.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        coinLabel.text = "1000"
        coinLabel.textColor = UIColor("#FFD700")
        coinLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        
        coinStackView.axis = .horizontal
        coinStackView.spacing = 8
        coinStackView.alignment = .center
        coinStackView.translatesAutoresizingMaskIntoConstraints = false
        coinStackView.addArrangedSubview(coinLabel)
        coinStackView.addArrangedSubview(coinIcon)
        containerView.addSubview(coinStackView)
    }
    
}




// MARK: - UI Configuration
private extension HomeVC {
    func configureUserInfoStackView() {
        userInfoStackView.axis = .horizontal
        userInfoStackView.alignment = .center
     //   userInfoStackView.distribution = .equalSpacing
        userInfoStackView.spacing = -2
        userInfoStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(userInfoStackView)
    }
    
    func configureAvatarImageView() {
        avatarImageView.image = UIImage(named: "Ellipse")
        avatarImageView.contentMode = .scaleAspectFit
        avatarImageView.layer.cornerRadius = 50
        avatarImageView.clipsToBounds = true
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func configureUsernameStackView() {
        usernameStackView.axis = .horizontal
        usernameStackView.alignment = .center
        usernameStackView.spacing = 0
        usernameStackView.backgroundColor = UIColor("2F2F72")
        usernameStackView.layer.cornerRadius = 15
        usernameStackView.clipsToBounds = true
        usernameStackView.translatesAutoresizingMaskIntoConstraints = false
        
        usernameLabel.text = "userName**"
        usernameLabel.textAlignment = .left
        usernameLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        usernameLabel.textColor = .black
      //  usernameLabel.backgroundColor = UIColor("2F2F72")
        
        userIDIcon.image = UIImage(named: "usernameIcon");
        userIDIcon.clipsToBounds = true
        userIDIcon.translatesAutoresizingMaskIntoConstraints = false

        userIDIcon.contentMode = .scaleAspectFit
        
        usernameStackView.addArrangedSubview(userIDIcon)
        usernameStackView.addArrangedSubview(usernameLabel)
    }
    
    func configureGoldStackView() {
        coinStackView.axis = .horizontal
        coinStackView.alignment = .center
        coinStackView.spacing = 5
        coinStackView.layer.cornerRadius = 15
        coinStackView.clipsToBounds = true
        coinStackView.backgroundColor = UIColor("2F2F72")
        coinStackView.translatesAutoresizingMaskIntoConstraints = false
        
        coinLabel.text = "1000"
        coinLabel.textAlignment = .center
        coinLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        coinLabel.textColor = .yellow
        
        coinIcon.image = UIImage(named: "coinIcon")
        coinIcon.clipsToBounds = true
        coinIcon.translatesAutoresizingMaskIntoConstraints = false
      
        
        coinStackView.addArrangedSubview(coinLabel)
        coinStackView.addArrangedSubview(coinIcon)
    }
}

// MARK: - Layout Configuration
private extension HomeVC {
    func layoutUserInfoView() {
        userInfoStackView.addArrangedSubview(usernameStackView)
        userInfoStackView.addArrangedSubview(avatarImageView)
        userInfoStackView.addArrangedSubview(coinStackView)
        
        NSLayoutConstraint.activate([
            userInfoStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            userInfoStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            userInfoStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            userInfoStackView.heightAnchor.constraint(equalToConstant: 90),
            
            avatarImageView.widthAnchor.constraint(equalToConstant: 90),
            avatarImageView.heightAnchor.constraint(equalToConstant: 90),
            
            userIDIcon.widthAnchor.constraint(equalToConstant: 36),
            userIDIcon.heightAnchor.constraint(equalToConstant: 36),
            
            coinIcon.widthAnchor.constraint(equalToConstant: 36),
            coinIcon.heightAnchor.constraint(equalToConstant: 36)
        ])
    }
}

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
