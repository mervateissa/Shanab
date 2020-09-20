//
//  LoginVC.swift
//  Shanab
//
//  Created by Macbook on 3/22/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit
class LoginVC: UIViewController {
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var EmailTF: UITextField!
    private let LoginVCPresenter = LoginPresenter(services: Services())
    var websiteUrl = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        LoginVCPresenter.setLoginViewDelegate(LoginViewDelegate: self)
        
    }
    
    @IBAction func forgetPassword(_ sender: UIButton) {
        let sb = UIStoryboard(name: "PopUps", bundle: nil).instantiateViewController(withIdentifier: "ForgetPasswordVC")
        sb.modalPresentationStyle = .overCurrentContext
        sb.modalTransitionStyle = .crossDissolve
        self.present(sb, animated: true, completion: nil)
    }
    @IBAction func backButton(_ sender: Any) {
        guard let sb = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainVC") as? MainVC else {return}
               self.navigationController?.pushViewController(sb, animated: true)
    }
    
    @IBAction func prespectiveLogin(_ sender: UIButton) {
        
        guard let url = URL(string: ("http://shanp.dtagdev.com/join_us/restaurant" )) else { return }
            UIApplication.shared.open(url)
 }
    @IBAction func login(_ sender: UIButton) {
        guard self .validate() else {return}
        guard let email = EmailTF.text else {return}
        guard let password = passwordTF.text else {return}
        LoginVCPresenter.showIndicator()
        LoginVCPresenter.postLogin(email: email, password: password)
    }
    private func validate()-> Bool {
        if self.EmailTF.text!.isEmpty {
            displayMessage(title: "", message: "ادخل البريد الالكتروني الخاص بك", status: .error, forController: self)
            return false
        } else if self.passwordTF.text!.isEmpty {
            displayMessage(title: "", message: "من فضلك ادخل الرقم السري الخاص بك", status: .error, forController: self)
            return false
        } else {
            return true
        }
    }
    
    @IBAction func DaliveryManLogin(_ sender: UIButton) {
        guard let sb = UIStoryboard(name: "Authentications", bundle: nil).instantiateViewController(withIdentifier: "DriverLoginVC") as? DriverLoginVC else {return}
        self.navigationController?.pushViewController(sb, animated: true)
    }
    
    @IBAction func registeration(_ sender: UIButton) {
        guard let sb = UIStoryboard(name: "Authentications", bundle: nil).instantiateViewController(withIdentifier: "RegisterationVC") as? RegisterationVC else {return}
        self.navigationController?.pushViewController(sb, animated: true)
    }
}
extension LoginVC: LoginViewDelegate {
    func LoginResult(_ error: Error?, _ result: SuccessError_Model?) {
        if let resultMsg = result {
            if resultMsg.successMessage != "" {
                displayMessage(title: "", message: resultMsg.successMessage, status: .success, forController: self)
            }else if resultMsg.un_active_account != "" {
                displayMessage(title: "", message: resultMsg.un_active_account, status: .error, forController: self)
            }else if resultMsg.email != [""] {
                displayMessage(title: "", message: resultMsg.email[0], status: .error, forController: self)
            } else if resultMsg.password != [""] {
                displayMessage(title: "", message: resultMsg.password[0], status: .error, forController: self)
            } else if resultMsg.device_token != [""] {
                displayMessage(title: "", message: resultMsg.device_token[0], status: .error, forController: self)
            }
        }
    }
    
}
