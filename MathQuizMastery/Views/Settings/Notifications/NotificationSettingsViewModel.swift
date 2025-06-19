//
//  NotificationSettingsViewModel.swift
//  MathQuizMastery
//
//  Created by System on 19.06.2025.
//

import Foundation
import UserNotifications

protocol NotificationSettingsViewModelDelegate: AnyObject {
    func notificationSettingsDidUpdate()
    func notificationPermissionDidChange(_ hasPermission: Bool)
}

struct NotificationSetting {
    let id: String
    let title: String
    let description: String
    let icon: String
    var isEnabled: Bool
    let section: NotificationSection
    let defaultTime: String? // "09:00" formatında
    
    enum NotificationSection: Int, CaseIterable {
        case general = 0
        case quiz = 1
        case achievement = 2
        
        var title: String {
            switch self {
            case .general:
                return L(.notification_section_general)
            case .quiz:
                return L(.notification_section_quiz)
            case .achievement:
                return L(.notification_section_achievement)
            }
        }
    }
}

class NotificationSettingsViewModel {
    
    // MARK: - Properties
    weak var delegate: NotificationSettingsViewModelDelegate?
    private var settings: [NotificationSetting] = []
    private let userDefaults = UserDefaults.standard
    private let notificationService = NotificationPermissionService.shared
    
    var hasNotificationPermission: Bool = false
    
    // MARK: - Keys
    private struct Keys {
        static let quizReminder = "notification_quiz_reminder"
        static let dailyChallenge = "notification_daily_challenge"
        static let weeklyReport = "notification_weekly_report"
        static let achievements = "notification_achievements"
        static let streakReminder = "notification_streak_reminder"
        static let newFeatures = "notification_new_features"
    }
    
    // MARK: - Initialization
    init() {
        setupSettings()
        setupNotificationService()
    }
    
    // MARK: - Setup
    private func setupSettings() {
        settings = [
            // General Section
            NotificationSetting(
                id: Keys.newFeatures,
                title: L(.notification_new_features),
                description: L(.notification_new_features_desc),
                icon: "sparkles",
                isEnabled: getSetting(for: Keys.newFeatures, defaultValue: true),
                section: .general,
                defaultTime: nil
            ),
            NotificationSetting(
                id: Keys.weeklyReport,
                title: L(.notification_weekly_report),
                description: L(.notification_weekly_report_desc),
                icon: "chart.bar",
                isEnabled: getSetting(for: Keys.weeklyReport, defaultValue: true),
                section: .general,
                defaultTime: "18:00"
            ),
            
            // Quiz Section
            NotificationSetting(
                id: Keys.quizReminder,
                title: L(.notification_quiz_reminder),
                description: L(.notification_quiz_reminder_desc),
                icon: "brain.head.profile",
                isEnabled: getSetting(for: Keys.quizReminder, defaultValue: true),
                section: .quiz,
                defaultTime: "09:00"
            ),
            NotificationSetting(
                id: Keys.dailyChallenge,
                title: L(.notification_daily_challenge),
                description: L(.notification_daily_challenge_desc),
                icon: "target",
                isEnabled: getSetting(for: Keys.dailyChallenge, defaultValue: true),
                section: .quiz,
                defaultTime: "10:00"
            ),
            NotificationSetting(
                id: Keys.streakReminder,
                title: L(.notification_streak_reminder),
                description: L(.notification_streak_reminder_desc),
                icon: "flame",
                isEnabled: getSetting(for: Keys.streakReminder, defaultValue: true),
                section: .quiz,
                defaultTime: "20:00"
            ),
            
            // Achievement Section
            NotificationSetting(
                id: Keys.achievements,
                title: L(.notification_achievements),
                description: L(.notification_achievements_desc),
                icon: "trophy",
                isEnabled: getSetting(for: Keys.achievements, defaultValue: true),
                section: .achievement,
                defaultTime: nil
            )
        ]
    }
    
    private func setupNotificationService() {
        notificationService.delegate = self
    }
    
