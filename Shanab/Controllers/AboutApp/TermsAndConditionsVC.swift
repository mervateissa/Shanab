//
//  TermsAndConditionsVC.swift
//  Shanab
//
//  Created by Macbook on 6/24/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit

class TermsAndConditionsVC: UIViewController {
    @IBOutlet weak var termsAndCondetionsTV: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func dismiss(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    

}
