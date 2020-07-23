//
//  RequestTypePopUpVC.swift
//  Shanab
//
//  Created by Macbook on 5/6/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit
import DLRadioButton
class RequestTypePopUpVC: UIViewController {
    @IBOutlet weak var radioButton: DLRadioButton!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func RadioButtonAction(_ sender: DLRadioButton) {
        switch radioButton.tag {
        case 1:
            print("")
        case 2:
            print("")
        case 3:
            print("")
        default:
            break
        }
    }
    @IBAction func PaymentRadioButtonAction(_ sender: DLRadioButton) {
        switch radioButton.tag  {
        case 1:
            print("Cach")
        case 2:
            print("Choose PaymentGetway")
        default:
            break
        }
    }
    @IBAction func confirm(_ sender: Any) {
        guard let Details = UIStoryboard(name: "PaymentGetWay", bundle: nil).instantiateViewController(withIdentifier: "PaymentDetailsVC") as? PaymentDetailsVC else { return }
        self.navigationController?.pushViewController(Details, animated: true)
    }
}
