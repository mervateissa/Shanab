//
//  MainVC.swift
//  Shanab
//
//  Created by Macbook on 3/22/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit

class MainVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    @IBAction func Browser(_ sender: UIButton) {
        guard let sb = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SectionsPageVC") as? SectionsPageVC else {return}
        self.navigationController?.pushViewController(sb, animated: true)
    }
    @IBAction func sideMenu(_ sender: UIBarButtonItem) {
        self.setupSideMenu()
    }
    
    @IBAction func Login(_ sender: UIButton) {
        guard let sb = UIStoryboard(name: "Authentications", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as? LoginVC else {return}
        self.navigationController?.pushViewController(sb, animated: true)
        
    }
  
    
    
}
