//
//  PaymentDetailsVC.swift
//  Shanab
//
//  Created by Macbook on 5/6/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit

class PaymentDetailsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    
    @IBAction func conffirm(_ sender: Any) {
       guard let sb = UIStoryboard(name: "PaymentGetWay", bundle: nil).instantiateViewController(withIdentifier: "PaymentGatewayVC") as? PaymentGatewayVC else { return }
        self.navigationController?.pushViewController(sb, animated: true)
    }
    
    
}
