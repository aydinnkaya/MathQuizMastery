//
//  BackgroundProviding.swift
//  MathQuizMastery
//
//  Created by AydınKaya on 13.01.2025.
//

import Foundation
import UIKit

class BackgroundProviding : BackgroundProvider {
    var backgroundColor: UIColor{
        let backgroundColors : [UIColor] = [.systemRed, .systemGray, .systemMint, .systemPink ]
        return backgroundColors.randomElement()!
    }
}
