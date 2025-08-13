//
//  AboutSystemVC.swift
//  Majma3ak
//
//  Created by Moamen Hassaballah on 11/08/2025.
//

import UIKit

class AboutSystemVC: UIViewController {
    @IBOutlet weak var aboutSystemLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isHiddenNavigation =  false
        aboutSystemLabel.text = "AboutSystemText".loclize_
        aboutSystemLabel.font = UIFont(name: "FFShamelFamily-SansOneBook", size: aboutSystemLabel.font.pointSize)
        
    }
    
    
    @IBAction func didTapBack(_ sender: Any) {
        self.pop()
    }

}
