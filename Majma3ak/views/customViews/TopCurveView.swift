//
//  TopCurveView.swift
//  Majma3ak
//
//  Created by ezz on 29/06/2025.
//

import UIKit
class TopCurveView: UIView {
    override func draw(_ rect: CGRect) {
        // Define the path
        let path = UIBezierPath()
        let height: CGFloat = rect.height
        let width: CGFloat = rect.width

        // Start at top left
        path.move(to: CGPoint(x: 0, y: 0))
        // Line to bottom left
        path.addLine(to: CGPoint(x: 0, y: height * 0.7))
        // Add curve
        path.addQuadCurve(to: CGPoint(x: width, y: height * 0.7),
                          controlPoint: CGPoint(x: width / 2, y: height * 1.2))
        // Line to top right
        path.addLine(to: CGPoint(x: width, y: 0))
        // Close path
        path.close()

        // Fill the shape
        UIColor.custom.setFill()
        // use custom color or UIColor(named: ...)
        path.fill()
    }
}
