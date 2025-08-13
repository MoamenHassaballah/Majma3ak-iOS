//
//  VisitRequestDetailsVC.swift
//  Majma3ak
//
//  Created by ezz on 19/07/2025.
//

import UIKit
import ProgressHUD
class VisitRequestDetailsVC: UIViewController {
    
    @IBOutlet weak var visitorNameLbl: UILabel!
    @IBOutlet weak var visitorPhoneLbl: UILabel!
    @IBOutlet weak var visitDateLbl: UILabel!
    @IBOutlet weak var visitTimeLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var requesterLbl: UILabel!
    @IBOutlet weak var createdAtLbl: UILabel!
    
    
    var visitObj : VisitRequest?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupVisitDetailsUI(visit: visitObj!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isHiddenNavigation = false 
    }
    
    @IBAction func didTapBack(_ sender: Any) {
        self.pop()
    }
    func setupVisitDetailsUI(visit : VisitRequest){
        self.visitorNameLbl.text = visit.visiterName
        self.visitorPhoneLbl.text = visit.visiterPhone
        self.visitDateLbl.text = visit.visitDate
        self.visitTimeLbl.text = visit.visitTime
        self.statusLbl.text = visit.status
        self.requesterLbl.text = visit.user.name
        self.createdAtLbl.text = extractDateOnly(from: visit.createdAt)
    }

    @IBAction func didTapCancelReq(_ sender: Any) {
        WebService.shared.sendRequest(url: Request.AddvisitRequests + "/\(visitObj!.id)/cancel",
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
