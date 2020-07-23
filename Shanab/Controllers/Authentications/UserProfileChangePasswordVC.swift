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
    override func viewDidLoad() {
        super.viewDidLoad()
        UserProfileChangePasswordVCPresenter.setUserProfileChangePasswordViewDelegate(UserProfileChangePasswordViewDelegate: self)
        UserProfileChangePasswordVCPresenter.setUserProfileChangePasswordViewDelegate(UserProfileChangePasswordViewDelegate: self)
        

    }
    

    @IBAction func save(_ sender: UIButton) {
         guard self.validate() else { return }
        guard let password = self.passwordTF.text else {return}
        guard let old_password = self.oldPasswordTF.text else {return}
        guard let password_confirmation = self.Password_confirmationTF.text else {return}
         UserProfileChangePasswordVCPresenter.showIndicator()
        UserProfileChangePasswordVCPresenter.postUserProfileChangePassword(password: password, old_password: old_password, password_confirmation: password_confirmation)
       
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
