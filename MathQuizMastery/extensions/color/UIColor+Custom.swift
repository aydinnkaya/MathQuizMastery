//
//  UIColor+Custom.swift
//  MathQuizMastery
//
//  Created by AydınKaya on 19.03.2025.
//

import Foundation
import UIKit


extension UIColor {
    convenience init?(_ hexString: String){
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        
        guard Scanner(string: hex).scanHexInt64(&int) else {
            
            return nil
        }
        
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            return nil
        }
        
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)

    }
}


extension UIColor {
    struct Custom {
        static let background = UIColor("0095FF") ?? UIColor.white
        static let navigationBar = UIColor("0095FF") ?? UIColor.white
        static let buttonPrimary = UIColor("FF5733") ?? UIColor.red
        static let textPrimary = UIColor("333333") ?? UIColor.black
    }
}
