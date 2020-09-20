//
//  SectionsPageVC.swift
//  Shanab
//
//  Created by Macbook on 4/7/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit

class SectionsPageVC: UIViewController {
    @IBOutlet weak var productiveBNStaitc: UIButton!
    @IBOutlet weak var stackviewBorder: UIStackView!
    @IBOutlet weak var food: UIStackView!
    @IBOutlet weak var restaurantsStack: UIStackView!
    @IBOutlet weak var ProductiveFamilyStatic: UIButton!
    @IBOutlet weak var foodTruckStatic: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
       
    
       
    }
   
   
    
    @IBAction func restaurants(_ sender: UIButton) {
        guard let sb = UIStoryboard(name: "Sections",  bundle: nil).instantiateViewController(withIdentifier: "RestaurantsVC") as? RestaurantsVC else {return}
               self.navigationController?.pushViewController(sb, animated: true)
        
    }
    
    @IBAction func foodTracks(_ sender: UIButton) {
        guard let sb = UIStoryboard(name: "Sections", bundle: nil).instantiateViewController(withIdentifier: "FoodTracksVC") as? FoodTracksVC else {return}
        self.navigationController?.pushViewController(sb, animated: true)
    }
    @IBAction func backButton(_ sender: Any) {
        guard let sb = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainVC") as? MainVC else {return}
        self.navigationController?.pushViewController(sb, animated: true)
    }
    @IBAction func sideMenue(_ sender: UIBarButtonItem) {
        self.setupSideMenu()
    }
    @IBAction func productiveFamilies(_ sender: UIButton) {
        guard let sb = UIStoryboard(name: "Sections", bundle: nil).instantiateViewController(withIdentifier: "ProductiveFamiliesVC") as? ProductiveFamiliesVC else {return}
        self.navigationController?.pushViewController(sb, animated: true)
    }
    

}
