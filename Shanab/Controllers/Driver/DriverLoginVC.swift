//
//  DriverLoginVC.swift
//  Shanab
//
//  Created by Macbook on 5/17/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit
class DriverLoginVC: UIViewController {
    private let DriverLoginVCPresenter = DriverLoginPresenter(services: Services())
    @IBOutlet weak var emailTF: CustomTextField!
    @IBOutlet weak var passwordTF: CustomTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        DriverLoginVCPresenter.setDriverLoginViewDelegate(DriverLoginViewDelegate: self)
        
        
    }
    private func validate()-> Bool {
        if self.emailTF.text!.isEmpty {
            displayMessage(title: "", message: "ادخل البريد الالكتروني الخاص بك", status: .error, forController: self)
            return false
        } else if self.passwordTF.text!.isEmpty {
            displayMessage(title: "", message: "من فضلك ادخل الرقم السري الخاص بك", status: .error, forController: self)
            return false
        } else {
            return true
        }
    }
    
    
    @IBAction func LoginBN(_ sender: UIButton) {
        guard self .validate() else {return}
        guard let email = emailTF.text else {return}
        guard let password = passwordTF.text else {return}
        DriverLoginVCPresenter.showIndicator()
        DriverLoginVCPresenter.postDriverLogin(email: email, password: password)
        
    }
    
    @IBAction func ForgetPassword(_ sender: UIButton) {
        let sb = UIStoryboard(name: "PopUps", bundle: nil).instantiateViewController(withIdentifier: "ForgetPasswordVC")
               sb.modalPresentationStyle = .overCurrentContext
               sb.modalTransitionStyle = .crossDissolve
               self.present(sb, animated: true, completion: nil)
    }
    @IBAction func registerBN(_ sender: UIButton) {
        guard let sb = UIStoryboard(name: "Authentications", bundle: nil).instantiateViewController(withIdentifier: "AgentRegisterationVC") as? AgentRegisterationVC else {return}
               self.navigationController?.pushViewController(sb, animated: true)
        
    }
}
extension DriverLoginVC: DriverLoginViewDelegate {
    func DriverLoginResult(_ error: Error?, _ result: SuccessError_Model?) {
        if let resultMsg = result {
            if resultMsg.successMessage != "" {
                displayMessage(title: "", message: resultMsg.successMessage, status: .success, forController: self)
            } else if resultMsg.email != [""] {
                displayMessage(title: "", message: resultMsg.email[0], status: .error, forController: self)
            } else if resultMsg.password != [""] {
                displayMessage(title: "", message: resultMsg.password[0], status: .error, forController: self)
            }
        }
    }
    
    
}
