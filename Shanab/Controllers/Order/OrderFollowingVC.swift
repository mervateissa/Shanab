//
//  OrderFollowingVC.swift
//  Shanab
//
//  Created by Macbook on 3/30/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit
import MapKit
class OrderFollowingVC: UIViewController {
    @IBOutlet weak var orderNum: UILabel!
    @IBOutlet weak var orderDate: UILabel!
    @IBOutlet weak var statusLB: UILabel!
    var id = Int()
    var status = String()
    var date = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        orderNum.text = "\(id)"
        orderDate.text = date
        statusLB.text = status
        
    }
    
    @IBAction func menu(_ sender: Any) {
        self.setupSideMenu()
    }
    @IBAction func Dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cart(_ sender: Any) {
        guard let details = UIStoryboard(name: "Cart", bundle: nil).instantiateViewController(withIdentifier: "CartVC") as? CartVC else { return }
               self.navigationController?.pushViewController(details, animated: true)
        
    }
    @IBAction func Comlpeleted(_ sender: Any) {
        let sb = UIStoryboard(name: "PopUps", bundle: nil).instantiateViewController(withIdentifier: "CustomerRateVC")
        sb.modalPresentationStyle = .overCurrentContext
        sb.modalTransitionStyle = .crossDissolve
        self.present(sb, animated: true, completion: nil)
        
    }
}
