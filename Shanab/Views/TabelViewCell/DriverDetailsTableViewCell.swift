//
//  DriverDetaisTableViewCell.swift
//  Shanab
//
//  Created by Macbook on 6/28/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit

class DriverDetailsTableViewCell: UITableViewCell {
    @IBOutlet weak var numberLB: UILabel!
    @IBOutlet weak var priceLB: UILabel!
    
    @IBOutlet weak var nameLB: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func config(name: String, number: Int, price: Int) {
        self.nameLB.text = name
        self.numberLB.text = "\(number)"
        self.priceLB.text = "\(price)"
    }
    
}
