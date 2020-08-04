//
//  ProductiveFamiliesVC.swift
//  Shanab
//
//  Created by Macbook on 3/31/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit
class ProductiveFamiliesVC: UIViewController {
    @IBOutlet weak var search: UISearchBar!
    fileprivate let cellIdentifier = "ProductiveFamiliesCell"
    @IBOutlet weak var FamiliesTableView: UITableView!
    //    var type = "family"
    private let RestaurantsVCPresenter = RestaurantsPresenter(services: Services())
    var restaurants_list = [Restaurant]()
    {
        didSet {
            DispatchQueue.main.async {
                self.FamiliesTableView.reloadData()
            }
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FamiliesTableView.delegate = self
        FamiliesTableView.dataSource = self
//        FamiliesTableView.rowHeight = UITableView.automaticDimension
//               FamiliesTableView.estimatedRowHeight = UITableView.automaticDimension
        FamiliesTableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        RestaurantsVCPresenter.setRestaurantsViewDelegate(RestaurantsViewDelegate: self)
        RestaurantsVCPresenter.showIndicator()
        RestaurantsVCPresenter.getAllRestaurants(type: ["family"])
        
    }
    
}
extension ProductiveFamiliesVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants_list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ProductiveFamiliesCell else { return UITableViewCell()}
        cell.config(familyName: restaurants_list[indexPath.row].nameAr ?? "", time: restaurants_list[indexPath.row].hasDelivery ?? 0 , imagePath: restaurants_list[indexPath.row].image ?? "", productName: restaurants_list[indexPath.row].nameEn ?? "", price: Double(restaurants_list[indexPath.row].hasDelivery ?? 0), rate: Double(restaurants_list[indexPath.row].rate ?? 0))
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    
}
extension ProductiveFamiliesVC: RestaurantsViewDelegate {
   
    func getAllRestaurantsResult(_ error: Error?, _ restaurants: [Restaurant]?) {
        if let restaurantList = restaurants {
            self.restaurants_list = restaurantList
            
        }
    }
    
}
