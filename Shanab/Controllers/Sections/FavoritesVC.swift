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
    
}
extension FavoritesVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ClientFavoriteList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? FavoriteCell else {return UITableViewCell()}
        let item_type = ClientFavoriteList[indexPath.row].restaurant ?? restaurant()
              cell.config(name: item_type.nameAr ?? "", details: item_type.descriptionAr ?? "", imagePath: item_type.image ?? "")
        cell.AddToCart = {
            
        }
      
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        150
    }
}
extension FavoritesVC: UserFavoritesViewDelegate {
    func UserFavoritesResult(_ error: Error?, _ favoriteList: [Favorites]?) {
        if let lists = favoriteList{
            self.ClientFavoriteList = lists.reversed()
            
        }
        
        
    }
}
