//
//  NotifcationsTableViewCell.swift
//  Majma3akMaintanceApp
//
//  Created by ezz on 09/07/2025.
//

import UIKit

class NotifcationsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titlelbl: UILabel!
    @IBOutlet weak var contentlbl: UILabel!
    
    static let identifier = "NotifcationsTableViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func configure(with notification : NotificationModel){
        self.titlelbl.text = notification.title
        self.contentlbl.text = notification.content
    }

}
