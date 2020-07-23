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
    @IBOutlet weak var orderId: UILabel!
    @IBOutlet weak var cancel: UIButton!
    @IBOutlet weak var statusLB: UILabel!
    var Cancel: (() ->Void)? = nil
    var goToDetails: (() -> Void)? = nil
    @IBOutlet weak var details: UIButton!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var orderNumber: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    func config(orderNumber: Int, date: String, status: String) {
        self.orderNumber.text = "\(orderNumber)"
        self.date.text = date
        self.statusLB.text = status
    }
    @IBAction func reservationCanceling(_ sender: UIButton) {
        Cancel?()
    }
    
    @IBAction func reservationDetails(_ sender: UIButton) {
        goToDetails?()
    }
}
