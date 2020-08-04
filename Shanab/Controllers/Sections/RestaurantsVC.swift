//
//  RestaurantsVC.swift
//  Shanab
//
//  Created by Macbook on 3/31/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit
class RestaurantsVC: UIViewController {
    private let RestaurantsVCPresenter = RestaurantsPresenter(services: Services())
    @IBOutlet weak var search: UISearchBar!
    var type = ["restaurant"]
    fileprivate let cellIdentifier = "ProductiveFamiliesCell"
    @IBOutlet weak var restaurantsTableView: UITableView!
    var restaurant_id = Int()
    var restaurants_list = [Restaurant]() {
        didSet {
            DispatchQueue.main.async {
                self.restaurantsTableView.reloadData()
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        restaurantsTableView.delegate = self
        restaurantsTableView.dataSource = self
//        restaurantsTableView.rowHeight = UITableView.automaticDimension
//               restaurantsTableView.estimatedRowHeight = UITableView.automaticDimension
        restaurantsTableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        RestaurantsVCPresenter.setRestaurantsViewDelegate(RestaurantsViewDelegate: self)
        RestaurantsVCPresenter.showIndicator()
        RestaurantsVCPresenter.getAllRestaurants(type: ["restaurant"])
        
    }
}
extension RestaurantsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants_list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as?
            ProductiveFamiliesCell else { return UITableViewCell()}
        cell.config(familyName: restaurants_list[indexPath.row].nameAr ?? "", time: restaurants_list[indexPath.row].hasDelivery ?? 0 , imagePath: restaurants_list[indexPath.row].image ?? "", productName: restaurants_list[indexPath.row].nameEn ?? "", price: Double(restaurants_list[indexPath.row].hasDelivery ?? 0), rate: Double(restaurants_list[indexPath.row].rate ?? 0))
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        120
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let details = UIStoryboard(name: "Products", bundle: nil).instantiateViewController(withIdentifier: "RestaurantDetailsVC") as? RestaurantDetailsVC else { return }
         details.restaurant_id = restaurants_list[indexPath.row].id ?? 0
        self.navigationController?.pushViewController(details, animated: true)
    }
     
    
}
extension RestaurantsVC: RestaurantsViewDelegate {
    func getAllRestaurantsResult(_ error: Error?, _ restaurants: [Restaurant]?) {
        if let restaurantList = restaurants {
            self.restaurants_list = restaurantList
        }
    }
    
}
