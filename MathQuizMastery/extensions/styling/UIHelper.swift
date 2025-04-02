//
//  UIHelper.swift
//  MathQuizMastery
//
//  Created by AydınKaya on 2.04.2025.
//

import UIKit

final class UIHelper {
    static func showLoading(on viewController: UIViewController) {
        let alert = UIAlertController(title: nil, message: "Loading...", preferredStyle: .alert)
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.startAnimating()
        alert.view.addSubview(indicator)
        indicator.center = alert.view.center
        viewController.present(alert, animated: true)
    }
    
    static func hideLoading(on viewController: UIViewController) {
        viewController.dismiss(animated: true)
    }
}
