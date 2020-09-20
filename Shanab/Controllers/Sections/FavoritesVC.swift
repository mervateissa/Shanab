//
//  FavoritesVC.swift
//  Shanab
//
//  Created by Macbook on 3/30/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit
class FavoritesVC: UIViewController {
    fileprivate let cellIdentifier = "FavoriteCell"
    var item_type = "restaurant"
    var deletedIndex: Int = 0
    private let UserFavoritesVCPresenter = UserFavoritesPresenter(services: Services())
    @IBOutlet weak var favoriteTableView: UITableView!
    var ClientFavoriteList = [Favorites]() {
        didSet {
            DispatchQueue.main.async {
                self.favoriteTableView.reloadData()
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        favoriteTableView.delegate = self
        favoriteTableView.dataSource = self
        favoriteTableView.rowHeight = UITableView.automaticDimension
        favoriteTableView.estimatedRowHeight = UITableView.automaticDimension
        favoriteTableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        UserFavoritesVCPresenter.setUserFavoritesViewDelegate(UserFavoritesViewDelegate: self)
        UserFavoritesVCPresenter.showIndicator()
        UserFavoritesVCPresenter.postFavoriteGet(item_type: "restaurant")
        
    }
    @IBAction func sideMenu(_ sender: Any) {
         self.setupSideMenu()
    }
    @IBAction func cart(_ sender: Any) {
        guard let details = UIStoryboard(name: "Cart", bundle: nil).instantiateViewController(withIdentifier: "CartVC") as? CartVC else { return }
               self.navigationController?.pushViewController(details, animated: true)
    }
}
extension FavoritesVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ClientFavoriteList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? FavoriteCell else {return UITableViewCell()}
        if "lang".localized == "ar" {
            let item_type = ClientFavoriteList[indexPath.row].restaurant ?? restaurant()
            cell.config(name: item_type.nameAr ?? "", details: item_type.descriptionAr ?? "", imagePath: item_type.image ?? "")
        } else {
            let item_type = ClientFavoriteList[indexPath.row].restaurant ?? restaurant()
            cell.config(name: item_type.nameEn ?? "", details: item_type.descriptionEn ?? "", imagePath: item_type.image ?? "")
        }
        
        cell.AddToCart = {
        
            
        }
        cell.RemoveFromeFavorite = {
            self.deletedIndex = indexPath.row
            self.UserFavoritesVCPresenter.showIndicator()
            self.UserFavoritesVCPresenter.postRemoveFavorite(item_id: self.ClientFavoriteList[indexPath.row].id ?? 0, item_type: self.ClientFavoriteList[indexPath.row].itemType ?? "")
        }
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 150
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let details = UIStoryboard(name: "Products", bundle: nil).instantiateViewController(withIdentifier: "RestaurantDetailsVC") as? RestaurantDetailsVC else { return }
        details.restaurant_id = ClientFavoriteList[indexPath.row].id ?? 0
        //               details.image = ClientFavoriteList[indexPath.row]. ?? ""
        self.navigationController?.pushViewController(details, animated: true)
    }
}
extension FavoritesVC: UserFavoritesViewDelegate {
    func RemoveFavorite(_ error: Error?, _ result: SuccessError_Model?) {
        if let resultMsg = result {
            if resultMsg.successMessage != "" {
                displayMessage(title: "", message: resultMsg.successMessage, status: .success, forController: self)
                self.ClientFavoriteList.remove(at: deletedIndex)
            } else if resultMsg.item_id != [""] {
                displayMessage(title: "", message: resultMsg.item_id[0], status: .error, forController: self)
            } else if resultMsg.item_type != [""] {
                displayMessage(title: "", message: resultMsg.item_type[0], status: .error, forController: self)
            }
        }
    }
    
    func UserFavoritesResult(_ error: Error?, _ favoriteList: [Favorites]?) {
        if let lists = favoriteList{
            self.ClientFavoriteList = lists.reversed()
            
        }
        
        
    }
}
