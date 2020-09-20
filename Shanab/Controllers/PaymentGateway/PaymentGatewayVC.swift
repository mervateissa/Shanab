//
//  PaymentGatewayVC.swift
//  Shanab
//
//  Created by Macbook on 5/6/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit
import DLRadioButton
class PaymentGatewayVC: UIViewController {
    @IBOutlet weak var radioButton: DLRadioButton!
    let Userdefaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
       
        

    }
    @IBAction func dismiss(_ sender: Any) {
    }
    @IBAction func RadioButtonAction(_ sender: DLRadioButton) {
        switch radioButton.tag {
        case 1:
            print("Master Card")
        case 2:
            print("")
        case 3:
            print("")
        case 4:
            print("")
        default:
            break
        }
    }
//    let cart = CartCoreData.getCurrentCart() ?? CartModel()
//    @IBAction func Confirm(_ sender: Any) {
//        let lat = UserDefaults.value(forKey: "longitude")
//         let long = UserDefaults.value(forKey: "Latitude")
//        UserCreateOrderVCPresenter.showIndicator()
//        UserCreateOrderVCPresenter.postUserCreateOrder(lat: lat as! Double, long: long as! Double, currency: cart.Currency ?? "", quantity: 0, total: (Int(cart.totalPrice ?? 0)), cartItems: cart.items ?? [], message: cart.cartNotes ?? "")
//        
//        
//    }
}
