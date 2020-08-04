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
    @IBOutlet weak var optionBN: DLRadioButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        func config(name: String, selected: Bool) {
//             self.name.text = name
//            if selected {
//               
//                self.name.backgroundColor = #colorLiteral(red: 0.8121929765, green: 0.2939046025, blue: 0.2674312294, alpha: 1)
//                self.name.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//            } else {
//                self.name.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//                self.name.textColor = #colorLiteral(red: 0.8121929765, green: 0.2939046025, blue: 0.2674312294, alpha: 1)
//            }
//            
        }
    }
    @IBAction func selection(_ radioButton: DLRadioButton) {
        switch radioButton.tag {
        case 1:
            print("Chees fries")
            
        default:
            break
        }
        
    }
    
    
}
