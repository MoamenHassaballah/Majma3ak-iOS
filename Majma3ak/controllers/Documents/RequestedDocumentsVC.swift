//
//  DocumentsVC.swift
//  Majma3ak
//
//  Created by Moamen Hassaballah on 03/11/2025.
//

import UIKit
import Kingfisher
import ProgressHUD


class RequestedDocumentsVC: UIViewController {
    
    @IBOutlet weak var documentsTableView: UITableView!
    
    @IBOutlet weak var loaderDocuments: UIActivityIndicatorView!
    @IBOutlet weak var emptyStateLabel: UILabel!
    var documents: [DocumentRequest] = []
    
    var currentPage: Int = 1
    var totalPagesCount = 1
    var isFetching: Bool = false
    var hasMoreData: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        
        self.emptyStateLabel.isHidden = true
        documentsTableView.delegate = self
        documentsTableView.dataSource = self
        documentsTableView.showsVerticalScrollIndicator = false
        documentsTableView.showsHorizontalScrollIndicator = false
        documentsTableView.register(UINib(nibName: String(describing: RequestedDocumentCell.self), bundle: nil), forCellReuseIdentifier: String(describing: RequestedDocumentCell.self))
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchDocuments()
    }
    
    func fetchDocuments() {
        if isFetching || !hasMoreData {
            return
        }
        isFetching = true
        
        self.emptyStateLabel.isHidden = true
        self.loaderDocuments.startAnimating()
//            self.loaderMaintenanceRequests.isHidden = false
        
        WebService.shared.sendRequest(
            url: Request.requestedDocuments + "per_page=10&page=\(currentPage)",
            method: .get,
            isAuth: true,
            responseType: DocumentRequestsResponse.self) { result in
                self.loaderDocuments.stopAnimating()
                self.isFetching = false
                
                switch result {
                case .success(let data):
                    self.totalPagesCount = data.data?.meta?.totalPages ?? 1
                    
                    let newDocuments = data.data?.documentRequests ?? []
                    self.documents.append(contentsOf: newDocuments)
                    
                    self.hasMoreData = self.totalPagesCount > self.currentPage
                    
                    print("Requests: ", self.documents.count)
                    
                    self.documentsTableView.reloadData()

                    self.emptyStateLabel.isHidden = !self.documents.isEmpty
                    self.currentPage += 1
                    
                case .failure(let error):
                    DispatchQueue.main.async {
//                        self.loaderMaintenanceRequests.stopAnimating()
//                        self.updateEmptyStateView()
                        ProgressHUD.failed(error.localizedDescription) // أو أي أداة عرض تنبيهات تستخدمها
                    }
                }
            }
    }

    @IBAction func onBackPressed(_ sender: Any) {
        print("Back Clicked")
        self.pop()
//        dismiss(animated: true)
    }
    
}

extension RequestedDocumentsVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return documents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

       
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RequestedDocumentCell.self), for: indexPath) as! RequestedDocumentCell
        
        let document = documents[indexPath.row]
        cell.configure(title: document.title ?? "", description: document.description ?? "", rejectionReason: document.rejectionReason ?? "", status: document.status ?? "")

        cell.onParentViewTapped = {
            let vc = UIStoryboard.mainStoryBoard.instantiateViewController(withIdentifier: "RequestedFileDetailsVC") as? RequestedFileDetailsVC
            vc?.document = document
            vc?.push()
        }
        
        return cell
    }
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 270
//    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height
        if offsetY > contentHeight - frameHeight - 100 {
            // near the bottom
            fetchDocuments()
        }
    }
}

