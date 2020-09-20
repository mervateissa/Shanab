//
//  DriverChangePasswordProfileVC.swift
//  Shanab
//
//  Created by Macbook on 5/14/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit

class DriverChangePasswordProfileVC: UIViewController {
    private let DriverChangePasswordProfileProfileVCPresenter = DriverChangeProfileProfilePresenter(services: Services())
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var old_passwordTF: UITextField!
    @IBOutlet weak var password_confirmationTF: UITextField!
    private let cellIdentifier = "ProfileCell"
    override func viewDidLoad() {
        super.viewDidLoad()
        DriverChangePasswordProfileProfileVCPresenter.DriverChangePasswordProfileProfileViewDelegate(DriverChangePasswordProfileProfileViewDelegate: self)
        
    }
    @IBAction func passwordInstructions(_ sender: UIButton) {
    }
    
    @IBAction func cart(_ sender: Any) {
        guard let details = UIStoryboard(name: "Cart", bundle: nil).instantiateViewController(withIdentifier: "CartVC") as? CartVC else { return }
               self.navigationController?.pushViewController(details, animated: true)
    }
    
    @IBAction func menu(_ sender: Any) {
        self.setupSideMenu()
    }
    
    @IBAction func save(_ sender: UIButton) {
        guard self.validate() else { return }
        guard let password = self.passwordTF.text else {return}
        guard let old_password = self.old_passwordTF.text else {return}
        guard let password_confirmation = self.password_confirmationTF.text else {return}
        DriverChangePasswordProfileProfileVCPresenter.showIndicator()
    DriverChangePasswordProfileProfileVCPresenter.postsetDriverChangePasswordProfileProfile(password: password, old_password: old_password, password_confirmation: password_confirmation)
        
        
    }
    private func validate() -> Bool {
        if self.passwordTF.text!.isEmpty {
            displayMessage(title: "", message: "", status: .error, forController: self)
            return false
        } else if self.password_confirmationTF.text!.isEmpty {
            displayMessage(title: "", message: "", status: .error, forController: self)
            return false
        } else if self.old_passwordTF.text!.isEmpty {
            displayMessage(title: "", message: "", status: .error, forController: self)
            return false
        } else {
            return true
        }
    }
    
}
extension DriverChangePasswordProfileVC: DriverChangePasswordProfileProfileViewDelegate {
 func DriverChangePasswordProfileProfileResult(_ error: Error?, _ result: SuccessError_Model?) {
      if let resultMsg = result {
                if resultMsg.successMessage != "" {
                    displayMessage(title: "", message: "", status: .success, forController: self)
                } else if resultMsg.old_password != [""] {
                    displayMessage(title: "", message: "", status: .error, forController: self)
                } else if resultMsg.password != [""] {
                    displayMessage(title: "", message: "", status: .error, forController: self)
                } else if resultMsg.password_confirmation != [""] {
                    displayMessage(title: "", message: "", status: .error, forController: self)
                }
 }
 

 }
}
