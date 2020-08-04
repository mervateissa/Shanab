//
//  ContactUsVC.swift
//  Shanab
//
//  Created by Macbook on 3/25/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit
import DropDown
import MessageUI
class ContactUsVC: UIViewController {
    @IBOutlet weak var socialMediaCollectionView: UICollectionView!
    private let MailTemplateVCPresenter = MailTempaltePresenter(services: Services())
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var messageDetails: UITextField!
    @IBOutlet weak var messageAddress: UIButton!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var name: UITextField!
    fileprivate let  cellIdentifeir = "SettingCell"
    let TypeArr = ["شكوي", "اقتراح"]
    var id = Int()
    var mailTempalte = [Tempalte]()
    var sectionArr = [Setting]() {
        didSet {
            DispatchQueue.main.async {
            self.socialMediaCollectionView.reloadData()
                
            }
        }
    }
    let MessageTypeDropDown = DropDown()
    override func viewDidLoad() {
        super.viewDidLoad()
        SetupMessageTypeDropDown()
        socialMediaCollectionView.delegate = self
        socialMediaCollectionView.dataSource = self
        socialMediaCollectionView.register(UINib(nibName: cellIdentifeir, bundle: nil), forCellWithReuseIdentifier: cellIdentifeir)
        MailTemplateVCPresenter.showIndicator()
        MailTemplateVCPresenter.getSettings()
        
    }
    func SetupMessageTypeDropDown() {
        MessageTypeDropDown.anchorView = messageAddress
        MessageTypeDropDown.bottomOffset = CGPoint(x: 0, y: MessageTypeDropDown.anchorView?.plainView.bounds.height ?? 0 + 50)
        MessageTypeDropDown.dataSource = TypeArr
        MessageTypeDropDown.selectionAction = {
            [weak self] (index, item) in
            self?.messageAddress.setTitleColor(#colorLiteral(red: 0.9195484519, green: 0.2682709396, blue: 0.21753335, alpha: 1), for: .normal)
            self?.messageAddress.setTitle(item, for: .normal)
            
        }
        MessageTypeDropDown.direction = .any
        MessageTypeDropDown.width = self.view.frame.width * 1
    }
    func SelectionAction(index: Int) {
        switch sectionArr[index].valueEn  {
        case "twitter":
            let userName = sectionArr[index].valueEn ?? ""
            
            let appURL = URL(string: "twitter:///\(userName)")!
            let webURL = URL(string: "https://twitter.com/\(userName)")!
            if UIApplication.shared.canOpenURL(appURL as URL) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(appURL)
                } else {
                    UIApplication.shared.openURL(appURL)
                }
            } else {
                
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(webURL)
                } else {
                    UIApplication.shared.openURL(webURL)
                }
            }
        case "facebook":
            let facebook = sectionArr[index].valueEn ?? ""
            let urlFacebook = "https://wa.me/\(facebook)"
            if let urlString = urlFacebook.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed){
                if let facebookURL = URL(string: urlString) {
                    if UIApplication.shared.canOpenURL(facebookURL){
                        if #available(iOS 10.0, *) {
                            UIApplication.shared.open(facebookURL, options: [:], completionHandler: nil)
                        } else {
                            UIApplication.shared.openURL(facebookURL)
                        }
                    }
                    else {
                        displayMessage(title: "", message: "Install Facebook First", status: .info, forController: self)
                    }
                }
            }
        case "instagram":
            let instagram = sectionArr[index].valueEn ?? ""
            let urlinstagram = "https://wa.me/\(instagram)"
            if let urlString = urlinstagram.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed){
                if let instgramURL = URL(string: urlString) {
                    if UIApplication.shared.canOpenURL(instgramURL){
                        if #available(iOS 10.0, *) {
                            UIApplication.shared.open(instgramURL, options: [:], completionHandler: nil)
                        } else {
                            UIApplication.shared.openURL(instgramURL)
                        }
                    }
                    else {
                        displayMessage(title: "", message: "Install Instagram First", status: .info, forController: self)
                    }
                }
            }
            
        default:
            print("Default")
            break
            
        }
    }
    
    
    @IBAction func send(_ sender: Any) {
        
        
    }
    
    
    @IBAction func messageType(_ sender: UIButton) {
        MessageTypeDropDown.show()
    }
    
    func sendEmail(email: String) {
        
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([email])
            mail.setMessageBody("", isHTML: true)
            
            present(mail, animated: true)
        } else {
            // show failure alert
            displayMessage(title: "", message: "Please Add your an Email to your device first", status: .error, forController: self)
            print("Please check the email.")
        }
    }
}
extension ContactUsVC: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if let error = error{
            print("error \(error.localizedDescription)")
            controller.dismiss(animated: true)
        }
        switch result {
        case .cancelled:
            print("cancelled")
        case .sent:
            print("sent")
            if "lang".localized == "ar" {
                displayMessage(title: "", message: "تم الإرسال", status: .success, forController: self)
            } else {
                displayMessage(title: "", message: "Message Sent", status: .success, forController: self)
            }
            
        case .failed:
            print("faild")
            if "lang".localized == "ar" {
                displayMessage(title: "", message: "فشل الإرسال", status: .error, forController: self)
            } else {
                displayMessage(title: "", message: "Message Failed To Send", status: .error, forController: self)
            }
            
        case .saved:
            print("saved")
            if "lang".localized == "ar" {
                displayMessage(title: "", message: "تم حفظ الرسالة", status: .success, forController: self)
            } else {
                displayMessage(title: "", message: "Message Saved", status: .success, forController: self)
            }
            
        @unknown default:
            fatalError()
        }
        controller.dismiss(animated: true)
        
    }
}
extension ContactUsVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sectionArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifeir, for: indexPath) as? SettingCell else {return UICollectionViewCell()}
        cell.config(imagePath: UIImage(data: sectionArr[indexPath.row].SettingImage!) ?? #imageLiteral(resourceName: "shanab loading"))
        cell.selectionAction = {
                   self.SelectionAction(index: indexPath.row)
               }
               return cell
    
     
         
    }
    
    
}
 extension ContactUsVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
        let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
        let size: CGFloat = (collectionView.frame.size.width - space) / 3.1
        return CGSize(width: size, height: size + 25)
    }
    
}


extension ContactUsVC: MailTempalteViewDelegate {
    func SupprortingResult(_ error: Error?, _ result: [Setting]?) {
        if let settings = result {
            for i in 0..<3 {
                self.sectionArr.append(settings[i])
                
            }
            for i in 0..<self.sectionArr.count {
                        switch self.sectionArr[i].key {
                        case "facebook":
                            self.sectionArr[i].SettingImage = #imageLiteral(resourceName: "twitter").pngData()
                        case "twitter":
                            self.sectionArr[i].SettingImage = #imageLiteral(resourceName: "logo").pngData()
                        case "instagram":
                            self.sectionArr[i].SettingImage = #imageLiteral(resourceName: "snapchat").pngData()
                       
                            
                        default:
                            self.sectionArr[i].SettingImage = #imageLiteral(resourceName: "profile pic").pngData()
                        }
                    }
                }
    }

    
    
    func mailTempalteResult(_ error: Error?, _ result: [Tempalte]?) {
        
        
    }
    
    
}

