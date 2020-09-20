//
//  CartDetailsVC.swift
//  Shanab
//
//  Created by Macbook on 28/07/2020.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit
class CartDetailsVC: UIViewController {
    @IBOutlet weak var quantityLB: UILabel!
    @IBOutlet weak var mealComponents: UILabel!
    @IBOutlet weak var calories: UILabel!
    @IBOutlet weak var mealImage: UIImageView!
    @IBOutlet weak var additionsLB: UILabel!
    @IBOutlet weak var mealPriceLB: CustomLabel!
    @IBOutlet weak var notes: UITextField!
    @IBOutlet weak var mealNameLB: UILabel!
    var productCounter = 1
    var mealId = Int()
    var mealName = String()
    var imagePath = String()
    var components = String()
    var caloriesNamber = String()
    var quantity = Int()
    var Addition = String()
    var price = Int()
    var details = onlineCart()
    private let CartDetailsVCPresenter = CartDetailsPresenter(services: Services())
    override func viewDidLoad() {
        super.viewDidLoad()
        mealComponents.text = components
        calories.text = caloriesNamber
        mealNameLB.text = mealName
        quantityLB.text = "\(productCounter)"
        additionsLB.text = Addition
        if "lang".localized == "ar" {
             mealPriceLB.text = "\(price) ريال"
        } else {
             mealPriceLB.text = "\(price) SAR"
        }
       
        if imagePath != "" {
            guard let imageURL = URL(string:  imagePath) else { return }
            self.mealImage.kf.setImage(with: imageURL)
        } else {
            self.mealImage.image = #imageLiteral(resourceName: "shanab loading")
        }
        CartDetailsVCPresenter.setCartDetailsViewDelegate(CartDetailsViewDelegate: self)
        
    }
    
    @IBAction func CartList(_ sender: Any) {
        guard let details = UIStoryboard(name: "Cart", bundle: nil).instantiateViewController(withIdentifier: "CartVC") as? CartVC else { return }
        self.navigationController?.pushViewController(details, animated: true)
        
    }
    @IBAction func decreases(_ sender: UIButton) {
        if productCounter > 1 {
            self.productCounter -= 1
            self.quantityLB.text = "\(self.productCounter)"
        } else {
            self.productCounter = 1
            self.quantityLB.text = "\(self.productCounter)"
        }
    }
    
    @IBAction func AddToCart(_ sender: Any) {
        CartDetailsVCPresenter.showIndicator()
        CartDetailsVCPresenter.postAddToCart(meal_id: details.meal?.id ?? 0, quantity : productCounter , message: notes.text ?? "" , options: [])
        
        
    }
    
    @IBAction func sideMenu(_ sender: Any) {
        self.setupSideMenu()
    }
    @IBAction func increase(_ sender: UIButton) {
        self.productCounter += 1
        self.quantityLB.text = "\(self.productCounter)"
    }
    @IBAction func AdditionsButtonPressed(_ sender: UIButton) {
        guard let Details = UIStoryboard(name: "Orders", bundle: nil).instantiateViewController(withIdentifier: "AdditionsVC") as? AdditionsVC else { return }
        let meal = details.meal ?? Meal()
        Details.meal_id = meal.id ?? 0
        Details.mealName = meal.nameAr ?? ""
        Details.mealComponents = meal.descriptionAr ?? ""
        Details.mealCalory = meal.points ?? 0
        Details.imagePath = details.meal?.image ?? ""
        self.navigationController?.pushViewController(Details, animated: true)
    }
}
extension CartDetailsVC: CartDetailsViewDelegate {
    func AddToCartResult(_ error: Error?, _ result: SuccessError_Model?) {
        if let meals = result {
            if meals.successMessage != "" {
                displayMessage(title: "Success", message: meals.successMessage, status: .success, forController: self)
                guard let details = UIStoryboard(name: "Location", bundle: nil).instantiateViewController(withIdentifier: "MyAddressesVC") as? MyAddressesVC else { return }
                self.navigationController?.pushViewController(details, animated: true)
            } else if meals.meal_id != [""] {
                displayMessage(title: "", message: meals.meal_id[0], status: .error, forController: self)
            } else if meals.quantity != [""] {
                displayMessage(title: "", message: meals.quantity[0], status: .error, forController: self)
            } else if meals.message != [""] {
                displayMessage(title: "", message: meals.message[0], status: .error, forController: self)
            } else if meals.options != [""] {
                displayMessage(title: "", message: meals.options[0], status: .error, forController: self)
            }
        }
    }
    
    
}
