//
//  AddMaintenanceRequestVC.swift
//
//
//  Created by ezz on 20/05/2025.
//

import UIKit
import ProgressHUD

class AddMaintenanceRequestVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    
    @IBOutlet weak var imageParentView: UIView!
    @IBOutlet weak var requestImage: UIImageView!
    @IBOutlet weak var requestCameraIcon: UIImageView!
    
    
    @IBOutlet weak var typeButton : UIButton!
    @IBOutlet weak var typeProblemtxt: UITextField!
    @IBOutlet weak var selectedApartmenttxt: UITextField!
    
    @IBOutlet weak var problemTitletxt: UITextField!
    @IBOutlet weak var descreptiontxt: UITextView!
    
    @IBOutlet weak var loaderAddMaintanceRequest: UIActivityIndicatorView!
    @IBOutlet weak var sendReqbtn: UIButton!
    var maintenanceDepartments : [MaintenanceDepartmentsModel] = []
    var apartments : [ApartmentAssociated] = []
    var selectedMD : Int?
    var selectedA : Int?
    private var selectedImage : UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setupData()
        fetchData()
        localized()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        isHiddenNavigation = false
        self.navigationItem.hidesBackButton = true
    }
    
    @objc private func pickRequestImage() {
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
    
    @IBAction func didTapBackButton(_ sender: Any) {
        pop()
    }
    
    
    @IBAction func showDropdown(_ sender: UIButton) {
        let alert = UIAlertController(title: "Choose an Option", message: nil, preferredStyle: .actionSheet)
        
        //        let options = ["Option 1", "Option 2", "Option 3"]
        
        for option in maintenanceDepartments {
            alert.addAction(UIAlertAction(title: option.name.loclize_, style: .default, handler: { _ in
                self.typeProblemtxt.text = option.name.loclize_// update button title
                self.selectedMD = option.id
            }))
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        // For iPad compatibility
        if let popover = alert.popoverPresentationController {
            popover.sourceView = sender
            popover.sourceRect = sender.bounds
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func showApartments(_ sender: UIButton) {
        let alert = UIAlertController(title: "Choose an Option", message: nil, preferredStyle: .actionSheet)
        
        //        let options = ["Option 1", "Option 2", "Option 3"]
        
        for option in apartments {
            alert.addAction(UIAlertAction(title: option.number, style: .default, handler: { _ in
                self.selectedApartmenttxt.text = option.number// update button title
                self.selectedA = option.id
            }))
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        // For iPad compatibility
        if let popover = alert.popoverPresentationController {
            popover.sourceView = sender
            popover.sourceRect = sender.bounds
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func sendRequestBtn(_ sender: Any) {
        
        guard let problemTitle = problemTitletxt.text , !problemTitle.isEmpty else {
            ProgressHUD.image("عنوان المشكلة مطلوبة" ,image: UIImage(systemName: "minus.circle.fill"))
            
            return
        }
        
        guard let maintenanceDepartment = typeProblemtxt.text , !maintenanceDepartment.isEmpty else {
            ProgressHUD.image("نوع المشكلة مطلوب" ,image: UIImage(systemName: "minus.circle.fill"))
            
            return
        }
        
        guard let apartment = selectedApartmenttxt.text , !apartment.isEmpty else {
            ProgressHUD.image("الشقة مطلوبة" ,image: UIImage(systemName: "minus.circle.fill"))
            
            return
        }
        
        
        guard let description = descreptiontxt.text , !description.isEmpty else {
            ProgressHUD.image("تفاصيل المشكلة مطلوبة" ,image: UIImage(systemName: "minus.circle.fill"))
            
            return
        }
        
        
        
        
        
        if (selectedMD != nil && selectedA != nil){
            if selectedImage != nil{
                sendMaintanaceRequestWithImage(title: problemTitle, maintenanceDepartmentId: selectedMD!, apartmentID: selectedA!, description: description)
            } else {
                sendMaintanaceRequest(title: problemTitle, maintenanceDepartmentId: selectedMD!, apartmentID: selectedA!, description: description)
            }
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
                
                self.requestImage.image = image
                self.requestImage.isHidden = false
                self.requestCameraIcon.isHidden = true
                self.selectedImage = image
            }

            picker.dismiss(animated: true, completion: nil)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true, completion: nil)
        }
}

extension AddMaintenanceRequestVC {
    func setUpView(){
        self.loaderAddMaintanceRequest.isHidden = true
        self.imageParentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.pickRequestImage)))
        setupTextViews()
    }
    func fetchData(){
        getMaintenanceDepartments()
        getApartments()
        
        
    }
    func localized(){
        
    }
    func setupData(){
        
    }
    
}
extension AddMaintenanceRequestVC {
    
    func getMaintenanceDepartments(){
        WebService.shared.sendRequest(url: Request.maintenanceDepartments,
                                      method: .get,
                                      isAuth: true,
                                      responseType: MaintenanceDepartmentsResponse.self) { result in
            switch result {
            case .success(let data):
                let maintenanceDepartments = data.data
                for maintenanceD in maintenanceDepartments {
                    self.maintenanceDepartments.append(maintenanceD)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func getApartments(){
        WebService.shared.sendRequest(
            url: Request.apartments,
            method: .get,
            isAuth: true,
            responseType: ApartmentsResponse.self) { result in
                switch result {
                case .success(let data):
                    let fetchApartments = data.data.apartments
                    print("Appartments: ", fetchApartments.count)
                    DispatchQueue.main.async {
                        self.apartments = fetchApartments
                    }
                case .failure(let failure):
                    print(failure.localizedDescription)
                }
                
            }
    }
    
    
    func sendMaintanaceRequest(title : String , maintenanceDepartmentId : Int , apartmentID : Int , description : String){
        self.loaderAddMaintanceRequest.isHidden = false
        self.loaderAddMaintanceRequest.startAnimating()
        self.sendReqbtn.setTitle("", for: .normal)
        
        WebService.shared.sendRequest(url: Request.maintenanceRequests,
                                      params: [
                                        "maintenance_department_id":maintenanceDepartmentId,
                                        "title":title,
                                        "description":description,
                                        "apartment_id":apartmentID
                                      ],
                                      method: .post,
                                      isAuth:true,
                                      responseType: SendMaintenanceResponse.self) { result in
            switch result {
            case .success(let data):
                self.loaderAddMaintanceRequest.isHidden = true
                self.sendReqbtn.setTitle("Send Request".loclize_, for: .normal)
                print(data.code)
                print(data.message)
//                print(data.data.title)
                ProgressHUD.succeed("Maintenance request sent successfully".loclize_)
                NotificationCenter.default.post(name: .maintenanceRequestAdded, object: nil)
                self.pop()
            case .failure(let failure):
                self.loaderAddMaintanceRequest.isHidden = true
                self.sendReqbtn.setTitle("Send Request".loclize_, for: .normal)
                ProgressHUD.failed("Failed to send maintenance request".loclize_)
                print(failure.localizedDescription)
            }
        }
    }
    
    func sendMaintanaceRequestWithImage(title : String , maintenanceDepartmentId : Int , apartmentID : Int , description : String){
        self.loaderAddMaintanceRequest.isHidden = false
        self.loaderAddMaintanceRequest.startAnimating()
        self.sendReqbtn.setTitle("", for: .normal)
        
        let params : [String : Any] = [
            "maintenance_department_id":maintenanceDepartmentId,
            "title":title,
            "description":description,
            "apartment_id":apartmentID
        ]
        
        WebService.shared.uploadImage(url: Request.maintenanceRequests, imageData: selectedImage?.jpegData(compressionQuality: 0.8)!, parameters: params, imageParameter: "image") { result in
            
            switch result {
            case .success(_):
                self.loaderAddMaintanceRequest.isHidden = true
                self.sendReqbtn.setTitle("Send Request".loclize_, for: .normal)
                
                ProgressHUD.succeed("Maintenance request sent successfully".loclize_)
                NotificationCenter.default.post(name: .maintenanceRequestAdded, object: nil)
                self.pop()
            case .failure(let failure):
                self.loaderAddMaintanceRequest.isHidden = true
                self.sendReqbtn.setTitle("Send Request".loclize_, for: .normal)
                ProgressHUD.failed("Failed to send maintenance request".loclize_)
                print(failure.localizedDescription)
            }
            
        }
        
    }
    
}

struct SendMaintenanceResponse : Codable {
    let code : Int
    let message : String
}


extension AddMaintenanceRequestVC: UITextViewDelegate, UITextFieldDelegate {
    public func setupTextViews() {
        view.subviews.forEach { setReturnHandler(for: $0) }
    }

    private func setReturnHandler(for view: UIView) {
        if let textView = view as? UITextView {
            textView.delegate = self
        } else {
            view.subviews.forEach { setReturnHandler(for: $0) }
        }
        
        if let textField = view as? UITextField {
            textField.delegate = self
            textField.returnKeyType = .done
        } else {
            view.subviews.forEach { setReturnHandler(for: $0) }
        }
    }

    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
