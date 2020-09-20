//
//  CartVC.swift
//  Shanab
//
//  Created by Macbook on 3/23/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit

class CartVC: UIViewController {
    @IBOutlet weak var cartTableView: UITableView!
    private let OnlineCartVCPresenter = OnlineCartPresenter(services: Services())
    @IBOutlet weak var total: CustomLabel!
    @IBOutlet weak var discreption: UITextView!
    var totalPrice = Double()
    var currency = String()
    var productCounter = 1
    var mealId = Int()
    var quantity = Int()
    var nameMeal = String()
    var mealComponents = String()
    var totalCartPrice: Double = 0.0
    var deletedIndex: Int = 0
    fileprivate let cellIdentifier = "CartCell"
    var CartIems = [onlineCart]() {
        didSet {
            DispatchQueue.main.async {
                self.cartTableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        OnlineCartVCPresenter.setonlineCartViewDelegate(onlineCartViewDelegate: self)
        OnlineCartVCPresenter.showIndicator()
        OnlineCartVCPresenter.getCartItems()
        cartTableView.delegate = self
        cartTableView.dataSource = self
        cartTableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        //        cartTableView.tableFooterView = UIView()
    }
    @IBAction func confirm(_ sender: UIButton) {
        guard let Details = UIStoryboard(name: "Location", bundle: nil).instantiateViewController(withIdentifier: "MyAddressesVC") as? MyAddressesVC else { return }
        Details.total = totalCartPrice
        Details.quantity = productCounter
        self.navigationController?.pushViewController(Details, animated: true)
        if (discreption?.text.isEmpty)! {
            
        }
    }
    @IBAction func menu(_ sender: Any) {
        self.setupSideMenu()
    }
    @IBAction func backButton(_ sender: Any) {
        guard let window = UIApplication.shared.keyWindow else { return }
        let sb = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HomeTabBar")
        window.rootViewController = sb
        UIView.transition(with: window, duration: 0.5, options: .curveEaseInOut, animations: nil, completion: nil)
    }
}

extension CartVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CartIems.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let Details = UIStoryboard(name: "Orders", bundle: nil).instantiateViewController(withIdentifier: "AdditionsVC") as? AdditionsVC else { return }
        let meal = CartIems[indexPath.row].meal ?? Meal()
        Details.meal_id = CartIems[indexPath.row].meal?.id ?? 0
        if "lang".localized == "ar" {
            Details.mealName = meal.nameAr ?? ""
            Details.mealComponents = meal.descriptionAr ?? ""
        } else {
            Details.mealName = meal.nameEn ?? ""
            Details.mealComponents = meal.descriptionEn ?? ""
        }
        
        
        Details.mealCalory = meal.points ?? 0
        Details.imagePath = CartIems[indexPath.row].meal?.image ?? ""
        //        Details. = CartIems[indexPath.row].meal?.option?[0].nameAr ?? ""
        Details.productCounter = CartIems[indexPath.row].quantity ?? 0
        Details.total = Double(meal.price?[0].price ?? 0)
        self.cartTableView.reloadData()
        self.navigationController?.pushViewController(Details, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CartCell else {return UITableViewCell()}
        let meal = CartIems[indexPath.row].meal ?? Meal()
        let meal_price = meal.price?[0].price ?? 0
        if "lang".localized == "ar" {
            cell.config(name: meal.nameAr  ?? "", price: 0 , imagePath: meal.image ?? "", components: meal.descriptionAr ?? "")
        } else {
            cell.config(name: meal.nameEn  ?? "", price: 0 , imagePath: meal.image ?? "", components: meal.descriptionEn ?? "")
        }
        
        let price = Double(CartIems[indexPath.row].quantity ?? 0) * (CartIems[indexPath.row].meal?.price?[0].price ?? 0.0)
        cell.quantityLB.text = "\(self.CartIems[indexPath.row].quantity ?? 0)"
        cell.orderName.text = self.CartIems[indexPath.row].meal?.nameAr ?? ""
        cell.price.text = "\(price.rounded(toPlaces: 2))"
        totalCartPrice += price
        let totalPrice = Int(meal_price) * productCounter
        //        total.text =  "\(meal_price)"
        total.text = "\(totalPrice)"
        cell.Dicrease = {
            
            if cell.productCounter > 1 {
                cell.productCounter -= 1
                cell.quantityLB.text = "\(self.productCounter)"
                cell.price.text = "\(meal_price)"
                let totalPrice = Double(meal_price) * Double(cell.productCounter)
                cell.price.text = "\(totalPrice.rounded(toPlaces: 2))"
                //self.total.text =  "\(meal_price)"
                // self.total.text = "\(totalPrice)"
                self.totalCartPrice -= meal_price
                self.total.text = "\(self.totalCartPrice.rounded(toPlaces: 2))"
                guard let Details = UIStoryboard(name: "Cart", bundle: nil).instantiateViewController(withIdentifier: "CartDetailsVC") as? CartDetailsVC else { return }
                let meal = self.CartIems[indexPath.row].meal ?? Meal()
                Details.mealId = self.CartIems[indexPath.row].meal?.id ?? 0
                Details.mealName = meal.nameAr ?? ""
                Details.components = meal.descriptionAr ?? ""
                Details.caloriesNamber = meal.status ?? ""
                Details.imagePath = self.CartIems[indexPath.row].meal?.image ?? ""
                Details.Addition = self.CartIems[indexPath.row].meal?.option?[0].nameAr ?? ""
                Details.quantity = self.CartIems[indexPath.row].quantity ?? 0
                Details.price = Int(meal.price?[0].price ?? 0)
                Details.price = Int((self.totalCartPrice))
                self.cartTableView.reloadData()
                self.navigationController?.pushViewController(Details, animated: true)
                
            } else {
                cell.productCounter = 1
                cell.quantityLB.text = "\(self.productCounter)"
                //cell.price.text = "\(meal_price)"
                let totalPrice = Double(meal_price) * Double(cell.productCounter)
                cell.price.text = "\(totalPrice.rounded(toPlaces: 2))"
                //                self.total.text =  "\(meal_price)"
                //                self.total.text = "\(totalPrice)"
                self.totalCartPrice -= meal_price
                self.total.text = "\(self.totalCartPrice.rounded(toPlaces: 2))"
                
            }
            
        }
        cell.Increase = {
            
            cell.productCounter += 1
            cell.quantityLB.text = "\(self.productCounter)"
            cell.price.text = "\(meal_price)"
            let totalPrice = Double(meal_price) * Double(cell.productCounter)
            //cell.price.text = "test" //"\(totalPrice)"
            //            self.total.text = "\(totalPrice)"
            cell.price.text = "\(totalPrice.rounded(toPlaces: 2))"
            //self.total.text = "\(totalPrice)"
            self.totalCartPrice += meal_price
            self.total.text = "\(self.totalCartPrice.rounded(toPlaces: 2))"
            //            guard let Details = UIStoryboard(name: "Cart", bundle: nil).instantiateViewController(withIdentifier: "CartDetailsVC") as? CartDetailsVC else { return }
            //            let meal = self.CartIems[indexPath.row].meal ?? Meal()
            //            Details.mealId = self.CartIems[indexPath.row].id ?? 0
            //            Details.mealName = meal.nameAr ?? ""
            //            Details.components = meal.descriptionAr ?? ""
            //            Details.caloriesNamber = meal.status ?? ""
            //            Details.imagePath = self.CartIems[indexPath.row].meal?.image ?? ""
            //            Details.Addition = self.CartIems[indexPath.row].meal?.option?[0].nameAr ?? ""
            //            Details.quantity = self.CartIems[indexPath.row].quantity ?? 0
            //            Details.price = Int(meal.price?[0].price ?? 0)
            //            self.cartTableView.reloadData()
            //            self.navigationController?.pushViewController(Details, animated: true)
            
        }
        cell.delet = {
            self.deletedIndex = indexPath.row
            self.OnlineCartVCPresenter.showIndicator()
            self.OnlineCartVCPresenter.postDeleteCart(condition: "one" , id: self.CartIems[indexPath.row].id ?? 0)
            
            
            
        }
        
        if indexPath.row == CartIems.count - 1 {
            total.text = "\(totalCartPrice.rounded(toPlaces: 2))"
        }
        return cell
    }
}

extension CartVC: onlineCartViewDelegate {
    func postDeleteCart(_ error: Error?, _ result: SuccessError_Model?) {
        if let resultMsg = result {
            if resultMsg.successMessage == "" {
                displayMessage(title: "scuccess", message: resultMsg.successMessage, status: .success, forController: self)
                self.CartIems.remove(at: deletedIndex)
                self.cartTableView.deleteRows(at: [IndexPath(row: deletedIndex, section: 0)], with: .automatic)
            } else if !resultMsg.condition.isEmpty ,resultMsg.condition != [""] {
                displayMessage(title: "", message: resultMsg.condition[0], status: .error, forController: self)
            } else if !resultMsg.id.isEmpty ,resultMsg.id != [""] {
                displayMessage(title: "", message: resultMsg.id[0], status: .error, forController: self)
            }
        }
    }
    
