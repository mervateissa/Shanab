//
//  RegisterationVC.swift
//  Shanab
//
//  Created by Macbook on 3/23/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit
import FlagPhoneNumber
class RegisterationVC: UIViewController {
    @IBOutlet weak var name: UITextView!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var phone: FPNTextField!
    @IBOutlet weak var email: UITextField!
    var dialCode = String()
    @IBOutlet weak var password_confirmation: CustomTextField!
    let listController: FPNCountryListViewController = FPNCountryListViewController(style: .grouped)
    private let UserRegisterVCPresenter = UserRegisterPresenter(servcies: Services())
    override func viewDidLoad() {
        super.viewDidLoad()
        phone.delegate = self
        UserRegisterVCPresenter.setUserRegisterViewDelegate(UserRegisterViewDelegate: self)
        
    }
    func setupCountryPHone() {
        
        
        self.phone.displayMode = .list
        
        listController.setup(repository: self.phone.countryRepository)
        listController.didSelect = { [weak self] country in
            self?.phone.setFlag(countryCode: country.code)
        }
    }
    
    @IBAction func register(_ sender: UIButton) {
        guard self.validate() else {return}
        guard let name = name.text else {return}
        guard let email = email.text else {return}
        guard let password = password.text else {return}
        guard let password_confirmation = password_confirmation.text else {return}
        guard let phone = phone.text else {return}
        UserRegisterVCPresenter.showIndicator()
        UserRegisterVCPresenter.postUserRegister(name: name, email: email, password: password, password_confirmation: password_confirmation, phone: "\(dialCode)\(phone)")
        
        
    }
    private func validate() ->Bool {
        if self.name.text!.isEmpty {
            displayMessage(title: "", message: "من فضلك قم بادخال الاسم ", status: .error, forController: self)
            return false
        } else if self.email.text!.isValidEmail() {
            displayMessage(title: "", message: "من فضلك ادخل البريد الالكتروني", status: .error, forController: self)
            return false
        } else if self.password.text!.isPasswordValid() {
            displayMessage(title: "", message: "من فضلك ادخل كلمة المرور", status: .error, forController: self)
            return false
        } else if self.password_confirmation.text!.isEmpty {
            displayMessage(title: "", message: "كلمة المرور غير متطابقة", status: .error, forController: self)
            return false
        } else if self.phone.text!.isEmpty {
            displayMessage(title: "", message: "من فضلك ادخل رقم الهاتف", status: .error, forController: self)
            return false
        } else {
            return true
        }
    }
    
    @IBAction func rejaxPopUpButton(_ sender: UIButton) {
        
    }
    @IBAction func login(_ sender: UIButton) {
        
        
    }
    
    @IBAction func PasswordMatch(_ sender: CustomTextField) {
        if password_confirmation.text == password.text {
            self.password_confirmation.leftImage = #imageLiteral(resourceName: "check")
        } else {
            print("Password not match")
        }
    }
}
extension RegisterationVC: UserRegisterViewDelegate {
    func LoginResult(_ error: Error?, _ result: SuccessError_Model?) {
        if let resultMsg = result {
            if resultMsg.successMessage != "" {
                displayMessage(title: "", message: resultMsg.successMessage, status: .success, forController: self)
//                UserDefaults.standard.removeObject(forKey: "email")
            } else if resultMsg.email != [""] {
                displayMessage(title: "", message: resultMsg.email[0], status: .error, forController: self)
            } else if resultMsg.password != [""] {
                displayMessage(title: "", message: resultMsg.password[0], status: .error, forController: self)
            }
            
        }
    }
    
    func userRegisterResult(_ error: Error?, _ result: SuccessError_Model?) {
        if let resultMsg = result {
            if resultMsg.successMessage != "" {
                displayMessage(title: "", message: resultMsg.successMessage, status: .success, forController: self)
                UserRegisterVCPresenter.postLogin(email: self.email.text ?? "", password: self.password.text ?? "")
            } else if resultMsg.name != [""] {
                displayMessage(title: "", message: resultMsg.name[0], status: .error, forController: self)
            } else if resultMsg.email != [""] {
                displayMessage(title: "", message: resultMsg.email[0], status: .error, forController: self)
            } else if resultMsg.phone != [""] {
                displayMessage(title: "", message: resultMsg.phone[0], status: .error, forController: self)
            } else if resultMsg.password != [""] {
                displayMessage(title: "", message: resultMsg.password[0], status: .error, forController: self)
            } else if resultMsg.password_confirmation != [""] {
                displayMessage(title: "", message: resultMsg.password_confirmation[0], status: .error, forController: self)
            }
        }
    }
    
}
extension RegisterationVC: FPNTextFieldDelegate {
    
    func fpnDisplayCountryList() {
        let navigationViewController = UINavigationController(rootViewController: listController)
        
        listController.title = "Countries"
        
        self.present(navigationViewController, animated: true, completion: nil)
    }
    
    func fpnDidSelectCountry(name: String, dialCode: String, code: String) {
        print(name, dialCode, code) // Output "France", "+33", "FR"
    }
    
    func fpnDidValidatePhoneNumber(textField: FPNTextField, isValid: Bool) {
        if isValid {
            
            self.phone.text = phone.getRawPhoneNumber()
        } else {
            displayMessage(title: "", message: "Number not valid", status: .error, forController: self)
        }
    }
}


