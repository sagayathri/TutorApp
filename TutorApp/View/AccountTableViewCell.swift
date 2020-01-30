//
//  AccountTableViewCell.swift
//  TutorApp
//

import UIKit

class AccountTableViewCell: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var nextImage: UIImageView!
   
    var rowItem: String = "" {
        didSet {
            self.configureCell()
        }
    }
    
    func configureCell() {
        if rowItem  == "Logout" {
            nextImage.isHidden = true
            label.textColor = .red
        }
        else {
            nextImage.isHidden = false
            label.textColor = .label
        }
        label.text = rowItem
    }
}
