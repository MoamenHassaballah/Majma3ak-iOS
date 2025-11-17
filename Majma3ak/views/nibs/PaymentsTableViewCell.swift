//
//  PaymentsTableViewCell.swift
//  Majma3ak
//
//  Created by Moamen Hassaballah on 12/08/2025.
//

import UIKit

class PaymentsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var invoiceNumber: UILabel!
    @IBOutlet weak var invoiceAmount: UILabel!
    @IBOutlet weak var invoiceDescription: UILabel!
    @IBOutlet weak var invoiceState: UILabel!
    @IBOutlet weak var invoiceDate: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        parentView.layer.shadowColor = UIColor.black.cgColor
        parentView.layer.shadowOpacity = 0.1
        parentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        parentView.layer.shadowRadius = 6
        parentView.layer.masksToBounds = false
        
    }
    
    
    func configure(data: PaymentData) {
        
        invoiceNumber.text = data.id != nil ? "\(data.id!)" : "N/A"
        invoiceAmount.text = "\(data.amount ?? "") \("IQD".loclize_)"
        invoiceDescription.text = data.description ?? ""
        invoiceState.text = data.status != nil ? "\(data.status!.loclize_)" : "N/A"
        invoiceDate.text = data.payment_date ?? "N/A"
        
    }
}
