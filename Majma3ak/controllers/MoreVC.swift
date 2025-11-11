//
//  MoreVC.swift
//  maGmayApp
//
//  Created by ezz on 16/05/2025.
//

import UIKit
import DropDown


protocol MoreVCDelegate: AnyObject {
    func didSwipeToProfile()
}

class MoreVC: UIViewController {
    
    
    
    @IBOutlet weak var maintenanceRequestArrowBtn: UIButton!
    @IBOutlet weak var visitRequestArrowBtn: UIButton!
    @IBOutlet weak var complaintSupportArrowBtn: UIButton!
    @IBOutlet weak var filesArrow: UIButton!
    
    @IBOutlet weak var maintenanceRequestView: UIStackView!
    
    @IBOutlet weak var visitRequestView: UIStackView!
    
    @IBOutlet weak var complaintsView: UIStackView!
    
    @IBOutlet weak var filesView: UIStackView!
    
    
    @IBOutlet weak var paymentsBtn: UIButton!
    @IBOutlet weak var maintenanceRequestBtn: UIButton!
    @IBOutlet weak var allMaintenanceRequests: UIButton!
    @IBOutlet weak var previousMaintenanceRequ3ests: UIButton!
    @IBOutlet weak var visitRequests: UIButton!
    @IBOutlet weak var addVisitRequest: UIButton!
    @IBOutlet weak var previousVisitRequest: UIButton!
    @IBOutlet weak var support: UIButton!
    @IBOutlet weak var addSupportRequest: UIButton!
    @IBOutlet weak var previousSupportRequests: UIButton!
    @IBOutlet weak var termsOfService: UIButton!
    @IBOutlet weak var aboutSystem: UIButton!
    @IBOutlet weak var logout: UIButton!
    
    
    
    
    var items : [String] = ["Payments"  , "Contact technical support"  , "Change language", "Maintenance" ,"Visit", "Privacy Policy", "About us", "Sign out" ]
    
    let maintenanceItems = ["Maintenance request".loclize_,"View all".loclize_]
    let visitItems = ["Visit request".loclize_ , "View all".loclize_];
    let maintenanceDropDown = DropDown()
    let visitDropDown = DropDown()

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var helloLabel: UILabel!
    
    

    @IBOutlet weak var tableView: UITableView!
    
    
    weak var delegate: MoreVCDelegate?

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        maintenanceDropDown.textFont = UIFont(name: "FFShamelFamily-SansOneBook", size: 14)!
        visitDropDown.textFont = UIFont(name: "FFShamelFamily-SansOneBook", size: 14)!
        let tapProfile = UITapGestureRecognizer(target: self, action: #selector(didTapGoProfilePage))
           profileImage.addGestureRecognizer(tapProfile)
           profileImage.isUserInteractionEnabled = true
        
        setupBtnFont()
        fetchUserData()

  
    }
    
    
    private func setupBtnFont(){
//        paymentsBtn.titleLabel?.font = UIFont(name: "FFShamelFamily-SansOneBook", size: 15)!
//        maintenanceRequestBtn.titleLabel?.font = UIFont(name: "FFShamelFamily-SansOneBook", size: 15)!
//        allMaintenanceRequests.titleLabel?.font = UIFont(name: "FFShamelFamily-SansOneBook", size: 15)!
//        
//        previousMaintenanceRequ3ests.titleLabel?.font = UIFont(name: "FFShamelFamily-SansOneBook", size: 15)!
//        visitRequests.titleLabel?.font = UIFont(name: "FFShamelFamily-SansOneBook", size: 15)!
//        addVisitRequest.titleLabel?.font = UIFont(name: "FFShamelFamily-SansOneBook", size: 15)!
//        
//        previousVisitRequest.titleLabel?.font = UIFont(name: "FFShamelFamily-SansOneBook", size: 15)!
//        support.configuration?.attributedTitle?.font = UIFont(name: "FFShamelFamily-SansOneBook", size: 15)!
//        
//        addSupportRequest.titleLabel?.font = UIFont(name: "FFShamelFamily-SansOneBook", size: 15)!
//        
//        previousSupportRequests.titleLabel?.font = UIFont(name: "FFShamelFamily-SansOneBook", size: 15)!
//        termsOfService.titleLabel?.font = UIFont(name: "FFShamelFamily-SansOneBook", size: 15)!
//        aboutSystem.titleLabel?.font = UIFont(name: "FFShamelFamily-SansOneBook", size: 15)!
//        logout.titleLabel?.font = UIFont(name: "FFShamelFamily-SansOneBook", size: 15)!
        
    }
    
    @objc func didTapGoProfilePage(){
         delegate?.didSwipeToProfile()


     }
    
