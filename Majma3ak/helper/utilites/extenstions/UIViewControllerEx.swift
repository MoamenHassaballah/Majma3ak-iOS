//
//  UIViewControllerEx.swift
//  Majma3ak
//
//  Created by ezz on 07/06/2025.
//

import Foundation
import UIKit

extension UIViewController {
    var isHiddenNavigation: Bool{
        set{
            self.navigationController?.setNavigationBarHidden(newValue, animated: true)
        }
        get{
            return self.navigationController?.isNavigationBarHidden ?? false
        }
    }
    
    
    
    
    var topMostViewController : UIViewController?{
        if let navigationController = self as? UINavigationController {
            return navigationController.topViewController?.topMostViewController
        }else if let tabBarController = self as? UITabBarController {
            if let selectedViewController = tabBarController.selectedViewController{
                return selectedViewController.topMostViewController
            }
            return tabBarController.topMostViewController
        }else if let presentedViewController = self.presentedViewController{
            return presentedViewController.topMostViewController
        }
        else{
            return self
        }
    }
    func push(){
        AppDelegate.shared?.rootNaviagtionController?.pushViewController(self, animated: true)
    }
    func pop(){
        AppDelegate.shared?.rootNaviagtionController?.popViewController(animated: true)
    }
    func rootPush(){
        AppDelegate.shared?.rootNaviagtionController?.setViewControllers([self], animated: false)
    }
    func presentVC(){
        AppDelegate.shared?.rootNaviagtionController?.present(self, animated: true)
    }
    func safePerformSegue(withIdentifier identifier : String, sender:Any?){
        if canPerformSegue(identifier: identifier){
        self.performSegue(withIdentifier: identifier, sender: sender)
        }
    }
    func canPerformSegue(identifier: String) -> Bool {
          guard let identifiers = value(forKey: "storyboardSegueTemplates") as? [NSObject] else {
              return false
          }
          let canPerform = identifiers.contains { (object) -> Bool in
              if let id = object.value(forKey: "_identifier") as? String {
                  return id == identifier
              }else{
                  return false
              }
          }
          return canPerform
      }
    func showAlert(title : String? , message : String?,buttonTitle1 : String = "OK" , buttonTitle2:String = "Cancle", buttonAction1:@escaping(() -> Void),buttonAction2:(@escaping() -> Void)){
            let alert = UIAlertController(title:title, message: message, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: buttonTitle1, style: .default,handler: {action in
            buttonAction1()
        })
            let cancelAction = UIAlertAction(title: buttonTitle2, style: .destructive) { action in
                buttonAction2()
            }
            alert.addAction(cancelAction)
            alert.addAction(okayAction)
            self.present(alert, animated: true)
    }
    
    func showAlert(title : String? , message : String?,buttonTitle1 : String = "OK", buttonAction1:@escaping(() -> Void)){
            let alert = UIAlertController(title:title, message: message, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: buttonTitle1, style: .default,handler: {action in
            buttonAction1()
        })
            alert.addAction(okayAction)
            self.present(alert, animated: true)
    }
    
    func showErrorMessage(message : String?){
        let alert = UIAlertController(title:"Warrining", message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Ok", style: .destructive) { action in
            
        }
        
        alert.addAction(cancelAction)
       self.present(alert, animated: true)
    }
    
//    var sideMenu : LGSlideMenuViewController? {
//        return AppDelegate.shared?.rootNaviagtionController?.viewControllers.first as? LGSlideMenuViewController
//        // First Item LGSlideMenuViewController
//    }
    
    func showAlertWithCancel(title: String, message: String, okAction: String = "Ok".loclize_ , completion: ((UIAlertAction) -> Void)? = nil ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: okAction, style: .default, handler: completion))
        alert.addAction(UIAlertAction(title: "Cancel".loclize_, style: .cancel))
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}
