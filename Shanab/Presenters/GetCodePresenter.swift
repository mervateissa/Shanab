//
//  GetCodePresenter.swift
//  Shanab
//
//  Created by Macbook on 5/3/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import Foundation
import SVProgressHUD
protocol GetCodeViewDelegate: class {
    func ForgetPasswordResult(_ error: Error?, _ result: SuccessError_Model?)
}
class GetCodePresenter {
    private let services: Services
    private weak var GetCodeViewDelegate: GetCodeViewDelegate?
    init(services: Services) {
        self.services = services
    }
    func setGetCodeViewDelegate(GetCodeViewDelegate: GetCodeViewDelegate) {
        self.GetCodeViewDelegate = GetCodeViewDelegate
    }
    func showIndicator() {
        SVProgressHUD.show()
    }
    func dismissIndicator() {
        SVProgressHUD.dismiss()
    }
    func ForgetPassword(email: String) {
        services.postForgetPassword(email: email) {[weak self] (_ error: Error?, _ result: SuccessError_Model?) in
            self?.GetCodeViewDelegate?.ForgetPasswordResult(error, result)
            self?.dismissIndicator()
        }
    }
    
}
