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
   
    @IBOutlet weak var sectionCollectionView: UICollectionView!
    private let CatgeoriesVCPresenter = CatgeoriesPresenter(services: Services())
    var catgeories = [Category]() {
        didSet {
            DispatchQueue.main.async {
                self.sectionCollectionView.reloadData()
            }
        }
    }
    fileprivate let cellIdentifier = "SectionCell"
    override func viewDidLoad() {
        super.viewDidLoad()
        sectionCollectionView.delegate = self
        sectionCollectionView.dataSource = self
        sectionCollectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        CatgeoriesVCPresenter.setCatgeoriesViewDelegate(CatgeoriesViewDelegate: self)
        CatgeoriesVCPresenter.getCatgeories()
        CatgeoriesVCPresenter.showIndicator()
      
    }
  

}

 
extension SectionsVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         return catgeories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? SectionCell else { return UICollectionViewCell()}
               cell.config(imagePath: catgeories[indexPath.row].image ?? "", name: catgeories[indexPath.row].nameAr ?? "")
               return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         guard let details = UIStoryboard(name: "Products", bundle: nil).instantiateViewController(withIdentifier: "MealDetailsVC") as? MealDetailsVC else { return }
            details.category_id =  self.catgeories[indexPath.row].id ?? 0
            self.navigationController?.pushViewController(details, animated: true)
    }
   
}
extension SectionsVC: UICollectionViewDelegateFlowLayout {
       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
           let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
           let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
           let size: CGFloat = (collectionView.frame.size.width - space) / 2.1
           return CGSize(width: size , height: size + 15)
       }
       
   }
extension SectionsVC: CatgeoriesViewDelegate {
    func CatgeoriesResult(_ error: Error?, _ catgeory: [Category]?) {
        if let catgeoryList = catgeory {
            self.catgeories = catgeoryList
        }
    }
    
    
}
