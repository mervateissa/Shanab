//
//  UserListPresenter.swift
//  Shanab
//
//  Created by Macbook on 6/2/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import Foundation
import SVProgressHUD
protocol UserListViewDelegate: class {
    func UserListResult(_ error: Error?, _ list: [OrderList]?)
}
class UserListPresenter {
    private let services: Services
    private weak var UserListViewDelegate: UserListViewDelegate?
    init(services: Services) {
        self.services = services
    }
    func setUserListViewDelegate(UserListViewDelegate: UserListViewDelegate) {
        self.UserListViewDelegate = UserListViewDelegate
    }
    func showIndicator() {
        SVProgressHUD.show()
    }
    func dismissIndicator() {
        SVProgressHUD.dismiss()
    }
    func postUserGetList(status: [String]) {
        services.postUserGetOrder(status: status) {[weak self] (_ error: Error?, _ list: [OrderList]?) in
            self?.UserListViewDelegate?.UserListResult(error, list)
            self?.dismissIndicator()
        }
    }
}
