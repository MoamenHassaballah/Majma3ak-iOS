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

class FileDetailsVC: UIViewController {
    
    @IBOutlet weak var parentView: UIView!
    
    var document: UserDocument!
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
        guard let doc = document else { return }
        // Remove previous subviews
        parentView.subviews.forEach { $0.removeFromSuperview() }
        if doc.file_type.lowercased() == "png" {
            parentView.addSubview(imageView)
            if let url = URL(string: doc.file_url) {
                imageView.kf.setImage(with: url)
            }
        } else if doc.file_type.lowercased() == "pdf" {
            parentView.addSubview(pdfView)
            if URL(string: doc.file_url) != nil {
                downloadFile(from: doc.file_url) { localUrl in
                    if let localUrl = localUrl {
                        self.pdfView.document = PDFDocument(url: localUrl)
                    }
                }
            }
        }
    }
    

    @IBAction func onBackClicked(_ sender: Any) {
        self.pop()
    }
    
    
    @IBAction func onDownloadClicked(_ sender: Any) {
        
        guard let doc = document else { return }
        let fileType = doc.file_type.lowercased()
        downloadFile(from: doc.file_url) { localUrl in
            guard let localUrl = localUrl else { return }
            DispatchQueue.main.async {
                if fileType == "png" {
                    if let image = UIImage(contentsOfFile: localUrl.path) {
                        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                        ProgressHUD.success("File downloaded!")
                    }
                } else if fileType == "pdf" {
                    let docPicker = UIDocumentPickerViewController(forExporting: [localUrl])
                    self.present(docPicker, animated: true) {
                        ProgressHUD.success("File downloaded!")
                    }
                } else {
                    // For other file types, fallback to showing success
                    ProgressHUD.success("File downloaded!")
                }
            }
        }
        
        
    }
    
    
    @IBAction func onShareClicked(_ sender: Any) {
        
        guard let doc = document else { return }
        downloadFile(from: doc.file_url) { localUrl in
            guard let localUrl = localUrl else { return }
            let activityVC = UIActivityViewController(activityItems: [localUrl], applicationActivities: nil)
            self.present(activityVC, animated: true)
        }
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
}
