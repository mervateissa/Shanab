//
//  ForgetPasswordVC.swift
//  Shanab
//
//  Created by Macbook on 3/24/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit

class ForgetPasswordVC: UIViewController {
    private let GetCodeVCPresenter = GetCodePresenter(services: Services())
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var confirmation_message: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        GetCodeVCPresenter.setGetCodeViewDelegate(GetCodeViewDelegate: self)
    }
    
    @IBAction func send(_ sender: UIButton) {
        guard self.validate() else { return }
        guard let email = email.text else {return}
        GetCodeVCPresenter.showIndicator()
        GetCodeVCPresenter.ForgetPassword(email: email)
    }
    private func validate() -> Bool {
        if self.email.text!.isEmpty {
            displayMessage(title: "", message: "" , status: .error, forController: self)
            return false
        } else {
            return true
        }
        
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
extension ForgetPasswordVC: GetCodeViewDelegate {
    func ForgetPasswordResult(_ error: Error?, _ result: SuccessError_Model?) {
        if let resultMsg = result {
            if resultMsg.successMessage != "" {
                displayMessage(title: "", message: resultMsg.successMessage, status: .success, forController: self)
                
            } else if resultMsg.email != [""] {
                displayMessage(title: "error", message: resultMsg.email[0], status: .error, forController: self)
                
            }
        }
    }
    
    
}
