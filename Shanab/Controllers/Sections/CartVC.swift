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
    private let FavoriteVCPresenter = FavoritePresenter(services: Services())
    @IBOutlet weak var total: CustomLabel!
    @IBOutlet weak var discreption: UITextView!
    
    var totalPrice = Double()
    var currency = String()
    var Cart = [CartModelItem]() {
        didSet {
            DispatchQueue.main.async {
                self.cartTableView.reloadData()
            }
        }
    }
    fileprivate let cellIdentifier = "CartCell"
    override func viewDidLoad() {
        super.viewDidLoad()
        handleGetCart()
        cartTableView.delegate = self
        cartTableView.dataSource = self
        cartTableView.rowHeight = UITableView.automaticDimension
        cartTableView.estimatedRowHeight = UITableView.automaticDimension
        cartTableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        
        
    }
    
    @IBAction func confirm(_ sender: UIButton) {
        if !discreption.text.isEmpty {
            let cartModel = CartModel(items: self.Cart, totalPrice: self.totalPrice, cartNotes: self.discreption.text, Currency: self.currency)
            CartCoreData.SaveCart(cart_data: cartModel)
            guard let Details = UIStoryboard(name: "Location", bundle: nil).instantiateViewController(withIdentifier: "MyAddressesVC") as? MyAddressesVC else { return }
            self.navigationController?.pushViewController(Details, animated: true)
        }
    }
    
    func handleGetCart() {
        if let cart = CartCoreData.getCurrentCart()  {
            self.total.text = "\(cart.totalPrice ?? 0.0) \(cart.Currency ?? "")"
            self.Cart = cart.items ?? []
            self.totalPrice = cart.totalPrice ?? 0.0
            self.currency = cart.Currency ?? ""
            if self.Cart.count == 0 {
                
            } else {
                
            }
            
            
        } else {
            displayMessage(title: "", message: "No Cart Yet", status: .error, forController: self)
        }
    }
}
extension CartVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Cart.count
    }
    //    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //        return 200
    //    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CartCell else {return UITableViewCell()}
        
        cell.quantityLB.text = "\(self.Cart[indexPath.row].itemQuantity ?? 0)"
        cell.orderName.text = self.Cart[indexPath.row].itemNameEn ?? ""
        cell.Dicrease = {
            if cell.productCounter > 1 {
                cell.productCounter -= 1
                
            } else {
                cell.productCounter = 1
                
            }
            //self.Cart[indexPath.row].itemQuantity = cell.productCounter
            var modifiedCartItems = self.Cart
            var totalPrice = Double()
            var item = CartModelItem(itemId: self.Cart[indexPath.row].itemId ?? 0,itemNameEn: self.Cart[indexPath.row].itemNameEn ?? "" , itemNameAr: self.Cart[indexPath.row].itemNameAr ?? "", itemPrice: self.Cart[indexPath.row].itemPrice ?? 0, itemSize: self.Cart[indexPath.row].itemSize ?? "", itemQuantity: self.Cart[indexPath.row].itemQuantity ?? 0, itemImageURL: self.Cart[indexPath.row].itemImageURL ?? "", itemCurrency: self.Cart[indexPath.row].itemCurrency ?? "", options: self.Cart[indexPath.row].options ?? [])
            if modifiedCartItems.contains(where: {$0.itemId == item.itemId}) {
                modifiedCartItems.removeAll(where: {$0.itemId == item.itemId})
                if item.itemQuantity ?? 1 > 1 {
                    item.itemQuantity! -= 1
                } else {
                    item.itemQuantity! = 1
                }
                //                for i in 0..<modifiedCartItems.count {
                //                    if modifiedCartItems[i].itemId == item.itemId {
                //                        if modifiedCartItems[i].itemQuantity! > 1 {
                //                            modifiedCartItems[i].itemQuantity! -= 1
                //                        } else {
                //                            modifiedCartItems[i].itemQuantity! = 1
                //                        }
                //                    }
                //                }
            }
            modifiedCartItems.append(item)
            for item in modifiedCartItems {
                totalPrice += (item.itemPrice ?? 0.0) * (Double(item.itemQuantity ?? 1))
            }
            self.totalPrice = totalPrice
            let cartModel = CartModel(items: modifiedCartItems, totalPrice: self.totalPrice, cartNotes: "", Currency: self.currency)
            
            CartCoreData.SaveCart(cart_data: cartModel)
            self.handleGetCart()
        }
        cell.Increase = {
            cell.productCounter += 1
            //self.Cart[indexPath.row].itemQuantity = cell.productCounter
            var modifiedCartItems = self.Cart
            var totalPrice = Double()
            var item = CartModelItem(itemId: self.Cart[indexPath.row].itemId ?? 0,itemNameEn: self.Cart[indexPath.row].itemNameEn ?? "" , itemNameAr: self.Cart[indexPath.row].itemNameAr ?? "", itemPrice: self.Cart[indexPath.row].itemPrice ?? 0, itemSize: self.Cart[indexPath.row].itemSize ?? "", itemQuantity: self.Cart[indexPath.row].itemQuantity ?? 0, itemImageURL: self.Cart[indexPath.row].itemImageURL ?? "", itemCurrency: self.Cart[indexPath.row].itemCurrency ?? "", options: self.Cart[indexPath.row].options ?? [])
            if modifiedCartItems.contains(where: {$0.itemId == item.itemId}) {
                modifiedCartItems.removeAll(where: {$0.itemId == item.itemId})
                item.itemQuantity! += 1
                
            }
            modifiedCartItems.append(item)
            for item in modifiedCartItems {
                totalPrice += (item.itemPrice ?? 0.0) * (Double(item.itemQuantity ?? 1))
            }
            self.totalPrice = totalPrice
            let cartModel = CartModel(items: modifiedCartItems, totalPrice: self.totalPrice, cartNotes: "", Currency: self.currency)
            
            CartCoreData.SaveCart(cart_data: cartModel)
            self.handleGetCart()
            
        }
        cell.delet = {
            var modifiedCartItems = self.Cart
            var totalPrice = Double()
            var item = CartModelItem(itemId: self.Cart[indexPath.row].itemId ?? 0,itemNameEn: self.Cart[indexPath.row].itemNameEn ?? "" , itemNameAr: self.Cart[indexPath.row].itemNameAr ?? "", itemPrice: self.Cart[indexPath.row].itemPrice ?? 0, itemSize: self.Cart[indexPath.row].itemSize ?? "", itemQuantity: self.Cart[indexPath.row].itemQuantity ?? 0, itemImageURL: self.Cart[indexPath.row].itemImageURL ?? "", itemCurrency: self.Cart[indexPath.row].itemCurrency ?? "",options: self.Cart[indexPath.row].options ?? [])
            if modifiedCartItems.contains(where: {$0.itemId == item.itemId}) {
                modifiedCartItems.removeAll(where: {$0.itemId == item.itemId})
                
            }
            for item in modifiedCartItems {
                totalPrice += (item.itemPrice ?? 0.0) * (Double(item.itemQuantity ?? 1))
            }
            self.totalPrice = totalPrice
            let cartModel = CartModel(items: modifiedCartItems, totalPrice: self.totalPrice, cartNotes: "", Currency: self.currency)
            
            CartCoreData.SaveCart(cart_data: cartModel)
            self.handleGetCart()
        }
        
        return cell
    }
    
    
}
extension CartVC: FavoriteViewDelegate {
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
    
    
}