    func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
    }
    
    
    @IBAction func didTapGoToNotifcations(_ sender: Any) {
        let vc = UIStoryboard.mainStoryBoard.instantiateViewController(withIdentifier: "NotifcationsVC") as? NotifcationsVC
        vc?.push()
    }
    
    
    
    
    func handleLanguageChange() {
        let alert = UIAlertController(title: "Select Language".loclize_, message: nil, preferredStyle: .actionSheet)

        let languages: [(code: String, name: String)] = [
            ("ar", "العربية"),
            ("ku", "کوردی"),
            ("en", "English")
        ]
        
        for language in languages {
            let action = UIAlertAction(title: language.name, style: .default) { _ in
                self.confirmLanguageChange(to: language.code, displayName: language.name)
            }
            alert.addAction(action)
        }

        alert.addAction(UIAlertAction(title: "Cancel".loclize_, style: .cancel))
        self.present(alert, animated: true)
    }

    
    func confirmLanguageChange(to langCode: String, displayName: String) {
        guard let window = UIApplication.shared.keyWindow else { return }

        let currentLang = UserProfile.shared.currentAppleLanguage()
        guard currentLang != langCode else { return } // No need to change if same

        self.showAlertWithCancel(
            title: "Change language to".loclize_ + " \(displayName)",
            message: "Must Restart app to change the language".loclize_,
            okAction: "Ok"
        ) { _ in
            UserProfile.shared.setAppleLAnguageTo(lang: langCode)

            // MOLH.reset() // if you're using MOLH

            window.makeKeyAndVisible()
            UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                exit(EXIT_SUCCESS)
            }
        }
    }


    @IBAction func onPaymentClick(_ sender: Any) {
        let vc = UIStoryboard.mainStoryBoard.instantiateViewController(identifier: "PaymentsVC") as? PaymentsVC
              vc?.push()
    }
    
    
    
    @IBAction func onExpandMaintenanceRequest(_ sender: Any) {
        
        UIView.animate(withDuration: 0.3, animations: { [self] in
            
            
            maintenanceRequestView.isHidden = !self.maintenanceRequestView.isHidden
            
            maintenanceRequestArrowBtn.setImage(maintenanceRequestView.isHidden ? UIImage(systemName: "chevron.down") : UIImage(systemName: "chevron.up"), for: .normal)
            
        })
        
    }
    
    
    @IBAction func onMaintenanceRequestClick(_ sender: Any) {
        
        self.addNewaintenanceRequest()
        
    }
    
    
    @IBAction func onPreviousMaintenanceRequestClick(_ sender: Any) {
        self.viewAllmaintenanceRequests()
    }
    
    
    @IBAction func expandVisitRequest(_ sender: Any) {
        UIView.animate(withDuration: 0.3, animations: { [self] in
            
            
            visitRequestView.isHidden = !self.visitRequestView.isHidden
            
            visitRequestArrowBtn.setImage(visitRequestView.isHidden ? UIImage(systemName: "chevron.down") : UIImage(systemName: "chevron.up"), for: .normal)
            
        })
    }
    
    
    @IBAction func onVisitRequestClick(_ sender: Any) {
        
        self.addNewVisitRequest()
    }
    
    
    @IBAction func onPreviousVisitRequestClick(_ sender: Any) {
        self.viewAllVisitsReqests()
    }
    
    
    
    @IBAction func expandComplaintAndSupport(_ sender: Any) {
        
        UIView.animate(withDuration: 0.3, animations: { [self] in
            
            
            complaintsView.isHidden = !self.complaintsView.isHidden
            
            complaintSupportArrowBtn.setImage(complaintsView.isHidden ? UIImage(systemName: "chevron.down") : UIImage(systemName: "chevron.up"), for: .normal)
            
        })
    }
    
    
    @IBAction func onComplaintsClick(_ sender: Any) {
        let vc = UIStoryboard.mainStoryBoard.instantiateViewController(withIdentifier: "TechnicalSupportVC") as? TechnicalSupportVC
        vc?.isAddTicket = true
        vc?.push()
    }
    
    @IBAction func onPreviousComplaints(_ sender: Any) {
        let vc = UIStoryboard.mainStoryBoard.instantiateViewController(withIdentifier: "TechnicalSupportVC") as? TechnicalSupportVC
        vc?.isAddTicket = false
        vc?.push()
    }
    
    
    @IBAction func onFIlesPressed(_ sender: Any) {
        UIView.animate(withDuration: 0.3, animations: { [self] in
            
            
            filesView.isHidden = !self.filesView.isHidden
            
            filesArrow.setImage(filesView.isHidden ? UIImage(systemName: "chevron.down") : UIImage(systemName: "chevron.up"), for: .normal)
            
        })
    }
    
    
    @IBAction func onSentFilesClicked(_ sender: Any) {
        let vc = UIStoryboard.mainStoryBoard.instantiateViewController(withIdentifier: "DocumentsVC") as? DocumentsVC
        vc?.push()
    }
    
    
    @IBAction func onRequestedFilesClick(_ sender: Any) {
        let vc = UIStoryboard.mainStoryBoard.instantiateViewController(withIdentifier: "RequestedDocumentsVC") as? RequestedDocumentsVC
        vc?.push()
    }
    
    
    @IBAction func onTermsClick(_ sender: Any) {
        let vc = UIStoryboard.mainStoryBoard.instantiateViewController(identifier: "TermsOfServiceVC") as? TermsOfServiceVC
              vc?.push()
    }
    
    @IBAction func onAboutSystemClick(_ sender: Any) {
        let vc = UIStoryboard.mainStoryBoard.instantiateViewController(identifier: "AboutSystemVC") as? AboutSystemVC
              vc?.push()
    }
    
    
    @IBAction func onLogout(_ sender: Any) {
        let art = UIAlertController(title: "", message: "Do you want to log out?".loclize_
                                    , preferredStyle: UIAlertController.Style.alert)
        let cancel = UIAlertAction(title: "Cancel".loclize_, style: UIAlertAction.Style.default, handler: nil)
        let ok = UIAlertAction(title: "Ok".loclize_, style: UIAlertAction.Style.default) { (UIAlertAction) in
            
            UserDefaults.standard.removeObject(forKey: "access_token")
            let vc = UIStoryboard.mainStoryBoard.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC
            vc?.rootPush()
            
            
        }
        art.addAction(cancel)
        art.addAction(ok)
        present(art, animated: true, completion: nil)
    }
    
    
}