    // MARK: - Public Methods
    func loadSettings() {
        checkNotificationPermission()
        delegate?.notificationSettingsDidUpdate()
    }
    
    func refreshSettings() {
        checkNotificationPermission()
        loadSettingsFromUserDefaults()
        delegate?.notificationSettingsDidUpdate()
    }
    
    func saveSettings() {
        for setting in settings {
            userDefaults.set(setting.isEnabled, forKey: setting.id)
        }
        userDefaults.synchronize()
        
        // Bildirimleri planla
        scheduleNotifications()
    }
    
    func updateSetting(_ setting: NotificationSetting, isEnabled: Bool) {
        if let index = settings.firstIndex(where: { $0.id == setting.id }) {
            settings[index].isEnabled = isEnabled
            userDefaults.set(isEnabled, forKey: setting.id)
            
            if isEnabled {
                scheduleNotification(for: settings[index])
            } else {
                cancelNotification(for: setting.id)
            }
        }
    }
    
    func updatePermissionStatus(_ status: NotificationPermissionStatus) {
        hasNotificationPermission = status == .authorized || status == .provisional
        delegate?.notificationPermissionDidChange(hasNotificationPermission)
    }
    
    // MARK: - TableView Data Source Methods
    func numberOfSections() -> Int {
        return NotificationSetting.NotificationSection.allCases.count
    }
    
    func numberOfRows(in section: Int) -> Int {
        guard let sectionType = NotificationSetting.NotificationSection(rawValue: section) else {
            return 0
        }
        return settings.filter { $0.section == sectionType }.count
    }
    
    func setting(at indexPath: IndexPath) -> NotificationSetting {
        guard let sectionType = NotificationSetting.NotificationSection(rawValue: indexPath.section) else {
            return settings[0]
        }
        let sectionSettings = settings.filter { $0.section == sectionType }
        return sectionSettings[indexPath.row]
    }
    
    func sectionTitle(for section: Int) -> String {
        guard let sectionType = NotificationSetting.NotificationSection(rawValue: section) else {
            return ""
        }
        return sectionType.title
    }
    
    // MARK: - Private Methods
    private func getSetting(for key: String, defaultValue: Bool) -> Bool {
        if userDefaults.object(forKey: key) == nil {
            userDefaults.set(defaultValue, forKey: key)
        }
        return userDefaults.bool(forKey: key)
    }
    
    private func loadSettingsFromUserDefaults() {
        for index in 0..<settings.count {
            settings[index].isEnabled = userDefaults.bool(forKey: settings[index].id)
        }
    }
    
    private func checkNotificationPermission() {
        notificationService.checkPermissionStatus { [weak self] status in
            DispatchQueue.main.async {
                self?.updatePermissionStatus(status)
            }
        }
    }
    
    private func scheduleNotifications() {
        // Önce tüm bildirimleri iptal et
        notificationService.cancelAllNotifications()
        
        // Aktif bildirimleri tekrar planla
        for setting in settings where setting.isEnabled {
            scheduleNotification(for: setting)
        }
    }
    
    private func scheduleNotification(for setting: NotificationSetting) {
        guard hasNotificationPermission else { return }
        
        switch setting.id {
        case Keys.quizReminder:
            scheduleQuizReminder()
        case Keys.dailyChallenge:
            scheduleDailyChallenge()
        case Keys.weeklyReport:
            scheduleWeeklyReport()
        case Keys.achievements:
            // Achievements are triggered by app logic, not scheduled
            break
        case Keys.streakReminder:
            scheduleStreakReminder()
        case Keys.newFeatures:
            // New features are triggered by app updates, not scheduled
            break
        default:
            break
        }
    }
    
    private func cancelNotification(for identifier: String) {
        notificationService.cancelNotification(withIdentifier: identifier)
    }
    
    // MARK: - Notification Scheduling
    private func scheduleQuizReminder() {
        let content = UNMutableNotificationContent()
        content.title = L(.quiz_reminder_title)
        content.body = L(.quiz_reminder_body)
        content.sound = .default
        content.categoryIdentifier = "QUIZ_REMINDER"
        
        // Her gün saat 9:00'da
        var dateComponents = DateComponents()
        dateComponents.hour = 9
        dateComponents.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: Keys.quizReminder, content: content, trigger: trigger)
        
