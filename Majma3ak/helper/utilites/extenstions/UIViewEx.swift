//
//  UIViewEx.swift
//  Majma3ak
//
//  Created by ezz on 07/06/2025.
//


import UIKit

extension UIView {

    @IBInspectable var borderWidth: CGFloat {
        get { return self.layer.borderWidth }
        set { self.layer.borderWidth = newValue }
    }

    @IBInspectable var borderColor: UIColor {
        get {
            guard let color = self.layer.borderColor else { return UIColor.clear }
            return UIColor(cgColor: color)
        }
        set {
            self.layer.borderColor = newValue.cgColor
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        get { return self.layer.cornerRadius }
        set {
            self.layer.cornerRadius = newValue
            self.layer.masksToBounds = true
            self.clipsToBounds = true
        }
    }

}
