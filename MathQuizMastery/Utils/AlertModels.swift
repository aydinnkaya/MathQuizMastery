import UIKit

struct AlertModel {
    let title: String
    let message: String
    let primaryAction: AlertAction?
    let secondaryAction: AlertAction?
    
    init(title: String, message: String, primaryAction: AlertAction? = nil, secondaryAction: AlertAction? = nil) {
        self.title = title
        self.message = message
        self.primaryAction = primaryAction
        self.secondaryAction = secondaryAction
    }
}

struct AlertAction {
    let title: String
    let style: AlertActionStyle
    let handler: (() -> Void)?
    
    init(title: String, style: AlertActionStyle = .default, handler: (() -> Void)? = nil) {
        self.title = title
        self.style = style
        self.handler = handler
    }
}

enum AlertActionStyle {
    case `default`
    case cancel
    case destructive
    
    var uiAlertActionStyle: UIAlertAction.Style {
        switch self {
        case .default:
            return .default
        case .cancel:
            return .cancel
        case .destructive:
            return .destructive
        }
    }
} 