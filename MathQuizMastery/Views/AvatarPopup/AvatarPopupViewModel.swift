//
//  AvatarPopupViewModel.swift
//  MathQuizMastery
//
//  Created by AydınKaya on 14.05.2025.
//

import Foundation

protocol AvatarPopupViewModelProtocol{
    var delegate: AvatarPopupViewModelDelegate? { get set }
    func loadAvatars()
    func getAvtarCount() -> Int
    func getAvatar(at index: Int) -> Avatar
    func selectAvatar(at index: Int)
}

protocol AvatarPopupViewModelDelegate: AnyObject{
    func avatarSellectionDidChange(_ viewModel: AvatarPopupViewModelProtocol, selectedAvatar: Avatar)
}

class AvatarPopupViewModel : AvatarPopupViewModelProtocol{
    
    weak var delegate: AvatarPopupViewModelDelegate?
    private var avatars : [Avatar] = []
    private var selectedAvatarIndex: Int?
    
    func loadAvatars(){
        avatars = [
            Avatar(id: "1", imageName: "batman_icon_64"),
            Avatar(id: "2", imageName: "batman_icon_64"),
            Avatar(id: "3", imageName: "batman_icon_64"),
            Avatar(id: "4", imageName: "batman_icon_64"),
            Avatar(id: "5", imageName: "batman_icon_64"),
        ]
    }
    
    func getAvtarCount() -> Int {
        return avatars.count
    }
    
    func getAvatar(at index: Int) -> Avatar {
        return avatars[index]
    }
    
    func selectAvatar(at index: Int){
        selectedAvatarIndex = index
        if let avatar = avatars[safe: index]{
            delegate?.avatarSellectionDidChange(self, selectedAvatar: avatar)
        }
    }
    
}


