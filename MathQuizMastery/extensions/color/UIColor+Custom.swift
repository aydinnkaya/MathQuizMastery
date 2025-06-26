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

import UIKit

// MARK: - Genel Özel Renkler
extension UIColor {
    struct Custom {
        
        // MARK: Background Colors
        static let backgroundDark1 = UIColor("0D0D2B") ?? .black
        static let backgroundDark2 = UIColor("111138") ?? .black
        static let backgroundDark3 = UIColor("1E1E5A") ?? .black
        
        // MARK: Login & Register Backgrounds
        static let loginBackground: [CGColor] = [
            UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1.0).cgColor,
            UIColor(red: 0.8, green: 0.1, blue: 0.0, alpha: 1.0).cgColor,
            UIColor(red: 0.9, green: 0.7, blue: 0.0, alpha: 1.0).cgColor
        ]
        
        static let registerBackground: [CGColor] = [
            UIColor(red: 0.9, green: 0.7, blue: 0.0, alpha: 1.0).cgColor,
            UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1.0).cgColor
        ]
        
        // MARK: Galactic Background Gradient
        static let galacticBackground: [CGColor] = [
            UIColor("#060F2F")?.cgColor ?? UIColor.black.cgColor,
            UIColor("#152D7A")?.cgColor ?? UIColor.darkGray.cgColor,
            UIColor("#2890D2")?.cgColor ?? UIColor.blue.cgColor,
            UIColor("#7CEEFF")?.cgColor ?? UIColor.cyan.cgColor,
            UIColor("#173985")?.cgColor ?? UIColor.blue.cgColor,
            UIColor("#060F2F")?.cgColor ?? UIColor.black.cgColor
        ]
        
        // MARK: General Colors
        static let buttonPrimary = UIColor("FF5733") ?? .red
        static let textPrimary = UIColor("333333") ?? .black
        
        // MARK: AnswerButton Styles
        static let answerButtonBackground: [CGColor] = [
            UIColor("361E1E")?.cgColor ?? UIColor.darkGray.cgColor,
            UIColor("190514")?.cgColor ?? UIColor.black.cgColor
        ]
        static let answerButtonBorder = UIColor("FF7A00")?.cgColor ?? UIColor.orange.cgColor
        static let answerButtonGlow = UIColor("FF7A00")?.cgColor ?? UIColor.orange.cgColor
        
        static let correctAnswerBackground: [CGColor] = [
            UIColor("1E9632")?.cgColor ?? UIColor.green.cgColor,
            UIColor("32B446")?.cgColor ?? UIColor.green.cgColor
        ]
        static let correctAnswerBorder = UIColor("50FF64")?.cgColor ?? UIColor.green.cgColor
        static let correctAnswerGlow = UIColor("50FF64")?.cgColor ?? UIColor.green.cgColor
        
        static let wrongAnswerBackground: [CGColor] = [
            UIColor("961E1E")?.cgColor ?? UIColor.red.cgColor,
            UIColor("B42828")?.cgColor ?? UIColor.red.cgColor
        ]
        static let wrongAnswerBorder = UIColor("FF3C3C")?.cgColor ?? UIColor.red.cgColor
        static let wrongAnswerGlow = UIColor("FF3C3C")?.cgColor ?? UIColor.red.cgColor
        
        static let answerTextGradient: [UIColor] = [
            UIColor("FFB432") ?? UIColor.orange,
            UIColor("FF6400") ?? UIColor.orange
        ]
        
        // MARK: InfoLabel Themes
        static let infoScoreBackground: [CGColor] = [
            UIColor("993FCC")?.cgColor ?? UIColor.purple.cgColor,
            UIColor("6633CC")?.cgColor ?? UIColor.purple.cgColor
        ]
        static let infoQuestionBackground: [CGColor] = [
            UIColor("993FCC")?.cgColor ?? UIColor.purple.cgColor,
            UIColor("6633CC")?.cgColor ?? UIColor.purple.cgColor
        ]
        static let infoTimerBackground: [CGColor] = [
            UIColor("333333")?.cgColor ?? UIColor.darkGray.cgColor,
            UIColor("1A1A1A")?.cgColor ?? UIColor.black.cgColor
        ]
        
        static let infoScoreBorder: [CGColor] = [
            UIColor("7AD0FF")?.cgColor ?? UIColor.cyan.cgColor,
            UIColor("8A2BE2")?.cgColor ?? UIColor.systemPurple.cgColor
        ]
        static let infoQuestionBorder: [CGColor] = [
            UIColor("7AD0FF")?.cgColor ?? UIColor.cyan.cgColor,
            UIColor("8A2BE2")?.cgColor ?? UIColor.systemPurple.cgColor
        ]
        static let infoTimerBorder: [CGColor] = [
            UIColor(white: 0.8, alpha: 0.8).cgColor,
            UIColor(white: 0.6, alpha: 0.6).cgColor
        ]
        
        static let infoScoreGlow = UIColor("FFE566") ?? .yellow
        static let infoQuestionGlow = UIColor("FFE566") ?? .yellow
        static let infoTimerGlow = UIColor.white
        
        // MARK: Question Styles
        static let questionBackground: [CGColor] = [
            UIColor("1C0641")!.cgColor,
            UIColor("0A0523")!.cgColor
        ]
        static let questionBorder = UIColor("66CCFF")!
        static let questionGlow = UIColor("6699FF")!
        
        static let questionTextGradient: [UIColor] = [
            UIColor("FFC850")!,
            UIColor("FF641E")!
        ]
        
        // MARK: Timer Styles
        static let timerBackground: [CGColor] = [
            UIColor("662611")!.cgColor,
            UIColor("7F331A")!.cgColor
        ]
        static let timerWarningBackground: [CGColor] = [
            UIColor("661A1A")!.cgColor,
            UIColor("802626")!.cgColor
        ]
        static let timerGlow = UIColor("FF9933")!
        static let timerBorder = UIColor("FF9933")!
        static let timerWarning = UIColor("FF4D4D")!
        static let timerTextGradient: [UIColor] = [
            UIColor("FFB432")!,
            UIColor("FF641E")!
        ]
        
        // MARK: Space Background Gradient Colors
        static let spaceBackgroundColors: [CGColor] = [
            UIColor(red: 0.05, green: 0.08, blue: 0.15, alpha: 1.0).cgColor,  // Deep Space Blue
            UIColor(red: 0.08, green: 0.12, blue: 0.20, alpha: 1.0).cgColor,  // Cosmic Navy
            UIColor(red: 0.12, green: 0.16, blue: 0.25, alpha: 1.0).cgColor,  // Space Gray
            UIColor(red: 0.06, green: 0.10, blue: 0.18, alpha: 1.0).cgColor   // Dark Void
        ]
        
        // MARK: Nebula Gradient Colors
        static let nebulaGradientColors: [CGColor] = [
            UIColor(red: 0.15, green: 0.20, blue: 0.35, alpha: 0.3).cgColor,
            UIColor(red: 0.20, green: 0.25, blue: 0.40, alpha: 0.2).cgColor,
            UIColor(red: 0.10, green: 0.15, blue: 0.30, alpha: 0.1).cgColor
        ]
        
        // MARK: Star Field Color
        static let starFieldColor = UIColor(red: 0.85, green: 0.90, blue: 1.0, alpha: 1.0).cgColor
        
        // MARK: Time Warning Layer Stroke Color
        static let timeWarningStrokeColor = UIColor(red: 1.0, green: 0.3, blue: 0.3, alpha: 0.8).cgColor
        
        // MARK: Success Effect Colors
        static let successEffectBackground = UIColor(red: 0.20, green: 0.70, blue: 0.40, alpha: 0.15).cgColor
        static let successParticleColor = UIColor(red: 0.30, green: 0.80, blue: 0.45, alpha: 1.0)
        
        // MARK: Wrong Answer Effect Colors
        static let wrongEffectBackground = UIColor(red: 0.70, green: 0.20, blue: 0.20, alpha: 0.12).cgColor
        
        // MARK: Finish Effect Colors (Skora Göre)
        static let finishEffectColorsHigh: [CGColor] = [
            UIColor(red: 1.0, green: 0.85, blue: 0.2, alpha: 0.3).cgColor,
            UIColor(red: 1.0, green: 0.75, blue: 0.1, alpha: 0.2).cgColor
        ]
        static let finishEffectColorsMedium: [CGColor] = [
            UIColor(red: 0.8, green: 0.85, blue: 0.9, alpha: 0.3).cgColor,
            UIColor(red: 0.7, green: 0.75, blue: 0.8, alpha: 0.2).cgColor
        ]
        static let finishEffectColorsLow: [CGColor] = [
            UIColor(red: 0.8, green: 0.5, blue: 0.2, alpha: 0.3).cgColor,
            UIColor(red: 0.7, green: 0.4, blue: 0.1, alpha: 0.2).cgColor
        ]
        
        // Notification Settings cell
        static let settingTitle = UIColor("333333") ?? .black
        static let settingDescription = UIColor("666666") ?? .darkGray
        static let settingTime = UIColor("999999") ?? .lightGray
        static let settingSwitchOn = UIColor("7B61FF") ?? .systemPurple
        static let settingIcon = UIColor("7B61FF") ?? .systemPurple
        static let settingBorderActive = UIColor("7B61FF")?.withAlphaComponent(0.3) ?? .lightGray
        static let settingBorderInactive = UIColor("E5E5E5") ?? .lightGray
        
        // FAQ
        static let closeButton = UIColor(red: 0.455, green: 0.816, blue: 0.988, alpha: 1.0)
        
        static let linkColor = UIColor(red: 0.26, green: 0.65, blue: 0.96, alpha: 1.0)
        
        
    }
}
