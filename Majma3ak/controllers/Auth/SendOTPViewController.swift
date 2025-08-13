//
//  PaddedTextField.swift
//  Majma3akMaintanceApp
//
//  Created by ezz on 10/07/2025.
//


import UIKit
import ProgressHUD

class SendOTPViewController: UIViewController {

    // MARK: - UI Properties
    
    
    @IBOutlet weak var mobiletNumberxt: UITextField!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var sendBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loader.isHidden = true
        self.loader.hidesWhenStopped = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.isHiddenNavigation = false
    }
    
    @IBAction func didTapBack(_ sender: Any) {
        self.pop()
    }
    
    @IBAction func submitButtonTaped(_ sender: Any) {
        sendBtn.setTitle("", for: .normal)
        loader.startAnimating()
        guard let mobileNumber = mobiletNumberxt.text , !mobileNumber.isEmpty else {
            ProgressHUD.image("mobile_required".loclize_ ,image: UIImage(systemName: "minus.circle.fill"))
            return
        }
        
        guard isValidInternationalPhoneNumber(mobileNumber) else {
            ProgressHUD.image("invalid_mobile".loclize_ ,image: UIImage(systemName: "minus.circle.fill"))
            return
        }
        
        
        WebService.shared.sendRequest(url: Request.forgotPassword,
                                      params: [
                                        "phone":mobileNumber
                                      ],
                                      method: .post,
                                      isAuth: false,
                                      responseType: APIResponse<[Empty]>.self) { result in
            switch result {
            case .success(let success):
                self.loader.stopAnimating()
                self.sendBtn.setTitle("send request to reset the password".loclize_, for: .normal)

                ProgressHUD.success("Password reset OTP sent successfully".loclize_,
                                    image: UIImage(systemName: "envelope.circle.fill"))
                let vc = UIStoryboard.mainStoryBoard.instantiateViewController(identifier: "OTPVC") as? OTPVC
                vc?.mobileNumber = mobileNumber
                vc?.push()
            
            case .failure(let failure):
                self.sendBtn.setTitle("send request to reset the password".loclize_, for: .normal)
                self.loader.stopAnimating()
                print(failure.localizedDescription)
            }
        }
    }
    
    
    // MARK: - Actions (placeholders)
    /*
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func submitButtonTapped() {
        guard let email = emailTextField.text, !email.isEmpty else {
            print("Email field is empty.")
            return
        }
        print("Submit button tapped. Email: \(email)")
    }
    
    @objc private func loginPromptTapped() {
        print("Login prompt tapped")
        // Navigate to the login screen
    }
    */
}
