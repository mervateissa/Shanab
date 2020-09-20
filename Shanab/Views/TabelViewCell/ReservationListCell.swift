//
//  ReservationListCell.swift
//  Shanab
//
//  Created by Macbook on 3/31/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit
import Kingfisher
class ReservationListCell: UITableViewCell {
    @IBOutlet weak var restaurantName: UILabel!
    @IBOutlet weak var restaurantImage: UIImageView!
    @IBOutlet weak var cancel: UIButton!
    var Cancel: (() ->Void)? = nil
    var goToDetails: (() -> Void)? = nil
    @IBOutlet weak var details: UIButton!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var orderType: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    func config(orderName: String, date: String, status: String, imagePath: String) {
        if imagePath != "" {
            guard let imageURL = URL(string:  imagePath) else { return }
            self.restaurantImage.kf.setImage(with: imageURL)
        } else {
            self.restaurantImage.image = #imageLiteral(resourceName: "shanab loading")
        }
        
        self.orderType.text = status
        self.date.text = date
        self.restaurantName.text = orderName
    }
    @IBAction func reservationCanceling(_ sender: UIButton) {
        Cancel?()
    }
    
    @IBAction func reservationDetails(_ sender: UIButton) {
        goToDetails?()
    }
}
