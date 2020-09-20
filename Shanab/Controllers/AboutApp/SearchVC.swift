//
//  SearchVC.swift
//  Shanab
//
//  Created by Macbook on 3/25/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit

class SearchVC: UIViewController {
    @IBOutlet weak var sigmentSearch: UISegmentedControl!
    //    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var MealsTableView: UITableView!
    @IBOutlet weak var SegmantStackView: UIStackView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchStack: UIStackView!
    @IBOutlet weak var searchTableView: UITableView!
    private let cellForTable = "ProductiveFamiliesCell"
    private let MealsCellIdentifier = "BestSellerCell"
    var type = String()
    var id = Int()
    var isSearching = false
    var MealSearch = [CollectionDataClass]() {
        didSet {
            DispatchQueue.main.async {
                self.MealsTableView.reloadData()
            }
        }
    }
    var NormalResult = [SearchResult]() {
        didSet {
            DispatchQueue.main.async {
                self.searchTableView.reloadData()
            }
        }
    }
    private let SearchVCPresenter = SearchPresenter(services: Services())
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTableView.delegate = self
        searchTableView.dataSource = self
        MealsTableView.delegate = self
        MealsTableView.dataSource = self
        sigmentSearch.layer.cornerRadius = 25
        sigmentSearch.layer.borderWidth = 1
        sigmentSearch.layer.borderColor = #colorLiteral(red: 0.9195484519, green: 0.2682709396, blue: 0.21753335, alpha: 1)
        SegmantStackView.layer.cornerRadius = 25
        SegmantStackView.layer.borderWidth = 1
        SegmantStackView.layer.borderColor = #colorLiteral(red: 0.9275402427, green: 0.2603120804, blue: 0.1841255426, alpha: 1)
        searchBar.returnKeyType = UIReturnKeyType.done
        searchTableView.register(UINib(nibName: cellForTable, bundle: nil), forCellReuseIdentifier: cellForTable)
        MealsTableView.register(UINib(nibName: MealsCellIdentifier, bundle: nil), forCellReuseIdentifier: MealsCellIdentifier)
        SearchVCPresenter.setSearchViewDelegate(SearchViewDelegate: self)
          searchStack.layer.borderColor = #colorLiteral(red: 0.9195484519, green: 0.2682709396, blue: 0.21753335, alpha: 1)
        searchStack.layer.borderWidth = 1
        searchStack.layer.cornerRadius = 25
        
    }
    @IBAction func sigmentPressed(_ sender: Any) {
        switch sigmentSearch.selectedSegmentIndex
            
        {
        case 1:
            self.type = "restaurant"
            if self.searchBar.text == "" {
                self.MealsTableView.isHidden = false
                self.searchTableView.isHidden = true
            } else {
                self.searchTableView.isHidden = false
                self.MealsTableView.isHidden = true
                SearchVCPresenter.showIndicator()
                SearchVCPresenter.postRestaurantSearch(word: self.searchBar.text ?? "")
                
            }
        case 0:
            self.type = "meal"
            if self.searchBar.text == "" {
                self.searchTableView.isHidden = false
                self.MealsTableView.isHidden = true
            } else {
                self.MealsTableView.isHidden = false
                self.searchTableView.isHidden = true
                SearchVCPresenter.showIndicator()
                SearchVCPresenter.postMealSearch(word: self.searchBar.text ?? "")
                
            }
        default:
            break
        }
    }
   
    
//    @IBAction func sideMenu(_ sender: UIBarButtonItem) {
//        self.setupSideMenu()
//    }
    @IBAction func backButton(_ sender: Any) {
        guard let window = UIApplication.shared.keyWindow else { return }
                  let sb = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HomeTabBar")
                  window.rootViewController = sb
                  UIView.transition(with: window, duration: 0.5, options: .curveEaseInOut, animations: nil, completion: nil)
    }
}
extension SearchVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if type == "restaurant" {
            return NormalResult.count
        } else if type == "meal" {
            return MealSearch.count
        }
        else {
            return NormalResult.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if type ==  "restaurant" {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellForTable, for: indexPath) as? ProductiveFamiliesCell else { return UITableViewCell()}
            cell.config(familyName: NormalResult[indexPath.row].nameEn ?? "" , time: 0 , imagePath: NormalResult[indexPath.row].image ?? "" , productName: NormalResult[indexPath.row].type ?? "", price: 0, rate: Double(NormalResult[indexPath.row].rate ?? 0))
            return cell
        } else {
             
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MealsCellIdentifier, for: indexPath) as? BestSellerCell else { return UITableViewCell()}
            cell.config(imagePath: MealSearch[indexPath.row].image ?? "", name: MealSearch[indexPath.row].nameAr ?? "", mealComponants: MealSearch[indexPath.row].descriptionAr ?? "", price: 0)
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}

extension SearchVC: SearchViewDelegate {
    func MealSearchResult(_ error: Error?, _ result: [CollectionDataClass]?) {
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
extension SearchVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            self.searchTableView.isHidden = true
            self.MealsTableView.isHidden = true
           
            if type == "restaurant" {
                SearchVCPresenter.showIndicator()
                SearchVCPresenter.postRestaurantSearch(word: self.searchBar.text ?? "")
                isSearching = true
                self.searchTableView.isHidden = false
                self.MealsTableView.isHidden = true
                self.searchTableView.reloadData()
            } else {
              
                SearchVCPresenter.showIndicator()
                SearchVCPresenter.postMealSearch(word: self.searchBar.text ?? "")
                isSearching = true
                self.MealsTableView.isHidden = false
                self.searchTableView.isHidden = true
                self.MealsTableView.reloadData()
            }
            
            //}
            //    //        print(SearchResultVC)
            
        }
        
    }
}
