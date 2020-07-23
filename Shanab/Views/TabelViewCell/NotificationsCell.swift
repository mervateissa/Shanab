//
//  NotificationsCell.swift
//  Shanab
//
//  Created by Macbook on 3/29/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit

class NotificationsCell: UITableViewCell {
     var delete: (() ->Void)? = nil
    @IBOutlet weak var notificationName: UILabel!
    @IBOutlet weak var status: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    func config(name: String, status:String){
        self.notificationName.text = name
        self.status.text = status
    }
    @IBAction func deleteBN(_ sender: UIButton) {
        delete?()
      
    }
    
}
