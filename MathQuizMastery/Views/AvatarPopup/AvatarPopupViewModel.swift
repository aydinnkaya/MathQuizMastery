//
//  AvatarPopupViewModel.swift
//  MathQuizMastery
//
//  Created by AydınKaya on 14.05.2025.
//

import Foundation

protocol AvatarPopupViewModelProtocol {
    var delegate: AvatarPopupViewModelDelegate? { get set }
    func loadAvatars()
    func getAvatarCount() -> Int
    func getAvatar(at index: Int) -> Avatar
    func selectAvatar(at index: Int)
    func getSelectedIndexPath() -> IndexPath?
    func handleSaveTapped()
}

protocol AvatarPopupViewModelDelegate: AnyObject {
    func avatarSelectionDidChange(selectedAvatar: Avatar)
    func avatarCellStyleUpdate(selectedIndexPath: IndexPath?, previousIndexPath: IndexPath?)
    func tappedSave()
}

class AvatarPopupViewModel: AvatarPopupViewModelProtocol {
    
    weak var delegate: AvatarPopupViewModelDelegate?
    private var avatars: [Avatar] = []
    private var selectedAvatarIndex: Int?
    
    func loadAvatars() {
        avatars = [
            Avatar(id: "1", imageName: "profile_image_1"),
            Avatar(id: "2", imageName: "profile_image_2"),
            Avatar(id: "3", imageName: "profile_image_3"),
            Avatar(id: "4", imageName: "profile_image_4"),
            Avatar(id: "5", imageName: "profile_image_5"),
            Avatar(id: "6", imageName: "profile_image_6"),
            Avatar(id: "7", imageName: "profile_image_7"),
            Avatar(id: "8", imageName: "profile_image_1"),
            Avatar(id: "9", imageName: "profile_image_2"),
            Avatar(id: "10", imageName: "profile_image_3")
        ]
    }
    
    func getAvatarCount() -> Int {
        return avatars.count
    }
    
    // MARK: - İlgili Index'teki Avatar
    func getAvatar(at index: Int) -> Avatar {
        return avatars[index]
    }
    
    // MARK: - Seçili Avatar'ın IndexPath'i
    func getSelectedIndexPath() -> IndexPath? {
        guard let index = selectedAvatarIndex else { return nil }
        return IndexPath(row: index, section: 0)
    }
    
    // MARK: - Avatar Seçimi
    func selectAvatar(at index: Int) {
        let previousIndexPath = getSelectedIndexPath()
        selectedAvatarIndex = index
        
        delegate?.avatarSelectionDidChange(selectedAvatar: avatars[index])
        delegate?.avatarCellStyleUpdate(selectedIndexPath: getSelectedIndexPath(), previousIndexPath: previousIndexPath)
    }
    
    func handleSaveTapped(){
        delegate?.tappedSave()
    }
    
}
