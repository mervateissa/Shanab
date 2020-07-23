//
//  MailTempaltePresenter.swift
//  Shanab
//
//  Created by Macbook on 5/27/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import Foundation
import SVProgressHUD
protocol MailTempalteViewDelegate: class {
    func mailTempalteResult(_ error: Error?, _ result: [Tempalte]?)
}
class MailTempaltePresenter {
    private let services: Services
    private weak var MailTempalteViewDelegate: MailTempalteViewDelegate?
    init(services: Services) {
        self.services = services
    }
    func setMailTempalteViewDelegate(MailTempalteViewDelegate: MailTempalteViewDelegate) {
        self.MailTempalteViewDelegate = MailTempalteViewDelegate
    }
    func showIndicator() {
        SVProgressHUD.show()
    }
    func dismissIndicator() {
        SVProgressHUD.dismiss()
    }
    func getmailTemalte(type: String) {
        services.GetmailTemplate(type: type) {[weak self] (_ error: Error?, _ result: [Tempalte]?) in
            self?.MailTempalteViewDelegate?.mailTempalteResult(error, result)
            self?.dismissIndicator()
        }
    }
}
