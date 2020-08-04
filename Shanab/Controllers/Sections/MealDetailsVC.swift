//
//  MealDetailsVC.swift
//  Shanab
//
//  Created by Macbook on 7/2/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit
import ImageSlideshow
class MealDetailsVC: UIViewController {
    @IBOutlet weak var MealsDetailsCollectionView: UICollectionView!
    @IBOutlet weak var MealDetailsTableView: UITableView!
    @IBOutlet weak var lowestPrice: UILabel!
    @IBOutlet weak var fees: UILabel!
    @IBOutlet weak var MealPic: UIImageView!
    @IBOutlet weak var OneImageView: CustomImageView!
    private let TableCellIdentifier = "BestSellerCell"
    private let CollectinCellIdentifier = "RestaurantDetailsCell"
    private let MealsDetailVCPresenter = MealsDetailPresenter(services: Services())
    var categoriesArr = [CategoriesModel]()
    var mealId = Int()
    var category_id = Int()
    var meals = [RestaurantMeal]() {
        didSet {
            DispatchQueue.main.async {
                self.MealDetailsTableView.reloadData()
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        MealPic.setRounded()
        categoriesArr.append(CategoriesModel(name: "MosttSeller", id: "category", selected: true))
        categoriesArr.append(CategoriesModel(name: "Offers", id: "top", selected: false))
        categoriesArr.append(CategoriesModel(name: "Drinks", id: "offer", selected: false))
        categoriesArr.append(CategoriesModel(name: "MosttSeller", id: "category", selected: false))
        MealDetailsTableView.delegate = self
        MealDetailsTableView.dataSource = self
        MealDetailsTableView.rowHeight = UITableView.automaticDimension
               MealDetailsTableView.estimatedRowHeight = UITableView.automaticDimension
        MealDetailsTableView.register(UINib(nibName: TableCellIdentifier, bundle: nil), forCellReuseIdentifier: TableCellIdentifier)
        MealDetailsTableView.rowHeight = UITableView.automaticDimension
                      MealDetailsTableView.estimatedRowHeight = UITableView.automaticDimension
              
        MealsDetailsCollectionView.delegate = self
        MealsDetailsCollectionView.dataSource = self
        MealsDetailsCollectionView.register(UINib(nibName: CollectinCellIdentifier, bundle: nil), forCellWithReuseIdentifier: CollectinCellIdentifier)
        MealsDetailVCPresenter.setMealsDetailsViewDelegate(MealsDetailsViewDelegate: self)
        MealsDetailVCPresenter.showIndicator()
        MealsDetailVCPresenter.postRestaurantMeals(restaurant_id: mealId, type: "meals", category_id: 0)
        
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
    
    @IBAction func sideMenu(_ sender: UIBarButtonItem) {
        self.setupSideMenu()
    }
    
}
extension MealDetailsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        meals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         guard let cell = tableView.dequeueReusableCell(withIdentifier: TableCellIdentifier, for: indexPath) as? BestSellerCell else {return UITableViewCell()}
        cell.config(imagePath: meals[indexPath.row].image ?? "", name: meals[indexPath.row].nameAr ?? "",  mealComponants: meals[indexPath.row].descriptionAr ?? "", price: 0)
               return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           guard let details = UIStoryboard(name: "Orders", bundle: nil).instantiateViewController(withIdentifier: "MealDetailsVC") as? MealDetailsVC else { return }
//                detatails.mealId =  self.meals[indexPath.row].id ?? 0
           self.navigationController?.pushViewController(details, animated: true)
       }
       
    
    
}
extension MealDetailsVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 50
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectinCellIdentifier, for: indexPath) as? RestaurantDetailsCell else {return UICollectionViewCell()}
        cell.config(name: categoriesArr[indexPath.row].CategoeryName, selected: categoriesArr[indexPath.row].NameSelected)
                return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
          MealsDetailVCPresenter.showIndicator()
               
                if indexPath.item == 0  {
                    MealsDetailVCPresenter.postRestaurantMeals(restaurant_id: mealId, type: categoriesArr[0].TypeId, category_id: category_id)
                } else if indexPath.item == 1 {
                     MealsDetailVCPresenter.postRestaurantMeals(restaurant_id: mealId, type: categoriesArr[1].TypeId, category_id: category_id)
                } else if indexPath.item == 2 {
                     MealsDetailVCPresenter.postRestaurantMeals(restaurant_id: mealId, type: categoriesArr[2].TypeId, category_id: category_id)
                }
                    DispatchQueue.main.async {
                        self.MealsDetailsCollectionView.reloadData()
                    }
                }
            }
  

extension MealDetailsVC: UICollectionViewDelegateFlowLayout {
      func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
          let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
          let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
          let size: CGFloat = (collectionView.frame.size.width + space) / 3.1
          return CGSize(width: size , height: size - 25 )
      }
      
  }
extension MealDetailsVC: MealsDetailsViewDelegate {
    func RestaurantMealsResult(_ error: Error?, _ meals: [RestaurantMeal]?) {
        if let restaurantMeals = meals {
            self.meals = restaurantMeals
           
        }
    }
    
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
    
    
}
