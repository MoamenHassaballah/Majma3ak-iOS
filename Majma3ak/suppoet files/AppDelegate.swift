//
//  AppDelegate.swift
//  Majma3ak
//
//  Created by ezz on 07/06/2025.
//

import UIKit
import IQKeyboardManagerSwift
import IQKeyboardToolbar

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    static let shared = UIApplication.shared.delegate as? AppDelegate
    
    var rootNaviagtionController : MainNaigationController?



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
            IQKeyboardManager.shared.isEnabled = true
        IQKeyboardManager.shared.resignOnTouchOutside = true // 👈 This is the key line
//            IQKeyboardManager.shared.enableAutoToolbar = true // optional
//        if let savedToken = UserDefaults.standard.string(forKey: "access_token") {
//            print("Saved Token: \(savedToken)")
        
        if UserDefaults.standard.bool(forKey: "hasLaunchedBefore") == false {
              // أول مرة يُشغّل فيها التطبيق
              UserProfile.shared.setAppleLAnguageTo(lang: "ar")
              UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
              UserDefaults.standard.synchronize()
            exit(0)
          }
        
        UILabel.swizzleInit()

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

}

