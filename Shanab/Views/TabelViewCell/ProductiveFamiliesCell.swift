//
//  ProductiveFamiliesCell.swift
//  Shanab
//
//  Created by Macbook on 3/31/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit
import Cosmos
import Kingfisher
class ProductiveFamiliesCell: UITableViewCell {
    @IBOutlet weak var staticLB: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var cosmos: CosmosView!
    @IBOutlet weak var familyName: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        productImage.setRounded()
        staticLB.adjustsFontSizeToFitWidth = true
        staticLB.minimumScaleFactor = 0.5
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
    }
    func config(familyName: String, time: Int, imagePath: String, productName: String, price: Double, rate: Double) {
        if imagePath != "" {
            guard let imageURL = URL(string: imagePath) else { return }
            self.productImage.kf.setImage(with: imageURL)
        } else {
            self.productImage.image = #imageLiteral(resourceName: "logo")
        }
        
        self.productName.text = productName
        self.familyName.text = familyName
        self.time.text = "\(time)"
        self.price.text = "\(price)"
        self.cosmos.rating = rate
    }
    
}
