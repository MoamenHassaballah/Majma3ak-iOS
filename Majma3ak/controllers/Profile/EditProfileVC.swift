//
//  EditProfileVC.swift
//  Majma3ak
//
//  Created by ezz on 04/07/2025.
//

import UIKit
import ProgressHUD

class EditProfileVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var personalImage: UIImageView!
    @IBOutlet weak var nametxt: UITextField!
    @IBOutlet weak var emailtxt: UITextField!
    @IBOutlet weak var savebtn: UIButton!
    @IBOutlet weak var phoneNumbertxt: UITextField!
    
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var loadingView: UIView!
    
    // Stored original values
       var originalImage: String = ""
       var originalName: String = ""
       var originalEmail: String = ""
       var originalPhone: String = ""
    
    var selectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backButtonTitle = ""
        setupView()
        setupdata()
        fetchData()
        localized()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.isHiddenNavigation = false
        self.navigationItem.hidesBackButton = false
        self.navigationItem.backButtonTitle = ""
    }
    
    @objc private func pickProfilePicture() {
        print("pick image")
        let alert = UIAlertController()
        alert.addAction(UIAlertAction(title: "Camera".loclize_, style: .default, handler: { _ in self.showImagePicker(sourceType: .camera) }))
        alert.addAction(UIAlertAction(title: "Gallery".loclize_, style: .default, handler: { _ in self.showImagePicker(sourceType: .photoLibrary) }))
        
        alert.addAction(UIAlertAction(title: "Cancel".loclize_, style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    private func showImagePicker(sourceType: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .photoLibrary
                imagePicker.allowsEditing = true // Optional: allows cropping
                present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func didTapBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTapSave(_ sender: Any) {
        guard let  currentName = nametxt.text , !currentName.isEmpty else  {
            ProgressHUD.success("full_name_required".loclize_,image: UIImage(systemName: "xmark.octagon"))
            return
        }
        guard let  currentEmail =  emailtxt.text , !currentEmail.isEmpty else  {
            ProgressHUD.success("email_required".loclize_,image: UIImage(systemName: "xmark.octagon"))
            return
        }
         guard let currentPhone = phoneNumbertxt.text , !currentPhone.isEmpty else {
             ProgressHUD.success("mobile_required".loclize_,image: UIImage(systemName: "xmark.octagon"))
            return
        }
        if !isvalidateEmail(enteredEmail: )(currentEmail) {
            ProgressHUD.success("invalid_email".loclize_,image: UIImage(systemName: "xmark.octagon"))
            return
        }
        
        if currentName == originalName &&
           currentEmail == originalEmail &&
           currentPhone == originalPhone && selectedImage == nil {
            ProgressHUD.error("None of the data has been updated.".loclize_ ,image: UIImage(systemName: "info.circle"))
            return
        }
        
        if selectedImage != nil {
            updateProfileWithImage(name: currentName, email: currentEmail, phone: currentPhone)
        }else {
            updateProfile(name: currentName, email: currentEmail, phone: currentPhone)
        }

        
    }
    
    // MARK: - UIImagePickerControllerDelegate Methods
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            var selectedImage: UIImage?

            if let editedImage = info[.editedImage] as? UIImage {
                selectedImage = editedImage
            } else if let originalImage = info[.originalImage] as? UIImage {
                selectedImage = originalImage
            }

            if let image = selectedImage {
                // Do something with the picked image (e.g., show in UIImageView)
                print("Image picked: \(image)")
                self.selectedImage = image
                self.personalImage.image = image
                
            }

            picker.dismiss(animated: true, completion: nil)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true, completion: nil)
        }
    
}


//MARK: - Main Functions...
extension EditProfileVC {
    func setupView(){
        loadingView.isHidden = false
        loader.startAnimating()
        
        self.personalImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.pickProfilePicture)))
        
    }
    func setupdata(){
        
    }
    func fetchData(){
        fetchUserData()
        
    }
    func localized(){
        
    }
}

//MARK: - Other Functions...
extension EditProfileVC {
    func fetchUserData(){
        
        WebService.shared.sendRequest(url: Request.getProfileData,
                                      method: .get,
                                      isAuth: true,
                                      responseType: ProfileResponse.self) { result in
            switch result {
            case .success(let success):
                let user = success.data
                //MARK: -  Get User Data
//                self.loader.isHidden = true
                self.loadingView.isHidden = true
                self.nametxt.text = user.name
                self.emailtxt.text = user.email
                self.phoneNumbertxt.text = user.phone
                
                if let profilePic = user.profilePciture {
                    self.personalImage.kf.setImage(with: URL(string: "\(Request.baseUrl)\(profilePic)")!)
                }
                
                // Store original values
                 self.originalName = user.name
                 self.originalEmail = user.email
                self.originalPhone = user.phone
                
            case .failure(let failure):
                self.loadingView.isHidden = true
                print(failure.localizedDescription)
                
            }
        }
       
    }
    
    func updateProfile(name: String, email: String, phone: String) {
        loadingView.isHidden = false
        loader.startAnimating()
        
        let params: [String: Any] = [
            "name": name,
            "email": email,
            "phone": phone
        ]
        
        WebService.shared.sendRequest(url: Request.getProfileData,
                                      params: params,
                                      method: .post,
                                      isAuth: true,
                                      responseType: ProfileResponse.self) { result in
          
            
            switch result {
            case .success(_):
                ProgressHUD.succeed("Your data has been updated.".loclize_)
                // Update stored values
                self.originalName = name
                self.originalEmail = email
                self.originalPhone = phone
                self.fetchUserData()
                self.loadingView.isHidden = true
                self.loader.stopAnimating()
                
            case .failure(let error):
                self.loadingView.isHidden = true
                self.loader.stopAnimating()
                print(error.localizedDescription)
                ProgressHUD.succeed("Data not updated, operation failed".loclize_)

            }
        }
        
    }
    
    
    func updateProfileWithImage(name: String, email: String, phone: String) {
        loadingView.isHidden = false
        loader.startAnimating()
        
        let params: [String: Any] = [
            "name": name,
            "email": email,
            "phone": phone
        ]
        
        WebService.shared.uploadImage(url: Request.getProfileData, imageData: selectedImage?.jpegData(compressionQuality: 0.8), parameters: params, imageParameter: "profile_picture") { result in
            
            switch result {
            case .success(_):
                ProgressHUD.succeed("Your data has been updated.".loclize_)
                // Update stored values
                self.originalName = name
                self.originalEmail = email
                self.originalPhone = phone
                self.fetchUserData()
                self.loadingView.isHidden = true
                self.loader.stopAnimating()
                
            case .failure(let error):
                self.loadingView.isHidden = true
                self.loader.stopAnimating()
                print(error.localizedDescription)
                ProgressHUD.succeed("Data not updated, operation failed".loclize_)

            }
        }
        
    }

}
