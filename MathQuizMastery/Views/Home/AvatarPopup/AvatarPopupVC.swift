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
        setupTextField()
        setuStyles()
        setupBackgroundView()
    }
    
    // MARK: - Setup Methods
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "AvatarCell")
    }
    
    private func setupTextField() {
        usernameTextField.delegate = self
        usernameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    @objc private func textFieldDidChange() {
        viewModel.updateUsername(usernameTextField.text ?? "")
    }
    
    // MARK: - Setup ViewModel
    private func setupViewModel() {
        viewModel.delegate = self
        viewModel.loadUserData()
    }
    
    // MARK: - Save Button Tapped
    @IBAction func saveButtonTapped(_ sender: UIButton, forEvent event: UIEvent) {
        usernameTextField.resignFirstResponder()
        viewModel.handleSaveTapped()
    }
    
}

// MARK: - UITextField Delegate
extension AvatarPopupVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Username için karakter limiti (örn: 20 karakter)
        let maxLength = 20
        let currentString = (textField.text ?? "") as NSString
        let newString = currentString.replacingCharacters(in: range, with: string)
        return newString.count <= maxLength
    }
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
    func tappedSave() {
        coordinator?.dismissPopup()
    }
    
    func userDataLoaded(username: String, avatar: Avatar) {
        DispatchQueue.main.async { [weak self] in
            self?.usernameTextField.text = username
            
            if let image = UIImage(named: avatar.imageName) {
                self?.profileImage.image = image
                self?.profileImage.layer.cornerRadius = self?.profileImage.frame.width ?? 0 / 2
                self?.profileImage.clipsToBounds = true
                self?.profileImage.layer.borderColor = UIColor.green.cgColor
                self?.profileImage.layer.borderWidth = 5.0
            }
        }
    }
    
    func avatarCellStyleUpdate(selectedIndexPath: IndexPath?, previousIndexPath: IndexPath?) {
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
    
    func showError(message: String) {
        let alert = UIAlertController(title: "Hata", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        present(alert, animated: true)
    }
    
    func showSuccess(message: String) {
        let alert = UIAlertController(title: "Başarılı", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        present(alert, animated: true)
    }
    
    func showLoading(_ show: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.saveButton.isEnabled = !show
            self?.saveButton.setTitle(show ? "Kaydediliyor..." : "Kaydet", for: .normal)
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

extension AvatarPopupVC {
    func setuStyles(){
        
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
        usernameTextField.layer.cornerRadius = 8
        usernameTextField.layer.borderWidth = 1
        
        usernameTextField.attributedPlaceholder = NSAttributedString(
            string: "Kullanıcı adınızı girin",
            attributes: [
                .foregroundColor: UIColor.lightGray
            ]
        )
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: usernameTextField.frame.height))
        usernameTextField.leftView = paddingView
        usernameTextField.leftViewMode = .always
    }
}
