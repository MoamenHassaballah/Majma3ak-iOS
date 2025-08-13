//
//  CategoryCollectionViewCell.swift
//  maGmayApp
//
//  Created by ezz on 15/05/2025.
//

import UIKit

class StatusCell: UICollectionViewCell {
    static let identifier = "StatusCell"

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var underline: UIView!

    func configure(text: String, selected: Bool) {
        label.text = text
        label.textColor = selected ? UIColor(named: "CustomColorFont") : .darkGray
        underline.backgroundColor = selected ? UIColor(named: "CustomColor") : .clear
        label.font = selected ? UIFont(name: "FFShamelFamily-SansOneBold", size: 15) : UIFont(name: "FFShamelFamily-SansOneBook", size: 14)
    }
}



