//
//  TechnicalSupportVC.swift
//  maGmayApp
//
//  Created by ezz on 23/05/2025.
//

import UIKit
import ProgressHUD

class TechnicalSupportVC: UIViewController {

    @IBOutlet weak var nametxt: UITextField!
    @IBOutlet weak var phonetxt: UITextField!
    @IBOutlet weak var emailtxt: UITextField!
    @IBOutlet weak var contenttxt: UITextView!
    @IBOutlet weak var ticketCollctionView: UICollectionView!
    
    @IBOutlet weak var ticketConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var typeProblemtxt: UITextField!
    
    @IBOutlet weak var loaderTickets: UIActivityIndicatorView!
    @IBOutlet weak var previousTicketsView: UIStackView!
    @IBOutlet weak var addNewTicketView: UIStackView!
    
    @IBOutlet weak var selectedImageView: UIImageView!
    @IBOutlet weak var selectImageParentView: UIStackView!
    private var selectedImage: UIImage?
    
    var contacts : [Contact] = []
    
    
    var isAddTicket = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupview()
        fetchData()
        setupdata()
        localized()

    }
    
    @IBAction func showPronlemType(_ sender: Any) {
        
        let alert = UIAlertController(title: "Choose type", message: "", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "inquiry".loclize_, style: .default, handler: { alert in
            self.typeProblemtxt.text = "inquiry"
            
        }))
        
        alert.addAction(UIAlertAction(title: "complaint".loclize_, style: .default, handler: { alert in
            self.typeProblemtxt.text = "complaint"
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)

        
    }
    @IBAction func onTapSendRequest(_ sender: Any) {
        guard let fullName = nametxt.text , !fullName.isEmpty else {
            ProgressHUD.image( "الاسم مطلوب".loclize_ ,image: UIImage(systemName: "minus.circle.fill"))
            return
        }
        
//        guard let email = emailtxt.text , !email.isEmpty else {
//            ProgressHUD.image("الإيميل مطلوب" ,image: UIImage(systemName: "minus.circle.fill"))
//
//            return
//        }
        
        
//        guard isvalidateEmail(enteredEmail: email) else {
//            ProgressHUD.image("الرجاء إدخال إيميل صحيح" ,image: UIImage(systemName: "minus.circle.fill"))
//            return
//        }
//        
//        guard let mobileNumber = phonetxt.text , !mobileNumber.isEmpty else {
//            ProgressHUD.image("رقم الموبايل مطلوب" ,image: UIImage(systemName: "minus.circle.fill"))
//            return
//        }
        
//        guard isValidInternationalPhoneNumber(mobileNumber) else {
//            ProgressHUD.image("الرجاء إدخال رقم صحيح مع مقدمة الدولة" ,image: UIImage(systemName: "minus.circle.fill"))
//            return
//        }
        
        guard let content = contenttxt.text , !content.isEmpty else {
            ProgressHUD.image("محتوى المشكلة مطلوب".loclize_ ,image: UIImage(systemName: "minus.circle.fill"))
            return
        }
        
//        guard let typeProblem = typeProblemtxt.text , !typeProblem.isEmpty else {
//            ProgressHUD.image("نوع الشكوى مطللوب" ,image: UIImage(systemName: "minus.circle.fill"))
//            return
//        }
        
        sentSupportTrchnical(name: fullName,
                             email: "",
                             mobileNumber: "",
                             content: content,
                             typeProblem: "")
        
        
        
        
    }
    
    
    @IBAction func backButton(_ sender: Any) {
        pop()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.isHiddenNavigation = false
        self.navigationItem.hidesBackButton = true
        
    }
    

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        ticketConstraint.constant = ticketCollctionView.contentSize.height
    }
    
    
    @IBAction func onSelectImage(_ sender: Any) {
        self.pickContactImage()
    }
    
    @IBAction func onDeleteSelectedImage(_ sender: Any) {
        self.selectedImageView.isHidden = true
        self.selectImageParentView.isHidden = false
        self.selectedImage = nil
    }
    

}

extension TechnicalSupportVC : UICollectionViewDelegate , UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PreviousTicktCollectionViewCell.identifier, for: indexPath) as! PreviousTicktCollectionViewCell
        cell.configure(with: contacts[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 100)
    }

    
}

