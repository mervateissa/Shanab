//
//  FoodTracksVC.swift
//  Shanab
//
//  Created by Macbook on 3/31/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit

class FoodTracksVC: UIViewController {
    @IBOutlet weak var search: UISearchBar!
    @IBOutlet weak var TracksTableView: UITableView!
    var type = ["truck"]
    private let RestaurantsVCPresenter = RestaurantsPresenter(services: Services())
    fileprivate let cellIdentifier = "ProductiveFamiliesCell"
    var restaurants_list = [Restaurant]()
    {
        didSet {
            DispatchQueue.main.async {
                self.TracksTableView.reloadData()
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        TracksTableView.delegate = self
        TracksTableView.dataSource = self
//        TracksTableView.rowHeight = UITableView.automaticDimension
//               TracksTableView.estimatedRowHeight = UITableView.automaticDimension
        TracksTableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        RestaurantsVCPresenter.setRestaurantsViewDelegate(RestaurantsViewDelegate: self)
        RestaurantsVCPresenter.showIndicator()
        RestaurantsVCPresenter.getAllRestaurants(type: ["truck"])
        
    }
    
    
    
}
extension FoodTracksVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants_list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ProductiveFamiliesCell else { return UITableViewCell()}
        cell.config(familyName: restaurants_list[indexPath.row].nameAr ?? "", time: restaurants_list[indexPath.row].hasDelivery ?? 0 , imagePath: restaurants_list[indexPath.row].image ?? "", productName: restaurants_list[indexPath.row].nameEn ?? "", price: Double(restaurants_list[indexPath.row].hasDelivery ?? 0), rate: Double(restaurants_list[indexPath.row].rate ?? 0))
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        150
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         guard let details = UIStoryboard(name: "Products", bundle: nil).instantiateViewController(withIdentifier: "RestaurantDetailsVC") as? RestaurantDetailsVC else { return }
                details.restaurant_id = restaurants_list[indexPath.row].id ?? 0
               self.navigationController?.pushViewController(details, animated: true)
    }
    
    
}
extension FoodTracksVC: RestaurantsViewDelegate {
   
    
    func getAllRestaurantsResult(_ error: Error?, _ restaurants: [Restaurant]?) {
        if let restaurantList = restaurants {
            self.restaurants_list = restaurantList
            
        }
    }
    
    
}
