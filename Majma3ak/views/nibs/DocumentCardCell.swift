//
//  DocumentCardCell.swift
//  Majma3ak
//
//  Created by Moamen Hassaballah on 04/11/2025.
//

import UIKit

class DocumentCardCell: UITableViewCell {
    
    
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var documentImage: UIImageView!
    @IBOutlet weak var documentDescription: UILabel!
    @IBOutlet weak var fileType: UILabel!
    @IBOutlet weak var documentType: UILabel!
    
    var onTap: (() -> Void)?

        override func awakeFromNib() {
            super.awakeFromNib()
            setupUI()
            setupGesture()
        }

        private func setupUI() {
            
            parentView.layer.shadowColor = UIColor.black.cgColor
            parentView.layer.shadowOpacity = 0.1
            parentView.layer.shadowOffset = CGSize(width: 0, height: 2)
            parentView.layer.shadowRadius = 6
            parentView.layer.masksToBounds = false

        }

        private func setupGesture() {
            let tap = UITapGestureRecognizer(target: self, action: #selector(parentTapped))
            parentView.isUserInteractionEnabled = true
            parentView.addGestureRecognizer(tap)
        }

        @objc private func parentTapped() {
            onTap?()
        }

    func configure(imageUrl: String?, description: String, type: String, documentType: String) {
            documentDescription.text = description
            fileType.text = type
        self.documentType.text = documentType

            if let urlString = imageUrl, let url = URL(string: urlString), type == "png" || type == "jpg" || type == "jpeg" {
                documentImage.kf.setImage(with: url)
            } else {
                documentImage.image = UIImage(named: "default-featured-image")
            }
        }

    
}
