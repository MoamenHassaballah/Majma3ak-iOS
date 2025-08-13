//
//  PreviousTicktCollectionViewCell.swift
//  maGmayApp
//
//  Created by ezz on 23/05/2025.
//

import UIKit

class PreviousTicktCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "PreviousTicktCollectionViewCell"

    @IBOutlet weak var numberTicket: UILabel!
    
    @IBOutlet weak var statusLbl: UILabel!
    
    @IBOutlet weak var lastReply: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    func configure(with contact : Contact){
        self.numberTicket.text = String(contact.id)
        self.statusLbl.text = contact.status
        self.dateLbl.text = extractDateOnlyForTicket(from: contact.createdAt)
        
    }

}
