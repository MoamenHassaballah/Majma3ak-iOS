//
//  RequestCollectionViewCell.swift
//  maGmayApp
//
//  Created by ezz on 15/05/2025.
//

import UIKit

class RequestCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "RequestCollectionViewCell"
    
    @IBOutlet weak var requestlbl: UILabel!
    
    @IBOutlet weak var requestTypelbl: UILabel!
    
    @IBOutlet weak var requestDatelbl: UILabel!
    
    @IBOutlet weak var cancelRequest: UIButton!
    
    @IBOutlet weak var cancelRequestView: UIStackView!
    var onCancelRequest : (() -> Void)?
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(object : MaintenanceRequest){
        self.requestlbl.text = object.title
        self.requestTypelbl.text = object.maintenanceDepartment?.name?.loclize_ ?? ""
        self.requestDatelbl.text = extractDateOnly(from: object.createdAt ?? "")
        
        self.cancelRequestView.isHidden = !(object.status?.lowercased() == "waiting")
    }

    @IBAction func onCancelRequest(_ sender: Any) {
        onCancelRequest?()
    }
}


