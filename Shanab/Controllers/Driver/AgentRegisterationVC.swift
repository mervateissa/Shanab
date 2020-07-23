//
//  AgentRegisterationVC.swift
//  Shanab
//
//  Created by Macbook on 4/12/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit
import Gallery
import FlagPhoneNumber
class AgentRegisterationVC: UIViewController {
    let listController: FPNCountryListViewController = FPNCountryListViewController(style: .grouped)
    private let DriverRegisterVCPresenter = DriverRegisterPresenter(services: Services())
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var phone: FPNTextField!
    @IBOutlet weak var passwordConfirmation: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var address: UITextField!
    var documents_images = [UIImage]()
    var images_type = String()
    let gallery = GalleryController()
    override func viewDidLoad() {
        super.viewDidLoad()
       
            DriverRegisterVCPresenter.setDriverRegisterViewDelegate(DriverRegisterViewDelegate: self)
            
    
        func setupCountryPHone() {
            
            
            self.phone.displayMode = .list
            
            listController.setup(repository: self.phone.countryRepository)
            listController.didSelect = { [weak self] country in
                self?.phone.setFlag(countryCode: country.code)
            }
        }
          func setupGallery() {
              gallery.delegate = self
              Config.tabsToShow = [.cameraTab, .imageTab]
              Config.initialTab = .cameraTab
          }
        
        setupGallery()
    }
    private func validate() -> Bool {
        if self.name.text!.isEmpty {
            displayMessage(title: "", message: "", status: .error, forController: self)
            return false
        } else if self.email.text!.isEmpty {
            displayMessage(title: "", message: "", status: .error, forController: self)
            return false
        } else if password.text!.isEmpty {
            displayMessage(title: "", message: "", status: .error, forController: self)
            return false
        } else if self.passwordConfirmation.text!.isEmpty {
            displayMessage(title: "", message: "", status: .error, forController: self)
            return false
        } else if phone.text!.isEmpty {
            displayMessage(title: "", message: "", status: .error, forController: self)
            return false
        } else if self.documents_images.count == 0 {
            displayMessage(title: "", message: "Please add your document images first", status: .error, forController: self)
            return false
            
        } else {
            return true
        }
    }
    
    
    @IBAction func confirm(_ sender: UIButton) {
        guard self.validate() else {return}
        guard let name = name.text else {return}
        guard let password = password.text else {return}
        guard let password_confirmation = passwordConfirmation.text else {return}
        guard let email = email.text else {return}
        guard let phone = phone.text else {return}
        DriverRegisterVCPresenter.showIndicator()
        DriverRegisterVCPresenter.postDriverRegister(name: name, password: password, password_confirmation: password_confirmation, phone: phone, documents: documents_images, email: email)
        
        
    }
    @IBAction func login(_ sender: UIButton) {
       guard let sb = UIStoryboard(name: "Authentications", bundle: nil).instantiateViewController(withIdentifier: "DriverLoginVC") as? DriverLoginVC else {return}
        self.navigationController?.pushViewController(sb, animated: true)
        
    }
    
    @IBAction func documents(_ sender: UIButton) {
        self.images_type = "documents"
        self.documents_images.removeAll()
        self.present(gallery, animated: true, completion: nil)
    }
}

extension AgentRegisterationVC: GalleryControllerDelegate {
    func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        
        
        for image in images {
            image.resolve { (img) in
                if self.images_type == "documents" {
                    
                    self.documents_images.append(img ?? UIImage())
                    if self.documents_images.count == images.count {
                        controller.dismiss(animated: true ){
                            
                        }
                    }
                }
                
                
            }
        }
        
        
    }
    func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) {
        for image in images {
            image.resolve { (img) in
                if self.images_type == "documents" {
                    self.documents_images.append(img ?? UIImage())
                    if self.documents_images.count == images.count {
                        controller.dismiss(animated: true ){
                            
                        }
                    }
                }
                
            }
        }
        
    }
    
    
    func galleryControllerDidCancel(_ controller: GalleryController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
}
extension AgentRegisterationVC: DriverRegisterViewDelegate {
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
    
    func DriverRegisterResult(_ error: Error?, _ result: SuccessError_Model?) {
        if let resultMsg = result {
            if resultMsg.successMessage != "" {
                displayMessage(title: "", message: resultMsg.successMessage, status: .success, forController: self)
                self.DriverRegisterVCPresenter.postDriverLogin(email: UserDefaults.standard.string(forKey: "email") ?? "", password: self.password.text ?? "")
                
            }  else if resultMsg.name != [""] {
                displayMessage(title: "", message: resultMsg.name[0], status: .error, forController: self)
            } else if resultMsg.email != [""] {
                displayMessage(title: "", message: resultMsg.email[0], status: .error, forController: self)
            } else if resultMsg.phone != [""] {
                displayMessage(title: "", message: resultMsg.phone[0], status: .error, forController: self)
            } else if resultMsg.password != [""] {
                displayMessage(title: "", message: resultMsg.password[0], status: .error, forController: self)
            } else if resultMsg.password_confirmation != [""]{
                displayMessage(title: "", message: resultMsg.password_confirmation[0], status: .error, forController: self)
            }
        }
    }
    
    
}
extension AgentRegisterationVC: FPNTextFieldDelegate {
    
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


