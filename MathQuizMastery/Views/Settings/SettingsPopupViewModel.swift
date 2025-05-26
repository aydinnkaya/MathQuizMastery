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
           SettingItem(title: "Profil Ayarları", iconName: "icon_profile", type: .profile),
           SettingItem(title: "Hesap Ayarları", iconName: "icon_account", type: .account),
           SettingItem(title: "İstatistik", iconName: "icon_stats", type: .statistics),
           SettingItem(title: "Bildirimler", iconName: "icon_notification", type: .notifications),
           SettingItem(title: "S.S.S.", iconName: "icon_faq", type: .faq),
           SettingItem(title: "Sorun Bildir", iconName: "icon_report", type: .report),
           SettingItem(title: "Çıkış Yap", iconName: "icon_logout", type: .logout)
       ]
}
