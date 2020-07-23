//
//  UserOrderDetailsPresenter.swift
//  Shanab
//
//  Created by Macbook on 7/6/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import Foundation
import SVProgressHUD
protocol UserOrderDetailsViewDelegate: class {
    func UserOrderDetailsResult(_ error: Error?, _ result: [DriverOrder]?)
}
class UserOrderDetailsPresenter {
    private let services: Services
    private weak var UserOrderDetailsViewDelegate: UserOrderDetailsViewDelegate?
    init(services: Services) {
        self.services = services
    }
    func setUserOrderDetailsViewDelegate( UserOrderDetailsViewDelegate: UserOrderDetailsViewDelegate) {
        self.UserOrderDetailsViewDelegate = UserOrderDetailsViewDelegate
    }
    func showIndicator() {
        SVProgressHUD.show()
    }
    func dismissIndicator() {
        SVProgressHUD.dismiss()
    }
    func postUserOrderDetails(id: Int, status: String) {
        services.postUserOrderDetail(id: id, status: status) {[weak self] (error: Error?, result:[ DriverOrder]?) in
            self?.UserOrderDetailsViewDelegate?.UserOrderDetailsResult(error, result)
            self?.dismissIndicator()
        }
    }
    
}
