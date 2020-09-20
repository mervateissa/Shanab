//
//  CustomerProfileVC.swift
//  Shanab
//
//  Created by Macbook on 3/29/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit

class CustomerProfileVC: UIViewController {
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var ProfileCollectionView: UICollectionView!
    @IBOutlet weak var name: UITextField!
//    let picker = UIImagePickerController()
    var profile = [User]()
    fileprivate let cellIdentifier = "ProfileCell"
    private let UserProfileVCPresenter = UserProfilePresenter(services: Services())
    var profileArr = [ProfileModel]() {
        didSet {
            DispatchQueue.main.async {
                self.ProfileCollectionView.reloadData()
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        UserProfileVCPresenter.setUserProfileViewDelegate(UserProfileViewDelegate: self)
//        profilePic.isUserInteractionEnabled = true
//        profilePic.addGestureRecognizer(UIGestureRecognizer(target: self, action: #selector(ProfileImageView(_:))))
        ProfileCollectionView.delegate = self
        ProfileCollectionView.dataSource = self
        ProfileCollectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        UserProfileVCPresenter.showIndicator()
        UserProfileVCPresenter.getUserProfile()
        if "lang".localized == "en" {
            self.profileArr = [ ProfileModel(name: "Profile", id: "profile", selected: false, profileImage: #imageLiteral(resourceName: "ic_person_24px")), ProfileModel(name: "ChangePassword", id: "ChangePassword", selected: false, profileImage: #imageLiteral(resourceName: "password")), ProfileModel(name: "Notifications", id: "Notifications", selected: false, profileImage: #imageLiteral(resourceName: "turn-notifications-on-button"))
            ]
        } else {
            self.profileArr = [ ProfileModel(name: "الملف الشخصي", id: "profile", selected: false, profileImage: #imageLiteral(resourceName: "ic_person_24px")), ProfileModel(name: "الباسورد", id: "ChangePassword", selected: false, profileImage: #imageLiteral(resourceName: "password")), ProfileModel(name: "الاشعارات", id: "Notifications", selected: false, profileImage: #imageLiteral(resourceName: "turn-notifications-on-button"))
            ]
        }
        
        
    }
    @IBAction func menu(_ sender: Any) {
        self.setupSideMenu()
    }
    @IBAction func cart(_ sender: Any) {
        guard let details = UIStoryboard(name: "Cart", bundle: nil).instantiateViewController(withIdentifier: "CartVC") as? CartVC else { return }
               self.navigationController?.pushViewController(details, animated: true)
    }
    
    //    @IBAction func ProfileImageView(_ sender: UIButton) {
//        showPickerImageControlActionSheet()
//    }
//    @objc fileprivate func profileImageView_Pressed(_ sender: UITapGestureRecognizer) {
//        showPickerImageControlActionSheet()
//        
//    }
    func SelectionAction(indexPath: IndexPath) {
        switch profileArr[indexPath.row].profileId {
        case "profile":
            guard let vc = UIStoryboard(name: "Profile", bundle: nil).instantiateViewController(withIdentifier: "CustomerProfileVC") as? CustomerProfileVC else { return }
            
            self.navigationController?.pushViewController(vc, animated: true)
        case "ChangePassword":
            guard UIStoryboard(name: "Authentications", bundle: nil).instantiateViewController(withIdentifier: "UserProfileChangePasswordVC") is UserProfileChangePasswordVC else { return }
        case "Notifications":
            guard let vc = UIStoryboard(name: "Profile", bundle: nil).instantiateViewController(withIdentifier: "NotificationsVC") as? NotificationsVC else { return }
            
            self.navigationController?.pushViewController(vc, animated: true)
        case "TermsAndConditions": break
        default:
            break
        }
        
    }
    func pushProfile(StoryboardName name: String,ForController identifier: String) {
        let main = UIStoryboard(name: name, bundle: nil).instantiateViewController(withIdentifier: identifier)
        
        self.navigationController?.pushViewController(main, animated: true)
    }
    func selectedCell(index: IndexPath) {
        switch profileArr[index.row].profileId  {
        case "Profile":
            pushProfile(StoryboardName: "Profile", ForController: "CustomerProfileVC")
        case "Notifications":
            pushProfile(StoryboardName: "Profile", ForController: "NotificationsVC")
        case "ChangePassword":
            pushProfile(StoryboardName: "Profile", ForController: "UserProfileChangePasswordVC")
        default:
            break
        }
    }
    
    
}

extension CustomerProfileVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return profileArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? ProfileCell else {return UICollectionViewCell()}
        let profileImage = profileArr[indexPath.row].profileImage
        cell.config(name: profileArr[indexPath.row].ProfileName, selected: profileArr[indexPath.row].ProfileSelected, imagePath: profileImage)
        cell.selectedBackgroundView?.backgroundColor = .clear
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        for i in 0...profileArr
            .count - 1 {
                if i == indexPath.row  {
                    profileArr[i].ProfileSelected = true
                } else {
                    profileArr[i].ProfileSelected = false
                }
        }
        ProfileCollectionView.reloadData()
        selectedCell(index: indexPath)
    }
    
    
}
extension CustomerProfileVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
        let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
        let size: CGFloat = (collectionView.frame.size.width + space) / 3.1
        return CGSize(width: size , height: size - 15 )
    }
    
}
extension CustomerProfileVC: UserProfileViewDelegate {
    func getUserProfileResult(_ error: Error?, _ result: User?) {
        if let profile = result {
            let personal = profile.personal ?? Personal()
            self.email.text = personal.email ?? ""
            if "lang".localized == "ar" {
               self.name.text = profile.nameAr ?? ""
            } else {
                self.name.text = profile.nameEn ?? ""
            }
            self.phone.text = profile.phone ?? ""
            self.address.text = profile.address ?? ""
//            if let image = profile.image {
//                guard let url = URL(string: BASE_URL + "/" + image) else { return }
//                self.profilePic.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "logo-2"))
//            }
            }
        }
        
