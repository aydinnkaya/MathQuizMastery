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
            Avatar(id: "1", imageName: "profile_image_1"),
            Avatar(id: "2", imageName: "profile_image_2"),
            Avatar(id: "3", imageName: "profile_image_3"),
            Avatar(id: "4", imageName: "profile_image_4"),
            Avatar(id: "5", imageName: "profile_image_5"),
            Avatar(id: "6", imageName: "profile_image_6"),
            Avatar(id: "7", imageName: "profile_image_7"),
            Avatar(id: "8", imageName: "profile_image_1"),
            Avatar(id: "9", imageName: "profile_image_2"),
            Avatar(id: "10", imageName: "profile_image_3"),
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


