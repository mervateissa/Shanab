//
//  SearchCell.swift
//  Shanab
//
//  Created by Macbook on 3/25/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit

class SearchCell: UITableViewCell {
    @IBOutlet weak var searchImage: UIImageView!
    @IBOutlet weak var familyName: UILabel!
    @IBOutlet weak var section: UILabel!
    @IBOutlet weak var rate: UILabel!
    @IBOutlet weak var price: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
      
    }
    func config(name: String, searchImage: UIImage, section: String, price: String) {
        
    self.familyName.text = name
    self.price.text = price
    self.section.text = section
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    
}
