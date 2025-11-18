//
//  FileDetailsVC.swift
//  Majma3ak
//
//  Created by Moamen Hassaballah on 05/11/2025.
//

import UIKit
import Kingfisher
import PDFKit
import ProgressHUD
import Photos
import Alamofire

class RequestedFileDetailsVC: UIViewController {
    
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var rejectionReason: UILabel!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var uploadedFilesTableView: UITableView!
    @IBOutlet weak var uploadFileBtn: UIButton!
    
    var document: DocumentRequest!
    var requestDocuments: [DocumentItem] = []
    
    
    lazy var imageView: UIImageView = {
        let iv = UIImageView(frame: parentView.bounds)
        iv.contentMode = .scaleAspectFit
        iv.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return iv
    }()
    lazy var pdfView: PDFView = {
        let v = PDFView(frame: parentView.bounds)
        v.autoScales = true
        v.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return v
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        guard document != nil else { return }
        
        configure()
        
        uploadedFilesTableView.dataSource = self
        uploadedFilesTableView.delegate = self
        uploadedFilesTableView.register(UINib(nibName: String(describing: DocumentCardCell.self), bundle: nil), forCellReuseIdentifier: String(describing: DocumentCardCell.self))
        uploadedFilesTableView.showsVerticalScrollIndicator = false
        uploadedFilesTableView.showsHorizontalScrollIndicator = false
        //uploadFileBtn.isHidden = document?.status?.lowercased() != "pending"
        
        
        // Remove previous subviews
//        parentView.subviews.forEach { $0.removeFromSuperview() }
//        if doc.file_type.lowercased() == "png" {
//            parentView.addSubview(imageView)
//            if let url = URL(string: doc.file_url) {
//                imageView.kf.setImage(with: url)
//            }
//        } else if doc.file_type.lowercased() == "pdf" {
//            parentView.addSubview(pdfView)
//            if URL(string: doc.file_url) != nil {
//                downloadFile(from: doc.file_url) { localUrl in
//                    if let localUrl = localUrl {
//                        self.pdfView.document = PDFDocument(url: localUrl)
//                    }
//                }
//            }
//        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchRequestData()
    }
    
    
    func configure() {
        guard let document else { return }
        titleLabel.text = document.title
        descriptionLabel.text = document.description
        statusLabel.text = document.status?.loclize_
        
        switch document.status?.lowercased() {
        case "rejected":
            statusView.backgroundColor = UIColor.systemRed
        case "approved":
            statusView.backgroundColor = UIColor.systemGreen
        case "pending":
            statusView.backgroundColor = UIColor.systemOrange
        default:
            statusView.backgroundColor = UIColor.lightGray
        }
        
        if let reason = document.rejectionReason, !reason.isEmpty {
            self.rejectionReason.isHidden = false
            self.rejectionReason.text = reason
        } else {
            self.rejectionReason.isHidden = true
        }
        
        requestDocuments = document.documents ?? []
        uploadedFilesTableView.reloadData()
    }
    
    private func fetchRequestData() {
        guard let document else { return }
        ProgressHUD.progress("loading..".loclize_, 0)
        WebService.shared.sendRequest(
            url: Request.uploadRequestedDocuments + "\(document.id!)",
            method: .get,
            isAuth: true,
            responseType: SingleDocumentRequestResponse.self) { result in
                switch result {
                case .success(let data):
                    ProgressHUD.dismiss()
                    self.document = data.data
                    self.configure()
                    
                case .failure(let error):
                    DispatchQueue.main.async {
//
                        ProgressHUD.failed(error.localizedDescription) // أو أي أداة عرض تنبيهات تستخدمها
                    }
                }
            }
    }

