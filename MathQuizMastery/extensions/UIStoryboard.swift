//
//  UIStoryboard.swift
//  MathQuizMastery
//
//  Created by AydınKaya on 14.05.2025.
//

import Foundation
import UIKit  

extension UIStoryboard {
    static func instantiate<T: UIViewController>(_ type: T.Type) -> T {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: String(describing: type)) as? T else {
            fatalError("Storyboard ID hatası: \(String(describing: type))")
        }
        return vc
    }
}
