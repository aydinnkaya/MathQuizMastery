//
//  AvatarPopupVC.swift
//  MathQuizMastery
//
//  Created by AydınKaya on 13.05.2025.
//

import UIKit

// MARK: - Section Name

class AvatarPopupVC: UIViewController {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var avatarPopupView: UIView!
    @IBOutlet weak var saveButton: UIButton!
    
    var viewModel: AvatarPopupViewModelProtocol!
    private var selectedIndexPath: IndexPath?
    
    init(viewModel: AvatarPopupViewModelProtocol){
        self.viewModel = viewModel
        super.init(nibName:nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configure(with viewModel: AvatarPopupViewModelProtocol){
        self.viewModel = viewModel
    }
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupViewModel()
        setupInitialProfileImage()
    }
    
    // MARK: - ??????
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setuStyles()
    }
    
    // MARK: - Setup Methods
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    // MARK: - Setup ViewModel
    private func setupViewModel() {
        viewModel.delegate = self
        viewModel.loadAvatars()
    }
    
    // MARK: - Setup Initial Profile Image
    private func setupInitialProfileImage() {
        profileImage.image = UIImage(named: viewModel.getAvatar(at: 0).imageName)
    }
    
    // MARK: - Save Button Tapped
    @IBAction func saveButtonTapped(_ sender: UIButton, forEvent event: UIEvent) {
        
    }
    
}

extension AvatarPopupVC : UICollectionViewDelegate, UICollectionViewDataSource{
    
    // MARK: - Collection View Number of Items in Section
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getAvtarCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AvatarPopupCell", for: indexPath) as? AvatarPopupCell else {
            fatalError("AvtarPopupCell bulunamadı.")
        }
        
        let avatar = viewModel.getAvatar(at: indexPath.row)
        if let image = UIImage(named: avatar.imageName) {
            cell.configure(with: image)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.selectAvatar(at: indexPath.row)
        
        for cell in collectionView.visibleCells as! [AvatarPopupCell] {
            cell.layer.cornerRadius = cell.layer.frame.width / 2
            cell.clipsToBounds = true
            cell.layer.borderColor = UIColor.gray.cgColor
            cell.layer.borderWidth = 3
        }
        
        if let cell = collectionView.cellForItem(at: indexPath) as? AvatarPopupCell {
            cell.layer.cornerRadius = cell.layer.frame.width / 2
            cell.clipsToBounds = true
            cell.layer.borderColor = UIColor.green.cgColor
            cell.layer.borderWidth = 3
        }
    }
}

extension AvatarPopupVC : AvatarPopupViewModelDelegate {
    func avatarSellectionDidChange(_ viewModel: any AvatarPopupViewModelProtocol, selectedAvatar: Avatar) {
        if let image =  UIImage(named: selectedAvatar.imageName) {
            profileImage.image = image
            profileImage.layer.cornerRadius = profileImage.frame.width / 2
            profileImage.clipsToBounds = true
            profileImage.layer.borderColor = UIColor.green.cgColor
            profileImage.layer.borderWidth = 5.0
        }
    }
}

//Throws: - avatarPopupView.layer.cornerRadius = 20
extension AvatarPopupVC {
    func setuStyles(){
        avatarPopupView.layer.cornerRadius = 20
        avatarPopupView.layer.borderWidth = 8.0
        avatarPopupView.layer.borderColor = UIColor("#7B61FF")?.cgColor;
        avatarPopupView.clipsToBounds = true
        avatarPopupView.center = view.center

        collectionView.layer.cornerRadius = 12
        collectionView.layer.borderWidth = 3.0
        collectionView.layer.borderColor = UIColor.blue.cgColor
        collectionView.clipsToBounds = true
        
        profileImage.layer.cornerRadius = profileImage.frame.width / 2
        profileImage.layer.borderColor = UIColor.systemIndigo.cgColor
        profileImage.layer.borderWidth = 4.0
        profileImage.clipsToBounds = true
        
        usernameTextField.layer.borderColor = UIColor.systemTeal.cgColor
        usernameTextField.backgroundColor = UIColor(named: "NebulaGray")
        
        usernameTextField.attributedPlaceholder = NSAttributedString(
            string: "Enter your username",
            attributes: [
                .foregroundColor: UIColor.lightGray
            ]
        )
    }
}
