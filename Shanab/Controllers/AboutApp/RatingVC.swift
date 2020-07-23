//
//  RatingVC.swift
//  Shanab
//
//  Created by Macbook on 4/12/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit
import Cosmos
class RatingVC: UIViewController {
    @IBOutlet weak var OrderRate: CosmosView!
    @IBOutlet weak var agentRate: CosmosView!
    @IBOutlet weak var discreption: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    

    @IBAction func confirm(_ sender: UIButton) {
        guard let sb = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HomeVC") as? HomeVC else {return}
        self.navigationController?.pushViewController(sb, animated: true)
    }
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

}
