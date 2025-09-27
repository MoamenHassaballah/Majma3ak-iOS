//
//  UILabelEx.swift
//  Majma3ak
//
//  Created by Moamen Hassaballah on 12/08/2025.
//

import UIKit

import UIKit

extension UILabel {
    
    static func swizzleInit() {
        // Swizzle init(frame:)
        let originalInitFrame = class_getInstanceMethod(UILabel.self, #selector(UILabel.init(frame:)))
        let swizzledInitFrame = class_getInstanceMethod(UILabel.self, #selector(UILabel.myInit(frame:)))
        
        if let originalInitFrame = originalInitFrame, let swizzledInitFrame = swizzledInitFrame {
            method_exchangeImplementations(originalInitFrame, swizzledInitFrame)
        }
        
        // Swizzle init(coder:) for Storyboard/XIB
        let originalInitCoder = class_getInstanceMethod(UILabel.self, #selector(UILabel.init(coder:)))
        let swizzledInitCoder = class_getInstanceMethod(UILabel.self, #selector(UILabel.myInit(coder:)))
        
        if let originalInitCoder = originalInitCoder, let swizzledInitCoder = swizzledInitCoder {
            method_exchangeImplementations(originalInitCoder, swizzledInitCoder)
        }
    }
    
    @objc private func myInit(frame: CGRect) -> UILabel {
        let label = myInit(frame: frame)
        label.applyCustomFontIfNeeded()
        return label
    }
    
    @objc private func myInit(coder aDecoder: NSCoder) -> UILabel? {
        guard let label = myInit(coder: aDecoder) else { return nil }
        label.applyCustomFontIfNeeded()
        return label
    }
    
    private func applyCustomFontIfNeeded() {
        // Replace with your custom font name
        let customFontName = "FFShamelFamily-SansOneBook"
        
        if let currentFont = self.font,
           let newFont = UIFont(name: customFontName, size: currentFont.pointSize) {
            self.font = newFont
        }
    }
    
    func applyCustomFont(_ fontSize: CGFloat) {
        let customFontName = "FFShamelFamily-SansOneBook"
        
        if let currentFont = self.font,
           let newFont = UIFont(name: customFontName, size: fontSize) {
            self.font = newFont
        }
    }
}

