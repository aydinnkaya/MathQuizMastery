//
//  StartVCV.swift
//  MathQuizMastery
//
//  Created by AydınKaya on 16.01.2025.
//

import UIKit

class StartVC: UIViewController {
    
    @IBOutlet weak var userInfoStackView: UIStackView!
    @IBOutlet weak var buttonStartLabel: UIButton!
    
    @IBOutlet weak var userIDIcon: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var usernameStackView: UIStackView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var goldStackView: UIStackView!
    @IBOutlet weak var goldLabel: UILabel!
    @IBOutlet weak var goldIcon: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
        configureButton(buttonStartLabel)
        setupUserInfoView()
    }
}


//Mark: - UI Setup
private extension StartVC {
    func setupUserInfoView(){
        configureUserInfoStackView()
        configureAvatarImageView()
        configureUsernameStackView()
        configureGoldStackView()
        layoutUserInfoView()
    }
}

// Mark: - UI Configuration
private extension StartVC{
    func configureUserInfoStackView (){
        userInfoStackView.axis = .horizontal
        userInfoStackView.alignment = .center
        userInfoStackView.distribution = .equalSpacing
        userInfoStackView.spacing = 20
        userInfoStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(userInfoStackView)
    }
    
    func configureAvatarImageView(){
        avatarImageView.image = UIImage(named: "image2vector")
        avatarImageView.contentMode = .scaleAspectFit
        avatarImageView.layer.cornerRadius = 30
        avatarImageView.clipsToBounds = true
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func configureUsernameStackView(){
        usernameStackView.axis = .horizontal
        usernameStackView.alignment = .center
        usernameStackView.spacing = 5
        usernameStackView.translatesAutoresizingMaskIntoConstraints = false
        
        usernameLabel.text = "Username"
        usernameLabel.font = .systemFont(ofSize: 20,weight: .semibold)
        usernameLabel.textColor = .black
        
        userIDIcon.image = UIImage(named: "user_id_icon")
        userIDIcon.contentMode = .scaleAspectFit
        
        usernameStackView.addArrangedSubview(userIDIcon)
        usernameStackView.addArrangedSubview(usernameLabel)
    }
    
    func configureGoldStackView(){
        goldStackView.axis = .horizontal
        goldStackView.alignment = .center
        goldStackView.spacing = 5
        goldStackView.translatesAutoresizingMaskIntoConstraints = false
        
        goldLabel.text = "1000"
        goldLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        goldLabel.textColor = .yellow
        
        goldIcon.image = UIImage(named: "circle_circle_symbol")
        goldIcon.contentMode = .scaleAspectFit
        
        goldStackView.addArrangedSubview(goldLabel)
        goldStackView.addArrangedSubview(goldIcon)
    }
}


// MARK: - Layout
private extension StartVC{
    func layoutUserInfoView() {
        userInfoStackView.addArrangedSubview(usernameStackView)
        userInfoStackView.addArrangedSubview(avatarImageView)
        userInfoStackView.addArrangedSubview(goldStackView)
        
        NSLayoutConstraint.activate([
            userInfoStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            userInfoStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            userInfoStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            userInfoStackView.heightAnchor.constraint(equalToConstant: 60),
            
            avatarImageView.widthAnchor.constraint(equalToConstant: 60),
            avatarImageView.heightAnchor.constraint(equalToConstant: 60),
            
            userIDIcon.widthAnchor.constraint(equalToConstant: 18),
            userIDIcon.heightAnchor.constraint(equalToConstant: 18),
            
            goldIcon.widthAnchor.constraint(equalToConstant: 18),
            goldIcon.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
}


private extension StartVC {
    func configureButton(_ button : UIButton){
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
