//
//  HomeVC.swift
//  Shanab
//
//  Created by Macbook on 7/14/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit
import ImageSlideshow
import DropDown
class HomeVC: UIViewController {
    @IBOutlet weak var search: UISearchBar!
    @IBOutlet weak var RestaurantTableView: UITableView!
    @IBOutlet weak var TypeBN: UIButton!
    @IBOutlet weak var imageSlider: ImageSlideshow!
    @IBOutlet weak var oneImageView: UIImageView!
    @IBOutlet weak var homeSectionsCollectionView: UICollectionView!
    fileprivate let CellIdentifierCollectionView = "HomeCell"
    fileprivate let CellIdentifierTableView = "ValiableResturantCell"
    private let GetAddsVCPresenter = GetAddsPresenter(services: Services())
    let TypeArr = ["truck".localized, "family".localized, "restaurant".localized]
    let APIArr = ["truck", "family", "restaurant"]
    var restaunt_id = Int()
    var restaurant_name = String()
    var sliderType = String()
    var isSearching = false
    var type = "restaurant"
    var MealSearch = [Collection]()
    let RestaurantsTypeDropDown = DropDown()
    var sections = [Category]() {
        didSet {
            DispatchQueue.main.async {
                self.homeSectionsCollectionView.reloadData()
            }
        }
    }
    var restaurants = [Restaurant]() {
        didSet {
            DispatchQueue.main.async {
                self.RestaurantTableView.reloadData()
            }
        }
    }
    var imageURLS = [Add]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SetupRestaurantsTypeDropDown()
        homeSectionsCollectionView.delegate = self
        homeSectionsCollectionView.dataSource = self
        homeSectionsCollectionView.register(UINib(nibName: CellIdentifierCollectionView, bundle: nil), forCellWithReuseIdentifier: CellIdentifierCollectionView)
        
