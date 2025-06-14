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
        avatars = []
        for i in 1...19 {
            let avatar = Avatar(id: "\(i)", imageName: "profile_icon_\(i)")
            avatars.append(avatar)
        }
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
