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
    private let UserCreateOrderVCPresenter = UserCreateOrderPresenter(services: Services())
    override func viewDidLoad() {
        super.viewDidLoad()
        UserCreateOrderVCPresenter.setCreateViewDelegate(CreateOrderViewDelegate: self)

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
extension PaymentGatewayVC: CreateOrderViewDelegate {
    func CreateOrderResult(_ error: Error?, _ result: SuccessError_Model?) {
        if let resultMsg = result {
          if resultMsg.successMessage != "" {
              displayMessage(title: "", message: resultMsg.successMessage , status: .success, forController: self)
            let sb = UIStoryboard(name: "PopUps", bundle: nil).instantiateViewController(withIdentifier: "OrderConfirmationPopUp")
                   sb.modalPresentationStyle = .overCurrentContext
                   sb.modalTransitionStyle = .crossDissolve
                   self.present(sb, animated: true, completion: nil)
          } else if resultMsg.latitude != [""] {
            displayMessage(title: "", message: resultMsg.latitude[0], status: .error, forController: self)
          } else if resultMsg.longitude != [""] {
            displayMessage(title: "", message: resultMsg.longitude[0], status: .error, forController: self)
          } else if resultMsg.quantity != [""] {
            displayMessage(title: "", message: resultMsg.currency[0], status: .error, forController: self)
          } else if resultMsg.quantity != [""] {
            displayMessage(title: "", message: resultMsg.quantity[0], status: .error, forController: self)
          } else if resultMsg.total != [""] {
            displayMessage(title: "", message: resultMsg.total[0], status: .error, forController: self)
          } else if resultMsg.message != [""] {
            displayMessage(title: "", message: resultMsg.message[0], status: .error, forController: self)
          } else if resultMsg.cartItems != [""] {
            displayMessage(title: "", message: resultMsg.cartItems[0], status: .error, forController: self)
            }
          }
       
        
    }
    
    
}