extension MoreVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as! TitleTableViewCell
        cell.configure(with: items[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0 :
            let vc = UIStoryboard.mainStoryBoard.instantiateViewController(withIdentifier: "TechnicalSupportVC") as? TechnicalSupportVC
            vc?.push()
        case 1 :
            handleLanguageChange()
        
        case 2 :
            let art = UIAlertController(title: "", message: "Do you want to log out?".loclize_
                                        , preferredStyle: UIAlertController.Style.alert)
            let cancel = UIAlertAction(title: "Cancel".loclize_, style: UIAlertAction.Style.default, handler: nil)
            let ok = UIAlertAction(title: "Ok".loclize_, style: UIAlertAction.Style.default) { (UIAlertAction) in
                
                UserDefaults.standard.removeObject(forKey: "access_token")
                let vc = UIStoryboard.mainStoryBoard.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC
                vc?.rootPush()
                
                
            }
            art.addAction(cancel)
            art.addAction(ok)
            present(art, animated: true, completion: nil)
            
            
        case 3:
            guard let cell = tableView.cellForRow(at: indexPath) else { return }

            maintenanceDropDown.anchorView = cell // Anchor to the tapped cell
            maintenanceDropDown.dataSource = maintenanceItems

            // Handle selection
            maintenanceDropDown.selectionAction = {[weak self]  (index: Int, item: String) in
                switch index {
                case 0:
                    self?.addNewaintenanceRequest()
                case 1:
                    self?.viewAllmaintenanceRequests()
                
                default:
                    print("nothing")
                }
                // You can handle the selected fruit here
            }

            maintenanceDropDown.show()
            
            
        case 4:
            guard let cell = tableView.cellForRow(at: indexPath) else { return }
            

            visitDropDown.anchorView = cell // Anchor to the tapped cell
            
            visitDropDown.dataSource = visitItems
            
        

            // Handle selection
            visitDropDown.selectionAction = { [weak self]  (index: Int, item: String) in
                switch index {
                case 0:
                    self?.addNewVisitRequest()
                case 1:
                    self?.viewAllVisitsReqests()
                default:
                    print("nothing")
                }
                // You can handle the selected fruit here
            }

            visitDropDown.show()

        default:
            break
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50 
    }
}


extension MoreVC {
    func addNewaintenanceRequest(){
        let vc = UIStoryboard.mainStoryBoard.instantiateViewController(identifier: "AddMaintenanceRequestVC") as? AddMaintenanceRequestVC
             vc?.push()
    }
    
    
    func addNewVisitRequest(){
        let vc = UIStoryboard.mainStoryBoard.instantiateViewController(identifier: "AddVisitRequestVC") as? AddVisitRequestVC
              vc?.push()
    }
    
    func viewAllVisitsReqests(){
        let vc = UIStoryboard.mainStoryBoard.instantiateViewController(withIdentifier: "VisitRequestsVC") as? VisitRequestsVC
              vc?.push()
    }
    
    func viewAllmaintenanceRequests(){
        let vc = UIStoryboard.mainStoryBoard.instantiateViewController(withIdentifier: "MaintenanceRequestsVC") as? MaintenanceRequestsVC
            vc?.push()
    }
    
    func fetchUserData(){
        
        
        
        WebService.shared.sendRequest(url: Request.getProfileData,
                                      method: .get,
                                      isAuth: true,
                                      responseType: ProfileResponse.self) { result in
            switch result {
            case .success(let success):
                let user = success.data
                self.helloLabel.text = "\("Hello".loclize_) \(user.name ?? "")"
                if let profilePic = user.profilePciture, !profilePic.isEmpty {
                    self.profileImage.kf.setImage(with: URL(string: "\(profilePic)")!)
                }
//                self.nameLbl.text = user.
                
            case .failure(let failure):
                print(failure.localizedDescription)
                
            }
        }
       
    }
}


class TitleTableViewCell : UITableViewCell {
    static let identifier = "TitleTableViewCell"
    
    @IBOutlet weak var titlelbl: UILabel!
    func configure(with title : String){
        self.titlelbl.text = title.loclize_
        
    }
    
    
    
}
