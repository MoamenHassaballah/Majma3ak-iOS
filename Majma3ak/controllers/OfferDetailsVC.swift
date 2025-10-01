//
//  OfferDetailsVC.swift
//  Majma3ak
//
//  Created by Moamen Hassaballah on 30/09/2025.
//

import UIKit
import Kingfisher

class OfferDetailsVC: UIViewController {
    
    @IBOutlet weak var offerImage: UIImageView!
    @IBOutlet weak var offerTitle: UILabel!
    @IBOutlet weak var offerDescription: UILabel!
    @IBOutlet weak var labelView: UIView!
    
    
    var imageUrl: String = ""
    var titleString: String = ""
    var descriptionString: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isHiddenNavigation = false
    }
    
    private func setupUI() {
        offerImage.contentMode = .scaleAspectFill
        if !imageUrl.isEmpty, let url = URL(string:imageUrl) {
            offerImage.kf.setImage(with: url)
        } else {
            offerImage.image = UIImage(named: "default-featured-image")
        }
        offerTitle.text = titleString
        offerDescription.text = descriptionString
        
        labelView.layer.shadowColor = UIColor.black.cgColor
        labelView.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        labelView.layer.shadowOpacity = 0.1
        labelView.layer.shadowRadius = 10.0
    }

    @IBAction func didTapBack(_ sender: Any) {
        self.pop()
    }
}
