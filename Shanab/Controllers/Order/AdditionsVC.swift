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
    private let AdditionalVCPresenter = AdditionsPresenter(services: Services())
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var components: UILabel!
    @IBOutlet weak var discreption: UITextView!
    @IBOutlet weak var oneImageView: UIImageView!
    @IBOutlet weak var price: UILabel!
    var appetizer = String()
    var restaurant_id = Int()
    var total = Double()
    var meal_id = Int()
       var cartItems = [CartModelItem]()
       var currency = String()
    var mealDetails = [RestaurantMeal]()
    override func viewDidLoad() {
        super.viewDidLoad()
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
    @IBAction func confirm(_ sender: UIButton) {
        AdditionalVCPresenter.showIndicator()
        AdditionalVCPresenter.postMealDetails(meal_id: meal_id)
        
        
    }
    @IBAction func selection(_ radioButton: DLRadioButton) {
        switch radioButton.tag {
        case 1:
            print("Chees fries")
            self.appetizer = "online"
        case 2:
            print("ketchup fries")
            self.appetizer = "cash"
        default:
            break
        }
        
    }
    
    
}
extension AdditionsVC: AdditionsViewDelegate {
    func MealDetailsResult(_ error: Error?, _ details: [RestaurantMeal]?) {
        if let lists = details {
            self.mealDetails = lists
        }
    }
    
}
