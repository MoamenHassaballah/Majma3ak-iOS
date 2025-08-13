//
//  TermOfServiceAlertViewController.swift
//  Majma3ak
//
//  Created by Moamen Hassaballah on 13/08/2025.
//

import UIKit
import BEMCheckBox

class TermOfServiceAlertViewController: UIViewController {
    
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var termsLabel: UILabel!
    @IBOutlet weak var doneReadingBox: BEMCheckBox!
    @IBOutlet weak var iAgreeBtn: UIButton!
    
    var onAgree: ((Bool) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        doneReadingBox.boxType = .square
        iAgreeBtn.layer.backgroundColor = UIColor.systemGray2.cgColor
        termsLabel.text = "TermsOfServiceText".loclize_
//        termsLabel.text = "TermsOfServiceText".loclize_
    }

    @IBAction func onCloseClick(_ sender: Any) {
        onAgree?(false)
        dismiss(animated: true)
    }
    
    
    @IBAction func onAgreeClick(_ sender: Any) {
        onAgree?(true)
        dismiss(animated: true)
    }
    
    
    @IBAction func onBoxUpdate(_ sender: BEMCheckBox) {
        iAgreeBtn.isEnabled = sender.on
        
        iAgreeBtn.layer.backgroundColor = sender.on ? UIColor.customColorFont.cgColor : UIColor.systemGray2.cgColor
    }
    
    
}
