//
//  SettingsViewModel.swift
//  MathQuizMastery
//
//  Created by AydınKaya on 22.05.2025.
//

import Foundation

protocol SettingsPopupViewModelProtocol: AnyObject {
    var settings: [SettingItem] { get }
    func selectItem(at index: Int)
}

protocol SettingsPopupDelegate: AnyObject {
    func didSelectSetting(_ item: SettingItem)
}

class SettingsPopupViewModel: SettingsPopupViewModelProtocol {

    weak var delegate: SettingsPopupDelegate?

    let settings: [SettingItem] = [
        SettingItem(title: L(.settings_profile), iconName: "settings_profile_icon", type: .profile),
        SettingItem(title: L(.settings_notifications), iconName: "settings_notification_icon", type: .notifications),
        SettingItem(title: L(.settings_faq), iconName: "settings_sss_icon", type: .faq),
        SettingItem(title: L(.settings_report), iconName: "settings_report_icon", type: .report),
        SettingItem(title: L(.settings_logout), iconName: "settings_logout_icon", type: .logout)
    ]


    func selectItem(at index: Int) {
        guard index >= 0 && index < settings.count else { return }
        let selectedItem = settings[index]
        delegate?.didSelectSetting(selectedItem)
    }
}
