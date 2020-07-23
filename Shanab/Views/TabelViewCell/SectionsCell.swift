//
//  SectionsCell.swift
//  Shanab
//
//  Created by Macbook on 3/25/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit
import Cosmos
import Kingfisher
class SectionsCell: UITableViewCell {
    @IBOutlet weak var productImage: CustomImageView!
  
    @IBOutlet weak var sectionName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        productImage.setRounded()
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
    }
    
    func config( imagePath: String, name: String){
        if imagePath != "" {
            guard let imageURL = URL(string: imagePath) else { return }
            self.productImage.kf.setImage(with: imageURL)
        } else {
            self.productImage.image = #imageLiteral(resourceName: "shanab loading")
        }
        
        self.sectionName.text = name
    }
    
    
    
}