        RestaurantTableView.delegate = self
        RestaurantTableView.dataSource = self
        RestaurantTableView.register(UINib(nibName: CellIdentifierTableView, bundle: nil), forCellReuseIdentifier: CellIdentifierTableView)
        search.layer.cornerRadius = 20
        GetAddsVCPresenter.setGetAddsViewDelegate(GetAddsViewDelegate: self)
        imageSlider.layer.cornerRadius = 25
        GetAddsVCPresenter.showIndicator()
        GetAddsVCPresenter.getAdds(item_id: 9 , item_type: "restaurant")
        GetAddsVCPresenter.getCatgeories()
        GetAddsVCPresenter.getAllRestaurants(type: ["truck", "family", "restaurant"])
        self.RestaurantTableView.isHidden = false
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(HomeVC.didTap))
        imageSlider.addGestureRecognizer(gestureRecognizer)
    }
    @objc func didTap() {
        if type == "restaurant" {
            guard let details = UIStoryboard(name: "Products", bundle: nil).instantiateViewController(withIdentifier: "RestaurantDetailsVC") as? RestaurantDetailsVC else { return }
            details.restaurant_id =  self.restaunt_id
            self.navigationController?.pushViewController(details, animated: true)
            
        } else if type == "meal" {
            //            guard let details = UIStoryboard(name: "Products", bundle: nil).instantiateViewController(withIdentifier: "MealDetailsVC") as? MealDetailsVC else { return }
            //             details.restaurant_id =  self.restaunt_id
            //        self.navigationController?.pushViewController(details, animated: true)
            
        }
    }
    @IBAction func TypeAction(_ sender: Any) {
        RestaurantsTypeDropDown.show()
        
    }
    @IBAction func sideMenu(_ sender: Any) {
        self.setupSideMenu()
    }
    
    fileprivate func setupImageSlider() {
        if self.imageURLS.count == 1 {
            imageSlider.isHidden = true
            oneImageView.isHidden = false
            oneImageView.image = UIImage.init(url: URL(string:  (self.imageURLS[0].image ?? "")))
            oneImageView.contentMode = .scaleAspectFill
            oneImageView.layer.cornerRadius = 25
            oneImageView.layer.masksToBounds = true
        } else {
            imageSlider.isHidden = false
            oneImageView.isHidden = true
            imageSlider.setImageInputs(self.getImageData())
        }
        imageSlider.slideshowInterval = 1.5
        imageSlider.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        imageSlider.contentScaleMode = .scaleAspectFill
        imageSlider.zoomEnabled = true
    }
    func SetupRestaurantsTypeDropDown() {
        RestaurantsTypeDropDown.anchorView = TypeBN
        RestaurantsTypeDropDown.bottomOffset = CGPoint(x: 0, y: RestaurantsTypeDropDown.anchorView?.plainView.bounds.height ?? 0 + 50)
        RestaurantsTypeDropDown.dataSource = TypeArr
        RestaurantsTypeDropDown.selectionAction =  {
            [weak self] (index, item) in
            self?.TypeBN.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
            self?.type = self?.APIArr[index] ?? ""
            self?.TypeBN.setTitle(item, for: .normal)
            if self?.type == "restaurant" {
                    self?.GetAddsVCPresenter.showIndicator()
                self?.GetAddsVCPresenter.getAllRestaurants(type: [self?.type ?? "" , "truck", "family"])
                } else {
                    self?.GetAddsVCPresenter.getAllRestaurants(type: [self?.type ?? ""])
                }
        }
        RestaurantsTypeDropDown.direction = .any
        RestaurantsTypeDropDown.width = self.view.frame.width * 1
    }
    @IBAction func searchButtonPressed(_ sender: Any) {
        guard let details = UIStoryboard(name: "SearchProducts", bundle: nil).instantiateViewController(withIdentifier: "SearchVC") as? SearchVC else { return }
        self.navigationController?.pushViewController(details, animated: true)
        
    }
    func getImageData () -> [ImageSource] {
        var imageS = [ImageSource(image: UIImage())]
        print("imageURL Count : \(self.imageURLS.count)")
        if self.imageURLS.count != 0 {
            for imageURL in imageURLS {
                if (imageURL.image?.contains("http"))! {
                    guard let url = URL(string: (imageURL.image ?? "")) else {return imageS}
                    print(url)
                    let image = UIImage.init(url: url)!
                    imageS.append(ImageSource(image: image))
                } else {
                    guard let url = URL(string: BASE_URL + "/" + (imageURL.image ?? "")) else {return imageS}
                    print(url)
                    let image = UIImage.init(url: url)!
                    imageS.append(ImageSource(image: image))
                    
                }
            }
        }
        imageS.removeFirst()
        print(imageS)
        print(imageS.count)
        return imageS
    }
}
extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifierCollectionView, for: indexPath) as? HomeCell else { return UICollectionViewCell()}
        if "lang".localized == "ar" {
            cell.config(imagePath: sections[indexPath.row].image ?? "", name: sections[indexPath.row].nameAr ?? "")
        } else {
            cell.config(imagePath: sections[indexPath.row].image ?? "", name: sections[indexPath.row].nameEn ?? "")
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let details = UIStoryboard(name: "Products", bundle: nil).instantiateViewController(withIdentifier: "MealDetailsVC") as? MealDetailsVC else { return }
        details.category_id =  self.sections[indexPath.row].id ?? 0
        self.navigationController?.pushViewController(details, animated: true)
    }
}
extension HomeVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
        let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
        let size: CGFloat = (collectionView.frame.size.width - space) / 3.1
        return CGSize(width: size, height: size + 25)
    }
}
extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifierTableView, for: indexPath) as? ValiableResturantCell else {return UITableViewCell()}
        if "lang".localized == "ar" {
            cell.config(name: restaurants[indexPath.row].nameAr ?? "", time: restaurants[indexPath.row].updatedAt ?? "", rate: Double(restaurants[indexPath.row].rate ?? 0), price: 0, imagePath: restaurants[indexPath.row].image ?? "", type: restaurants[indexPath.row].type ?? "")
            return cell
        } else {
            cell.config(name: restaurants[indexPath.row].nameEn ?? "", time: restaurants[indexPath.row].updatedAt ?? "", rate: Double(restaurants[indexPath.row].rate ?? 0), price: 0, imagePath: restaurants[indexPath.row].image ?? "", type: restaurants[indexPath.row].type ?? "")
            cell.goToFavorites = {
                
                self.GetAddsVCPresenter.showIndicator()
                self.GetAddsVCPresenter.postCreateFavorite(item_id: self.restaurants[indexPath.row].id ?? 0, item_type: self.restaurants[indexPath.row].type ?? "")
                
            }
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        150
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let details = UIStoryboard(name: "Products", bundle: nil).instantiateViewController(withIdentifier: "RestaurantDetailsVC") as? RestaurantDetailsVC else { return }
        details.restaurant_id =  self.restaurants[indexPath.row].id ?? 0
        details.image =  self.restaurants[indexPath.row].image ?? ""
        details.restaurant_type = self.restaurants[indexPath.row].type ?? ""
        details.rate = self.restaurants[indexPath.row].rate ?? 0
        details.delivery_time = self.restaurants[indexPath.row].deliveryTime ?? 0
        details.delivery_fees = self.restaurants[indexPath.row].deliveryFee ?? 0
       
        if "lang".localized == "ar" {
             details.name = self.restaurants[indexPath.row].nameAr ?? ""
        } else {
             details.name = self.restaurants[indexPath.row].nameEn ?? ""
        }
       
        self.navigationController?.pushViewController(details, animated: true)
      
    }
}
extension HomeVC: GetAddsViewDelegate {
    func FavoriteResult(_ error: Error?, _ result: SuccessError_Model?) {
        if let resultMsg = result {
            if resultMsg.successMessage != "" {
                displayMessage(title: "Done", message: resultMsg.successMessage, status: .success, forController: self)
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
    
    func RestaurantSearchResult(_ error: Error?, _ restaurantResult: [SearchResult]?) {
        //        if let lists = restaurantResult {
        //            self.NormalResult =  lists
        //            print(self.NormalResult)
        //        }
    }
    
    func getAddsResult(_ error: Error?, _ result: [Add]?) {
        if let adds = result {
            self.imageURLS = adds
            self.setupImageSlider()
        }
    }
    
    func CatgeoriesResult(_ error: Error?, _ catgeory: [Category]?) {
        if let catgeoryList = catgeory {
            self.sections = catgeoryList
        }
    }
    
    func getAllRestaurantsResult(_ error: Error?, _ restaurants: [Restaurant]?) {
        if let restaurantList = restaurants {
            self.restaurants = restaurantList
        }
    }
}

