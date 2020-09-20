//
//  LoginPopupVC.swift
//  Shanab
//
//  Created by mac on 1/25/1442 AH.
//  Copyright © 1442 AH Dtag. All rights reserved.
//

import UIKit

class LoginPopupVC: UIViewController {
    private let LoginVCPresenter = LoginPresenter(services: Services())
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var email: CustomTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func register(_ sender: Any) {
        guard let sb = UIStoryboard(name: "Authentications", bundle: nil).instantiateViewController(withIdentifier: "RegisterationVC") as? RegisterationVC else {return}
        self.navigationController?.pushViewController(sb, animated: true)
    }
    
    @IBAction func login(_ sender: Any) {
        guard self.validate() else { return }
        guard let email = email.text else {return}
        guard let password = password.text else {return}
        LoginVCPresenter.showIndicator()
        LoginVCPresenter.postLogin(email: email, password: password)
        
        
    }
    private func validate()-> Bool {
        if self.email.text!.isEmpty {
            displayMessage(title: "Invalid", message: "invalid number", status: .error, forController: self)
            return false
        } else if self.password.text!.isEmpty {
            displayMessage(title: "Invalid", message: "invalid Pasword", status: .error, forController: self)
            return false
        }else {
            return true
        }
    }
}
extension LoginPopupVC: LoginViewDelegate {
    func LoginResult(_ error: Error?, _ result: SuccessError_Model?) {
        if let resultMsg = result {
            if resultMsg.successMessage != "" {
                displayMessage(title: "Done", message: resultMsg.successMessage, status: .success, forController: self)
                
            } else if resultMsg.errorMessage != "" {
                displayMessage(title: "", message: resultMsg.errorMessage, status: .error, forController: self)
            } else if resultMsg.email != [""] {
                displayMessage(title: "", message: resultMsg.email[0] , status: .error, forController: self)
            } else if resultMsg.password != [""] {
                displayMessage(title: "", message: resultMsg.password[0] , status: .error, forController: self)
            } else if resultMsg.device_token != [""] {
                displayMessage(title: "", message: resultMsg.device_token[0], status: .error, forController: self)
            }
        }
    }
    
}








