//
//  RequestedDocumentCell.swift
//  Majma3ak
//
//  Created by Moamen Hassaballah on 11/11/2025.
//

import UIKit

class RequestedDocumentCell: UITableViewCell {
    
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var rejectionReason: UILabel!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    
    var onParentViewTapped: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        setupShadow()
        let tap = UITapGestureRecognizer(target: self, action: #selector(parentViewTapped))
        parentView.addGestureRecognizer(tap)
        parentView.isUserInteractionEnabled = true
    }

    func setupShadow() {
        parentView.layer.shadowColor = UIColor.black.cgColor
        parentView.layer.shadowOpacity = 0.15
        parentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        parentView.layer.shadowRadius = 4
        parentView.layer.masksToBounds = false
    }

    func configure(title: String, description: String, rejectionReason: String?, status: String) {
        titleLabel.text = title
        descriptionLabel.text = description
        statusLabel.text = status.loclize_
        
        switch status.lowercased() {
        case "rejected":
            statusView.backgroundColor = UIColor.systemRed
        case "approved":
            statusView.backgroundColor = UIColor.systemGreen
        case "pending":
            statusView.backgroundColor = UIColor.systemOrange
        default:
            statusView.backgroundColor = UIColor.lightGray
        }
        
        if let reason = rejectionReason, !reason.isEmpty {
            self.rejectionReason.isHidden = false
            self.rejectionReason.text = reason
        } else {
            self.rejectionReason.isHidden = true
        }
    }

    @objc private func parentViewTapped() {
        onParentViewTapped?()
    }

    
}
