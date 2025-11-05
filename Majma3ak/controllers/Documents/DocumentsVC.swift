//
//  DocumentsVC.swift
//  Majma3ak
//
//  Created by Moamen Hassaballah on 03/11/2025.
//

import UIKit
import Kingfisher
import ProgressHUD


class DocumentsVC: UIViewController {
    
    @IBOutlet weak var documentsTableView: UITableView!
    
    @IBOutlet weak var loaderDocuments: UIActivityIndicatorView!
    @IBOutlet weak var emptyStateLabel: UILabel!
    var documents: [UserDocument] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        
        documentsTableView.delegate = self
        documentsTableView.dataSource = self
        documentsTableView.showsVerticalScrollIndicator = false
        documentsTableView.showsHorizontalScrollIndicator = false
        documentsTableView.register(UINib(nibName: String(describing: DocumentCardCell.self), bundle: nil), forCellReuseIdentifier: String(describing: DocumentCardCell.self))
        
        fetchDocuments()
    }
    
    func fetchDocuments() {
        // TODO: API call
        
        
        self.emptyStateLabel.isHidden = true
        self.loaderDocuments.startAnimating()
//            self.loaderMaintenanceRequests.isHidden = false

        
        WebService.shared.sendRequest(
            url: Request.documents + "per_page=50",
            method: .get,
            isAuth: true,
            responseType: DocumentResponse.self) { result in
                self.loaderDocuments.stopAnimating()
                
                switch result {
                case .success(let data):
                   
                    self.documents = data.data
                    self.documentsTableView.reloadData()

                    self.emptyStateLabel.isHidden = !self.documents.isEmpty
                    
                    
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

extension DocumentsVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return documents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

       
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: DocumentCardCell.self), for: indexPath) as! DocumentCardCell
        
        let document = documents[indexPath.row]
        cell.configure(imageUrl: document.file_url, description: document.description, type: document.file_type)
        
        cell.onTap = {
            print(document.description)
        }
        
        return cell
    }
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 270
//    }
}
