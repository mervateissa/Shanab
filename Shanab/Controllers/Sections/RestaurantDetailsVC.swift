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
    @IBOutlet weak var rateLB: UILabel!
    @IBOutlet weak var FavoriteBN: UIButton!
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var lowestPrice: UILabel!
    @IBOutlet weak var oneImageView: UIImageView!
    @IBOutlet weak var deliveryTime: UILabel!
    @IBOutlet weak var deliveryFees: UILabel!
    @IBOutlet weak var ProductName: UILabel!
    fileprivate let cellIdentifier = "BestSellerCell"
    fileprivate let CellIdentifier = "RestaurantDetailsCell"
    @IBOutlet weak var bestSellerTableView: UITableView!
    var mealId = Int()
    var image = String()
    var isFavourite = Bool()
    var name = String()
    var restaurant_type = String()
    var rate = Int()
    var delivery_time = Int()
    var lowest_price = Int()
    var delivery_fees = Int()
    var categoriesArr = [CategoriesModel]()
    var meals = [RestaurantMeal]() {
        didSet{
            DispatchQueue.main.async {
                self.bestSellerTableView.reloadData()
            }
        }
    }
    
    var restaurant_id = Int()
    var category_id = Int()
    override func viewDidLoad() {
        super.viewDidLoad()
         if (!image.contains("http")) {
                  guard let imageURL = URL(string: (BASE_URL + "/" + image).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") else { return }
                  print(imageURL)
                  self.oneImageView.kf.setImage(with: imageURL)
              }  else if image != "" {
                  guard let imageURL = URL(string: image) else { return }
                  self.oneImageView.kf.setImage(with: imageURL)
              } else {
                  self.oneImageView.image = #imageLiteral(resourceName: "shanab loading")
              }
        if "lang".localized == "en" {
            categoriesArr.append(CategoriesModel(name: "Best Seller", id: "category", selected: true))
            categoriesArr.append(CategoriesModel(name: "Offers", id: "top", selected: false))
//             categoriesArr.append(CategoriesModel(name: "الاكثر مبيعا", id: "category", selected: true))
//             categoriesArr.append(CategoriesModel(name: "الاكثر مبيعا", id: "category", selected: true))
            
            
            
        } else {
            categoriesArr.append(CategoriesModel(name: "الاكثر مبيعا", id: "category", selected: true))
            categoriesArr.append(CategoriesModel(name: "العروض", id: "top", selected: false))
                                categoriesArr.append(CategoriesModel(name: "المشروبات", id: "offer", selected: false))
//             categoriesArr.append(CategoriesModel(name: " مشروبات", id: "", selected: true))
            
        }
        ProductName.text = name
        type.text = restaurant_type
        deliveryTime.text = "\(delivery_time)"
        rateLB.text = "\(rate)"
        deliveryFees.text = "\(delivery_fees)"
        
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
        if isFavourite {
            FavoriteBN.setImage(#imageLiteral(resourceName: "heart-1"), for: .normal)
            isFavourite = false
        }
        else {
            FavoriteBN.setImage(#imageLiteral(resourceName: "heart 2"), for: .normal)
            isFavourite = true
            
        }
        RestaurantDetailVCPresenter.showIndicator()
        RestaurantDetailVCPresenter.postCreateFavorite(item_id: self.restaurant_id , item_type: "meal")
        RestaurantDetailVCPresenter.postRemoveFavorite(item_id: self.restaurant_id , item_type: "meal")
    }
    @IBAction func cartItemsButton(_ sender: Any) {
        guard let details = UIStoryboard(name: "Cart", bundle: nil).instantiateViewController(withIdentifier: "CartVC") as?
                  CartVC else { return }
          self.navigationController?.pushViewController(details, animated: true)
    }
    
    @IBAction func sideMenu(_ sender: Any) {
         self.setupSideMenu()
    }
   
    
    @IBAction func ReservationBn(_ sender: UIButton) {
        guard let details = UIStoryboard(name: "Reservation", bundle: nil).instantiateViewController(withIdentifier: "ReservationRequestVC") as?
            ReservationRequestVC else { return }
        details.resturant_id = self.restaurant_id
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
        if "lang".localized == "ar" {
            cell.config(imagePath: meals[indexPath.row].image ?? "" , name: meals[indexPath.row].nameAr ?? "", mealComponants: meals[indexPath.row].descriptionAr ?? "", price: 0)
        } else {
            cell.config(imagePath: meals[indexPath.row].image ?? "" , name: meals[indexPath.row].nameEn ?? "", mealComponants: meals[indexPath.row].descriptionEn ?? "", price: 0)
        }
        
        cell.addToCart = {
            self.RestaurantDetailVCPresenter.showIndicator()
            self.RestaurantDetailVCPresenter.postAddToCart(meal_id: self.meals[indexPath.row].id ?? 0  , quantity: 1 , message:  "test one" , options: [])
        }
        cell.goToFavorites = {
            self.RestaurantDetailVCPresenter.showIndicator()
            self.RestaurantDetailVCPresenter.postCreateFavorite(item_id: self.meals[indexPath.row].id ?? 0, item_type: "meal")
            self.RestaurantDetailVCPresenter.postRemoveFavorite(item_id: self.meals[indexPath.row].id ?? 0, item_type: "meal")
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let details = UIStoryboard(name: "Orders", bundle: nil).instantiateViewController(withIdentifier: "AdditionsVC") as? AdditionsVC else { return }
        details.restaurant_id = self.restaurant_id 
        details.meal_id =  self.meals[indexPath.row].id ?? 0
        details.imagePath = self.meals[indexPath.row].image ?? ""
        details.mealCalory = self.meals[indexPath.row].points ?? 0
        if "lan".localized == "ar" {
            details.mealName = self.meals[indexPath.row].nameAr ?? ""
            details.mealComponents = self.meals[indexPath.row].descriptionAr ?? ""
              details.imagePath = self.meals[indexPath.row].image ?? ""
           
        } else {
           details.mealName = self.meals[indexPath.row].nameEn ?? ""
            details.mealComponents = self.meals[indexPath.row].descriptionEn ?? ""
              details.imagePath = self.meals[indexPath.row].image ?? ""
        }
        
        self.navigationController?.pushViewController(details, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220
    }
}
extension RestaurantDetailsVC: RestaurantDetailsViewDelegate {
    func AddToCartResult(_ error: Error?, _ result: SuccessError_Model?) {
        if let meals = result {
            if meals.successMessage != "" {
                displayMessage(title: "done", message: meals.successMessage, status: .success, forController: self)
            } else if meals.meal_id != [""] {
                displayMessage(title: "", message: meals.meal_id[0], status: .error, forController: self)
            } else if meals.quantity != [""] {
                displayMessage(title: "", message: meals.quantity[0], status: .error, forController: self)
            } else if meals.message != [""] {
                displayMessage(title: "", message: meals.message[0], status: .error, forController: self)
            } else if meals.options != [""] {
                displayMessage(title: "", message: meals.options[0], status: .error, forController: self)
            }
        }
    }
    
    func FavoriteResult(_ error: Error?, _ result: SuccessError_Model?) {
        if let resultMsg = result {
            if resultMsg.successMessage != "" {
                if "lang".localized == "en" {
                    displayMessage(title: "Saved At Favorite List", message: resultMsg.successMessage, status: .success, forController: self)
                }  else {
                    if resultMsg.successMessage != "" {
                        displayMessage(title: "تمت الاضافة الي المفضلة", message: resultMsg.successMessage, status: .success, forController: self)
                    }
                }
            }else if resultMsg.item_id != [""] {
                displayMessage(title: "", message: resultMsg.item_id[0], status: .error, forController: self)
            } else if resultMsg.item_type != [""] {
                displayMessage(title: "", message: resultMsg.item_type[0], status: .error, forController: self)
            }
        }
    }
    
    func RemoveFavorite(_ error: Error?, _ result: SuccessError_Model?) {
        if let resultMsg = result {
            if "lang".localized == "en" {
                if resultMsg.successMessage != "" {
                    displayMessage(title: "Remove from Favorite List", message: resultMsg.successMessage, status: .success, forController: self)
                }  else {
                    if resultMsg.successMessage != "" {
                        displayMessage(title: "تم الالغاء من المفضلة", message: resultMsg.successMessage, status: .success, forController: self)
                    }
                }
            } else if !resultMsg.item_id.isEmpty, resultMsg.item_id != [""] {
                displayMessage(title: "", message: resultMsg.item_id[0], status: .error, forController: self)
            } else if !resultMsg.item_type.isEmpty, resultMsg.item_type != [""] {
                displayMessage(title: "", message: resultMsg.item_type[0], status: .error, forController: self)
            }
        }
    }
    
    func RestaurantMealsResult(_ error: Error?, _ meals: [RestaurantMeal]?) {
        if let restaurantMeals = meals {
            self.meals = restaurantMeals
            if self.meals.count == 0 {
                self.emptyView.isHidden = false
                self.bestSellerTableView.isHidden = true
            } else {
                self.emptyView.isHidden = true
                self.bestSellerTableView.isHidden = false
            }
            
        }
        
    }
    
    
    func RestaurantDetailsResult(_ error: Error?, _ details: RestaurantDetail?) {
        if let restaurantDetails = details {
            if "lang".localized == "ar" {
                self.ProductName.text = restaurantDetails.nameAr ?? ""
                if let image = restaurantDetails.image {
                    guard let url = URL(string:  image) else { return }
                    self.oneImageView.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "shanab loading"))
                }
                self.deliveryFees.text = "\(restaurantDetails.deliveryFee ?? 0)"
                self.rateLB.text = "\(restaurantDetails.rate ?? 0)"
                self.deliveryTime.text = "\(restaurantDetails.deliveryTime ?? 0)"
                self.lowestPrice.text = "\(restaurantDetails.minimum ?? 0)"
                self.rateLB.text = "\(restaurantDetails.rate ?? 0) "
                self.type.text = restaurantDetails.type ?? ""
            } else {
                self.ProductName.text = restaurantDetails.nameEn ?? ""
                if let image = restaurantDetails.image {
                    guard let url = URL(string: image) else { return }
                    self.oneImageView.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "shanab loading"))
                }
                self.deliveryFees.text = "\(restaurantDetails.deliveryFee ?? 0)"
                self.rateLB.text = "\(restaurantDetails.rate ?? 0)"
                self.deliveryTime.text = "\(restaurantDetails.deliveryTime ?? 0)"
                self.lowestPrice.text = "\(restaurantDetails.minimum ?? 0)"
                self.rateLB.text = "\(restaurantDetails.rate ?? 0) "
                self.type.text = restaurantDetails.type ?? ""
            }
            
        }
    }
}
extension RestaurantDetailsVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoriesArr.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier, for: indexPath) as? RestaurantDetailsCell else {return UICollectionViewCell()}
        cell.config(name: categoriesArr[indexPath.row].CategoeryName, selected: categoriesArr[indexPath.row].NameSelected)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        RestaurantDetailVCPresenter.showIndicator()
        SelectionAction(indexPath: indexPath)
        RestaurantDetailVCPresenter.postRestaurantMeals(restaurant_id: restaurant_id, type: categoriesArr[indexPath.row].TypeId, category_id: category_id)
        DispatchQueue.main.async {
            self.categoriesCollectionView.reloadData()
        }
    }
}
extension RestaurantDetailsVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
        let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
        let size: CGFloat = (collectionView.frame.size.width - space) / 2.1
        return CGSize(width: size  , height: size - 20)
    }
    
}



