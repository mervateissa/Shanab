//
//  DriverGetCodeVC.swift
//  Shanab
//
//  Created by Macbook on 5/13/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit

class DriverGetCodeVC: UIViewController {
    @IBOutlet weak var emailTF: UITextField!
    private let DriverGetCodeVCPresenter = DriverGetCodePresenter(services: Services())
    @IBOutlet weak var confirmationMessageTF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        DriverGetCodeVCPresenter.setDriverGetCodeViewDelegate(DriverGetCodeViewDelegate: self)
        
        
    }
    
    
    @IBAction func sendBN(_ sender: UIButton) {
        guard self.validate() else { return }
               guard let email = emailTF.text else {return}
               DriverGetCodeVCPresenter.showIndicator()
        DriverGetCodeVCPresenter.postDriverGetCode(email: email)
        
    }
    private func validate() -> Bool {
           if self.emailTF.text!.isEmpty {
               displayMessage(title: "", message: "" , status: .error, forController: self)
               return false
           } else {
               return true
           }
           
       }
    
    @IBAction func dismiss(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
extension DriverGetCodeVC: DriverGetCodeViewDelegate {
    func DriverGetCodeResult(_ error: Error?, _ result: SuccessError_Model?) {
        if let resultMsg = result {
            if resultMsg.successMessage != "" {
                displayMessage(title: "", message: resultMsg.successMessage, status: .success, forController: self)
                
            } else if resultMsg.email != [""] {
                displayMessage(title: "error", message: resultMsg.email[0], status: .error, forController: self)
                
            }
        }
    }
    
    
}
