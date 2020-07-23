//
//  SectionsVC.swift
//  Shanab
//
//  Created by Macbook on 3/25/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit

class SectionsVC: UIViewController {
 
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var SectionsTableView: UITableView!
    private let CatgeoriesVCPresenter = CatgeoriesPresenter(services: Services())
    var catgeories = [Category]() {
        didSet {
            DispatchQueue.main.async {
                self.SectionsTableView.reloadData()
            }
        }
    }
    fileprivate let cellIdentifier = "SectionsCell"
    override func viewDidLoad() {
        super.viewDidLoad()
        SectionsTableView.delegate = self
        SectionsTableView.dataSource = self
        SectionsTableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        CatgeoriesVCPresenter.setCatgeoriesViewDelegate(CatgeoriesViewDelegate: self)
        SectionsTableView.rowHeight = UITableView.automaticDimension
                      SectionsTableView.estimatedRowHeight = UITableView.automaticDimension
        CatgeoriesVCPresenter.getCatgeories()
        CatgeoriesVCPresenter.showIndicator()
      
    }
    

  

}
extension SectionsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return catgeories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SectionsCell else { return UITableViewCell()}
        cell.config(imagePath: catgeories[indexPath.row].image ?? "", name: catgeories[indexPath.row].nameAr ?? "")
        return cell 
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         guard let details = UIStoryboard(name: "Products", bundle: nil).instantiateViewController(withIdentifier: "MealDetailsVC") as? MealDetailsVC else { return }
                  details.category_id =  self.catgeories[indexPath.row].id ?? 0
                  self.navigationController?.pushViewController(details, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    
}
extension SectionsVC: CatgeoriesViewDelegate {
    func CatgeoriesResult(_ error: Error?, _ catgeory: [Category]?) {
        if let catgeoryList = catgeory {
            self.catgeories = catgeoryList
        }
    }
    
    
}
