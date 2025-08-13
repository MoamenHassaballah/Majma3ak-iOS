//
//  StringEx.swift
//  Majma3ak
//
//  Created by ezz on 07/06/2025.
//
import UIKit
extension String {
    var color_ : UIColor {
        return UIColor.init(named: self) ?? UIColor.init(hexString: self)
    }
    
    var colorcg : CGColor {
        return self.color_.cgColor
    }
    
    var image_ : UIImage? {
        return UIImage.init(named: self)
    }
    
    var removeWhiteSpace_ : String {
        return self.replacingOccurrences(of: " ", with: "")
    }

    var isValidValue : Bool {
        return !self.removeWhiteSpace_.isEmpty
    }
    
    var loclize_ : String {
        return NSLocalizedString(self, comment: "")
    }
    
    //MARK: convert from String to Date
    func date(dateFormatter : String , timeZone : String = TimeZone.current.identifier) -> Date? {
        let formatter = DateFormatter()
        formatter.calendar = Calendar.init(identifier: .gregorian)
        formatter.dateFormat = dateFormatter //2021-03-12
        formatter.timeZone = TimeZone.init(identifier: timeZone)
        return formatter.date(from: self)
    }
}
extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}
