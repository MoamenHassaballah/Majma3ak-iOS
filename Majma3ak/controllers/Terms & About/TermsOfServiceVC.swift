//
//  TermsOfServiceViewController.swift
//  Majma3ak
//
//  Created by Moamen Hassaballah on 11/08/2025.
//

import UIKit

class TermsOfServiceVC: UIViewController {

    @IBOutlet weak var termsOfServiceLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
        termsOfServiceLabel.text = "TermsOfServiceText".loclize_
        termsOfServiceLabel.font = UIFont(name: "FFShamelFamily-SansOneBook", size: termsOfServiceLabel.font.pointSize)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isHiddenNavigation = false
    }
    

    @IBAction func didTapBack(_ sender: Any) {
        self.pop()
    }
}
