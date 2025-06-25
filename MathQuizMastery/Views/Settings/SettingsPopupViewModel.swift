//
//  SettingsViewModel.swift
//  MathQuizMastery
//
//  Created by AydınKaya on 22.05.2025.
//

import Foundation

protocol SettingsPopupViewModelProtocol: AnyObject {
    var delegate: SettingsPopupDelegate? { get set }
    var settings: [SettingItem] { get }
    func selectItem(at index: Int)
}

protocol SettingsPopupDelegate: AnyObject {
    func didSelectSetting(_ item: SettingItem)
    func tappedProfile()
    func tappedNotifications()
    func tappedFAQ()
    func tappedReport()
    func tappedLogout()
}

class SettingsPopupViewModel: SettingsPopupViewModelProtocol {
    
    weak var delegate: SettingsPopupDelegate?
    
    let settings: [SettingItem] = [
        SettingItem(title: L(.settings_profile_title), iconName: "profile_settings", type: .profile),
        SettingItem(title: L(.settings_notifications_title), iconName: "settings_notification_icon", type: .notifications),
        SettingItem(title: L(.settings_faq_title), iconName: "settings_question_icon", type: .faq),
        SettingItem(title: L(.settings_report_title), iconName: "settings_report_icon", type: .report),
        SettingItem(title: L(.settings_logout_title), iconName: "settings_logout_icon", type: .logout)
    ]
    
    func selectItem(at index: Int) {
        guard index >= 0 && index < settings.count else { return }
        let selectedItem = settings[index]
        
        switch selectedItem.type {
        case .profile:
            delegate?.tappedProfile()
        case .notifications:
            delegate?.tappedNotifications()
        case .faq:
            delegate?.tappedFAQ()
        case .report:
            delegate?.tappedReport()
        case .logout:
            delegate?.tappedLogout()
        }
    }
}
