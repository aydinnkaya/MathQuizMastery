//
//  SettingsViewModel.swift
//  MathQuizMastery
//
//  Created by AydınKaya on 22.05.2025.
//

import Foundation

protocol SettingsPopupViewModelProtocol : AnyObject {
    var settings: [SettingItem] { get }
}

protocol SettingsPopupDelegate : AnyObject {
    func didSelectSetting(_ setting: SettingItem)
}

class SettingsPopupViewModel : SettingsPopupViewModelProtocol{
    let settings: [SettingItem] = [
           SettingItem(title: "Profil Ayarları", iconName: "profile_image_1", type: .profile),
           SettingItem(title: "Hesap Ayarları", iconName: "profile_image_2", type: .account),
           SettingItem(title: "İstatistik", iconName: "profile_image_3", type: .statistics),
           SettingItem(title: "Bildirimler", iconName: "profile_image_4", type: .notifications),
           SettingItem(title: "S.S.S.", iconName: "profile_image_5", type: .faq),
           SettingItem(title: "Sorun Bildir", iconName: "profile_image_6", type: .report),
           SettingItem(title: "Çıkış Yap", iconName: "profile_image_8", type: .logout)
       ]
}
