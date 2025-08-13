//
//  FontApplicable.swift
//  Majma3ak
//
//  Created by ezz on 03/07/2025.
//


import UIKit

protocol FontApplicable {
    func setFont(name: String, size: CGFloat)
}

extension FontApplicable where Self: UIView {
    func setFont(name: String, size: CGFloat) {
        if let textField = self as? UITextField {
            textField.font = UIFont(name: name, size: size)
        } else if let label = self as? UILabel {
            label.font = UIFont(name: name, size: size)
        } else if let button = self as? UIButton {
            button.titleLabel?.font = UIFont(name: name, size: size)
            
            button.configuration?.attributedTitle?.font = UIFont(name: name, size: size)
        }
    }
}

// Common extension for UITextField, UILabel, and UIButton
extension UITextField: FontApplicable {}
extension UILabel: FontApplicable {}
extension UIButton: FontApplicable {}

extension UIView {
    @IBInspectable
    var rajdhaniBold: CGFloat {
        set {
            (self as? FontApplicable)?.setFont(name: "FFShamelFamily-SansOneBold", size: newValue)
        }
        get {
            return 0.0
        }
    }

    @IBInspectable
    var rajdhaniLight: CGFloat {
        set {
            (self as? FontApplicable)?.setFont(name: "FFShamelFamily-SansOneBook", size: newValue)
        }
        get {
            return 0.0
        }
    }

//    @IBInspectable
//    var rajdhaniMedium: CGFloat {
//        set {
//            (self as? FontApplicable)?.setFont(name: "Rajdhani-Medium", size: newValue)
//        }
//        get {
//            return 0.0
//        }
//    }
//
//    @IBInspectable
//    var rajdhaniRegular: CGFloat {
//        set {
//            (self as? FontApplicable)?.setFont(name: "Rajdhani-Regular", size: newValue)
//        }
//        get {
//            return 0.0
//        }
//    }
//
//    @IBInspectable
//    var rajdhaniSemiBold: CGFloat {
//        set {
//            (self as? FontApplicable)?.setFont(name: "Rajdhani-SemiBold", size: newValue)
//        }
//        get {
//            return 0.0
//        }
//    }
}
