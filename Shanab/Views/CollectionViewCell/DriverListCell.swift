//
//  DriverListCell.swift
//  Shanab
//
//  Created by Macbook on 6/21/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit
import Cosmos
class DriverListCell: UICollectionViewCell {
    @IBOutlet weak var customerPic: UIImageView!
    @IBOutlet weak var customerName: UILabel!
    @IBOutlet weak var rate: CosmosView!
    @IBOutlet weak var customerAddress: UILabel!
     var goToDetails: (() ->Void)? = nil
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func config(Name: String, imagePath: String, rate: Double, address: String) {
        guard let imageURL = URL(string: BASE_URL + "/" + imagePath) else { return }
               self.customerPic.kf.setImage(with: imageURL)
        self.customerName.text = Name
        self.customerAddress.text = address
        self.rate.text = "\(rate)"
       
    }

    @IBAction func goToDetails(_ sender: Any) {
        goToDetails?()
    }
}
