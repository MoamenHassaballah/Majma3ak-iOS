//
//  NotificationDetailsVC.swift
//  Majma3ak
//
//  Created by Moamen Hassaballah on 01/10/2025.
//

import UIKit

class NotificationDetailsVC: UIViewController {
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var channelLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    var notification: NotificationModel? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        isHiddenNavigation = false
    }
    
    
    private func setupUI() {
        
        parentView.layer.shadowColor = UIColor.black.cgColor
        parentView.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        parentView.layer.shadowOpacity = 0.1
        parentView.layer.shadowRadius = 10.0
        
        if let notification = notification {
            print("Notification: \(notification)")
            titleLabel.text = notification.title
            descriptionLabel.text = notification.content
            dateLabel.text = "\("Sent At:".loclize_) \(notification.sentAt)"
            channelLabel.text = "\("Channel:".loclize_) \(notification.channel)"
            statusLabel.text = "\("Status:".loclize_) \(notification.status.loclize_)"
            
        }
    }
    
    
    @IBAction func didTapBack(_ sender: Any) {
        self.pop()
    }
    
}
