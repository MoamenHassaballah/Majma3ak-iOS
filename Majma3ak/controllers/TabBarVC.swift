//
//  TabBarVC.swift
//  maGmayApp
//
//  Created by ezz on 16/05/2025.
//

import UIKit

class TabBarVC: UIViewController , HomeVCDelegate, MoreVCDelegate {
    
    @IBOutlet weak var listImage: UIImageView!
    
    @IBOutlet weak var listlbl: UILabel!
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var profilelbl: UILabel!
    
    @IBOutlet weak var homeImage: UIImageView!
    
    @IBOutlet weak var homelbl: UILabel!
    var selectedTab: Int = 1


    @IBOutlet weak var listButton: UIButton!
    
    @IBOutlet weak var profileButton: UIButton!
    
    @IBOutlet weak var homeButton: UIButton!
    
    override var childForStatusBarStyle: UIViewController? {
        return currentVC
    }

    override var childForStatusBarHidden: UIViewController? {
        return currentVC
    }

    
    
    var currentVC: UIViewController?

    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        let home = storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        switchToViewController(home)
        updateTabBarColors()
        
        
        
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.isHiddenNavigation = true
    }

    
    func switchToViewController(_ vc: UIViewController) {
        // إزالة القديم
        if let current = currentVC {
            current.willMove(toParent: nil)
            current.view.removeFromSuperview()
            current.removeFromParent()
        }
        
        // If the new view controller is a HomeVC, set its delegate
         if let homeVC = vc as? HomeVC {
             homeVC.delegate = self
         }
        
        if let MoreVC = vc as? MoreVC {
            MoreVC.delegate = self
        }

        // إضافة الجديد
        addChild(vc)
        vc.view.frame = contentView.bounds
        contentView.addSubview(vc.view)
        vc.didMove(toParent: self)
        currentVC = vc
    }

    @IBAction func onClickedTab(_ sender: UIButton) {
        let tag = sender.tag
        selectedTab = tag
       updateTabBarColors()

        switch tag {
        case 1:
            guard let home = storyboard?.instantiateViewController(withIdentifier: "HomeVC") as? HomeVC else { return }
            switchToViewController(home)
            
        case 2:
            guard let profile = storyboard?.instantiateViewController(withIdentifier: "ProfileVC") as? ProfileVC else { return }
            switchToViewController(profile)
            
        default:
            guard let more = storyboard?.instantiateViewController(withIdentifier: "MoreVC") as? MoreVC else { return }
            switchToViewController(more)
        }
    }
    
    func updateTabBarColors() {
        let selectedColor = UIColor.customColorFont
        let defaultColor = UIColor.white

        // Reset all to default
        homelbl.textColor = defaultColor
        homeImage.tintColor = defaultColor

        profilelbl.textColor = defaultColor
        profileImage.tintColor = defaultColor

        listlbl.textColor = defaultColor
        listImage.tintColor = defaultColor

        // Highlight selected
        switch selectedTab {
        case 1:
            homelbl.textColor = selectedColor
            homeImage.tintColor = selectedColor
        case 2:
            profilelbl.textColor = selectedColor
            profileImage.tintColor = selectedColor
        case 3:
            listlbl.textColor = selectedColor
            listImage.tintColor = selectedColor
        default:
            break
        }
    }
    
    // MARK: - HomeVCDelegate
    func didSwipeToProfile() {
        // Switch to the Profile tab
        guard let profile = storyboard?.instantiateViewController(withIdentifier: "ProfileVC") as? ProfileVC else { return }
        selectedTab = 2 // Set the tag for the profile tab
        updateTabBarColors()
        switchToViewController(profile)
    }
    
    
//    // MARK: - MoreVCDelegate
//    func didSwipeToProfile() {
//        // Switch to the Profile tab
//        guard let profile = storyboard?.instantiateViewController(withIdentifier: "MoreVC") as? MoreVC else { return }
//        selectedTab = 2 // Set the tag for the profile tab
//        updateTabBarColors()
//        switchToViewController(profile)
//    }



}