extension TechnicalSupportVC {
    func setupview(){
        setUpCollectionView()
        self.loaderTickets.isHidden = false
        
        self.addNewTicketView.isHidden = !isAddTicket
        self.previousTicketsView.isHidden = isAddTicket
        
    }
    func fetchData(){
        getTickets()
        
    }
    func localized(){
 
        
    }
    func setupdata(){
        
    }
    
    
    private func pickContactImage() {
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
}

extension TechnicalSupportVC {
    func getTickets(){
        self.loaderTickets.isHidden = false
        self.loaderTickets.startAnimating()
        WebService.shared.sendRequest(url: Request.contacts, method: .get, isAuth: true, responseType: ContactsResponse.self) { result in
            switch result {
            case .success(let success):
                self.loaderTickets.isHidden = true
                let contacts = success.data.contacts
                        print("✅ Contacts Count: \(contacts.count)")
                        self.contacts = contacts
                        DispatchQueue.main.async {
                            self.ticketCollctionView.reloadData()
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                self.ticketConstraint.constant = self.ticketCollctionView.contentSize.height
                                print("✅ Updated CollectionView Height: \(self.ticketConstraint.constant)")
                            }
                        }
                
            case .failure(let failure):
                self.loaderTickets.isHidden = true
                ProgressHUD.failed(failure.localizedDescription)
                print(failure.localizedDescription)
            }
        }
        
    }
    
    func sentSupportTrchnical(name : String , email : String , mobileNumber : String , content : String ,  typeProblem : String){
        ProgressHUD.progress("loading..".loclize_, 1.0)
        WebService.shared.sendRequest(
            url: Request.contacts,
            params: [
                "name":name,
                "email":email,
                "phone":mobileNumber,
                "type":typeProblem,
                "content":content
            ],
            method: .post,
            isAuth: true,
            responseType: AddContactsResponse.self) { result in
                switch result {
                case .success(let success):
                    print(success.code)
//                    print("Success message: \(success.message)")
                    ProgressHUD.succeed("Request sent successfully".loclize_)
                    DispatchQueue.main.async {
                        self.contacts.removeAll()
                        self.getTickets()
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                        self.pop()
                    })
                    
                case .failure(let failure):
                    
                    ProgressHUD.failed(failure.localizedDescription)
                }
            }
    }
    
    
    func setUpCollectionView(){
        
        ticketCollctionView.delegate = self
        ticketCollctionView.dataSource = self
        ticketCollctionView.register(UINib(nibName: PreviousTicktCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: PreviousTicktCollectionViewCell.identifier)
        
        
        // reload + adjust height after layout
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.ticketConstraint.constant = self.ticketCollctionView.contentSize.height
            print("✅ Updated Height: \(self.ticketConstraint.constant)")
        }

    }
    
    
//    func fetchCcontacts(){
//        WebService.shared.
//    }
}


extension TechnicalSupportVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    // MARK: - UIImagePickerControllerDelegate Methods
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            var selectedImage: UIImage?

            if let editedImage = info[.editedImage] as? UIImage {
                selectedImage = editedImage
            } else if let originalImage = info[.originalImage] as? UIImage {
                selectedImage = originalImage
            }

            if let image = selectedImage {
               
                
                self.selectedImageView.image = image
                self.selectedImageView.isHidden = false
                self.selectImageParentView.isHidden = true
                self.selectedImage = image
            }

            picker.dismiss(animated: true, completion: nil)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true, completion: nil)
        }
    
}


struct AddContactsResponse : Codable {
    let code : Int
    let message : String
}

//class BaseViewController: UIViewController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupBackButton()
//    }
//
//    func setupBackButton() {
//        let isArabic = UserProfile.shared.currentLanguageKey == "ar"
//        let backImageName = isArabic ? "arrow-right" : "arrow-left" 
//
//        let backButton = UIBarButtonItem(
//            image: UIImage(named: backImageName),
//            style: .plain,
//            target: self,
//            action: #selector(backAction)
//        )
//
//        if !isArabic {
//            navigationItem.rightBarButtonItem = backButton
//            navigationItem.leftBarButtonItem = nil
//        } else {
//            navigationItem.leftBarButtonItem = backButton
//            navigationItem.rightBarButtonItem = nil
//        }
//    }
//
//    @objc func backAction() {
//        navigationController?.popViewController(animated: true)
//    }
//}
