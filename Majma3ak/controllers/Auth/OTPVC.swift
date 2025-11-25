//
//  OTPViewController.swift
//  Majma3akMaintanceApp
//
//  Created by ezz on 09/07/2025.
//


import UIKit
import ProgressHUD

class OTPVC  : UIViewController  {
    
    var resendTimer: Timer?
    var remainingSeconds: Int = 180
    let countdownLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont(name: "FFShamelFamily-SansOneBook", size: 14)
        label.textColor = .gray
        label.isHidden = true
        return label
    }()
    
    
    // MARK: - UI Elements
    
    
    var mobileNumber : String? = ""
    var isRegister : Bool? = false

    
    let titleLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Enter the code sent to your phone".loclize_
        label.font = UIFont(name: "FFShamelFamily-SansOneBook", size: 14)
        label.textAlignment = .center
        
        return label
    }()
    
    var otpTextFields: [UITextField] = []
    
    lazy var verifyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Verify".loclize_, for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.setFont(name: "FFShamelFamily-SansOneBold", size: 14)
        button.addTarget(self, action: #selector(verifyTapped), for: .touchUpInside)
        return button
    }()
    
    let resendLabel: UILabel = {
        let label = UILabel()
        label.text = "Didn't receive the code? Resend".loclize_
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        label.font = UIFont(name: "FFShamelFamily-SansOneBook", size: 14)
        label.isUserInteractionEnabled = true // Important

        return label
    }()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        resendLabel.isHidden = true
        countdownLabel.isHidden = false
        startResendCountdown()
        
        setupViews()
        // Add tap gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleResendTap))
        resendLabel.addGestureRecognizer(tapGesture)
        print("Mobile Number:=\(mobileNumber ?? "")")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        otpTextFields.first?.becomeFirstResponder()
    }
    
    @IBAction func didTapBack(_ sender: Any) {
        self.pop()
    }
    
    

    // Selector method
    @objc func handleResendTap() {
        
        guard resendLabel.isUserInteractionEnabled else { return }
        
        guard let phone = mobileNumber else {
            print("Mobile number is nil")
            return
        }
        
        // Implement your resend logic here
        
        if(isRegister == true){
            WebService.shared.sendRequest(url: Request.resendVerificationOtp,
                                          params: [
                                            "phone":phone
                                          ],
                                          method: .post,
                                          isAuth: false,
                                          responseType: APIResponse<[Empty]>.self) { result in
                switch result {
                case .success(_):
    //                self.loader.stopAnimating()

                    ProgressHUD.success("OTP sent successfully".loclize_,
                                        image: UIImage(systemName: "envelope.circle.fill"))
                    
                
                case .failure(let failure):
                    ProgressHUD.failed("The code was not sent, please try again.".loclize_)
                    print(failure.localizedDescription)
                }
            }
        } else {
            WebService.shared.sendRequest(url: Request.resendVerificationOtp,
                                          params: [
                                            "phone":phone
                                          ],
                                          method: .post,
                                          isAuth: false,
                                          responseType: APIResponse<[Empty]>.self) { result in
                switch result {
                case .success(_):
    //                self.loader.stopAnimating()

                    ProgressHUD.success("Password reset OTP sent successfully".loclize_,
                                        image: UIImage(systemName: "envelope.circle.fill"))
                    
                
                case .failure(let failure):
                    ProgressHUD.failed("The code was not sent, please try again.".loclize_)
                    print(failure.localizedDescription)
                }
            }
            print("Resend tapped")
        }
        
        remainingSeconds = 180
        startResendCountdown()
        
    }


    
    // MARK: - Setup
    
    func setupViews() {
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        let stackView = UIStackView()
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.semanticContentAttribute = .forceLeftToRight
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        for _ in 0..<6 {
            let textField = createOTPTextField()
            otpTextFields.append(textField)
            stackView.addArrangedSubview(textField)
        }
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 50),
            stackView.widthAnchor.constraint(equalToConstant: 300)
        ])
        
        view.addSubview(verifyButton)
        verifyButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            //verifyButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 30),
            verifyButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            verifyButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            verifyButton.widthAnchor.constraint(equalToConstant: 150),
            verifyButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        view.addSubview(resendLabel)
        resendLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            resendLabel.topAnchor.constraint(equalTo: verifyButton.bottomAnchor, constant: 20),
            resendLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        view.addSubview(countdownLabel)
        countdownLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            countdownLabel.topAnchor.constraint(equalTo: verifyButton.bottomAnchor, constant: 20),
            countdownLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func createOTPTextField() -> UITextField {
        let textField = UITextField()
        textField.keyboardType = .numberPad
        textField.textAlignment = .center
        textField.font = UIFont.systemFont(ofSize: 20)
        textField.borderStyle = .roundedRect
        textField.semanticContentAttribute = .forceLeftToRight

        textField.delegate = self
        return textField
    }
    
    // MARK: - Actions
    
    @objc func verifyTapped() {
        let code = otpTextFields.compactMap { $0.text }.joined()
        
        guard let phone = mobileNumber else {
            print("Mobile number is nil")
            return
        }

        

        // Show loading indicator
        //ProgressHUD.load()
        ProgressHUD.progress("loading..".loclize_, 0.5)
        
        if(isRegister == true){
            print("Registration: Entered OTP: \(code), phone: \(phone)")
            WebService.shared.sendRequest(url: Request.verifyPhone,
                                          params: [
                                            "phone": phone,
                                            "otp": code
                                          ],
                                          method: .post,
                                          isAuth: false,
                                          responseType: VerifiedOtpResponse.self) { result in
                switch result {
                case .success(_):
//                    self.loader.stopAnimating()

                    ProgressHUD.success("OTP sent successfully".loclize_,
                                        image: UIImage(systemName: "envelope.circle.fill"))
                    let vc = UIStoryboard.mainStoryBoard.instantiateViewController(withIdentifier: "LoginVC" ) as? LoginVC
                    vc?.rootPush()
                case .failure(let failure):
                    ProgressHUD.failed("The code was not sent, please try again.".loclize_)
                    print(failure.localizedDescription)
                }
            }
        }
        else {
            
            print("Password Reset: Entered OTP: \(code), phone: \(phone)")
            
            WebService.shared.sendRequest(
                url: Request.verifyResetOtp,
                params: [
                    "phone": phone,
                    "otp": code
                ],
                method: .post,
                isAuth: false,
                responseType: APIResponse<[Empty]>.self
            ) { result in
                // Hide loader on response
                ProgressHUD.dismiss()

                switch result {
                case .success(let success):
                    print("OTP Verified: \(success)")
                    let vc = UIStoryboard.mainStoryBoard.instantiateViewController(identifier: "NewPasswordVC") as? NewPasswordVC
                    vc?.phone = phone
                    vc?.otp = code
                    vc?.push()
                    // Proceed to next step in app flow (e.g., push next screen)
                    
                case .failure(let failure):
                    print("Verification failed: \(failure.localizedDescription)")
                    // Optionally show error message
                    ProgressHUD.failed("Invalid OTP. Please try again.")
                }
            }
        }

   
    }
    
    func startResendCountdown() {
        updateCountdownLabel()
        countdownLabel.isHidden = false
        resendLabel.isHidden = true
        resendLabel.isUserInteractionEnabled = false
        resendTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCountdown), userInfo: nil, repeats: true)
    }

    @objc func updateCountdown() {
        remainingSeconds -= 1
        updateCountdownLabel()
        if remainingSeconds <= 0 {
            resendTimer?.invalidate()
            resendTimer = nil
            countdownLabel.isHidden = true
            resendLabel.isHidden = false
            resendLabel.isUserInteractionEnabled = true
        }
    }

    func updateCountdownLabel() {
        let minutes = remainingSeconds / 60
        let seconds = remainingSeconds % 60
        countdownLabel.text = String(format: "resend_code_timer".loclize_, minutes, seconds)
    }

}

// MARK: - UITextFieldDelegate

extension OTPVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard textField.text != nil else { return false }
        
        // إذا تم الضغط على زر الحذف
        if string.isEmpty {
            textField.text = ""
            if let prevIndex = otpTextFields.firstIndex(of: textField), prevIndex > 0 {
                otpTextFields[prevIndex - 1].becomeFirstResponder()
            }
            return false
        }

        // فقط حرف واحد مسموح به
        if string.count == 1 {
            textField.text = string

            // الانتقال للخانة التالية من اليسار إلى اليمين
            if let currentIndex = otpTextFields.firstIndex(of: textField), currentIndex < otpTextFields.count - 1 {
                otpTextFields[currentIndex + 1].becomeFirstResponder()
            } else {
                textField.resignFirstResponder()
            }

            return false
        }

        return false
    }

}

