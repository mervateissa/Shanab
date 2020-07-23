//
//  UserProfilePresenter.swift
//  Shanab
//
//  Created by Macbook on 5/3/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import Foundation
import SVProgressHUD
protocol UserProfileViewDelegate: class {
    func UserChangeProfileResult(_ error: Error?, _ result: SuccessError_Model?)
    func getUserProfileResult(_ error: Error?, _ result: User?)
}
class UserProfilePresenter {
    private let services: Services
    private weak var UserProfileViewDelegate: UserProfileViewDelegate?
    init(services: Services) {
        self.services = services
    }
    func setUserProfileViewDelegate( UserProfileViewDelegate: UserProfileViewDelegate) {
        self.UserProfileViewDelegate = UserProfileViewDelegate
    }
    func showIndicator() {
        SVProgressHUD.show()
    }
    func dismissIndicator() {
        SVProgressHUD.dismiss()
    }
    func postUserChangeProfileImage(image: UIImage) {
        services.UserChangeProfileImage(image: image) {[weak self] (_ error: Error?, _ result: SuccessError_Model?, _ progress: Progress?) in
            self?.UserProfileViewDelegate?.UserChangeProfileResult(error, result)
            self?.dismissIndicator()
        }
    }
    func getUserProfile() {
        services.getProfile {[weak self] (error: Error?, result: User?) in
            self?.UserProfileViewDelegate?.getUserProfileResult(error, result)
            self?.dismissIndicator()
        }
    }
}
