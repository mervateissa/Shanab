//
//  DriverProfilePresenter.swift
//  Shanab
//
//  Created by Macbook on 5/17/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import Foundation
import SVProgressHUD
protocol DriverProfileViewDelegate: class {
    func DriverChangeImageResult(_ error: Error?, _ result: SuccessError_Model?)
    func DriverIsAvaliableChangeResult(_ error: Error?, _ result: SuccessError_Model?)
    func DriverOrderListResult(_ error: Error?, _ list: [OrderList]?, _ orderErrors: OrdersErrors?)
    func getDriverProfileResult(_ error: Error?, _ result: User?)
    func postEditDriverProfileResult(_ error: Error?, _ result: SuccessError_Model?)
}
class DriverProfilePresenter{
    private let services: Services
    private weak var DriverProfileViewDelegate: DriverProfileViewDelegate?
    init(services: Services) {
        self.services = services
    }
    func setDriverProfileViewDelegate(DriverProfileViewDelegate: DriverProfileViewDelegate) {
        self.DriverProfileViewDelegate = DriverProfileViewDelegate
    }
    func showIndicator() {
        SVProgressHUD.show()
    }
    func dismissIndicator() {
        SVProgressHUD.dismiss()
    }
    func postDriverChangeImage(image: UIImage) {
        services.postDriverChangeImage(image: image) {[weak self] (error: Error?, result: SuccessError_Model?,  progress :Progress?) in
            self?.DriverProfileViewDelegate?.DriverChangeImageResult(error, result)
            self?.dismissIndicator()
        }
    }
    func getIsAvailableChange() {
        services.getIsAvailable {[weak self] (error: Error?, result: SuccessError_Model?) in
            self?.DriverProfileViewDelegate?.DriverIsAvaliableChangeResult(error, result)
        }
    }
    func DriverOrderList(type: [String]) {
        services.getDriverOrderList(type: type) {[weak self] (error: Error?, list:[OrderList]?, orderErrors: OrdersErrors?) in
            self?.DriverProfileViewDelegate?.DriverOrderListResult(error, list, orderErrors)
            self?.dismissIndicator()
        }
    }
    func postEditDriverProfile(phone: String, email: String, name_ar: String) {
        services.postDriverEditProfile(phone: phone, name_ar: name_ar, email: email) {[weak self] (error: Error?, result: SuccessError_Model?) in
            self?.DriverProfileViewDelegate?.postEditDriverProfileResult(error, result)
            self?.dismissIndicator()
        }
    }
    func getDriverProfile() {
        services.getDriverProfile { [weak self](error: Error?, result: User?) in
            self?.DriverProfileViewDelegate?.getDriverProfileResult(error, result)
        }
    }
}
