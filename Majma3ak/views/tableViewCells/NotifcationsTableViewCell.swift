//
//  NotifcationsTableViewCell.swift
//  Majma3akMaintanceApp
//
//  Created by ezz on 09/07/2025.
//

import UIKit

class NotifcationsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var titlelbl: UILabel!
    @IBOutlet weak var contentlbl: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    static let identifier = "NotifcationsTableViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        parentView.layer.shadowColor = UIColor.black.cgColor
        parentView.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        parentView.layer.shadowOpacity = 0.1
        parentView.layer.shadowRadius = 10.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func configure(with notification : NotificationModel){
        self.titlelbl.text = notification.title
        self.contentlbl.text = notification.content
        if let date = formatDate(notification.sentAt) {
            self.dateLabel.text = date
        } else {
            self.dateLabel.isHidden = true
        }
    }

    
    func formatDate(_ dateString: String) -> String? {
        // Input formatter
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX") // Use POSIX for parsing
        
        // Parse the date
        guard let date = inputFormatter.date(from: dateString) else {
            return nil
        }
        
        // Output formatter with localization
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "dd MMMM yyyy, hh:mm a"
        outputFormatter.locale = Locale(identifier: UserProfile.shared.currentAppleLanguage())
        outputFormatter.timeZone = TimeZone.current // Uses device's timezone
        
        return outputFormatter.string(from: date)
    }
}
