//
//  SectionCell.swift
//  Shanab
//
//  Created by Macbook on 27/07/2020.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit

class SectionCell: UICollectionViewCell {
    @IBOutlet weak var sectionName: UILabel!
    @IBOutlet weak var sectionImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.sectionName.adjustsFontSizeToFitWidth = true
        self.sectionName.minimumScaleFactor = 0.5
        sectionImage.setRounded()
        // Initialization code
    }
    func config( imagePath: String, name: String){
           if imagePath != "" {
               guard let imageURL = URL(string: imagePath) else { return }
               self.sectionImage.kf.setImage(with: imageURL)
           } else {
               self.sectionImage.image = #imageLiteral(resourceName: "shanab loading")
           }
           
           self.sectionName.text = name
       }

}
