//
//  LoginVC.swift
//  maGmayApp
//
//  Created by ezz on 13/05/2025.
import UIKit
import ProgressHUD
import BEMCheckBox

class LoginVC : UIViewController{
    
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var emailtxt: UITextField!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var passwordtxt: UITextField!
    
    @IBOutlet weak var hidePassword: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var indactor: UIActivityIndicatorView!
    private var isPasswordHidden = true
    @IBOutlet weak var rememberMe: BEMCheckBox!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        emailtxt.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        passwordtxt.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        indactor.isHidden  = true
        indactor.color = .white
        
        emailtxt.delegate = self
        
        passwordtxt.delegate = self
        
        emailtxt.returnKeyType = .next
        passwordtxt.returnKeyType = .done
        
        passwordtxt.isSecureTextEntry = true
        hidePassword.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        loadRemmberMe()
        
        indactor.hidesWhenStopped = true
        setBEMBox()
        loginBtn.setFont(name: "FFShamelFamily-SansOneBook", size: 15)

    }
    
    
    func setBEMBox(){
        rememberMe.onCheckColor = .customColorFont
        rememberMe.boxType = .square
        rememberMe.onAnimationType = .bounce
        rememberMe.offAnimationType = .bounce
    }
    
    
    
    @IBAction func didTapLoginByGoogle(_ sender: Any) {
        self.showAlert(title: "Alert!".loclize_, message: "Are you sure to change App Language? The application will turn off.plase relunch it again.".loclize_) {
              if(UserProfile.shared.currentAppleLanguage() == "en"){
                  UserProfile.shared.setAppleLAnguageTo(lang: "ar")
              }else{
                  UserProfile.shared.setAppleLAnguageTo(lang: "en")
              }
              exit(0)
              
          }
    }
    
    
    
    @IBAction func didTapLogin(_ sender: Any) {
        guard let email = emailtxt.text, !email.isEmpty else {
            ProgressHUD.image("email_required".loclize_, image: UIImage(systemName: "minus.circle.fill"))
            return
        }

        guard let password = passwordtxt.text, !password.isEmpty else {
            ProgressHUD.image("password_required".loclize_, image: UIImage(systemName: "minus.circle.fill"))
            return
        }

        // Start simulated progress
        var currentProgress: Double = 0.0
        ProgressHUD.progress("Logging in...".loclize_ + "0%", currentProgress)

        let progressTimer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { timer in
            currentProgress += 0.1
            let percent = Int(currentProgress * 100)
            ProgressHUD.progress("Logging in...".loclize_ + "\(percent)%", currentProgress)
            
            if currentProgress >= 0.9 {
                timer.invalidate() // Stop simulating, waiting for actual response
            }
        }
//"+964\(email)"
        WebService.shared.sendRequest(
            url: Request.login,
            params: [
                "phone":  "+964\(email)",
                "password": password
            ],
            method: .post,
            isAuth: false,
            responseType: LoginResponse.self
        ) { result in
            progressTimer.invalidate()
            ProgressHUD.dismiss()
            switch result {
            case .success(let data):
//                let user = data.data.user
                let token = data.data.token
                Helper.access_token = token
                UserDefaults.standard.set(token, forKey: "access_token")
                self.checkRemmberMe(email: email, password: password)

                let vc = UIStoryboard.mainStoryBoard.instantiateViewController(withIdentifier: "TabBarVC")
                vc.rootPush()
                ProgressHUD.succeed("Login successful".loclize_)

            case .failure(_):
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    ProgressHUD.failed("Something went wrong, please check your mobile number or password.".loclize_)
                }
            }
        }
    }

    
    @IBAction func didTapPushToRegister(_ sender: Any) {
        let vc = UIStoryboard.mainStoryBoard.instantiateViewController(withIdentifier: "RegisterVC") as? RegisterVC
        vc?.push()
    }
    
    @IBAction func didTapForgetPassword(_ sender: Any) {
        let vc = UIStoryboard.mainStoryBoard.instantiateViewController(withIdentifier: "SendOTPViewController") as? SendOTPViewController
        vc?.push()
    }
    
    @IBAction func HidePasswordBtn(_ sender: Any) {
            isPasswordHidden.toggle()
            passwordtxt.isSecureTextEntry = isPasswordHidden
            
            let imageName = isPasswordHidden ? "eye.slash" : "eye"
            hidePassword.setImage(UIImage(systemName: imageName), for: .normal)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.isHiddenNavigation = true
    }
    
    
}

extension LoginVC {
    func setupview(){
        
        
    }
    
    func setUpData(){
        
    }
    
    func localized(){
        
    }
    
    func fetchData(){
        
    }
    
    func loadRemmberMe(){
        if UserDefaults.standard.bool(forKey: "remember_me_checked") {
            emailtxt.text = UserDefaults.standard.string(forKey: "saved_phone")
            passwordtxt.text = UserDefaults.standard.string(forKey: "saved_password")
            rememberMe.setOn(true, animated: false)
        } else {
            rememberMe.setOn(false, animated: false)
        }

    }
    
    func checkRemmberMe(email : String , password : String){
        if self.rememberMe.on {
            UserDefaults.standard.set(email, forKey: "saved_phone")
            UserDefaults.standard.set(password, forKey: "saved_password")
            UserDefaults.standard.set(true, forKey: "remember_me_checked")
        } else {
            UserDefaults.standard.removeObject(forKey: "saved_phone")
            UserDefaults.standard.removeObject(forKey: "saved_password")
            UserDefaults.standard.set(false, forKey: "remember_me_checked")
        }

    }
    
    
}
extension LoginVC : UITextFieldDelegate {
    @objc func textFieldDidChange(_ textField: UITextField) {
        var targetView: UIView?
        
        switch textField {
        case emailtxt:
            targetView = emailView
        case passwordtxt:
            targetView = passwordView
        default:
            break
        }
        
        if let text = textField.text, !text.isEmpty {
            targetView?.layer.borderWidth = 1.0
            targetView?.layer.borderColor = UIColor.customColorFont.cgColor
//            targetView?.layer.cornerRadius = 8
        } else {
            targetView?.layer.borderWidth = 0
            targetView?.layer.borderColor = UIColor.clear.cgColor
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailtxt {
            passwordtxt.becomeFirstResponder()
        } else if textField == passwordtxt {
            passwordtxt.resignFirstResponder()  // يغلق الكيبورد عند الضغط على Done
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == emailtxt {
            guard let currentText = textField.text as NSString? else { return true }
                    let updatedText = currentText.replacingCharacters(in: range, with: string)
                    return updatedText.count <= 10
        }
        
        return true
    }
    
    
    
    
    
}
