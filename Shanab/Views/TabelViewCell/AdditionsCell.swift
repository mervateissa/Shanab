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
    var selectionOption: (() ->Void)?
    @IBOutlet weak var optionBN: DLRadioButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    @IBAction func radioButtonAction(_ sender: DLRadioButton) {
        selectionOption?()
    }
    func config(name: String, selected: Bool) {
        optionBN.setTitle(name, for: .normal)
        if selected {
            optionBN.isSelected = true
        } else {
            optionBN.isSelected = false
        }
        
    }
   
    
    
}
