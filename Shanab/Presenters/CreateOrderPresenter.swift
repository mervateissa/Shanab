//
//  CreateOrderPresenter.swift
//  Shanab
//
//  Created by Macbook on 7/14/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import Foundation
import SVProgressHUD
protocol CreateOrderViewDelegate: class {
    func CreateOrderResult(_ error: Error?, _ result: SuccessError_Model?)
    func getCartResult(_ error: Error?, _ result: [onlineCart]?)
    func postDeleteCart(_ error: Error?, _ result: SuccessError_Model?)
}
class UserCreateOrderPresenter {
    private let services: Services
    private weak var CreateOrderViewDelegate: CreateOrderViewDelegate?
    init(services: Services) {
        self.services = services
    }
    func setCreateViewDelegate(CreateOrderViewDelegate: CreateOrderViewDelegate) {
        self.CreateOrderViewDelegate = CreateOrderViewDelegate
    }
    func showIndicator() {
        SVProgressHUD.show()
    }
    func dismissIndicator() {
        SVProgressHUD.dismiss()
    }
    func postUserCreateOrder(lat: Double, long: Double, currency: String, quantity: Int, total: Int, cartItems: [onlineCart], message: String, address_id: Int) {
        services.postUserCreateOrder(lat: lat, long: long, quantity: quantity, currency: currency, total: total, message: message, address_id: address_id, cartItems: cartItems) {[weak self](error: Error?, result: SuccessError_Model?) in
            self?.CreateOrderViewDelegate?.CreateOrderResult(error, result)
            self?.dismissIndicator()
        }
    }
    func getCartItems() {
           services.getCartItems {[weak self] (error: Error?, result: [onlineCart]?) in
               self?.CreateOrderViewDelegate?.getCartResult(error, result)
               self?.dismissIndicator()
           }
       }
    func postDeleteCart(condition: String, id: Int) {
           services.postDeleteCart(condition: condition, id: id) {[weak self] (error: Error?, result: SuccessError_Model?) in
               self?.CreateOrderViewDelegate?.postDeleteCart(error, result)
               self?.dismissIndicator()
           }
       }
}
