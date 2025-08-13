
import UIKit

class MainNaigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        localized()
        fetchData()
        setupData()

        // Do any additional setup after loading the view.
    }
    

}

extension MainNaigationController {
    func setupView(){
        AppDelegate.shared?.rootNaviagtionController = self
        setRoot()
        if #available(iOS 15, *){
            let appernce = UINavigationBarAppearance()
            appernce.configureWithOpaqueBackground()
            appernce.backgroundColor = "#FFFFFF".color_
            appernce.shadowColor = .clear
            appernce.titleTextAttributes = [NSAttributedString.Key.foregroundColor : "#1B1D28".color_, NSAttributedString.Key.font : UIFont.init(name: "FFShamelFamily-SansOneBold", size: 18)]
            self.navigationBar.standardAppearance = appernce
            self.navigationBar.scrollEdgeAppearance = appernce
            self.navigationItem.backButtonTitle = ""
            
        }else {
            self.navigationBar.setBackgroundImage(UIImage(), for: .default)
            self.navigationBar.isTranslucent = false
            self.navigationBar.barTintColor = "#FFFFFF".color_
            self.navigationBar.backgroundColor = "#FFFFFF".color_
            self.navigationItem.backButtonTitle = ""
            self.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : "#1B1D28".color_, NSAttributedString.Key.font : UIFont.init(name: "FFShamelFamily-SansOneBold", size: 18)]
        }
        self.navigationBar.tintColor = .customColorFont
        
        
    }
    func localized(){
        
    }
    func fetchData(){
        
    }
    func setupData(){
        
    }
}
extension MainNaigationController {
    func setRoot(){
        //not found navigation for NavgationController
        //this vc is first item in stack
        if let savedToken = UserDefaults.standard.string(forKey: "access_token") {
            //            print("Saved Token: \(savedToken)")
            let vc = UIStoryboard.mainStoryBoard.instantiateViewController(withIdentifier: "TabBarVC")
            vc.rootPush()
            Helper.access_token = savedToken
            print("Token => \(savedToken)")
        }else  {
            
            let vc = UIStoryboard.mainStoryBoard.instantiateViewController(identifier: "LoginVC")
            vc.rootPush()
        }
    }
}
