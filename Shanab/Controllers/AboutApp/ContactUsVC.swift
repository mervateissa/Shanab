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
    private let MailTemplateVCPresenter = MailTempaltePresenter(services: Services())
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var messageDetails: UITextField!
    @IBOutlet weak var messageAddress: UIButton!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var name: UITextField!
      let TypeArr = ["شكوي", "اقتراح"]
    var id = Int()
    var mailTempalte = [Tempalte]()
    let MessageTypeDropDown = DropDown()
    override func viewDidLoad() {
        super.viewDidLoad()
     SetupMessageTypeDropDown()
       
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
    
    
    @IBAction func send(_ sender: Any) {
    
        
    }
    
    @IBAction func twitterBn(_ sender: UIButton) {

         let userName =  "twitter"
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
        
    }
    @IBAction func messageType(_ sender: UIButton) {
        MessageTypeDropDown.show()
    }
    @IBAction func snapChatBn(_ sender: UIButton) {
        let username = "instagram"
        let appURL = URL(string: "snapchat://add/\(username)")!
        let application = UIApplication.shared

        if application.canOpenURL(appURL) {
            application.open(appURL)

        } else {
            // if Snapchat app is not installed, open URL inside Safari
            let webURL = URL(string: "https://www.snapchat.com/add/\(username)")!
            application.open(webURL)

    }
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
    
    @IBAction func facebookBn(_ sender: UIButton) {
        let userName =  "Facebook"
              let appURL = URL(string: "facebook:///\(userName)")!
              let webURL = URL(string: "https://facebook.com/\(userName)")!
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



extension ContactUsVC: MailTempalteViewDelegate {
    func mailTempalteResult(_ error: Error?, _ result: [Tempalte]?) {
        
        
    }
    
    
}

