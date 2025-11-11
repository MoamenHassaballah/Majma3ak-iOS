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

class RequestedFileDetailsVC: UIViewController {
    
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var rejectionReason: UILabel!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var uploadedFilesTableView: UITableView!
    
    var document: DocumentRequest!
    
    
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
        guard let document = document else { return }
        
        configure(title: document.title ?? "", description: document.description ?? "", rejectionReason: document.rejectionReason ?? "", status: document.status ?? "")
        
        uploadedFilesTableView.dataSource = self
        uploadedFilesTableView.delegate = self
        uploadedFilesTableView.register(UINib(nibName: String(describing: DocumentCardCell.self), bundle: nil), forCellReuseIdentifier: String(describing: DocumentCardCell.self))
        
        
        
        
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
    
    
    func configure(title: String, description: String, rejectionReason: String?, status: String) {
        titleLabel.text = title
        descriptionLabel.text = description
        statusLabel.text = status.loclize_
        
        switch status.lowercased() {
        case "rejected":
            statusView.backgroundColor = UIColor.systemRed
        case "approved":
            statusView.backgroundColor = UIColor.systemGreen
        case "pending":
            statusView.backgroundColor = UIColor.systemOrange
        default:
            statusView.backgroundColor = UIColor.lightGray
        }
        
        if let reason = rejectionReason, !reason.isEmpty {
            self.rejectionReason.isHidden = false
            self.rejectionReason.text = reason
        } else {
            self.rejectionReason.isHidden = true
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
    
    
}

extension RequestedFileDetailsVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return document.documents?.count ?? 0
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
}
