//
//  offerCell.swift
//  Majma3ak
//
//  Created by ezz on 29/06/2025.
//

import UIKit
class OfferCell: UICollectionViewCell {

    static let identifier = "OfferCell"

    @IBOutlet weak var imageOffer: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()

        imageOffer.layer.cornerRadius = 10
        imageOffer.layer.masksToBounds = true

        self.contentView.layer.cornerRadius = 12
        self.contentView.layer.shadowColor = UIColor.orange.cgColor
        self.contentView.layer.shadowOpacity = 0.3
        self.contentView.layer.shadowOffset = CGSize(width: 0, height: 4)
        self.contentView.layer.shadowRadius = 6
        self.contentView.layer.masksToBounds = false
    }

//    func configuer(imageUrl: String) {
//        if let url = URL(string: imageUrl) {
//            print(url)
//            imageOffer.kf.setImage(with: url)
//        }
//    }
    
    func configuer(imageUrl: String) {
        // Placeholder image when image fails or is empty
        let placeholderImage = UIImage(named: "default-featured-image") // Add this image to your Assets

        // Check if imageUrl is empty or invalid
        guard let url = URL(string: imageUrl), !imageUrl.trimmingCharacters(in: .whitespaces).isEmpty else {
            imageOffer.image = placeholderImage
            return
        }

        // Use Kingfisher to download the image with a fallback image on failure
        imageOffer.kf.setImage(
            with: url,
            placeholder: placeholderImage,
            options: nil,
            completionHandler: { result in
                switch result {
                case .success(let value):
                    print("Loaded image: \(value.source.url?.absoluteString ?? "")")
                case .failure(let error):
                    print("Image load failed: \(error.localizedDescription)")
                    self.imageOffer.image = placeholderImage
                }
            }
        )
    }

}
