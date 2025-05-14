//
//  AvatarPopupVC.swift
//  MathQuizMastery
//
//  Created by AydınKaya on 13.05.2025.
//

import UIKit


class AvatarPopupVC: UIViewController {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameTexfield: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var profileImageButton: UIButton!
    @IBOutlet weak var avatarPopupView: UIView!
    
    @IBOutlet weak var saveButton: UIButton!
    
    var viewModel: AvatarPopupViewModelProtocol!

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        viewModel.delegate = self
        setuStyles()
    }
    
    override func viewDidLayoutSubviews() {
        
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton, forEvent event: UIEvent) {
        
    }
    
   
    
}

extension AvatarPopupVC : UICollectionViewDelegate, UICollectionViewDataSource{
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
            cell.layer.borderColor = UIColor.gray.cgColor
        }
        
        if let cell = collectionView.cellForItem(at: indexPath) as? AvatarPopupCell {
            cell.layer.borderColor = UIColor.green.cgColor
            cell.layer.borderWidth = 2
        }
    }
}

extension AvatarPopupVC : AvatarPopupViewModelDelegate {
    func avatarSellectionDidChange(_ viewModel: any AvatarPopupViewModelProtocol, selectedAvatar: Avatar) {
        if let image =  UIImage(named: selectedAvatar.imageName) {
            profileImage.image = image
        }
    }
}

extension AvatarPopupVC {
    func setuStyles(){
        avatarPopupView.layer.cornerRadius = 12
        avatarPopupView.layer.borderWidth = 3
        avatarPopupView.layer.borderColor = UIColor.blue.cgColor
        avatarPopupView.clipsToBounds = true
        
        collectionView.layer.cornerRadius = 12
        collectionView.layer.borderWidth = 3
        collectionView.layer.borderColor = UIColor.blue.cgColor
        collectionView.clipsToBounds = true
    }
}
