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
    case register_title_text
    
    // MARK: - Login Ekranı
    case log_in
    case login_success
    case enter_password_required
    case email_required
    case password_required
    case password_too_short
    case agreement_text
    case terms_of_service
    case privacy_policy
    case create_account_title
    case no_account_question
    case register_now
    
    // MARK: - Genel Butonlar
    case ok
    case cancel
    case settings
    
    // MARK: - Uyarılar
    case loading
    case success
    case error
    case warning
    case error_title
    
    // MARK: - Ayarlar
    case settings_profile
    case settings_notifications
    case settings_faq
    case settings_report
    case settings_logout
    case settings_logout_message
    
    // MARK: - Logout Alert
    case logout_title
    case logout_message
    case logout_cancel
    case logout_confirm
    
    // MARK: - Notification Permission Alerts (Yeni eklendi)
    case notification_permission_title
    case notification_permission_message
    case notification_permission_error
    
    // MARK: - Notification Permission Buttons (Yeni eklendi)
    case notification_permission_cancel
    case notification_permission_settings
    
    // MARK: - Auth
    case login_title = "login_title"
    case login_button = "login_button"
    case register_button = "register_button"
    case username_placeholder = "username_placeholder"
    case password_placeholder = "password_placeholder"
    case register_success = "register_success"
    case register_error = "register_error"
    case login_error = "login_error"
    case validation_error = "validation_error"
    case settings_title = "settings_title"
    
    // MARK: - Game
    case game_title = "game_title"
    case game_score = "game_score"
    case game_time = "game_time"
    case game_level = "game_level"
    case game_over = "game_over"
    case game_pause = "game_pause"
    case game_resume = "game_resume"
    case game_restart = "game_restart"
    case game_quit = "game_quit"
    case game_next = "game_next"
    case game_previous = "game_previous"
    
    case game_quit_message = "game_quit_message"
    case game_over_message = "game_over_message"
    case game_win = "game_win"
    case game_win_message = "game_win_message"
    
    // MARK: - Notifications
    case notification_title = "notification_title"
    case notification_message = "notification_message"
    case notification_settings = "notification_settings"
    case notification_permission_denied = "notification_permission_denied"
    case notification_permission_granted = "notification_permission_granted"
    
    case notifications_title = "notifications_title"
    case notifications_enable = "notifications_enable"
    case notifications_disable = "notifications_disable"
    case notifications_daily = "notifications_daily"
    case notifications_weekly = "notifications_weekly"
    case notifications_time = "notifications_time"
    
    // MARK: - Notification Sections
    case notification_section_general
    case notification_section_quiz
    case notification_section_achievement
    
    // MARK: - Notification Settings Titles & Descriptions
    case notification_new_features
    case notification_new_features_desc
    case notification_weekly_report
    case notification_weekly_report_desc
    case notification_quiz_reminder
    case notification_quiz_reminder_desc
    case notification_daily_challenge
    case notification_daily_challenge_desc
    case notification_streak_reminder
    case notification_streak_reminder_desc
    case notification_achievements
    case notification_achievements_desc
    
    // MARK: - Notification Content Titles & Bodies
    case quiz_reminder_title
    case quiz_reminder_body
    case daily_challenge_title
    case daily_challenge_body
    case weekly_report_title
    case weekly_report_body
    case streak_reminder_title
    case streak_reminder_body
    
    // MARK: - Common
    case yes = "yes"
    case no = "no"
    
    // MARK: - Home
    case home_title = "home_title"
    case home_welcome = "home_welcome"
    case home_play = "home_play"
    case home_settings = "home_settings"
    case home_profile = "home_profile"
    
    // MARK: - Profile
    case profile_title = "profile_title"
    case profile_username = "profile_username"
    case profile_score = "profile_score"
    case profile_rank = "profile_rank"
    case profile_achievements = "profile_achievements"
    
    // MARK: - Category
    case category_title = "category_title"
    case category_addition = "category_addition"
    case category_subtraction = "category_subtraction"
    case category_multiplication = "category_multiplication"
    case category_division = "category_division"
    case category_mixed = "category_mixed"
    
    // MARK: - Result
    case result_title = "result_title"
    case result_score = "result_score"
    case result_time = "result_time"
    case result_accuracy = "result_accuracy"
    case result_new_record = "result_new_record"
    case result_play_again = "result_play_again"
    case result_home = "result_home"
    case result_share = "result_share"
    /// Sonuç ekranı: "{0} kategorisinde {1} doğru cevap verdin!"
    case result_score_text = "result_score_text"
    
    // MARK: - FAQ
    case faq_title
    case faq_empty = "faq_empty"
    case faq_q1 = "faq_q1"
    case faq_a1 = "faq_a1"
    case faq_q2 = "faq_q2"
    case faq_a2 = "faq_a2"
    case faq_q3 = "faq_q3"
    case faq_a3 = "faq_a3"
    case faq_q4 = "faq_q4"
    case faq_a4 = "faq_a4"
    case faq_q5 = "faq_q5"
    case faq_a5 = "faq_a5"
    
    // MARK: - Report
    case report_title = "report_title"
    case report_description = "report_description"
    case report_submit = "report_submit"
    case report_success = "report_success"
    case report_error = "report_error"
    case report_placeholder = "report_placeholder"
    
    // MARK: - Other
    case notification_time_format
    
    case notification_settings_saved
    case notification_permission_denied_title
    case notification_permission_denied_message
    case notification_settings_title
    case open_settings
    case save
    
    
    // MARK: - SettingsPopup Başlıkları
    case settings_profile_title
    case settings_notifications_title
    case settings_faq_title
    case settings_report_title
    case settings_about_title
    case settings_logout_title
    
    case save_button_title = "save_button_title"
    
    // MARK: - Validation Messages
    case email_too_long
    case password_too_long
    case password_weak
    case name_too_long
    case name_invalid_characters
    case confirm_password_required
    
    case validation_in_progress 
    // MARK: - Error Messages
    case error_network
    
    case launch_title
    case launch_slogan
    case launch_loading
    
    case no_internet_connection
    
}
