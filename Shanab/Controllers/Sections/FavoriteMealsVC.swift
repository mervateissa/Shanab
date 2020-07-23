//
//  FavoriteMealsVC.swift
//  Shanab
//
//  Created by Macbook on 7/1/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit

class FavoriteMealsVC: UIViewController {
    @IBOutlet weak var favoriteMealsTableView: UITableView!
    fileprivate let cellIdentifier = "FavoriteCell"
    var item_type = "meal"
    private let UserFavoritesMealsVCPresenter = UserFavoritesMealsPresenter(services: Services())
    var ClientFavoriteList = [Favorites]() {
        didSet {
            DispatchQueue.main.async {
                self.favoriteMealsTableView.reloadData()
            }
        }
    }
    var total = Double()
    var cartItems = [CartModelItem]()
    var currency = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        favoriteMealsTableView.delegate = self
        favoriteMealsTableView.dataSource = self
        favoriteMealsTableView.rowHeight = UITableView.automaticDimension
               favoriteMealsTableView.estimatedRowHeight = UITableView.automaticDimension
        favoriteMealsTableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        UserFavoritesMealsVCPresenter.setFavoriteMealsViewDelegate(FavoriteMealsViewDelegate: self)
        UserFavoritesMealsVCPresenter.showIndicator()
        UserFavoritesMealsVCPresenter.postFavoriteGet(item_type: "meal")
        handleGetCart()
        
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
    
    
}
extension FavoriteMealsVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ClientFavoriteList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? FavoriteCell else {return UITableViewCell()}
        let item_type = ClientFavoriteList[indexPath.row].meal ?? Meal()
        cell.AddToCart = {
            var modifiedCartItems = self.cartItems
            var totalPrice = Double()
            var item = CartModelItem(itemId: self.ClientFavoriteList[indexPath.row].itemID ?? 0, itemNameEn: item_type.nameEn ?? "", itemNameAr: item_type.nameAr ?? "", itemPrice: 50, itemSize: "Large", itemQuantity: 1, itemImageURL: item_type.image ?? "", itemCurrency: "SAR")
            if modifiedCartItems.contains(where: {$0.itemId == item.itemId}) {
                item.itemQuantity! += 1
            } else {
                modifiedCartItems.append(item)
            }
            for item in modifiedCartItems {
                totalPrice += (item.itemPrice ?? 0.0) * (Double(item.itemQuantity ?? 1))
            }
            self.total = totalPrice
            let cartModel = CartModel(items: modifiedCartItems, totalPrice: self.total, cartNotes: "", Currency: self.currency)
            
            CartCoreData.SaveCart(cart_data: cartModel)
        }
        
        cell.config(name: item_type.nameAr ?? "" , details: item_type.descriptionAr ?? "" , imagePath: item_type.image ?? "")
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        150
    }
    
    
}
extension FavoriteMealsVC: FavoriteMealsViewDelegate {
    func UserFavoriteMealssResult(_ error: Error?, _ favoriteList: [Favorites]?) {
        if let lists = favoriteList{
            self.ClientFavoriteList = lists.reversed()
            
        }
    }
    
    
    
    
}
