//
//  NotifcationsVC.swift
//  Majma3akMaintanceApp
//
//  Created by ezz on 09/07/2025.
//

import UIKit

class NotifcationsVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    var pushNotificationsArray : [NotificationModel] = []
    var smsNotificationsArray : [NotificationModel] = []
    var notificationSections : [String] = ["Push Notifications".loclize_, "SMS".loclize_]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        getNotifications()
//        loader.isHidden = true
        loader.hidesWhenStopped = true

    }
    
    @IBAction func didTapBack(_ sender: Any) {
        self.pop()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }

}

extension NotifcationsVC {
    func setUpTableView(){
        tableView.delegate = self
        tableView.dataSource = self
//        tableView.registerCell(type: NotifcationsTableViewCell.self)
        
        
    }
    
    func getNotifications(){
        loader.startAnimating()
        WebService.shared.sendRequest(url: Request.notifications + "per_page=10&page=1",
                                      method: .get,
                                      isAuth: true,
                                      responseType: NotifcationsResponse.self) { result in
            switch result {
            case .success(let success):
                let notifications = success.data.notifications
                DispatchQueue.main.async {
                    self.loader.stopAnimating()

                    let pushNotifications = notifications.filter({$0.channel == "push"})
                    let smsNotifications = notifications.filter({$0.channel != "push"})
                    
                    if self.pushNotificationsArray.isEmpty {
                        self.pushNotificationsArray = pushNotifications
                    } else {
                        self.pushNotificationsArray.append(contentsOf: pushNotifications)
                    }
                    
                    
                    if self.smsNotificationsArray.isEmpty {
                        self.smsNotificationsArray = smsNotifications
                    } else {
                        self.smsNotificationsArray.append(contentsOf: smsNotifications)
                    }
                    
                    self.tableView.reloadData()
                }
            case .failure(let failure):
                DispatchQueue.main.async {
                    self.loader.stopAnimating()

                }
                print(failure.localizedDescription)
            }
        }
        
        
        
        WebService.shared.sendRequest(url: Request.complextNotifications + "per_page=10&page=1",
                                      method: .get,
                                      isAuth: true,
                                      responseType: ComplexNotificationResponse.self) { result in
            switch result {
            case .success(let success):
                let notifications = success.data.data
                DispatchQueue.main.async {
                    self.loader.stopAnimating()

                    
                    let list = notifications.map { complexNotification in
                        NotificationModel(id: complexNotification.id, title: complexNotification.title, content: complexNotification.content, channel: complexNotification.channel, status: complexNotification.status, sentAt: complexNotification.sentAt ?? "", createdAt: complexNotification.createdAt ?? "", updatedAt: complexNotification.updatedAt ?? "")
                    }
                    
                    let pushNotifications = list.filter({$0.channel == "push"})
                    let smsNotifications = list.filter({$0.channel != "push"})
                    
                    if self.pushNotificationsArray.isEmpty {
                        self.pushNotificationsArray = pushNotifications
                    } else {
                        self.pushNotificationsArray.append(contentsOf: pushNotifications)
                    }
                    
                    
                    if self.smsNotificationsArray.isEmpty {
                        self.smsNotificationsArray = smsNotifications
                    } else {
                        self.smsNotificationsArray.append(contentsOf: smsNotifications)
                    }
                    
                    
                    self.tableView.reloadData()
                }
            case .failure(let failure):
                DispatchQueue.main.async {
                    self.loader.stopAnimating()

                }
                print("Error getting complex notifications: " , failure.localizedDescription)
            }
        }
    }
}



extension NotifcationsVC : UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        notificationSections[section]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        notificationSections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? pushNotificationsArray.count : smsNotificationsArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : NotifcationsTableViewCell = tableView.dequeueReusableCell(withIdentifier: NotifcationsTableViewCell.identifier, for: indexPath) as! NotifcationsTableViewCell
        let notification = indexPath.section == 0 ? pushNotificationsArray[indexPath.row] : smsNotificationsArray[indexPath.row]
        cell.configure(with: notification)
        return cell

        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        let notification = indexPath.section == 0 ? pushNotificationsArray[indexPath.row] : smsNotificationsArray[indexPath.row]
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NotificationDetailsVC") as? NotificationDetailsVC
        
        vc?.notification = notification
        
        vc?.push()
        
    }
    
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            header.textLabel?.applyCustomFont(14)
            header.textLabel?.numberOfLines = 0
            header.textLabel?.textColor = UIColor.darkGray
        }
    }
    
}
