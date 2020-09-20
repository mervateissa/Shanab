//
//  OrderConfirmationPopUp.swift
//  Shanab
//
//  Created by Macbook on 3/31/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit

class OrderConfirmationPopUp: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    
    @IBAction func FollowOrder(_ sender: UIButton) {
        let sb = UIStoryboard(name: "Details", bundle: nil).instantiateViewController(withIdentifier: "OrderFollowingVC")
                     sb.modalPresentationStyle = .overCurrentContext
                     sb.modalTransitionStyle = .crossDissolve
                     self.present(sb, animated: true, completion: nil)
        
    }
    
    @IBAction func dismiss(_ sender: UIButton) {
        guard let window = UIApplication.shared.keyWindow else { return }
        let sb = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HomeNav")
        window.rootViewController = sb
        UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromLeft, animations: nil, completion: nil)
       
    }
    
}
