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
    @IBOutlet weak var invoiceState: UILabel!
    @IBOutlet weak var invoiceDate: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    func configure(data: PaymentData) {
        
        invoiceNumber.text = data.id != nil ? "\(data.id!)" : "N/A"
        invoiceAmount.text = "\(data.installment_amount ?? "") \("IQD".loclize_)"
        invoiceState.text = data.status != nil ? "\(data.status!.loclize_)" : "N/A"
        invoiceDate.text = data.created_at ?? "N/A"
        
    }
}