    func FavoriteResult(_ error: Error?, _ result: SuccessError_Model?) {
        if let resultMsg = result {
            if resultMsg.successMessage != "" {
                displayMessage(title: "", message: resultMsg.successMessage, status: .success, forController: self)
            } else if resultMsg.item_id != [""] {
                displayMessage(title: "", message: resultMsg.item_id[0], status: .error, forController: self)
            } else if resultMsg.item_type != [""] {
                displayMessage(title: "", message: resultMsg.item_type[0], status: .error, forController: self)
            }
        }
    }
    
    func RemoveFavorite(_ error: Error?, _ result: SuccessError_Model?) {
        if let resultMsg = result {
            if resultMsg.successMessage != "" {
                displayMessage(title: "", message: resultMsg.successMessage, status: .success, forController: self)
            } else if resultMsg.item_id != [""] {
                displayMessage(title: "", message: resultMsg.item_id[0], status: .error, forController: self)
            } else if resultMsg.item_type != [""] {
                displayMessage(title: "", message: resultMsg.item_type[0], status: .error, forController: self)
            }
        }
        
    }
    
    func getCartResult(_ error: Error?, _ result: [onlineCart]?) {
        if let cart_items = result {
            self.CartIems = cart_items
            Singletone.instance.cart = CartIems
        }
    }
    
    
}

extension Double {
    
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
