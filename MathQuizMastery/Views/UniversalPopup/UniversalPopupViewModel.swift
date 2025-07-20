//
//  UniversalPopupViewModel.swift
//  MathQuizMastery
//
//  Created by Aydın KAYA on 20.07.2025.
//

import UIKit

struct UniversalPopupViewModel {
    let messageText: String
    let primaryButtonText: String
    let secondaryButtonText: String
    let iconImage: UIImage?

    init(messageText: String,
         primaryButtonText: String,
         secondaryButtonText: String,
         iconImage: UIImage? = UIImage(systemName: "person.crop.circle.fill")) {
        self.messageText = messageText
        self.primaryButtonText = primaryButtonText
        self.secondaryButtonText = secondaryButtonText
        self.iconImage = iconImage
    }
}
