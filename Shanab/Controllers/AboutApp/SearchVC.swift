//
//  SearchVC.swift
//  Shanab
//
//  Created by Macbook on 3/25/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit

class SearchVC: UIViewController {
    
    @IBOutlet weak var products: UIButton!
    @IBOutlet weak var restaurants: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchTableView: UITableView!
    private let cellForTable = "RestaurantCell"
    private let MealsCellIdentifier = "SearchCell"
    var type = String()
    var id = Int()
    var isSearching = false
    var MealSearch = [Collection]()
    var NormalResult = [SearchResult]()
     private let SearchVCPresenter = SearchPresenter(services: Services())
   
    
    //    var SearchingResult = [SearchProduct]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTableView.delegate = self
        searchTableView.dataSource = self
        searchTableView.register(UINib(nibName: cellForTable, bundle: nil), forCellReuseIdentifier: cellForTable)
        searchTableView.register(UINib(nibName: MealsCellIdentifier, bundle: nil), forCellReuseIdentifier: MealsCellIdentifier)
        SearchVCPresenter.setSearchViewDelegate(SearchViewDelegate: self)
        SearchVCPresenter.showIndicator()
       
        
        
    }
    
    
    
    
    @IBAction func restaurantsBn(_ sender: UIButton) {
        SearchVCPresenter.postRestaurantSearch(word: "restaurant")
        var  NormalResult = [SearchResult]() {
            didSet {
                DispatchQueue.main.async {
                    self.searchTableView.reloadData()
                }
            }
        }
        
    }
    @IBAction func products(_ sender: UIButton) {
         SearchVCPresenter.postMealSearch(word: "meal")
        var MealSearch = [Collection]() {
            didSet {
                DispatchQueue.main.sync {
                    self.searchTableView.reloadData()
                }
            }
        }
        
    }
    @IBAction func searchBn(_ sender: UIButton) {
    }
    @IBAction func sideMenu(_ sender: UIBarButtonItem) {
        self.setupSideMenu()
    }
}
extension SearchVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 200
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if type ==  "restaurant" {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellForTable, for: indexPath) as? RestaurantCell else { return UITableViewCell()}
            cell.config(name: NormalResult[indexPath.row].nameAr ?? "", time: 0, imagePath: NormalResult[indexPath.row].image ?? "")
            return cell
            
            
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MealsCellIdentifier, for: indexPath) as? SearchCell else { return UITableViewCell()}
            cell.config(name: NormalResult[indexPath.row].nameAr ?? "", imagePath: NormalResult[indexPath.row].image ?? "", section: NormalResult[indexPath.row].type ?? "", price: "")
            return cell
        }
        
        
        
    }
    
    
}
extension SearchVC: SearchViewDelegate {
    func MealSearchResult(_ error: Error?, _ result: [Collection]?) {
        if let lists = result{
            self.MealSearch = lists
        }
        
    }
    
    func RestaurantSearchResult(_ error: Error?, _ restaurantResult: [SearchResult]?) {
        if let lists = restaurantResult {
            self.NormalResult =  lists
        }
    }
    
    
    
}

