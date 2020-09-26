//
//  UserProfileChangePasswordVC.swift
//  Shanab
//
//  Created by Macbook on 4/30/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit

class UserProfileChangePasswordVC: UIViewController {
    private let UserProfileChangePasswordVCPresenter = UserProfileChangePasswordPresenter(services: Services())
    private let cellIdentifier = "ProfileCell"
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var oldPasswordTF: UITextField!
    @IBOutlet weak var Password_confirmationTF: UITextField!
    var imagePath = String()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        UserProfileChangePasswordVCPresenter.setUserProfileChangePasswordViewDelegate(UserProfileChangePasswordViewDelegate: self)
        UserProfileChangePasswordVCPresenter.setUserProfileChangePasswordViewDelegate(UserProfileChangePasswordViewDelegate: self)

        
    }
    
    @IBAction func strongPassword(_ sender: UIButton) {
        let sb = UIStoryboard(name: "PopUps", bundle: nil).instantiateViewController(withIdentifier: "StrongPasswordPopupVC")
        sb.modalPresentationStyle = .overCurrentContext
        sb.modalTransitionStyle = .crossDissolve
        self.present(sb, animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: UIButton) {
        guard self.validate() else { return }
        guard let password = self.passwordTF.text else {return}
        guard let old_password = self.oldPasswordTF.text else {return}
        guard let password_confirmation = self.Password_confirmationTF.text else {return}
        UserProfileChangePasswordVCPresenter.showIndicator()
        UserProfileChangePasswordVCPresenter.postUserProfileChangePassword(password: password, old_password: old_password, password_confirmation: password_confirmation)
        
    }

    func pushProfile(StoryboardName name: String,ForController identifier: String) {
        let main = UIStoryboard(name: name, bundle: nil).instantiateViewController(withIdentifier: identifier)
        
        self.navigationController?.pushViewController(main, animated: true)
    }

    @IBAction func cart(_ sender: Any) {
        guard let details = UIStoryboard(name: "Cart", bundle: nil).instantiateViewController(withIdentifier: "CartVC") as? CartVC else { return }
        self.navigationController?.pushViewController(details, animated: true)
    }
    
    @IBAction func sideMenu(_ sender: Any) {
        self.setupSideMenu()
    }
    
    private func validate() -> Bool {
        
        if self.passwordTF.text!.isEmpty {
            displayMessage(title: "", message: "", status: .error, forController: self)
            return false
        } else if self.Password_confirmationTF.text!.isEmpty {
            displayMessage(title: "", message: "", status: .error, forController: self)
            return false
        } else if self.oldPasswordTF.text!.isEmpty {
            displayMessage(title: "", message: "", status: .error, forController: self)
            return false
        } else {
            return true
        }
    }
    
    
}
extension UserProfileChangePasswordVC: UserProfileChangePasswordViewDelegate {
    func UserProfileChangePasswordResult(_ error: Error?, _ result: SuccessError_Model?) {
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
extension UserProfileChangePasswordVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? ProfileCell else {return UICollectionViewCell()}
        return cell
    }

}
