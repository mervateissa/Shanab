//
//  CartCell.swift
//  Shanab
//
//  Created by Macbook on 3/25/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit
import DLRadioButton
import Kingfisher
class CartCell: UITableViewCell {
    @IBOutlet weak var quantityLB: UILabel!
    var productCounter = 1
    var Increase: (() ->Void)? = nil
    var Dicrease:(() ->Void)? = nil
    var Size:(() ->Void)? = nil
    var delet:(() ->Void)? = nil
    @IBOutlet weak var dicrease: UIButton!
    @IBOutlet weak var orderName: UILabel!
    @IBOutlet weak var orderImage: UIImageView!
    @IBOutlet weak var increase: UIButton!
    @IBOutlet weak var price: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        quantityLB.adjustsFontSizeToFitWidth = true
        quantityLB.minimumScaleFactor = 0.5
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
    }
    func config(name: String, price: Double , imagePath:  String) {
        if imagePath != "" {
            guard let imageURL = URL(string: imagePath) else { return }
                  self.orderImage.kf.setImage(with: imageURL)
        } else {
            self.orderImage.image = #imageLiteral(resourceName: "shanab loading")
        }
      
        self.orderName.text = name
        self.price.text = "\(price)"
        
        
    }
    
    @IBAction func Increase(_ sender: Any) {
        Increase?()
        self.quantityLB.text = "\(productCounter)"
    }
    
    @IBAction func Dicrease(_ sender: UIButton) {
        Dicrease?()
        self.quantityLB.text = "\(productCounter)"
    }
    @IBAction func Size(_ radioButton: DLRadioButton) {
        Size?()
        
    }
    
    @IBAction func delet(_ sender: Any) {
        delet?()
    }
}
