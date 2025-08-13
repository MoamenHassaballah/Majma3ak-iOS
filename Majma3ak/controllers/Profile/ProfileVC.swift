//
//  ProfileVC.swift
//  maGmayApp
//
//  Created by ezz on 16/05/2025.
//

import UIKit

class ProfileVC: UIViewController {
    
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var personalImage: UIImageView!
    
    
    @IBOutlet weak var logoutBtn: UIButton!
    @IBOutlet weak var emailLbl: UILabel!
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var phoneLbl: UILabel!
    
    @IBOutlet weak var loader: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setUpData()
        localized()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchData()
    }
    
    @IBOutlet weak var MainStack: UIStackView!
    
    @IBAction func didTapLogOut(_ sender: Any) {
        let art = UIAlertController(title: "", message: "Do you want to log out?".loclize_
                                    , preferredStyle: UIAlertController.Style.alert)
        let cancel = UIAlertAction(title: "No".loclize_, style: UIAlertAction.Style.default, handler: nil)
        let ok = UIAlertAction(title: "Yes".loclize_, style: UIAlertAction.Style.default) { (UIAlertAction) in
            
            UserDefaults.standard.removeObject(forKey: "access_token")
            let vc = UIStoryboard.mainStoryBoard.instantiateViewController(withIdentifier: "LoginVC")
            vc.rootPush()
            
            
        }
        art.addAction(cancel)
        art.addAction(ok)
        present(art, animated: true, completion: nil)

    }
    
        
        @IBAction func didTapChangeLanguage(_ sender: Any) {
            handleLanguageChange()
    }
    
    @IBAction func didTapGoToEditPRofile(_ sender: Any) {
        let vc = UIStoryboard.mainStoryBoard.instantiateViewController(withIdentifier: "EditProfileVC") as? EditProfileVC
        vc?.push()
    }
    func restartApp() {
        guard let scene = UIApplication.shared.connectedScenes.first,
              let sceneDelegate = scene.delegate as? UIWindowSceneDelegate,
              let window = sceneDelegate.window else {
            return
        }

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        window?.rootViewController = storyboard.instantiateInitialViewController()
        UIView.transition(with: window!,
                          duration: 0.5,
                          options: [.transitionCrossDissolve],
                          animations: {},
                          completion: nil)
    }
    
    
}



private var bundleKey: UInt8 = 0

extension Bundle {
    class func setLanguage(_ language: String) {
        object_setClass(Bundle.main, PrivateBundle.self)
        objc_setAssociatedObject(Bundle.main, &bundleKey, Bundle(path: Bundle.main.path(forResource: language, ofType: "lproj")!), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}

private class PrivateBundle: Bundle, @unchecked Sendable {
    override func localizedString(forKey key: String, value: String?, table tableName: String?) -> String {
        let bundle = objc_getAssociatedObject(self, &bundleKey) as? Bundle ?? Bundle.main
        return bundle.localizedString(forKey: key, value: value, table: tableName)
    }
}




extension ProfileVC {
    func setupView(){
        self.MainStack.isHidden = true
        self.loader.startAnimating()
        setShadowViews()
        let backItem = UIBarButtonItem()
        backItem.title = "" // ✅ إخفاء النص
        navigationItem.backBarButtonItem = backItem
        
        
        
    }
    func setUpData(){
        
    }
    func fetchData(){
        fetchUserData()
        
    }
    func localized(){
        
    }
    
    
    func setShadowViews() {
        
        mainView?.layer.shadowColor = UIColor.black.cgColor
        mainView?.layer.shadowOpacity = 0.1
        mainView?.layer.shadowOffset = CGSize(width: 0, height: 4)
        mainView?.layer.shadowRadius = 8
        mainView?.layer.cornerRadius = 20
        mainView?.layer.masksToBounds = false
        
    }
}

extension ProfileVC {
    func fetchUserData(){
        
        
        
        WebService.shared.sendRequest(url: Request.getProfileData,
                                      method: .get,
                                      isAuth: true,
                                      responseType: ProfileResponse.self) { result in
            switch result {
            case .success(let success):
                let user = success.data
                print("userData: ", user)
                //MARK: -  Get User Data
                self.loader.isHidden = true
                self.MainStack.isHidden = false
                self.nameLbl.text = user.name
                self.emailLbl.text = user.email
                self.phoneLbl.text = user.phone
                if let profilePic = user.profilePciture, !profilePic.isEmpty {
                    self.personalImage.kf.setImage(with: URL(string: "\(Request.baseUrl)\(profilePic)")!)
                }
//                self.nameLbl.text = user.
                
            case .failure(let failure):
                print(failure.localizedDescription)
                
            }
        }
       
    }
    
    func handleLanguageChange() {
        let alert = UIAlertController(title: "Select Language".loclize_, message: nil, preferredStyle: .actionSheet)
        
        let supportedLanguages = ["en", "ar", "ku"]
        let displayNames = ["English", "العربية", "کوردی"]

        for (index, langCode) in supportedLanguages.enumerated() {
            let langName = displayNames[index]
            let action = UIAlertAction(title: langName, style: .default) { _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.confirmLanguageChange(to: langCode, displayName: langName)
                }
            }
            alert.addAction(action)
        }
        
        alert.addAction(UIAlertAction(title: "Cancel".loclize_, style: .cancel))
        self.present(alert, animated: true)
    }
    
    func confirmLanguageChange(to langCode: String, displayName: String) {
        
        
        guard let window = UIApplication.shared.currentKeyWindow else { return }

//        let currentLang = UserProfile.shared.currentAppleLanguage()
//        guard currentLang != langCode else { return } // No need to change if same

        self.showAlertWithCancel(
            title: "Change language to".loclize_ + " \(displayName)",
            message: "Must Restart app to change the language".loclize_,
            okAction: "Ok".loclize_
        ) { _ in
            UserProfile.shared.setAppleLAnguageTo(lang: langCode)

            // MOLH.reset() // if you're using MOLH

            window.makeKeyAndVisible()
            UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                exit(EXIT_SUCCESS)
            }
        }
    }
}
