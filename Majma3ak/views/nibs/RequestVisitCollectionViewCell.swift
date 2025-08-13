//
//  RequestVisitCollectionViewCell.swift
//  maGmayApp
//
//  Created by ezz on 18/05/2025.
//

import UIKit

class RequestVisitCollectionViewCell: UICollectionViewCell {
    
    
    static let identifier = "RequestVisitCollectionViewCell"

    @IBOutlet weak var nameVisitorlbl: UILabel!
    
    @IBOutlet weak var dateVisit: UILabel!
    
    @IBOutlet weak var timeVisit: UILabel!
    
    @IBOutlet weak var statusVisit: UILabel!
    
    @IBOutlet weak var cancelRequestView: UIStackView!
    
    var onCancelRequest : (()->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    func configure(with object : VisitRequest){
        nameVisitorlbl.text = object.visiterName
        dateVisit.text = object.visitDate
        timeVisit.text = object.visitTime
        statusVisit.text = object.status.loclize_
        
        cancelRequestView.isHidden = object.status != "pending"
        
    }
    
    @IBAction func onCancelClicked(_ sender: Any) {
        onCancelRequest?()
    }
    

}