        notificationService.notificationCenter.add(request) { error in
            if let error = error {
                print("Quiz reminder schedule error: \(error.localizedDescription)")
            }
        }
    }
    
    private func scheduleDailyChallenge() {
        let content = UNMutableNotificationContent()
        content.title = L(.daily_challenge_title)
        content.body = L(.daily_challenge_body)
        content.sound = .default
        content.categoryIdentifier = "DAILY_CHALLENGE"
        
        // Her gün saat 10:00'da
        var dateComponents = DateComponents()
        dateComponents.hour = 10
        dateComponents.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: Keys.dailyChallenge, content: content, trigger: trigger)
        
        notificationService.notificationCenter.add(request) { error in
            if let error = error {
                print("Daily challenge schedule error: \(error.localizedDescription)")
            }
        }
    }
    
    private func scheduleWeeklyReport() {
        let content = UNMutableNotificationContent()
        content.title = L(.weekly_report_title)
        content.body = L(.weekly_report_body)
        content.sound = .default
        content.categoryIdentifier = "WEEKLY_REPORT"
        
        // Her pazar saat 18:00'da
        var dateComponents = DateComponents()
        dateComponents.weekday = 1 // Sunday
        dateComponents.hour = 18
        dateComponents.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: Keys.weeklyReport, content: content, trigger: trigger)
        
        notificationService.notificationCenter.add(request) { error in
            if let error = error {
                print("Weekly report schedule error: \(error.localizedDescription)")
            }
        }
    }
    
    private func scheduleStreakReminder() {
        let content = UNMutableNotificationContent()
        content.title = L(.streak_reminder_title)
        content.body = L(.streak_reminder_body)
        content.sound = .default
        content.categoryIdentifier = "STREAK_REMINDER"
        
        // Her gün saat 20:00'da
        var dateComponents = DateComponents()
        dateComponents.hour = 20
        dateComponents.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: Keys.streakReminder, content: content, trigger: trigger)
        
        notificationService.notificationCenter.add(request) { error in
            if let error = error {
                print("Streak reminder schedule error: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Achievement Notifications (Triggered by app logic)
    func triggerAchievementNotification(title: String, message: String) {
        guard hasNotificationPermission && getSetting(for: Keys.achievements, defaultValue: true) else {
            return
        }
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = message
        content.sound = .default
        content.categoryIdentifier = "ACHIEVEMENT"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let identifier = "achievement_\(Date().timeIntervalSince1970)"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        notificationService.notificationCenter.add(request) { error in
            if let error = error {
                print("Achievement notification error: \(error.localizedDescription)")
            }
        }
    }
    
    func triggerNewFeatureNotification(title: String, message: String) {
        guard hasNotificationPermission && getSetting(for: Keys.newFeatures, defaultValue: true) else {
            return
        }
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = message
        content.sound = .default
        content.categoryIdentifier = "NEW_FEATURE"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let identifier = "new_feature_\(Date().timeIntervalSince1970)"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        notificationService.notificationCenter.add(request) { error in
            if let error = error {
                print("New feature notification error: \(error.localizedDescription)")
            }
        }
    }
}

// MARK: - NotificationPermissionServiceDelegate
extension NotificationSettingsViewModel: NotificationPermissionServiceDelegate {
    func notificationPermissionDidChange(_ granted: Bool) {
        hasNotificationPermission = granted
        delegate?.notificationPermissionDidChange(granted)
        
        if granted {
            scheduleNotifications()
        } else {
            notificationService.cancelAllNotifications()
        }
    }
    
    func notificationPermissionDidFail(_ error: NotificationPermissionError) {
        hasNotificationPermission = false
        delegate?.notificationPermissionDidChange(false)
        print("Notification permission failed: \(error.localizedDescription)")
    }
}
