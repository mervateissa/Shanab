//
//  ListCell.swift
//  Shanab
//
//  Created by Macbook on 3/24/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit
import Kingfisher
class ListCell: UITableViewCell {
    @IBOutlet weak var resturantName: UILabel!
    var goToDetails: (() ->Void)? = nil
    var FollowOrder:(() ->Void)? = nil
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var orderNum: UILabel!
    @IBOutlet weak var date: UILabel!
//    @IBOutlet weak var nameLB: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }
    func config( date: String, status: String, orderNumber: Int) {
 
        self.date.text = date
        self.status.text = status
        self.orderNum.text = "\(orderNumber)"

    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    @IBAction func orderDetails(_ sender: UIButton) {
         goToDetails?()
    }
    
    @IBAction func orderFollwing(_ sender: UIButton) {
        FollowOrder?()
    }
}
