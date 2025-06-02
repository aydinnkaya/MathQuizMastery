//
//  LocalizedKey.swift
//  MathQuizMastery
//
//  Created by Aydın KAYA on 31.03.2025.
//

import Foundation

enum LocalizedKey: String {
    
    // MARK: - Register Ekranı
    case register_title
    case enter_name
    case enter_email
    case enter_password
    case reenter_password
    case password_mismatch
    case field_required
    case registration_success
    case registration_failed
    case invalid_email
    case weak_password
    case name_required
    case passwords_do_not_match

    // MARK: - Login Ekranı
    case log_in
    case login_success
    case enter_password_required
    case email_required
    case password_required
    case password_too_short

    // MARK: - Genel Butonlar
    case ok_button
    case cancel_button

    // MARK: - Uyarılar
    case loading
    case success
    case error
    case warning

    // MARK: - Ayarlar
    case settings_profile
    case settings_notifications
    case settings_faq
    case settings_report
    case settings_logout
    
    // MARK: - Logout Alert
    case logout_title
    case logout_message
    case logout_cancel
    case logout_confirm
}
