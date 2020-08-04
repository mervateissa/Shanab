//
//  HomeVC.swift
//  Shanab
//
//  Created by Macbook on 7/14/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit
import ImageSlideshow
class HomeVC: UIViewController {
    @IBOutlet weak var search: UISearchBar!
    @IBOutlet weak var RestaurantTableView: UITableView!
    @IBOutlet weak var imageSlider: ImageSlideshow!
    @IBOutlet weak var oneImageView: UIImageView!
    @IBOutlet weak var homeSectionsCollectionView: UICollectionView!
    fileprivate let CellIdentifierCollectionView = "HomeCell"
    fileprivate let CellIdentifierTableView = "ValiableResturantCell"
    private let GetAddsVCPresenter = GetAddsPresenter(services: Services())
    var restaunt_id = Int()
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
        homeSectionsCollectionView.delegate = self
        homeSectionsCollectionView.dataSource = self
        homeSectionsCollectionView.register(UINib(nibName: CellIdentifierCollectionView, bundle: nil), forCellWithReuseIdentifier: CellIdentifierCollectionView)
        RestaurantTableView.delegate = self
        RestaurantTableView.dataSource = self
        RestaurantTableView.register(UINib(nibName: CellIdentifierTableView, bundle: nil), forCellReuseIdentifier: CellIdentifierTableView)
        GetAddsVCPresenter.setGetAddsViewDelegate(GetAddsViewDelegate: self)
        GetAddsVCPresenter.showIndicator()
        GetAddsVCPresenter.getAdds()
        GetAddsVCPresenter.getCatgeories()
        GetAddsVCPresenter.getAllRestaurants(type: ["restaurant"])
        
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
        cell.config(imagePath: sections[indexPath.row].image ?? "", name: sections[indexPath.row].nameAr ?? "")
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
        cell.config(name: restaurants[indexPath.row].nameAr ?? "", time: restaurants[indexPath.row].updatedAt ?? "", rate: Double(restaurants[indexPath.row].rate ?? 0), price: 0, imagePath: restaurants[indexPath.row].image ?? "", type: "")
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        150
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let details = UIStoryboard(name: "Products", bundle: nil).instantiateViewController(withIdentifier: "RestaurantDetailsVC") as? RestaurantDetailsVC else { return }
        details.restaurant_id =  self.restaurants[indexPath.row].id ?? 0
        self.navigationController?.pushViewController(details, animated: true)
    }
    
    
}
extension HomeVC: GetAddsViewDelegate {
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


