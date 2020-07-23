//
//  ReservationCell.swift
//  Shanab
//
//  Created by Macbook on 3/29/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit
import Kingfisher
class ReservationCell: UICollectionViewCell {
    @IBOutlet weak var selectionNumber: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    
        
    }
    func config(selectionNumber: Int, selected: Bool) {
        
        self.selectionNumber.text = "\(selectionNumber)"
        if selected {
            self.selectionNumber.backgroundColor = #colorLiteral(red: 0.8121929765, green: 0.2939046025, blue: 0.2674312294, alpha: 1)
            self.selectionNumber.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        } else {
            self.selectionNumber.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.selectionNumber.textColor = #colorLiteral(red: 0.8121929765, green: 0.2939046025, blue: 0.2674312294, alpha: 1)
        }
        
    }
    
    
}
