//
//  FavoriteCell.swift
//  Shanab
//
//  Created by Macbook on 3/30/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit
import Kingfisher
class FavoriteCell: UITableViewCell {
    var AddToCart: (() ->Void)? =  nil
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var details: UILabel!
    @IBOutlet weak var price: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
      
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
    }
    func config(name: String, details: String, imagePath: String) {
        if imagePath != "" {
            guard let imageURL = URL(string:  imagePath) else { return }
            self.productImage.kf.setImage(with: imageURL)
        } else {
            self.productImage.image = #imageLiteral(resourceName: "shanab loading")
        }
        
        self.name.text = name
        self.details.text = details
    }
    
    @IBAction func AddToCart(_ sender: Any) {
        AddToCart?()
    }
    
}
