//
//  MakeOrderVC.swift
//  Shanab
//
//  Created by Macbook on 3/26/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit
import DLRadioButton
import ImageSlideshow
class AdditionsVC: UIViewController {
    @IBOutlet weak var AdditionTableView: UITableView!
    private let AdditionalVCPresenter = AdditionsPresenter(services: Services())
   
    @IBOutlet weak var notesTF: UITextField!
    @IBOutlet weak var oneImageView: UIImageView!
    @IBOutlet weak var price: UILabel!
    fileprivate let cellIdentifier = "AdditionsCell"
   
    var restaurant_id = Int()
    var total = Double()
    var meal_id = Int()
       var cartItems = [CartModelItem]()
       var currency = String()
    var mealDetails = [RestaurantMeal]() {
        didSet {
            DispatchQueue.main.async {
                self.AdditionTableView.reloadData()
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        AdditionTableView.delegate = self
        AdditionTableView.dataSource = self
        let headerView = UIView()
        AdditionTableView.tableHeaderView = headerView
        AdditionalVCPresenter.setAdditionsViewDelegate(AdditionsViewDelegate: self)
      
    }
    func handleGetCart() {
          if let cart = CartCoreData.getCurrentCart()  {
              self.cartItems = cart.items ?? []
              self.total = cart.totalPrice ?? 0.0
              self.currency = cart.Currency ?? ""
              
          } else {
              displayMessage(title: "", message: "No Cart Yet", status: .error, forController: self)
          }
      }
    @IBAction func mealSelection(_ radioButton: DLRadioButton) {
        switch radioButton.tag {
               case 1:
                   print("")
               case 2:
                   print("")
               default:
                   break
               }
          
    }
    
    @IBAction func selectDrink(_ radioButton: DLRadioButton) {
        switch radioButton.tag {
               case 1:
                   print("")
               case 2:
                   print("")
               default:
                   break
               }
         
    }
    
    @IBAction func sideMenu(_ sender: UIBarButtonItem) {
        self.setupSideMenu()
    }
    @IBAction func Increase(_ sender: UIButton) {
    }
    @IBAction func decreaseBN(_ sender: UIButton) {
    }
    
    @IBAction func confirm(_ sender: UIButton) {
        AdditionalVCPresenter.showIndicator()
        AdditionalVCPresenter.postMealDetails(meal_id: meal_id)
        
        
    }
    
    
}
extension AdditionsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mealDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CartCell else {return UITableViewCell()}
        return cell
        
    }
    
    
}
extension AdditionsVC: AdditionsViewDelegate {
    func MealDetailsResult(_ error: Error?, _ details: [RestaurantMeal]?) {
        if let lists = details {
            self.mealDetails = lists
        }
    }
    
}