    @IBAction func onBackClicked(_ sender: Any) {
        self.pop()
    }
    
    
    func downloadFile(from urlString: String, completion: @escaping (URL?) -> Void) {
        guard let url = URL(string: urlString) else { completion(nil); return }
        let task = URLSession.shared.downloadTask(with: url) { tempUrl, response, error in
            guard let tempUrl = tempUrl, error == nil else {
                DispatchQueue.main.async { completion(nil) }
                return
            }
            // Move file to a temp location with correct extension
            let fileExtension = (url.pathExtension.isEmpty ? "tmp" : url.pathExtension)
            let fileName = UUID().uuidString + "." + fileExtension
            let fileManager = FileManager.default
            let docsDir = fileManager.temporaryDirectory
            let destUrl = docsDir.appendingPathComponent(fileName)
            try? fileManager.removeItem(at: destUrl)
            do {
                try fileManager.moveItem(at: tempUrl, to: destUrl)
                DispatchQueue.main.async { completion(destUrl) }
            } catch {
                DispatchQueue.main.async { completion(nil) }
            }
        }
        task.resume()
    }
    
    
    @IBAction func onUploadNewFile(_ sender: Any) {
        let vc = UIStoryboard.mainStoryBoard.instantiateViewController(withIdentifier: "UploadFileVC") as? UploadFileVC
        vc?.requestId = document.id
        vc?.push()
    }
    
    func deleteDocument(at indexPath: IndexPath) {
        
        let alert = UIAlertController(title: "Confirm Delete".loclize_, message: "Are you sure you want to delete this file?".loclize_, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel".loclize_, style: .cancel))
        alert.addAction(UIAlertAction(title: "Delete".loclize_, style: .destructive, handler: { _ in
            ProgressHUD.progress("Deleting...".loclize_, 0)
            
            WebService.shared.sendRequest(
                url: Request.documentsPrefix + "\(self.requestDocuments[indexPath.row].id!)",
                method: .delete,
                isAuth: true,
                responseType: DeleteDocumentResponse.self) { result in
                    switch result {
                    case .success(_):
                        ProgressHUD.dismiss()
                        self.requestDocuments.remove(at: indexPath.row)
                        self.uploadedFilesTableView.reloadData()
//                        self.fetchRequestData()
                        
                    case .failure(let error):
                        DispatchQueue.main.async {
    //
                            ProgressHUD.failed(error.localizedDescription) // أو أي أداة عرض تنبيهات تستخدمها
                        }
                    }
                }
            
            
//            let url = "https://your.api/requested_documents/\(requestId)/delete-file/\(docId)" // Adjust BASE URL as needed
//            AF.request(url, method: .delete).response { response in
//                ProgressHUD.dismiss {
//                    if response.error == nil, let code = response.response?.statusCode, code == 200 || code == 204 {
//                        ProgressHUD.success("File deleted")
////                        self.document.documents?.remove(at: indexPath.row)
//                        self.uploadedFilesTableView.deleteRows(at: [indexPath], with: .automatic)
//                    } else {
//                        ProgressHUD.failed("Could not delete file")
//                    }
//                }
//            }
        }))
        self.present(alert, animated: true)
    }
    
}

extension RequestedFileDetailsVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requestDocuments.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: DocumentCardCell.self), for: indexPath) as! DocumentCardCell
        
        
        guard let docItem = document.documents?[indexPath.row] else { return cell }
        cell.configure(
            imageUrl: docItem.filePath,
            description: docItem.description ?? docItem.fileName ?? "",
            type: docItem.fileType ?? "",
            documentType: docItem.fileName ?? ""
        )
        cell.onTap = {
            // Implement preview or download if desired
            
            let vc = UIStoryboard.mainStoryBoard.instantiateViewController(withIdentifier: "FileDetailsVC") as? FileDetailsVC
            vc?.document = UserDocument(id: docItem.id ?? -1, user_id: "", apartment_id: "", file_name: docItem.fileName, file_path: docItem.filePath ?? "", file_url: docItem.filePath ?? "", file_type: docItem.fileType ?? "", document_type: "", description: docItem.description ?? "", apartment: nil, created_at: "", updated_at: "")
            vc?.push()
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Only allow delete if status is "rejected"
        return document.status?.lowercased() != "approved"
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard self.tableView(tableView, canEditRowAt: indexPath) else { return nil }
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete".loclize_) { [weak self] (_, _, completionHandler) in
            self?.deleteDocument(at: indexPath)
            completionHandler(true)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
