//
//  RequestTypePopUpVC.swift
//  Shanab
//
//  Created by Macbook on 5/6/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit
import DLRadioButton
class RequestTypePopUpVC: UIViewController {
    @IBOutlet weak var local: DLRadioButton!
    @IBOutlet weak var pasherlyBN: DLRadioButton!
    @IBOutlet weak var radioButton: DLRadioButton!
    @IBOutlet weak var visa: DLRadioButton!
    @IBOutlet weak var cach: DLRadioButton!
    var CartIems = [onlineCart]()
    var quantity_cart = Int()
    var total = Double()
    var address_id = Int()
    var carruncy = String()
     var deletedIndex: Int = 0
    private let UserCreateOrderVCPresenter = UserCreateOrderPresenter(services: Services())
    override func viewDidLoad() {
        super.viewDidLoad()
        UserCreateOrderVCPresenter.setCreateViewDelegate(CreateOrderViewDelegate: self)

    }
    
    @IBAction func RadioButtonAction(_ sender: DLRadioButton) {
        switch radioButton.tag {
        case 1:
            print("International")
        case 2:
            print("Local")
        case 3:
            print("Pasherly")
        default:
            break
        }
    }
    @IBAction func PaymentRadioButtonAction(_ sender: DLRadioButton) {
        switch radioButton.tag {
        case 1:
            print("Ok")
        case 2:
            print("Enter Your Information")
        default:
            break
        }
    }
    @IBAction func confirm(_ sender: Any) {
        let longitude = Constants.long
               let latitude = Constants.lat
        UserCreateOrderVCPresenter.showIndicator()
        UserCreateOrderVCPresenter.postUserCreateOrder(lat: latitude, long: longitude, currency:  "SAR", quantity: quantity_cart, total: Int(total) , cartItems: Singletone.instance.cart, message: "", address_id: address_id)

    }
}
extension RequestTypePopUpVC: CreateOrderViewDelegate {
    func postDeleteCart(_ error: Error?, _ result: SuccessError_Model?) {
         if let resultMsg = result {
                   if resultMsg.successMessage == "" {
                       displayMessage(title: "scuccess", message: resultMsg.successMessage, status: .success, forController: self)
                       self.CartIems.remove(at: deletedIndex)
                   } else if !resultMsg.condition.isEmpty ,resultMsg.condition != [""] {
                       displayMessage(title: "", message: resultMsg.condition[0], status: .error, forController: self)
                   } else if !resultMsg.id.isEmpty ,resultMsg.id != [""] {
                       displayMessage(title: "", message: resultMsg.id[0], status: .error, forController: self)
                   }
               }
    }
    
    func getCartResult(_ error: Error?, _ result: [onlineCart]?) {
          if let cart_items = result {
            self.CartIems = cart_items
              }
    }
    
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
