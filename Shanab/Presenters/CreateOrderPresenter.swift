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
    func postUserCreateOrder(lat: Double, long: Double, currency: String, quantity: Int, total: Int, cartItems: [CartModelItem], message: String) {
        services.postUserCreateOrder(lat: lat, long: long, quantity: quantity, currency: currency, total: total, message: message, cartItems: cartItems) {[weak self](error: Error?, result: SuccessError_Model?) in
            self?.CreateOrderViewDelegate?.CreateOrderResult(error, result)
            self?.dismissIndicator()
        }
    }
}
