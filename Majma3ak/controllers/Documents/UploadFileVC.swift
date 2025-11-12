//
//  UploadFileVC.swift
//  Majma3ak
//
//  Created by Moamen Hassaballah on 11/11/2025.
//

import UIKit
import Alamofire
import MobileCoreServices
import UniformTypeIdentifiers
import ProgressHUD

class UploadFileVC: UIViewController, UIDocumentPickerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var selectedFileName: UILabel!
    
    private var selectedFileURL: URL?
    private var selectedImageData: Data?
    private var selectedFileNameString: String?
    private let maxFileSize: Int = 10 * 1024 * 1024 // 10 MB
    
    var requestId: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectedFileName.isHidden = true
    }
    
    @IBAction func onSelectFileClicked(_ sender: Any) {
        let alert = UIAlertController(title: "Select File".loclize_, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera".loclize_, style: .default, handler: { _ in self.presentImagePicker(.camera) }))
        alert.addAction(UIAlertAction(title: "Photo Library".loclize_, style: .default, handler: { _ in self.presentImagePicker(.photoLibrary) }))
        alert.addAction(UIAlertAction(title: "Document".loclize_, style: .default, handler: { _ in self.presentDocumentPicker() }))
        alert.addAction(UIAlertAction(title: "Cancel".loclize_, style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    
    @IBAction func onUploadFileClicked(_ sender: Any) {
//        guard let description = descriptionTextField.text, !description.isEmpty else {
//            showError("Please enter a description.")
//            return
//        }
        guard let fileData = selectedImageData ?? (selectedFileURL != nil ? try? Data(contentsOf: selectedFileURL!) : nil), let _ = selectedFileNameString else {
            showError("Please select a file.".loclize_)
            return
        }
        if fileData.count > maxFileSize {
            showError("File exceeds 10 MB.".loclize_)
            return
        }
        
        if requestId == nil {
            showError("Can't upload file.".loclize_)
            return
        }
        
        ProgressHUD.progress("Uploading file...".loclize_, 8)
        
        let urlString = "\(Request.uploadRequestedDocuments)\(requestId!)/upload" // TODO: Replace with the actual endpoint
        WebService.shared.uploadImage(url: urlString, imageData: fileData, parameters: [
            "description" : description
        ], imageParameter: "file") { result in
            
            switch result {
                case .success:
                print("File uploaded successfully.".loclize_)
                ProgressHUD.success("File uploaded successfully.".loclize_)
                
                
                self.selectedFileURL = nil
                self.selectedImageData = nil
                self.selectedFileNameString = nil
                self.selectedFileName.isHidden = true
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.pop()
                }
                
                
            case .failure(let error):
                print("Failed to upload file: \(error)")
                ProgressHUD.failed("\(error)")
            }
            
        }
        
        
//        AF.upload(multipartFormData: { multipart in
//            multipart.append(fileData, withName: "file", fileName: fileName, mimeType: self.mimeType(for: fileName))
//            multipart.append(description.data(using: .utf8)!, withName: "description")
//        }, to: urlString)
//        .validate()
//        .response { response in
//            ProgressHUD.dismiss {
//                if let error = response.error {
//                    self.showError("Upload failed: \(error.localizedDescription)")
//                } else {
//                    let alert = UIAlertController(title: "Success", message: "File uploaded successfully!", preferredStyle: .alert)
//                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//                    self.present(alert, animated: true, completion: nil)
//                    self.selectedFileURL = nil
//                    self.selectedImageData = nil
//                    self.selectedFileNameString = nil
//                    self.selectedFileName.isHidden = true
//                }
//            }
//            
//        }
    }
    
    @IBAction func onBackClicked(_ sender: Any) {
        self.pop()
    }
    
    private func presentImagePicker(_ sourceType: UIImagePickerController.SourceType) {
        guard UIImagePickerController.isSourceTypeAvailable(sourceType) else { return }
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = sourceType
        picker.allowsEditing = false
        present(picker, animated: true)
    }

    private func presentDocumentPicker() {
        let types: [UTType] = [UTType.pdf, UTType.jpeg, UTType.png]
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: types, asCopy: true)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.originalImage] as? UIImage else { return }
        if let imageData = image.jpegData(compressionQuality: 0.8) {
            if imageData.count > maxFileSize {
                showError("Image exceeds 10 MB.")
                return
            }
            selectedImageData = imageData
            selectedFileURL = nil
            selectedFileNameString = "Image_\(Int(Date().timeIntervalSince1970)).jpg"
            selectedFileName.text = selectedFileNameString
            selectedFileName.isHidden = false
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let url = urls.first else { return }
        let coordinator = NSFileCoordinator()
        var error: NSError? = nil
        var pickedData: Data?
        coordinator.coordinate(readingItemAt: url, options: [], error: &error) { (url) in
            pickedData = try? Data(contentsOf: url)
        }
        guard let data = pickedData else { showError("Could not read file."); return }
        if data.count > maxFileSize {
            showError("File exceeds 10 MB.")
            return
        }
        selectedFileURL = url
        selectedImageData = nil
        selectedFileNameString = url.lastPathComponent
        selectedFileName.text = selectedFileNameString
        selectedFileName.isHidden = false
    }

    private func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func mimeType(for fileName: String) -> String {
        let ext = (fileName as NSString).pathExtension.lowercased()
        switch ext {
        case "jpg", "jpeg": return "image/jpeg"
        case "png": return "image/png"
        case "pdf": return "application/pdf"
        default: return "application/octet-stream"
        }
    }
}
