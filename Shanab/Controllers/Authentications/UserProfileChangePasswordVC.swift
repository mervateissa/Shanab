//
//  UserProfileChangePasswordVC.swift
//  Shanab
//
//  Created by Macbook on 4/30/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit

class UserProfileChangePasswordVC: UIViewController {
    @IBOutlet weak var profileCollectionView: UICollectionView!
    private let UserProfileChangePasswordVCPresenter = UserProfileChangePasswordPresenter(services: Services())
    private let cellIdentifier = "ProfileCell"
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var oldPasswordTF: UITextField!
    @IBOutlet weak var Password_confirmationTF: UITextField!
    var imagePath = String()
   // var profileArr = [ProfileModel]() {
//           didSet {
//               DispatchQueue.main.async {
//                   self.profileCollectionView.reloadData()
//               }
//           }
//}
    override func viewDidLoad() {
        super.viewDidLoad()
        UserProfileChangePasswordVCPresenter.setUserProfileChangePasswordViewDelegate(UserProfileChangePasswordViewDelegate: self)
        UserProfileChangePasswordVCPresenter.setUserProfileChangePasswordViewDelegate(UserProfileChangePasswordViewDelegate: self)
//             if "lang".localized == "en" {
//            self.profileArr = [ ProfileModel(name: "Profile", id: "profile", selected: false, profileImage: #imageLiteral(resourceName: "ic_person_24px")), ProfileModel(name: "ChangePassword", id: "ChangePassword", selected: false, profileImage: #imageLiteral(resourceName: "password")), ProfileModel(name: "Notifications", id: "Notifications", selected: false, profileImage: #imageLiteral(resourceName: "turn-notifications-on-button"))
//            ]
//        } else {
//            self.profileArr = [ ProfileModel(name: "الملف الشخصي", id: "profile", selected: false, profileImage: #imageLiteral(resourceName: "ic_person_24px")), ProfileModel(name: "الباسورد", id: "ChangePassword", selected: false, profileImage: #imageLiteral(resourceName: "password")), ProfileModel(name: "الاشعارات", id: "Notifications", selected: false, profileImage: #imageLiteral(resourceName: "turn-notifications-on-button"))
//            ]
//        }
//
        
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
//    func SelectionAction(indexPath: IndexPath) {
//        switch profileArr[indexPath.row].profileId {
//        case "profile":
//            guard let vc = UIStoryboard(name: "Profile", bundle: nil).instantiateViewController(withIdentifier: "CustomerProfileVC") as? CustomerProfileVC else { return }
//            
//            self.navigationController?.pushViewController(vc, animated: true)
//        case "ChangePassword":
//            guard UIStoryboard(name: "Authentications", bundle: nil).instantiateViewController(withIdentifier: "UserProfileChangePasswordVC") is UserProfileChangePasswordVC else { return }
//        case "Notifications":
//            guard let vc = UIStoryboard(name: "Profile", bundle: nil).instantiateViewController(withIdentifier: "NotificationsVC") as? NotificationsVC else { return }
//            
//            self.navigationController?.pushViewController(vc, animated: true)
//        case "TermsAndConditions": break
//        default:
//            break
//        }
//        
//    }
    func pushProfile(StoryboardName name: String,ForController identifier: String) {
        let main = UIStoryboard(name: name, bundle: nil).instantiateViewController(withIdentifier: identifier)
        
        self.navigationController?.pushViewController(main, animated: true)
    }
//    func selectedCell(index: IndexPath) {
//        switch profileArr[index.row].profileId  {
//        case "Profile":
//            pushProfile(StoryboardName: "Profile", ForController: "CustomerProfileVC")
//        case "Notifications":
//            pushProfile(StoryboardName: "Profile", ForController: "NotificationsVC")
//        case "ChangePassword":
//            pushProfile(StoryboardName: "Profile", ForController: "UserProfileChangePasswordVC")
//        default:
//            break
//        }
//    }
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
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//           for i in 0...profileArr
//               .count - 1 {
//                   if i == indexPath.row  {
//                       profileArr[i].ProfileSelected = true
//                   } else {
//                       profileArr[i].ProfileSelected = false
//                   }
//           }
//           profileCollectionView.reloadData()
//           selectedCell(index: indexPath)
//       }
       
    
}
