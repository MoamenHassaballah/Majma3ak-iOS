//
//  PaymentsVC.swift
//  Majma3ak
//
//  Created by Moamen Hassaballah on 12/08/2025.
//

import UIKit
import ProgressHUD
import Alamofire

class PaymentsVC: UIViewController {
    
    @IBOutlet weak var parentView: UIView!
    
    @IBOutlet weak var totalPaidShadowView: UIView!
    @IBOutlet weak var totalPaidRoundView: UIView!
    @IBOutlet weak var totalPaidLabel: UILabel!
    @IBOutlet weak var totalDueShadowView: UIView!
    @IBOutlet weak var totalDueRoundView: UIView!
    @IBOutlet weak var totalDueLabel: UILabel!
    @IBOutlet weak var remainingAmoutLabel: UILabel!
    
    
    @IBOutlet weak var paymentHistoryTableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    private var paymentHistoryArray: [PaymentData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isHiddenNavigation = false
        parentView.isHidden = true
        
        paymentHistoryTableView.delegate = self
        paymentHistoryTableView.dataSource = self
        
        paymentHistoryTableView.register(UINib(nibName: String(describing: PaymentsTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: PaymentsTableViewCell.self))
        
        setupUI()
        fetchData()
    }
    
    private func setupUI(){
        totalDueShadowView.layer.shadowColor = UIColor.black.cgColor
        totalDueShadowView.layer.shadowOffset = CGSize(width: 0, height: 2)
        totalDueShadowView.layer.shadowOpacity = 0.2
        totalDueShadowView.layer.shadowRadius = 5
        
        totalDueRoundView.layer.cornerRadius = 10
        
        totalPaidShadowView.layer.shadowColor = UIColor.black.cgColor
        totalPaidShadowView.layer.shadowOffset = CGSize(width: 0, height: 2)
        totalPaidShadowView.layer.shadowOpacity = 0.2
        totalPaidShadowView.layer.shadowRadius = 5
        
        totalPaidRoundView.layer.cornerRadius = 10
    }
    
    
    
    @IBAction func didTapBack(_ sender: Any) {
        self.pop()
    }
    
    
    private func fetchData(){
        loadingIndicator.startAnimating()
//        ProgressHUD.load()
        
        
//        var headers: HTTPHeaders = [:]
//        headers.add(name: "Authorization", value: "Bearer \(Helper.access_token)")
//        headers.add(name: "Accept", value: "application/json")
//        
//        
//        AF.request(Request.payments, method: .get, parameters: [:], encoding: URLEncoding.default, headers: headers)
//            .validate()
//            .responseString { response in
//                switch response.result {
//                case .success(let decodedObject):
//                    print("Successfully fetched data, data: \(decodedObject)")
//                case .failure(let error):
//                    
//                    print("Error fetching data: \(error)")
//                }
//            }
        
        WebService.shared.sendRequest(
            url: Request.payments,
            method: .get,
            isAuth: true,
            responseType: PaymentsResponse.self) { result in
                self.loadingIndicator.stopAnimating()
                switch result {
                case .success(let data):
                    
                    if let data = data.data {
                        self.setupData(data: data)
                    }

                    
                case .failure(let error):
                    print("Error fetching data: \(error)")
                    ProgressHUD.failed(error.localizedDescription) // أو أي أداة عرض تنبيهات تستخدمها

                }
                
            }
    }
    
    
    private func setupData(data: [PaymentData]) {
        parentView.isHidden = false
        paymentHistoryArray = data
        paymentHistoryTableView.reloadData()
        tableViewHeight.constant = CGFloat(paymentHistoryArray.count * 170)
        
        
        var remainingAmount = 0.0
        var paidAmount = 0.0
        
        
        data.forEach { (item) in
            if item.status?.lowercased() == "paid" {
                paidAmount += Double(item.total_amount ?? "0.0") ?? 0.0
            } else {
                remainingAmount += Double(item.total_amount ?? "0.0") ?? 0.0
            }
        }
        
        totalPaidLabel.text = "\(paidAmount) \("IQD".loclize_)"
        remainingAmoutLabel.text = "\(remainingAmount) \("IQD".loclize_)"
        totalDueLabel.text = "\(remainingAmount + paidAmount) \("IQD".loclize_)"
    }
    

}


extension PaymentsVC : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        paymentHistoryArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PaymentsTableViewCell.self)) as! PaymentsTableViewCell
        let item = paymentHistoryArray[indexPath.row]
        cell.configure(data: item)
        return cell
        
    }
    
    
    
    
}
