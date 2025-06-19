////
////  NotificationAlertModel.swift
////  MathQuizMastery
////
////  Created by AydınKaya on 18.06.2025.
////
//
//import UIKit
//
//// MARK: - Alert Model for Notifications
//struct NotificationAlertModel {
//    let title: String
//    let message: String
//    let primaryAction: NotificationAlertAction?
//    let secondaryAction: NotificationAlertAction?
//    
//    init(title: String, message: String, primaryAction: NotificationAlertAction? = nil, secondaryAction: NotificationAlertAction? = nil) {
//        self.title = title
//        self.message = message
//        self.primaryAction = primaryAction
//        self.secondaryAction = secondaryAction
//    }
//}
//
//struct NotificationAlertAction {
//    let title: String
//    let style: NotificationAlertActionStyle
//    let handler: (() -> Void)?
//    
//    init(title: String, style: NotificationAlertActionStyle = .default, handler: (() -> Void)? = nil) {
//        self.title = title
//        self.style = style
//        self.handler = handler
//    }
//}
//
//enum NotificationAlertActionStyle {
//    case `default`
//    case cancel
//    case destructive
//    
//    var uiAlertActionStyle: UIAlertAction.Style {
//        switch self {
//        case .default:
//            return .default
//        case .cancel:
//            return .cancel
//        case .destructive:
//            return .destructive
//        }
//    }
//}
//
