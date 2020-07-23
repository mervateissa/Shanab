//
//  PreviousListVC.swift
//  Shanab
//
//  Created by Macbook on 4/1/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit
import DropDown
class DriverOrderListVC: UIViewController {
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var DriverName: UILabel!
    @IBOutlet weak var orderType: UIButton!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var phoneLB: UILabel!
    let DriverStatusDropDown = DropDown()
    @IBOutlet weak var available: UIButton!
    var ChangeAvailablity = String()
    var isAvailable = Int()
    var type = "parpare"
    var id = Int()
    let TypesArr = ["parpare", "On Way", "Arrived", "completed"]
    let StatusArr = ["Avaliable", "Unavailable"]
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var DriverListCollectionView: UICollectionView!
    fileprivate let cellIdentifier = "DriverListCell"
    private let DriverProfileVCPresenter = DriverProfilePresenter(services: Services())
    let picker = UIImagePickerController()
    var list = [Order]() {
        didSet {
            DispatchQueue.main.async {
                self.DriverListCollectionView.reloadData()
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImage.setRounded()
        DriverProfileVCPresenter.setDriverProfileViewDelegate(DriverProfileViewDelegate: self)
        profileImage.isUserInteractionEnabled = true
        profileImage.addGestureRecognizer(UIGestureRecognizer(target: self, action: #selector(ProfileImageView(_:))))
        DriverListCollectionView.delegate = self
        DriverListCollectionView.dataSource = self
        DriverListCollectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        DriverProfileVCPresenter.setDriverProfileViewDelegate(DriverProfileViewDelegate: self)
        DriverProfileVCPresenter.showIndicator()
        DriverProfileVCPresenter.DriverOrderList(type: ["parpare", "On Way", "Arrived", "completed"] )
        SetupDriverStatusDropDown()
        
    }
    func SetupDriverStatusDropDown() {
        DriverStatusDropDown.anchorView = orderType
        DriverStatusDropDown.bottomOffset = CGPoint(x: 0, y: DriverStatusDropDown.anchorView?.plainView.bounds.height ?? 0 + 50)
        DriverStatusDropDown.dataSource = TypesArr
        DriverStatusDropDown.selectionAction = {
            [weak self] (index, item) in
            self?.orderType.setTitleColor(#colorLiteral(red: 0.007525420282, green: 0.4868255258, blue: 0.6823853254, alpha: 1), for: .normal)
            self?.orderType.setTitle("\(item.capitalized) Orders", for: .normal)
            self?.DriverProfileVCPresenter.showIndicator()
            if self?.type ?? "" == "parpare" {
                self?.DriverProfileVCPresenter.DriverOrderList(type: [self?.type ?? "parpare", "On Way", "Arrived", "completed"])
            } else {
                self?.DriverProfileVCPresenter.DriverOrderList(type: [self?.type ?? "parpare", "On Way", "Arrived", "completed"])
            }
            
            
        }
        
        
        DriverStatusDropDown.direction = .any
        DriverStatusDropDown.width = self.view.frame.width * 1
    }
    @IBAction func EditProfile(_ sender: UIButton) {
        guard let name = self.DriverName.text else { return }
//              guard let email = self.Email.text else { return }
              guard let phone = self.phoneLB.text else { return }
        DriverProfileVCPresenter.showIndicator()
//        DriverProfileVCPresenter.postEditDriverProfile(phone: phone, email: <#T##String#>, name_ar: name)
              
    }
    func showImagePickerView(sourceType: UIImagePickerController.SourceType) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = sourceType
        present(imagePickerController, animated: true, completion: nil)
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage ] as? UIImage
        {
            profileImage.image = editedImage
            DriverProfileVCPresenter.postDriverChangeImage(image: editedImage)
            
        } else if let orignalImage =
            info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profileImage.image = orignalImage
            DriverProfileVCPresenter.postDriverChangeImage(image: orignalImage)
        }
    }
    @IBAction func ProfileImageView(_ sender: UIButton) {
        showPickerImageControlActionSheet()
    }
    @objc fileprivate func profileImageView_Pressed(_ sender: UITapGestureRecognizer) {
        showPickerImageControlActionSheet()
        
    }
    
    
}

extension DriverOrderListVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func showPickerImageControlActionSheet() {
        if "lang".localized == "ar" {
            let PhotoLibraryAction = UIAlertAction(title: "المعرض".localized, style: .default) { (action) in
                self.showImagePickerView(sourceType: .photoLibrary)
            }
            let cameraAction = UIAlertAction(title: "الكاميرا".localized, style: .default) { (action) in
                self.showImagePickerView(sourceType: .camera)
            }
            let cancelAction = UIAlertAction(title: "إلغاء".localized, style: .cancel, handler: nil)
            
            AlertService.showAlert(style: .actionSheet, title: "إختار الصورة".localized, message: nil, actions: [PhotoLibraryAction, cameraAction,cancelAction], completion: nil)
        } else {
            let PhotoLibraryAction = UIAlertAction(title: "Gallrey".localized, style: .default) { (action) in
                self.showImagePickerView(sourceType: .photoLibrary)
            }
            let cameraAction = UIAlertAction(title: "Camera".localized, style: .default) { (action) in
                self.showImagePickerView(sourceType: .camera)
            }
            let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil)
            
            AlertService.showAlert(style: .actionSheet, title: "Choose your Picture".localized, message: nil, actions: [PhotoLibraryAction, cameraAction,cancelAction], completion: nil)
        }
        
    }
}
extension DriverOrderListVC: DriverProfileViewDelegate {
    func postEditDriverProfileResult(_ error: Error?, _ result: SuccessError_Model?) {
         if let profile = result {
        if profile.successMessage != "" {
            displayMessage(title: "", message: profile.successMessage, status: .success, forController: self)
        } else if profile.name != [""] {
            displayMessage(title: "", message: profile.name[0], status: .error, forController: self)
        } else if profile.address != [""] {
            displayMessage(title: "", message: profile.address[0], status: .error, forController: self)
        } else if profile.email != [""] {
            displayMessage(title: "", message: profile.email[0], status: .error, forController: self)
            }
        }
    }
    func getDriverProfileResult(_ error: Error?, _ result: User?) {
        if let profile = result {
            
            self.phoneLB.text = profile.phone ?? ""
            self.DriverName.text = profile.nameAr ?? ""
            if let image = profile.image {
                guard let url = URL(string: BASE_URL + "/" + image) else { return }
                self.profileImage.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "profileSM"))
            }
        }
    }
    
    func DriverOrderListResult(_ error: Error?, _ list: [Order]?, _ orderErrors: OrdersErrors?) {
        if let lists = list {
            self.list = lists.reversed()
            if self.list.count == 0 {
                self.emptyView.isHidden = false
                self.DriverListCollectionView.isHidden = true
            } else {
                self.emptyView.isHidden = true
                self.DriverListCollectionView.isHidden = false
            }
            self.orderType.setTitle("\(self.type.capitalized) Orders", for: .normal)
        }
    }
    
    func DriverChangeImageResult(_ error: Error?, _ result: SuccessError_Model?) {
        if let resultMsg = result {
            if resultMsg.successMessage != "" {
                displayMessage(title: "done", message: resultMsg.successMessage, status: .success, forController: self)
                DriverProfileVCPresenter.dismissIndicator()
            } else if resultMsg.image != [""] {
                displayMessage(title: "try agine", message: resultMsg.image[0], status: .error, forController: self)
            }
        }
    }
    
    func DriverIsAvaliableChangeResult(_ error: Error?, _ result: SuccessError_Model?) {
        if let profile = result {
            //            self.ChangeAvailablity = "\(profile.isAvailable ?? 0)"
            //            if profile.isAvailable ?? 0 == 0 {
            self.available.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
            if "lang".localized == "ar" {
                self.available.setTitle("غير متصل", for: .normal)
            } else {
                self.available.setTitle("Disconnected", for: .normal)
            }
            
        } else {
            self.available.backgroundColor = #colorLiteral(red: 0.2039215686, green: 0.7803921569, blue: 0.3490196078, alpha: 1)
            if "lang".localized == "ar" {
                self.available.setTitle("متصل", for: .normal)
            } else {
                self.available.setTitle("Connected", for: .normal)
            }
            
        }
    }
    
}
extension DriverOrderListVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
          guard let Details = UIStoryboard(name: "Orders", bundle: nil).instantiateViewController(withIdentifier: "DriverOrderListVC") as? DriverOrderListVC else { return }
               Details.id = list[indexPath.row].id ?? 0

              self.navigationController?.pushViewController(Details, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? DriverListCell else {return UICollectionViewCell()}
        let client = list[indexPath.row].client ?? Client()
        cell.config(Name: client.nameAr ?? "", imagePath: client.image ?? "", rate: Double(list[indexPath.row].rate ?? 0) , address: client.address ?? "")
        
        cell.goToDetails = {
            guard let Details = UIStoryboard(name: "Details", bundle: nil).instantiateViewController(withIdentifier: "OrderReceiptVC") as? OrderReceiptVC else { return }
            Details.id = self.list[indexPath.row].id ?? 0
            self.navigationController?.pushViewController(Details, animated: true)
        }
        return cell
    }
}



