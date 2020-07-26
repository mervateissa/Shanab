//
//  AdditionsCell.swift
//  Shanab
//
//  Created by Macbook on 23/07/2020.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit
import DLRadioButton
class AdditionsCell: UITableViewCell {
 var appetizer = String()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    @IBAction func selection(_ radioButton: DLRadioButton) {
        switch radioButton.tag {
        case 1:
            print("Chees fries")
            self.appetizer = "chees"
        case 2:
            print("ketchup fries")
            self.appetizer = "pepsci"
        case 3:
            print("ketchup")
            self.appetizer = "ketchup"
        default:
            break
        }
        
    }
    
    
}
