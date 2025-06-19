import UIKit

extension UIColor {
    static let spaceBlack = UIColor(hex: "#0A0F2C")
    static let galaxyPurple = UIColor(hex: "#8A2BE2")
    static let neonBlue = UIColor(hex: "#00F5FF")
    static let neonPink = UIColor(hex: "#FF00FF")
    static let spaceGray = UIColor(hex: "#232946")
    static let starYellow = UIColor(hex: "#FFD700")

    convenience init(hex: String) {
        var cString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if cString.hasPrefix("#") { cString.removeFirst() }
        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: 1.0
        )
    }
} 