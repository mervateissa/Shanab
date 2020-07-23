//
//  OrderDetailsPresenter.swift
//  Shanab
//
//  Created by Macbook on 5/21/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import Foundation
import SVProgressHUD
protocol DriverOrderDetailsViewDelegate: class {
    func DriverOrderDetailsResult(_ error: Error?, _ details: [DriverOrder]?)
     func DriverChangeStatusResult(_ error: Error?, _ result: SuccessError_Model?)
}
class DriverOrderDetailsPresenter {
    private let services: Services
    private weak var DriverOrderDetailsViewDelegate: DriverOrderDetailsViewDelegate?
    init(services: Services) {
        self.services = services
    }
    func setDriverOrderDetailsViewDelegate(DriverOrderDetailsViewDelegate: DriverOrderDetailsViewDelegate) {
        self.DriverOrderDetailsViewDelegate = DriverOrderDetailsViewDelegate
    }
    func showIndicator() {
        SVProgressHUD.show()
    }
    func dismissIndicator() {
        SVProgressHUD.dismiss()
    }
    func getDriverOrderDetails(id: Int) {
        services.getDriverOrderDetails(id: id) {[weak self] (error: Error?, details: [DriverOrder]?) in
            self?.DriverOrderDetailsViewDelegate?.DriverOrderDetailsResult(error, details)
            self?.dismissIndicator()
        }
    }
    func DriverChangeStatus(id: Int) {
           services.postDriverChangeOrderStatus(id: id) {[weak self] (error: Error?, result: SuccessError_Model?) in
               self?.DriverOrderDetailsViewDelegate?.DriverChangeStatusResult(error, result)
               self?.dismissIndicator()
           }
       }
}
