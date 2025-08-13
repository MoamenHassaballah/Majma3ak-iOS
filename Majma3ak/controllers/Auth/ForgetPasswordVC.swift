//
//  ForgetPasswordVC.swift
//  maGmayApp
//
//  Created by ezz on 24/05/2025.
//

import UIKit
import ProgressHUD

class ForgetPasswordVC: UIViewController {

    @IBOutlet weak var emailPhonetxt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

  
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isHiddenNavigation = false
        self.navigationItem.hidesBackButton = true
    }
    @IBAction func didTapBackButton(_ sender: Any) {
        
        pop()
    }
    
    @IBAction func didTapLogin(_ sender: Any) {
        guard let emailPhone = emailPhonetxt.text , !emailPhone.isEmpty else {
            ProgressHUD.image("الإيميل مطلوب" ,image: UIImage(systemName: "envelope.badge"))
            return
        }
//        
//        WebService.shared.sendRequest(url: Request.forgotPassword,
//                                      params: [
//                                        "phone":emailPhone
//                                      ],
//                                      method: .post,
//                                      isAuth: false,
//                                      responseType: <#T##Decodable.Type#>,
//                                      completion: <#T##(Result<Decodable, any Error>) -> Void#>)
    }
    
    
}
