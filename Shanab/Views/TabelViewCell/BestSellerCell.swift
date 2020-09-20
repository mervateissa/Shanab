//
//  BestSellerCell.swift
//  Shanab
//
//  Created by Macbook on 3/23/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit
import Kingfisher
class BestSellerCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var FavoriteBN: UIButton!
    @IBOutlet weak var mealComponants: UILabel!
    @IBOutlet weak var mealImage: UIImageView!
    var goToFavorites: (() ->Void)? = nil
    @IBOutlet weak var price: UILabel!
    var addToCart:(() ->Void)? = nil
    var isFavourite = true
    override func awakeFromNib() {
        super.awakeFromNib()
        mealImage.setRounded()
        
    }
    func config(imagePath: String, name: String, mealComponants: String, price: Double) {
        
        if (!imagePath.contains("http")) {
            guard let imageURL = URL(string: (BASE_URL + "/" + imagePath).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") else { return }
            print(imageURL)
            self.mealImage.kf.setImage(with: imageURL)
        }  else if imagePath != "" {
            guard let imageURL = URL(string: imagePath) else { return }
            self.mealImage.kf.setImage(with: imageURL)
        } else {
            self.mealImage.image = #imageLiteral(resourceName: "shanab loading")
        }
        
        self.name.text = name
        
        self.price.text = "\(price)"
        self.mealComponants.text = mealComponants
        
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
    }
    
    @IBAction func favorite(_ sender: UIButton) {
        goToFavorites?()
        if isFavourite {
            FavoriteBN.setImage(#imageLiteral(resourceName: "heart-1"), for: .normal)
            isFavourite = false
        }
        else {
            FavoriteBN.setImage(#imageLiteral(resourceName: "heart 2"), for: .normal)
            isFavourite = true
            
        }
    }
    @IBAction func addToCart(_ sender: UIButton) {
        addToCart?()
    }
}

