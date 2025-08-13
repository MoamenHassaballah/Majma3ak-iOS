//
//  MaintenanceRequestsVC.swift
//  Majma3ak
//
//  Created by ezz on 02/07/2025.
//

import UIKit
import ProgressHUD

class MaintenanceRequestsVC: UIViewController ,UIScrollViewDelegate {
    
    @IBOutlet weak var allRequestsCollectionView: UICollectionView!
    @IBOutlet weak var emptyStateLabel: UILabel!
    @IBOutlet weak var loaderMaintenanceRequests: UIActivityIndicatorView!
    
    var maintenanceRequests : [MaintenanceRequest] = []
    var totalPage = 0
    var currentPage = 1
    var isLoading = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupdata()
        fetchData()
        localized()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func pop(_ sender: Any) {
        self.pop()
    }
}

extension MaintenanceRequestsVC {
    func setupView(){
        setUpCollectionView()
//        removeBackButton(vc: self)
        self.loaderMaintenanceRequests.isHidden = true
        self.loaderMaintenanceRequests.hidesWhenStopped = true
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationItem.backButtonTitle = ""
        
    }
    func setupdata(){
        
    }
    func fetchData(){
        getMantanceRequests()
        
    }
    func localized(){
        
    }
}

extension MaintenanceRequestsVC {
    
    func setUpCollectionView(){
        
        //request Collection View
        allRequestsCollectionView.delegate = self
        allRequestsCollectionView.dataSource = self
        allRequestsCollectionView.register(UINib(nibName: "RequestCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "RequestCollectionViewCell")
        
        if let layout = allRequestsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
            layout.minimumLineSpacing = 5
            layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
    }
    func getMantanceRequests(currentPage : Int = 0){
            self.emptyStateLabel.isHidden = true
            self.loaderMaintenanceRequests.startAnimating()
//            self.loaderMaintenanceRequests.isHidden = false

            
            WebService.shared.sendRequest(
                url: Request.maintenanceRequests + "page=\(self.currentPage)&per_page=10",
                method: .get,
                isAuth: true,
                responseType: MaintenanceRequestsResponse.self) { result in
                    switch result {
                    case .success(let data):
                        let maintenanceRequests = data.data!.maintenanceRequests!
//                        print(data.code)
//                        print(data.message)
                        self.currentPage = data.data!.meta!.currentPage!
                        self.totalPage = data.data!.meta!.totalPages!
                        self.isLoading = false
    //                    print(data.data.meta.count)
//
                        // ✅ Set default displayed list and selected category
                        DispatchQueue.main.async {
                            self.maintenanceRequests += maintenanceRequests
                            self.allRequestsCollectionView.reloadData()
                             self.loaderMaintenanceRequests.stopAnimating()
                            self.allRequestsCollectionView.isHidden = false
                             self.updateEmptyStateView()
                         }

                        
                    case .failure(let error):
                        DispatchQueue.main.async {
                            self.loaderMaintenanceRequests.stopAnimating()
                            self.updateEmptyStateView()
                            ProgressHUD.failed(error.localizedDescription) // أو أي أداة عرض تنبيهات تستخدمها
                        }

                    }
                }
        }
    
    func updateEmptyStateView(){
        emptyStateLabel.isHidden = !self.maintenanceRequests.isEmpty
    }
    
    func removeBackButton(vc:UIViewController) {
            let button = UIButton.init(type: .custom)
            button.setImage(UIImage.init(named:""), for: .normal)
            let leftBarButton = UIBarButtonItem.init(customView: button)
            vc.navigationItem.leftBarButtonItem = leftBarButton
    }
    
    private func cancelMaintenanceRequest(requestId: Int){
        ProgressHUD.progress("loading..".loclize_, 0)
        
        WebService.shared.sendRequest(
            url: "\(Request.maintenanceRequests2)/\(requestId)/cancel",
            params: [:],
            method: .put,
            isAuth: true,
            responseType: String.self
        ) { result in
            
            ProgressHUD.dismiss{
                self.maintenanceRequests.removeAll()
                self.getMantanceRequests()
            }
        }
    }
}


extension MaintenanceRequestsVC : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return maintenanceRequests.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:  RequestCollectionViewCell.identifier, for: indexPath) as! RequestCollectionViewCell
        cell.configure(object: maintenanceRequests[indexPath.row])
        cell.onCancelRequest = {
            self.cancelMaintenanceRequest(requestId: self.maintenanceRequests[indexPath.row].id!)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let height = collectionView.frame.height
        return CGSize(width: width, height: 100)
    }
}


extension MaintenanceRequestsVC {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    
    
        if scrollView == self.allRequestsCollectionView {
            if ((scrollView.contentOffset.x + scrollView.frame.size.width) >= (scrollView.contentSize.width)) {
                
                if !isLoading {
                    
                    if self.currentPage < self.totalPage {
                        self.currentPage += 1
                        self.getMantanceRequests(currentPage:  self.currentPage)
                        self.isLoading = true
                    }else{
                        print("stop")
                    }
                    
                }
            }
        }
    }
}




