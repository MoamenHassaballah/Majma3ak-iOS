//
//  NewPasswordVC.swift
//  Majma3akMaintanceApp
//
//  Created by ezz on 11/07/2025.
//


import UIKit
import ProgressHUD

class NewPasswordVC: UIViewController {
    
    var phone: String? // Set this before pushing the view controller
    var otp : String?
    
    private let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter new password".loclize_
        tf.isSecureTextEntry = true
        tf.borderStyle = .roundedRect
        tf.font = UIFont(name: "FFShamelFamily-SansOneBook", size: 14)
        return tf
    }()
    
    private let confirmPasswordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Confirm new password".loclize_
        tf.isSecureTextEntry = true
        tf.borderStyle = .roundedRect
        tf.font = UIFont(name: "FFShamelFamily-SansOneBook", size: 14)

        return tf
    }()
    
    private let resetButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Reset Password".loclize_, for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.setFont(name: "FFShamelFamily-SansOneBook", size: 16)
        button.addTarget(self, action: #selector(resetTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Reset Password".loclize_
        view.backgroundColor = .white
        setupLayout()
    }
    
    @IBAction func didTapBack(_ sender: Any) {
        self.pop()
    }
    
    
    // MARK: - Actions
    @objc func resetTapped() {
        
        guard let phone = phone else {
                  print("Mobile number is nil")
                  return
              }
        
        guard let otpCode = otp else {
                  print("Mobile number is nil")
                  return
              }
        guard let newPassword = passwordTextField.text, !newPassword.isEmpty,
              let confirmPassword = confirmPasswordTextField.text, !confirmPassword.isEmpty else {
            ProgressHUD.failed("Please fill in all fields".loclize_)
            return
        }
        
        guard newPassword == confirmPassword else {
            ProgressHUD.failed("Passwords do not match".loclize_)
            return
        }
        
        ProgressHUD.load()
        
        // Make your API call here
        WebService.shared.sendRequest(url: Request.resetPassword,
                                      params: [
                                        "phone": phone,
                                        "otp":otpCode,
                                        "password": newPassword,
                                        "password_confirmation":confirmPassword,
                                        
                                      ],
                                      method: .post,
                                      isAuth: false,
                                      responseType: APIResponse<[Empty]>.self) { result in
            ProgressHUD.dismiss()
            switch result {
            case .success(_):
                ProgressHUD.success("Password reset successfully".loclize_)
                // Navigate to login or home
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    self.navigationController?.popToRootViewController(animated: true)
                }
            case .failure(let error):
                ProgressHUD.failed("Error: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Layout
    func setupLayout() {
        view.addSubview(passwordTextField)
        view.addSubview(confirmPasswordTextField)
        view.addSubview(resetButton)
        
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        confirmPasswordTextField.translatesAutoresizingMaskIntoConstraints = false
        resetButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            passwordTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            passwordTextField.heightAnchor.constraint(equalToConstant: 44),
            
            confirmPasswordTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            confirmPasswordTextField.leadingAnchor.constraint(equalTo: passwordTextField.leadingAnchor),
            confirmPasswordTextField.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor),
            confirmPasswordTextField.heightAnchor.constraint(equalToConstant: 44),
            
            resetButton.topAnchor.constraint(equalTo: confirmPasswordTextField.bottomAnchor, constant: 30),
            resetButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            resetButton.widthAnchor.constraint(equalToConstant: 180),
            resetButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
