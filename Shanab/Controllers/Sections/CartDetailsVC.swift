//
//  CartDetailsVC.swift
//  Shanab
//
//  Created by Macbook on 28/07/2020.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit

class CartDetailsVC: UIViewController {

    @IBOutlet weak var quantity: UILabel!
    @IBOutlet weak var mealComponents: UILabel!
    @IBOutlet weak var calories: UILabel!
    @IBOutlet weak var mealImage: UIImageView!
    @IBOutlet weak var notes: UITextField!
    @IBOutlet weak var mealNameLB: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    

    @IBAction func decreases(_ sender: UIButton) {
    }
    

    @IBAction func increase(_ sender: UIButton) {
    }
}
