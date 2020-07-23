//
//  OrderFollowingVC.swift
//  Shanab
//
//  Created by Macbook on 3/30/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit

class OrderFollowingVC: UIViewController {
    @IBOutlet weak var orderNum: UILabel!
    @IBOutlet weak var orderDate: UILabel!
    @IBOutlet weak var new: UIImageView!
    @IBOutlet weak var delivering: UIImageView!
    @IBOutlet weak var delivered: UIImageView!
    @IBOutlet weak var orderFollowing: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    

    @IBAction func Dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

    @IBAction func Comlpeleted(_ sender: Any) {
        let sb = UIStoryboard(name: "PopUps", bundle: nil).instantiateViewController(withIdentifier: "RatingVC")
                     sb.modalPresentationStyle = .overCurrentContext
                     sb.modalTransitionStyle = .crossDissolve
                     self.present(sb, animated: true, completion: nil)
              
    }
}
