//
//  CustomerProfileVC.swift
//  Shanab
//
//  Created by Macbook on 3/29/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit

class CustomerProfileVC: UIViewController {
    @IBOutlet weak var ProfileCollectionView: UICollectionView!
//    let picker = UIImagePickerController()
    var profile = [User]()
    fileprivate let cellIdentifier = "ProfileCell"
    var profileVC: ProfileVC!
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "profileSegue" {
            if segue.destination.isKind(of: ProfileVC.self) {
                profileVC = (segue.destination as! ProfileVC)
            }
        }
    }
    lazy var subViewControllers: [UIViewController] = {
        return [
            UIStoryboard(name: "Profile", bundle: nil).instantiateViewController(identifier: "ProfileVC") as! ProfileVC, UIStoryboard(name: "Profile", bundle: nil).instantiateViewController(identifier: "NotificationsVC") as! NotificationsVC,
            UIStoryboard(name: "Profile", bundle: nil).instantiateViewController(identifier: "UserProfileChangePasswordVC") as! UserProfileChangePasswordVC
        ]
    } ()
    var profileArr = [ProfileModel]() {
        didSet {
            DispatchQueue.main.async {
                self.ProfileCollectionView.reloadData()
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
         //setViewControllerFromIndex(index: 0)
//        profilePic.isUserInteractionEnabled = true
//        profilePic.addGestureRecognizer(UIGestureRecognizer(target: self, action: #selector(ProfileImageView(_:))))
        ProfileCollectionView.delegate = self
        ProfileCollectionView.dataSource = self
        ProfileCollectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
      
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
    
    
    func SelectionAction(indexPath: IndexPath) {
        switch profileArr[indexPath.row].profileId {
        case "profile":
            guard let vc = UIStoryboard(name: "Profile", bundle: nil).instantiateViewController(withIdentifier: "ProfileVC") as? CustomerProfileVC else { return }
            
            self.navigationController?.pushViewController(vc, animated: true)
        case "ChangePassword":
            guard UIStoryboard(name: "Profile", bundle: nil).instantiateViewController(withIdentifier: "UserProfileChangePasswordVC") is UserProfileChangePasswordVC else { return }
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

    
    

