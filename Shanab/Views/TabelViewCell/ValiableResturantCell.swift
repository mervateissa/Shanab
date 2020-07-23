//
//  ValiableResturantCell.swift
//  Shanab
//
//  Created by Macbook on 3/23/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit
import Kingfisher
import Cosmos
class ValiableResturantCell: UITableViewCell {
    @IBOutlet weak var staticLB: UILabel!
    @IBOutlet weak var staticTime: UILabel!
    @IBOutlet weak var resturantImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var cosmos: CosmosView!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var price: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        staticLB.adjustsFontSizeToFitWidth = true
        staticLB.minimumScaleFactor = 0.5
        staticTime.adjustsFontSizeToFitWidth = true
        staticTime.minimumScaleFactor = 0.5
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func config(name: String, time: String, rate: Double, price: Double, imagePath: String) {
        if imagePath != "" {
            guard let imageURL = URL(string:  imagePath) else { return }
            self.resturantImage.kf.setImage(with: imageURL)
        } else {
            self.resturantImage.image = #imageLiteral(resourceName: "shanab loading")
        }
        
        self.name.text = name
        self.time.text = time
        self.price.text = "\(price)"
        self.cosmos.rating = rate
    }
    
}
