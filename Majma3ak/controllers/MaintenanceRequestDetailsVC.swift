//
//  MaintenanceRequestDetailsVC.swift
//  Majma3ak
//
//  Created by ezz on 19/07/2025.
//

import UIKit
import ProgressHUD

class MaintenanceRequestDetailsVC: UIViewController {
    
    
    @IBOutlet weak var requestImage: UIImageView!
    @IBOutlet weak var requestImageDivider: UIView!
    
    
    
    @IBOutlet weak var titleValuelbl: UILabel!
    @IBOutlet weak var descriptioValueLbl: UILabel!
    
    @IBOutlet weak var statusValueLbl: UILabel!
    
    @IBOutlet weak var complexNameValueLbl: UILabel!
    
    @IBOutlet weak var builidingAddressValueLbl: UILabel!
    
    @IBOutlet weak var apartmentNumberValueLbl: UILabel!
    
    @IBOutlet weak var floorValueLbl: UILabel!
    
    @IBOutlet weak var maintenanceDepValueLbl: UILabel!
    @IBOutlet weak var createdValueLbl: UILabel!
    
    @IBOutlet weak var cancelBtn: UIButton!
    
    
    
    var request : MaintenanceRequest?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isHiddenNavigation = false
    }
    
    @IBAction func didBack(_ sender: Any) {
        pop()
    }
    
    func setupData(){
        
        if let imageUrl = request?.images?.admin?.first?.imageURL {
            
            requestImage.kf.setImage(with: URL(string: imageUrl))
            
        } else {
            requestImage.isHidden = true
            requestImageDivider.isHidden = true
        }
        
        
        self.titleValuelbl.text = request?.title
        self.descriptioValueLbl.text = request?.description
        self.statusValueLbl.text = request?.status?.loclize_
        self.complexNameValueLbl.text = request?.complex?.name
        self.apartmentNumberValueLbl.text = request?.complex?.building?.apartment?.number
        self.builidingAddressValueLbl.text = request?.complex?.building?.address
        self.floorValueLbl.text =
        request?.complex?.building?.apartment?.floorNumber
        self.maintenanceDepValueLbl.text =
        request?.maintenanceDepartment?.name?.loclize_
        self.createdValueLbl.text = extractDateOnly(from: request?.createdAt ?? "")
        
        
        cancelBtn.isHidden = request?.status != "waiting"
    }
    
    @IBAction func didTapCancelRequest(_ sender: Any) {
        WebService.shared.sendRequest(url: Request.maintenanceRequests2 + "/\(request!.id!)/cancel",
                                      method: .put,
                                      isAuth: true,
                                      responseType: CancelMaintenanceRequest.self) { result in
            switch result {
            case .success(let success):
                print(success.message)
                ProgressHUD.succeed("The request was successfully cancelled.".loclize_)
                NotificationCenter.default.post(name: .maintenanceRequestAdded, object: nil)

                self.pop()
            case .failure(let failure):
                ProgressHUD.failed("request cancellation failed".loclize_)
                
            }
        }
    }
    
}
struct CancelMaintenanceRequest : Codable{
    let code : Int
    let message : String
}
