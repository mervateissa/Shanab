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
    @IBOutlet weak var deliveryTime: UILabel!
    @IBOutlet weak var NameLB: UILabel!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var TypeLB: UILabel!
    @IBOutlet weak var RateLb: UILabel!
    @IBOutlet weak var lowestPrice: UILabel!
    @IBOutlet weak var fees: UILabel!
    @IBOutlet weak var OneImageView: CustomImageView!
    private let TableCellIdentifier = "BestSellerCell"
    private let CollectinCellIdentifier = "RestaurantDetailsCell"
    private let MealsDetailVCPresenter = MealsDetailPresenter(services: Services())
    var categoriesArr = [CategoriesModel]()
    var mealId = Int()
    var category_id = Int()
    var image = String()
    var Name = String()
    var cartItems = [onlineCart]()
    //    var quantity = Int()
    var meals = [RestaurantMeal]() {
        didSet {
            DispatchQueue.main.async {
                self.MealDetailsTableView.reloadData()
            }
        }
    }
    override func viewDidLoad() {
        if (!image.contains("http")) {
            guard let imageURL = URL(string: (BASE_URL + "/" + image).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") else { return }
            print(imageURL)
            self.OneImageView.kf.setImage(with: imageURL)
        }  else if image != "" {
            guard let imageURL = URL(string: image) else { return }
            self.OneImageView.kf.setImage(with: imageURL)
        } else {
            self.OneImageView.image = #imageLiteral(resourceName: "shanab loading")
        }
        NameLB.text = Name
        TypeLB.text = Name
        super.viewDidLoad()
        if "lang".localized == "en" {
            categoriesArr.append(CategoriesModel(name: "Best Seller", id: "category", selected: true))
            categoriesArr.append(CategoriesModel(name: "Offers", id: "top", selected: false))
//            categoriesArr.append(CategoriesModel(name: "Drinks", id: "", selected: false))
//            categoriesArr.append(CategoriesModel(name: "Sweets", id: "", selected: false))
        } else {
            categoriesArr.append(CategoriesModel(name: "الاكثر مبيعا", id: "category", selected: true))
            categoriesArr.append(CategoriesModel(name: "العروض", id: "top", selected: false))
            //            categoriesArr.append(CategoriesModel(name: "المشروبات", id: "offer", selected: false))
            //             categoriesArr.append(CategoriesModel(name: "الاكثر مبيعا", id: "category", selected: true))
        }
        
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
        MealsDetailVCPresenter.postRestaurantMeals(restaurant_id: mealId, type: "meal", category_id: category_id)
        MealsDetailVCPresenter.postRestaurantDetails(restaurant_id: category_id)
        
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
    
    @IBAction func favorite(_ sender: UIButton) {
    }
    
    @IBAction func reservationTablr(_ sender: UIButton) {
    }
    @IBAction func sideMenu(_ sender: Any) {
        self.setupSideMenu()
    }
    
    @IBAction func cartItems(_ sender: Any) {
        guard let details = UIStoryboard(name: "Cart", bundle: nil).instantiateViewController(withIdentifier: "CartVC") as?
            CartVC else { return }
        self.navigationController?.pushViewController(details, animated: true)
    }
}
extension MealDetailsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        meals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableCellIdentifier, for: indexPath) as? BestSellerCell else {return UITableViewCell()}
        if "lang".localized == "ar" {
            cell.config(imagePath: meals[indexPath.row].image ?? "", name: meals[indexPath.row].nameAr ?? "",  mealComponants: meals[indexPath.row].descriptionAr ?? "", price: 0)
            return cell
        } else {
            cell.config(imagePath: meals[indexPath.row].image ?? "", name: meals[indexPath.row].nameEn ?? "",  mealComponants: meals[indexPath.row].descriptionEn ?? "", price: meals[indexPath.row].price?[0].price ?? 0)
            cell.goToFavorites = {
                self.MealsDetailVCPresenter.showIndicator()
                self.MealsDetailVCPresenter.postCreateFavorite(item_id:  self.meals[indexPath.row].id ?? 0, item_type: "meal")
                self.MealsDetailVCPresenter.postRemoveFavorite(item_id: self.meals[indexPath.row].id ?? 0, item_type: "meal")
            }
            cell.addToCart = {
                self.MealsDetailVCPresenter.showIndicator()
                self.MealsDetailVCPresenter.postAddToCart(meal_id: self.meals[indexPath.row].id ?? 0  , quantity: 1 , message:  "test one" , options: [])
            }
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let details = UIStoryboard(name: "Orders", bundle: nil).instantiateViewController(withIdentifier: "AdditionsVC") as? AdditionsVC else { return }
        
        details.meal_id =  self.meals[indexPath.row].id ?? 0
        details.image = self.meals[indexPath.row].image ?? ""
        details.mealCalory = self.meals[indexPath.row].points ?? 0
        if "lang".localized == "en" {
            details.mealName = self.meals[indexPath.row].nameEn ?? ""
            details.mealComponents = self.meals[indexPath.row].descriptionEn ?? ""
             details.image = self.meals[indexPath.row].image ?? ""
        } else {
            details.mealName = self.meals[indexPath.row].nameAr ?? ""
            details.mealComponents = self.meals[indexPath.row].descriptionAr ?? ""
             details.image = self.meals[indexPath.row].image ?? ""
        }
        
        self.navigationController?.pushViewController(details, animated: true)
    }
    
    
    
}
extension MealDetailsVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoriesArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectinCellIdentifier, for: indexPath) as? RestaurantDetailsCell else {return UICollectionViewCell()}
        cell.config(name: categoriesArr[indexPath.row].CategoeryName, selected: categoriesArr[indexPath.row].NameSelected)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        MealsDetailVCPresenter.showIndicator()
        SelectionAction(indexPath: indexPath)
        MealsDetailVCPresenter.postRestaurantMeals(restaurant_id: category_id, type: categoriesArr[indexPath.row].TypeId, category_id: category_id)
        DispatchQueue.main.async {
            self.MealsDetailsCollectionView.reloadData()
        }
    }
}


