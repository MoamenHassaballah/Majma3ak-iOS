//
//  RegisterVC.swift
//  maGmayApp
//
//  Created by ezz on 13/05/2025.
//

import UIKit
import ProgressHUD
import BEMCheckBox
import DropDown

class RegisterVC: UIViewController, BEMCheckBoxDelegate  {

    @IBOutlet weak var nametxt: UITextField!
    
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var emailtxt: UITextField!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var mobiletxt: UITextField!
    
    @IBOutlet weak var mobileView: UIView!
    
    @IBOutlet weak var registerLoader: UIActivityIndicatorView!
    @IBOutlet weak var passwordtxt: UITextField!
    
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var passwordView: UIView!
    
    @IBOutlet weak var selectedLanguage: UITextField!
    @IBOutlet weak var selectedComplex: UITextField!
    
    @IBOutlet weak var chekStatus: BEMCheckBox!
    
    @IBOutlet weak var createButton: UIButton!
    
    @IBOutlet weak var sHPassword: UIButton!
    
    @IBOutlet weak var sHPassword2: UIButton!
    
    private var isPasswordHidden = true
    private var isConfiremPasswordHidden = true
    var complexes : [ComplexModel] = []
    var complexesDropDonw = DropDown()
    var selectedComplexId: Int?



    override func viewDidLoad() {
        super.viewDidLoad()
        emailtxt.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        mobiletxt.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        nametxt.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        passwordtxt.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        emailtxt.delegate = self
        mobiletxt.delegate = self
        nametxt.delegate = self
        passwordtxt.delegate = self
//        nametxt.text = "Izzdine Atallah"
//        mobiletxt.text = "+972592661816"
//        emailtxt.text = "ezzdine494@gmail.com"
//        passwordtxt.text = "123456789"
        chekStatus.onCheckColor = .customColorFont
        chekStatus.boxType = .square
        chekStatus.onAnimationType = .bounce
        chekStatus.offAnimationType = .bounce
        fetchComplext()
        complexesDropDonw.textFont = UIFont(name: "FFShamelFamily-SansOneBook", size: 14)!
        registerLoader.hidesWhenStopped = true
        
        let title = NSAttributedString(
            string: "Create an account".loclize_,
            attributes: [
                .font: UIFont(name: "FFShamelFamily-SansOneBook", size: 16)!,
                .foregroundColor: UIColor.white
            ]
        )
        self.createButton.setAttributedTitle(title, for: .normal)


    }
    
    
    func fetchComplext(){
        WebService.shared.sendRequest(url: Request.complexes,
                                      method: .get,
                                      isAuth: false,
                                      responseType: ComplexResponse.self) { result in
            switch result {
            case .success(let data):
                self.complexes = data.data
                self.complexesDropDonw.dataSource = self.complexes.map { $0.name }

                // Handle item selection
                self.complexesDropDonw.selectionAction = { [weak self] (index: Int, item: String) in
                    guard let self = self else { return }
                    let selectedComplex = self.complexes[index]
                    self.selectedComplex.text = selectedComplex.name
                    self.selectedComplexId = selectedComplex.id
                }

            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    
    func showTermsAlert() {
        if let alertVC = storyboard?.instantiateViewController(withIdentifier: "TermOfServiceAlertViewController") as? TermOfServiceAlertViewController {
            alertVC.modalPresentationStyle = .overFullScreen
            alertVC.modalTransitionStyle = .crossDissolve
            
            alertVC.onAgree = {agreed in
                self.chekStatus.setOn(agreed, animated: true)
            }
            present(alertVC, animated: true)
        }
    }
    
    @IBAction func sHPassword(_ sender: Any) {
        isPasswordHidden.toggle()
          passwordtxt.isSecureTextEntry = isPasswordHidden
          
          let imageName = isPasswordHidden ? "eye.slash" : "eye"
          sHPassword.setImage(UIImage(systemName: imageName), for: .normal)
        
    }
    
    
    @IBAction func sHPassword2(_ sender: Any) {
        isConfiremPasswordHidden.toggle()
        confirmPassword.isSecureTextEntry = isConfiremPasswordHidden
          
          let imageName = isConfiremPasswordHidden ? "eye.slash" : "eye"
          sHPassword2.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    @IBAction func didTapBack(_ sender: Any) {
        self.pop()
    }
    
    
    @IBAction func didTapRegister(_ sender: Any) {
        
        guard let fullName = nametxt.text, !fullName.isEmpty else {
            ProgressHUD.image("full_name_required".loclize_, image: UIImage(systemName: "minus.circle.fill"))
            return
        }
        
        guard let email = emailtxt.text, !email.isEmpty else {
            ProgressHUD.image("email_required".loclize_, image: UIImage(systemName: "minus.circle.fill"))
            return
        }
        
        guard isvalidateEmail(enteredEmail: email) else {
            ProgressHUD.image("invalid_email".loclize_, image: UIImage(systemName: "minus.circle.fill"))
            return
        }
        
        guard let mobileNumber = mobiletxt.text, !mobileNumber.isEmpty else {
            ProgressHUD.image("mobile_required".loclize_, image: UIImage(systemName: "minus.circle.fill"))
            return
        }
        
        guard let password = passwordtxt.text, !password.isEmpty else {
            ProgressHUD.image("password_required".loclize_, image: UIImage(systemName: "minus.circle.fill"))
            return
        }
        
        guard password.count >= 8 else {
            ProgressHUD.image("password_length".loclize_, image: UIImage(systemName: "minus.circle.fill"))
            return
        }
        
        guard password == confirmPassword.text else {
            ProgressHUD.image("Passwords do not match".loclize_, image: UIImage(systemName: "minus.circle.fill"))
            return
        }
        
        guard chekStatus.on else {
            ProgressHUD.image("agree_terms_required".loclize_, image: UIImage(systemName: "minus.circle.fill"))
            return
        }
        
        guard let lang = selectedLanguage.text, !lang.isEmpty else {
            ProgressHUD.image("Language required".loclize_, image: UIImage(systemName: "minus.circle.fill"))
            return
        }
        
        guard let complexId = selectedComplexId else {
            ProgressHUD.image("Complex required".loclize_, image: UIImage(systemName: "minus.circle.fill"))
            return
        }

        // Start simulated progress
        var currentProgress: Double = 0.0
        ProgressHUD.progress("Registering...".loclize_+"0%", currentProgress)

        // Timer to simulate progress
        let progressTimer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { timer in
            currentProgress += 0.1
            let percentage = Int(currentProgress * 100)
            ProgressHUD.progress("Registering...".loclize_+"\(percentage)%", currentProgress)
            
            if currentProgress >= 0.9 {
                timer.invalidate() // Stop simulating further. Leave room for real response.
            }
        }
        

        // Send registration request
        WebService.shared.sendRequest(
            url: Request.register,
            params: [
                "name": fullName,
                "email": email,
                "phone": "+964\(mobileNumber)",
                "locale": lang,
                "password": password,
                "password_confirmation": password,
                "residential_complex_id": complexId
            ],
            method: .post,
            isAuth: false,
            responseType: RegisterResponse.self
        ) { result in
            progressTimer.invalidate()  // stop the simulated timer
            ProgressHUD.dismiss{
                switch result {
                case .success(let data):
                    
                    ProgressHUD.succeed("Registration successful. Please verify your phone number.".loclize_)

                    let vc = UIStoryboard.mainStoryBoard.instantiateViewController(withIdentifier: "OTPVC") as? OTPVC
                    vc?.mobileNumber = data.data.user.phone
                    vc?.isRegister = true
                    vc?.push()

                case .failure(let error):
                    ProgressHUD.failed("There was a problem registering, check your internet and try again.".loclize_)
                    print("Registration failed: \(error.localizedDescription)")
                }
            } // clear progress HUD before showing result

            
            
            
        }
    }

    
    @IBAction func showDropDownLanguages(_ sender: UIButton){
        let alert = UIAlertController(title: "choose_language".loclize_, message: nil, preferredStyle: .actionSheet)
        let languages = ["ar" , "en" , "ku"]
        for language in languages {
            alert.addAction(UIAlertAction(title: language, style: .default, handler: { _ in
                self.selectedLanguage.text = language
                
            }))
        }
        alert.addAction(UIAlertAction(title: "cancel".loclize_, style: .cancel, handler: nil))

        // For iPad compatibility
        if let popover = alert.popoverPresentationController {
            popover.sourceView = sender
            popover.sourceRect = sender.bounds
        }

        present(alert, animated: true, completion: nil)
    }
    

    @IBAction func showComplexes(_ sender: Any) {
        complexesDropDonw.show()
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isHiddenNavigation = false
        self.navigationItem.hidesBackButton = false
    }
    
    @IBAction func didTapBackButton(_ sender: Any) {
        pop()
    }
    
    @IBAction func onClickTerms(_ sender: Any) {
//        let vc = UIStoryboard.mainStoryBoard.instantiateViewController(identifier: "TermsOfServiceVC") as? TermsOfServiceVC
//              vc?.push()
        
        
        
        showTermsAlert()
        
    }
    
    
    @IBAction func onCheckUpdate(_ sender: BEMCheckBox) {
        if sender.on {
            showTermsAlert()
        }
    }
    
    
    
}



extension RegisterVC : UITextFieldDelegate {
    @objc func textFieldDidChange(_ textField: UITextField) {
        var targetView: UIView?

        switch textField {
        case nametxt:
            targetView = nameView
        case emailtxt:
            targetView = emailView
        case mobiletxt:
            targetView = mobileView
        case passwordtxt:
            targetView = passwordView
        default:
            break
        }

        if let text = textField.text, !text.isEmpty {
            targetView?.layer.borderWidth = 1.0
            targetView?.layer.borderColor = UIColor(named: "CustomColor")?.cgColor ?? UIColor.orange.cgColor
            targetView?.layer.cornerRadius = 8
        } else {
            targetView?.layer.borderWidth = 0
            targetView?.layer.borderColor = UIColor.clear.cgColor
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nametxt {
            emailtxt.becomeFirstResponder()
        } else if textField == emailtxt {
            mobiletxt.becomeFirstResponder()
        }else if textField == mobiletxt {
            passwordtxt.becomeFirstResponder()
        }else if textField == passwordtxt {
            passwordtxt.resignFirstResponder()
        }
        return true
    }

    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == mobiletxt {
            guard let currentText = textField.text as NSString? else { return true }
                    let updatedText = currentText.replacingCharacters(in: range, with: string)
                    return updatedText.count <= 10
        }
        
        return true
    }

}