        func UserChangeProfileResult(_ error: Error?, _ result: SuccessError_Model?) {
            
            if let resultMsg = result {
                if resultMsg.successMessage != "" {
                    displayMessage(title: "done", message: resultMsg.successMessage, status: .success, forController: self)
                    UserProfileVCPresenter.dismissIndicator()
                } else if resultMsg.image != [""] {
                    displayMessage(title: "try agine", message: resultMsg.image[0], status: .error, forController: self)
                    
                }
            }
        }
        
    }
//    extension CustomerProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//        func showPickerImageControlActionSheet() {
//            let PhotoLibraryAction = UIAlertAction(title: "اختر من الكاميرا", style: .default) { (action) in
//                self.showImagePickerView(sourceType: .photoLibrary)
//            }
//            let cameraAction = UIAlertAction(title: "التقط صورة", style: .default) { (action) in
//                self.showImagePickerView(sourceType: .camera)
//            }
//            let cancelAction = UIAlertAction(title: "الغاء", style: .cancel, handler: nil)
//            AlertService.showAlert(style: .actionSheet, title: "المكتبة", message: nil, actions: [PhotoLibraryAction, cameraAction,cancelAction], completion: nil)
//
//        }
//
//        func showImagePickerView(sourceType: UIImagePickerController.SourceType) {
//            let imagePickerController = UIImagePickerController()
//            imagePickerController.delegate = self
//            imagePickerController.allowsEditing = true
//            imagePickerController.sourceType = sourceType
//            present(imagePickerController, animated: true, completion: nil)
//
//        }
//         func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//               if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
//                UserProfileVCPresenter.postUserChangeProfileImage(image: editedImage)
//               } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
//                  UserProfileVCPresenter.postUserChangeProfileImage(image: originalImage)
//               }
//               dismiss(animated: true, completion: nil)
//           }
//}
//