extension MealDetailsVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
        let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
        let size: CGFloat = (collectionView.frame.size.width + space) / 2.1
        return CGSize(width: size , height: size - 10 )
    }
    
}
extension MealDetailsVC: MealsDetailsViewDelegate {
    func AddToCartResult(_ error: Error?, _ result: SuccessError_Model?) {
        if let meals = result {
            if meals.successMessage != "" {
                displayMessage(title: "done", message: meals.successMessage, status: .success, forController: self)
                Singletone.instance.cart = cartItems
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
    
    func RestaurantDetailsResult(_ error: Error?, _ details: RestaurantDetail?) {
        if let restaurantDetails = details {
            if "lang".localized == "ar" {
                self.NameLB.text = restaurantDetails.nameAr ?? ""
                if let image = restaurantDetails.image {
                    if (!image.contains("http")) {
                        guard let imageURL = URL(string: (BASE_URL + "/" + image).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") else { return }
                        print(imageURL)
                        self.OneImageView.kf.setImage(with: imageURL)
                    }  else if image != "" {
                        guard let imageURL = URL(string: image) else { return }
                        self.OneImageView.kf.setImage(with: imageURL)
                    } else {
                        self.OneImageView.image = #imageLiteral(resourceName: "shanab loading")
                    }
                }
                self.fees.text = "\(restaurantDetails.deliveryFee ?? 0)"
                self.RateLb.text = "\(restaurantDetails.rate ?? 0)"
                self.deliveryTime.text = "\(restaurantDetails.deliveryTime ?? 0)"
                self.lowestPrice.text = "\(restaurantDetails.minimum ?? 0)"
                self.RateLb.text = "\(restaurantDetails.rate ?? 0) "
                self.TypeLB.text = restaurantDetails.type ?? ""
            } else {
                self.NameLB.text = restaurantDetails.nameEn ?? ""
                if let image = restaurantDetails.image {
                    guard let url = URL(string: image) else { return }
                    self.OneImageView.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "shanab loading"))
                }
                self.fees.text = "\(restaurantDetails.deliveryFee ?? 0)"
                self.RateLb.text = "\(restaurantDetails.rate ?? 0)"
                self.deliveryTime.text = "\(restaurantDetails.deliveryTime ?? 0)"
                self.lowestPrice.text = "\(restaurantDetails.minimum ?? 0)"
                self.RateLb.text = "\(restaurantDetails.rate ?? 0) "
                self.TypeLB.text = restaurantDetails.type ?? ""
            }
            
        }
    }
    
    func RestaurantMealsResult(_ error: Error?, _ meals: [RestaurantMeal]?) {
        if let restaurantMeals = meals {
            self.meals = restaurantMeals
            if self.meals.count == 0 {
                self.emptyView.isHidden = false
                self.MealDetailsTableView.isHidden = true
            } else {
                self.emptyView.isHidden = true
                self.MealDetailsTableView.isHidden = false
            }
            
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
