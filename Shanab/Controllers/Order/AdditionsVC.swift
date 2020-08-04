//
//  MakeOrderVC.swift
//  Shanab
//
//  Created by Macbook on 3/26/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit
import DLRadioButton
class AdditionsVC: UIViewController {
    @IBOutlet weak var AdditionTableView: UITableView!
    private let AdditionalVCPresenter = AdditionsPresenter(services: Services())
    @IBOutlet weak var notesTF: UITextField!
    @IBOutlet weak var oneImageView: UIImageView!
    @IBOutlet weak var price: UILabel!
    fileprivate let cellIdentifier = "AdditionsCell"
    fileprivate let HeaderIdentifier = "HeaderCell"
    var restaurant_id = Int()
    var total = Double()
    var meal_id = Int()
       var cartItems = [CartModelItem]()
       var currency = String()
    var mealDetails:  CollectionDataClass? {
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
        AdditionTableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
      AdditionTableView.register(UINib(nibName: HeaderIdentifier, bundle: nil), forCellReuseIdentifier: HeaderIdentifier)
        AdditionalVCPresenter.setAdditionsViewDelegate(AdditionsViewDelegate: self)
        AdditionalVCPresenter.showIndicator()
        AdditionalVCPresenter.postMealDetails(meal_id: 10)
      
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
 
    @IBAction func sideMenu(_ sender: UIBarButtonItem) {
        self.setupSideMenu()
    }
    @IBAction func Increase(_ sender: UIButton) {
    }
    @IBAction func decreaseBN(_ sender: UIButton) {
    }
    
    @IBAction func confirm(_ sender: UIButton) {
       
//                  var modifiedCartItems = self.cartItems
//                  var totalPrice = Double()
//                  var item = CartModelItem(itemId: self.mealDetails[indexPath.row].itemID ?? 0, itemNameEn: item_type.nameEn ?? "", itemNameAr: item_type.nameAr ?? "", itemPrice: 50, itemSize: "Large", itemQuantity: 1, itemImageURL: item_type.image ?? "", itemCurrency: "SAR")
//                  if modifiedCartItems.contains(where: {$0.itemId == item.itemId}) {
//                      item.itemQuantity! += 1
//                  } else {
//                      modifiedCartItems.append(item)
//                  }
//                  for item in modifiedCartItems {
//                      totalPrice += (item.itemPrice ?? 0.0) * (Double(item.itemQuantity ?? 1))
//                  }
//                  self.total = totalPrice
//                  let cartModel = CartModel(items: modifiedCartItems, totalPrice: self.total, cartNotes: "", Currency: self.currency)
//
//                  CartCoreData.SaveCart(cart_data: cartModel)
           }
    
}
extension AdditionsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mealDetails?.collection?[section].option?.count ?? 0
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return mealDetails?.collection?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? AdditionsCell else {return UITableViewCell()}
        cell
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HeaderIdentifier) as? HeaderCell else {return UITableViewCell()}
        cell.config(mealName: mealDetails?.collection?[section].nameAr ?? "" )
        
            return cell
    }
   
    
}
extension AdditionsVC: AdditionsViewDelegate {
    func MealDetailsResult(_ error: Error?, _ details: CollectionDataClass?) {
        if let lists = details {
            self.mealDetails = lists
        }
    }
    
}
