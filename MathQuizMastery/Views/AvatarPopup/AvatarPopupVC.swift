//
//  AvatarPopupVC.swift
//  MathQuizMastery
//
//  Created by AydınKaya on 13.05.2025.
//

import UIKit

protocol AvatarPopupCoordinatorProtocol {
    func dismissPopup()
}

class AvatarPopupVC: UIViewController {
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var AvatarPopupView: UIView!
    
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var backgroundView: UIView!
    
    
    var viewModel: AvatarPopupViewModelProtocol!
    var coordinator: AppCoordinator?
    
    init(viewModel: AvatarPopupViewModelProtocol, coordinator: AppCoordinator) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName:"AvatarPopupVC", bundle: nil)
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
        setuStyles()
        setupBackgroundView()
    }
    
    // MARK: - Setup Methods
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "AvatarCell")
        
    }
    
    private func commonInit() {
        let nib = UINib(nibName: "AvatarPopupVC", bundle: nil)
        if let view = nib.instantiate(withOwner: self, options: nil).first as? UIView {
            view.frame = self.view.bounds
            self.view.addSubview(view)
        }
    }
    
    // MARK: - Setup ViewModel
    private func setupViewModel() {
        viewModel.delegate = self
        viewModel.loadAvatars()
    }
    
    //    // MARK: - Save Button Tapped
    //    @IBAction func saveButtonTapped(_ sender: UIButton, forEvent event: UIEvent) {
    //
    //    }
    
}

extension AvatarPopupVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getAvatarCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AvatarCell", for: indexPath)
        
        // Hücreyi yapılandır
        let avatar = viewModel.getAvatar(at: indexPath.row)
        let isSelected = (viewModel.getSelectedIndexPath() == indexPath)
        
        // Extension ile hücreyi güncelleyelim
        cell.configure(with: avatar, isSelected: isSelected)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.selectAvatar(at: indexPath.row)
    }
}

extension AvatarPopupVC : AvatarPopupViewModelDelegate {
    func avatarCellStyleUpdate(selectedIndexPath: IndexPath?, previousIndexPath: IndexPath?) {
        // Eski seçili hücreyi griye döndür
        // Eski seçili hücreyi griye döndür
        if let previous = previousIndexPath,
           let previousCell = collectionView.cellForItem(at: previous) {
            previousCell.configureBorder(isSelected: false)
        }
        
        // Yeni seçili hücreyi yeşile boyama
        if let current = selectedIndexPath,
           let currentCell = collectionView.cellForItem(at: current) {
            currentCell.configureBorder(isSelected: true)
        }
    }
    
    func avatarSelectionDidChange(selectedAvatar: Avatar) {
        if let image =  UIImage(named: selectedAvatar.imageName) {
            profileImage.image = image
            profileImage.layer.cornerRadius = profileImage.frame.width / 2
            profileImage.clipsToBounds = true
            profileImage.layer.borderColor = UIColor.green.cgColor
            profileImage.layer.borderWidth = 5.0
        }
    }
}

extension AvatarPopupVC {
    private func setupBackgroundView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
        backgroundView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func backgroundTapped() {
        coordinator?.dismissPopup()
    }
}

extension UICollectionViewCell {
    func configureBorder(isSelected: Bool) {
        layer.borderColor = isSelected ? UIColor.green.cgColor : UIColor.gray.cgColor
        layer.borderWidth = isSelected ? 3 : 2
    }
    
    func configure(with avatar: Avatar, isSelected: Bool) {
        
        // Görsel daha önce eklenmediyse ekle
        if contentView.viewWithTag(100) == nil {
            let imageView = UIImageView(frame: contentView.bounds)
            imageView.contentMode = .scaleAspectFit
            imageView.layer.cornerRadius = frame.width / 2
            imageView.clipsToBounds = true
            imageView.tag = 100
            contentView.addSubview(imageView)
        }
        
        // Görseli güncelle
        if let imageView = contentView.viewWithTag(100) as? UIImageView {
            imageView.image = UIImage(named: avatar.imageName)
        }
        
        // Hücre Stili Güncellemeleri
        layer.cornerRadius = frame.width / 2
        layer.borderColor = isSelected ? UIColor.green.cgColor : UIColor.gray.cgColor
        layer.borderWidth = isSelected ? 3 : 2
    }
}

//Throws: - avatarPopupView.layer.cornerRadius = 20
extension AvatarPopupVC {
    func setuStyles(){
        profileImage.image = UIImage(named: viewModel.getAvatar(at: 0).imageName)
        
        popupView.layer.cornerRadius = 20
        popupView.layer.borderWidth = 8.0
        popupView.layer.borderColor = UIColor("#7B61FF")?.cgColor;
        popupView.clipsToBounds = true
        popupView.center = view.center
        
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
