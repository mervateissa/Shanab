//
//  BestSellerVC.swift
//  Shanab
//
//  Created by Macbook on 3/23/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit
import ImageSlideshow
class RestaurantDetailsVC: UIViewController {
    private let RestaurantDetailVCPresenter = RestaurantDetailPresenter(services: Services())
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    @IBOutlet weak var oneImageView: UIImageView!
    @IBOutlet weak var deliveryFees: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var ProductName: UILabel!
    fileprivate let cellIdentifier = "BestSellerCell"
    fileprivate let CellIdentifier = "RestaurantDetailsCell"
    @IBOutlet weak var bestSellerTableView: UITableView!
    var mealId = Int()
    var categoriesArr = [CategoriesModel]()
    var meals = [RestaurantMeal]() {
        didSet{
            DispatchQueue.main.async {
                          self.bestSellerTableView.reloadData()
                      }
        }
    }
    var details = [RestaurantDetail]() {
        didSet {
            DispatchQueue.main.async {
                self.bestSellerTableView.reloadData()
            }
        }
    }
    
    var restaurant_id = Int()
    var category_id = Int()
    override func viewDidLoad() {
        super.viewDidLoad()
        categoriesArr.append(CategoriesModel(name: "MosttSeller", id: "category", selected: true))
         categoriesArr.append(CategoriesModel(name: "Offers", id: "top", selected: false))
         categoriesArr.append(CategoriesModel(name: "Drinks", id: "offer", selected: false))
         categoriesArr.append(CategoriesModel(name: "MosttSeller", id: "category", selected: false))
        productImage.setRounded()
        bestSellerTableView.delegate = self
        bestSellerTableView.dataSource = self
        bestSellerTableView.rowHeight = UITableView.automaticDimension
               bestSellerTableView.estimatedRowHeight = UITableView.automaticDimension
        bestSellerTableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
    RestaurantDetailVCPresenter.setRestaurantDetailsViewDelegate(RestaurantDetailsViewDelegate: self)
        RestaurantDetailVCPresenter.postRestaurantDetails(restaurant_id: restaurant_id)
        RestaurantDetailVCPresenter.postRestaurantMeals(restaurant_id: restaurant_id, type: "category", category_id: category_id)
        RestaurantDetailVCPresenter.showIndicator()
        categoriesCollectionView.delegate = self
        categoriesCollectionView.dataSource = self
        categoriesCollectionView.register(UINib(nibName: CellIdentifier, bundle: nil), forCellWithReuseIdentifier: CellIdentifier)

    }
    
    @IBAction func favoriteBN(_ sender: UIButton) {
        guard let details = UIStoryboard(name: "Orders", bundle: nil).instantiateViewController(withIdentifier: "AdditionsVC") as? AdditionsVC else { return }
        self.navigationController?.pushViewController(details, animated: true)
        
    }
    
    @IBAction func ReservationBn(_ sender: UIButton) {
        guard let details = UIStoryboard(name: "Reservation", bundle: nil).instantiateViewController(withIdentifier: "ReservationRequestVC") as? ReservationRequestVC else { return }
        self.navigationController?.pushViewController(details, animated: true)
    }
    func SelectionAction(indexPath: IndexPath) {
           for i in 0..<categoriesArr.count {
               if i == indexPath.row {
                   self.categoriesArr[i].NameSelected = true
               } else {
                   self.categoriesArr[i].NameSelected = false
               }
           }
       }
}
extension RestaurantDetailsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? BestSellerCell else {return UITableViewCell()}
        cell.config(imagePath: meals[indexPath.row].image ?? "" , name: meals[indexPath.row].nameAr ?? "", mealComponants: meals[indexPath.row].descriptionAr ?? "", price: 0)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let details = UIStoryboard(name: "Orders", bundle: nil).instantiateViewController(withIdentifier: "AdditionsVC") as? AdditionsVC else { return }
        details.restaurant_id =  self.details[indexPath.row].id ?? 0
        self.navigationController?.pushViewController(details, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}
extension RestaurantDetailsVC: RestaurantDetailsViewDelegate {
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
    
    func RestaurantMealsResult(_ error: Error?, _ meals: [RestaurantMeal]?) {
        if let restaurantMeals = meals {
            self.meals = restaurantMeals

        }
    }
    
    func RestaurantDetailsResult(_ error: Error?, _ details: RestaurantDetail?) {
//        if let restaurantDetails = details {
//            self.details = [restaurantDetails]
//            self.ProductName.text = details?.nameEn
//            if let oneImageView = details.image {
//                                  guard let url = URL(string: image) else { return }
//                                  self.oneImageView.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "shanab loading"))
//                              }
//        }
    }
}
extension RestaurantDetailsVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoriesArr.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier, for: indexPath) as? RestaurantDetailsCell else {return UICollectionViewCell()}
        cell.config(name: categoriesArr[indexPath.row].CategoeryName, selected: categoriesArr[indexPath.row].NameSelected)
               cell.selectedBackgroundView?.backgroundColor = .clear
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        RestaurantDetailVCPresenter.showIndicator()
        if indexPath.item == 0  {
            RestaurantDetailVCPresenter.postRestaurantMeals(restaurant_id: restaurant_id, type: categoriesArr[0].TypeId, category_id: category_id)
            
        } else if indexPath.item == 1 {
            RestaurantDetailVCPresenter.postRestaurantMeals(restaurant_id: restaurant_id, type: categoriesArr[1].TypeId, category_id: category_id)
        } else if indexPath.item == 2 {
            RestaurantDetailVCPresenter.postRestaurantMeals(restaurant_id: restaurant_id, type: categoriesArr[2].TypeId, category_id: category_id)
        }
            DispatchQueue.main.async {
                self.categoriesCollectionView.reloadData()
            }
        }
    }
extension RestaurantDetailsVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
        let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
        let size: CGFloat = (collectionView.frame.size.width - space) / 4.1
        return CGSize(width: size, height: size + 40)
    }
    
}
    
    

