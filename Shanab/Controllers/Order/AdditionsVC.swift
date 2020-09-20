//
//  MakeOrderVC.swift
//  Shanab
//
//  Created by Macbook on 3/26/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit
import DLRadioButton
class AdditionsVC: UIViewController {
    @IBOutlet weak var AdditionTableView: UITableView!
    @IBOutlet weak var quantityTF: UILabel!
    @IBOutlet weak var emptyView: UIView!
    private let AdditionalVCPresenter = AdditionsPresenter(services: Services())
    @IBOutlet weak var stackViewST: UIStackView!
    @IBOutlet weak var mealNameLB: UILabel!
    @IBOutlet weak var caloriesLB: UILabel!
    @IBOutlet weak var notesTF: UITextField!
    @IBOutlet weak var oneImageView: UIImageView!
    @IBOutlet weak var mealComponentsLB: UILabel!
    @IBOutlet weak var price: UILabel!
    fileprivate let cellIdentifier = "AdditionsCell"
    fileprivate let HeaderIdentifier = "HeaderCell"
    var restaurant_id = Int()
    var total = Double()
    var meal_id = Int()
    var cartItems = [onlineCart]()
    var currency = String()
    var productCounter = 1
    var CurrentIndex = 0
    var selections = [Int]()
    var selected = Bool()
    var imagePath = String()
    var mealName = String()
    var mealComponents = String()
    var mealCalory = Int()
    var image = String()
    var mealDetails =  [Collection]() {
        didSet {
            DispatchQueue.main.async {
                self.AdditionTableView.reloadData()
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if "lang".localized == "ar" {
            price.text = "\(total) ريال"
        } else {
            price.text = "\(total) SAR"
        }
        if (!imagePath.contains("http")) {
            guard let imageURL = URL(string: (BASE_URL + "/" + image).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") else { return }
            print(imageURL)
            self.oneImageView.kf.setImage(with: imageURL)
        }  else if imagePath != "" {
            guard let imageURL = URL(string: image) else { return }
            self.oneImageView.kf.setImage(with: imageURL)
        } else {
            self.oneImageView.image = #imageLiteral(resourceName: "shanab loading")
        }
        mealNameLB.text = mealName
        mealComponentsLB.text = mealComponents
        caloriesLB.text = "\(mealCalory)"
        mealComponentsLB.text = mealComponents
        AdditionTableView.delegate = self
        AdditionTableView.dataSource = self
        AdditionTableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        AdditionTableView.register(UINib(nibName: HeaderIdentifier, bundle: nil), forCellReuseIdentifier: HeaderIdentifier)
        AdditionalVCPresenter.setAdditionsViewDelegate(AdditionsViewDelegate: self)
        AdditionalVCPresenter.showIndicator()
        AdditionalVCPresenter.postMealDetails(meal_id: meal_id)
        stackViewST.layer.cornerRadius = 20
        
    }
    
    @IBAction func menu(_ sender: Any) {
        self.setupSideMenu()
    }
    
    @IBAction func cart(_ sender: Any) {
        guard let details = UIStoryboard(name: "Cart", bundle: nil).instantiateViewController(withIdentifier: "CartVC") as? CartVC else { return }
        self.navigationController?.pushViewController(details, animated: true)
        
    }
    @IBAction func Increase(_ sender: UIButton) {
        self.productCounter += 1
        self.quantityTF.text = "\(self.productCounter)"
        
    }
    @IBAction func cartListButton(_ sender: Any) {
        
    }
    @IBAction func decreaseBN(_ sender: UIButton) {
        if productCounter > 1 {
            self.productCounter -= 1
            self.quantityTF.text = "\(self.productCounter)"
        } else {
            self.productCounter = 1
            self.quantityTF.text = "\(self.productCounter)"
        }
    }
    
    @IBAction func confirm(_ sender: UIButton) {
        AdditionalVCPresenter.showIndicator()
        AdditionalVCPresenter.postAddToCart(meal_id: meal_id, quantity: productCounter, message: notesTF.text ?? "", options: selections)
        
    }
}
extension AdditionsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mealDetails[section].option?.count ?? 0
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return mealDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for:
            indexPath) as? AdditionsCell else {return UITableViewCell()}
        var options = self.mealDetails[indexPath.section].option ?? [Options]()
        if "lang".localized == "en" {
            if CurrentIndex == indexPath.row && self.selected {
                cell.config(name: options[indexPath.row].nameEn ?? "", selected: true)
            } else {
                cell.config(name: options[indexPath.row].nameEn ?? "", selected: false)
            }
            
        } else {
            if CurrentIndex == indexPath.row && self.selected {
                cell.config(name: options[indexPath.row].nameAr ?? "", selected: true)
            } else {
                cell.config(name: options[indexPath.row].nameAr ?? "", selected: false)
            }
            
        }
        
        cell.selectionOption = {
            self.selected = true
            for i in 0..<options.count {
                if i == indexPath.row {
                    self.CurrentIndex = i
                    self.selections.append(options[self.CurrentIndex].id ?? 0)
                } else {
                    options[i].selected = false
                }
                
            }
            self.AdditionTableView.reloadData()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HeaderIdentifier) as? HeaderCell else {return UITableViewCell()}
        if "lang".localized == "ar" {
            cell.config(mealName: mealDetails[section].nameAr ?? "" )
            return cell
        } else {
            cell.config(mealName: mealDetails[section].nameEn ?? "" )
            return cell
        }
        
    }
}
extension AdditionsVC: AdditionsViewDelegate {
    func postAddToCartResult(_ error: Error?, _ result: SuccessError_Model?) {
        if let resultMsg = result {
            if resultMsg.successMessage != "" {
                displayMessage(title: "تمت الاضافة للسلة بنجاح", message: resultMsg.successMessage, status: .success, forController: self)
                Singletone.instance.cart = cartItems
                //                guard let Details = UIStoryboard(name: "Cart", bundle: nil).instantiateViewController(withIdentifier: "CartVC") as? CartVC else { return }
                //                 self.AdditionTableView.reloadData()
                //                Details.nameMeal = mealDetails[0].nameAr ?? ""
                //                Details.mealComponents = mealDetails[0].option?[0].nameAr ?? ""
                //self.navigationController?.pushViewController(Details, animated: true)
            } else if resultMsg.meal_id != [""] {
                displayMessage(title: "", message: resultMsg.meal_id[0], status: .error, forController: self)
            } else if resultMsg.quantity != [""] {
                displayMessage(title: "", message: resultMsg.quantity[0], status: .error, forController: self)
            } else if resultMsg.message != [""] {
                displayMessage(title: "", message: resultMsg.message[0], status: .error, forController: self)
            } else if resultMsg.options != [""] {
                displayMessage(title: "", message: resultMsg.options[0], status: .error, forController: self)
            }
        }
    }
    
    func MealDetailsResult(_ error: Error?, _ details: CollectionDataClass?) {
        if let lists = details {
            self.mealDetails = lists.collection ?? []
            if self.mealDetails.count == 0 {
                self.emptyView.isHidden = false
                self.AdditionTableView.isHidden = true
            } else {
                self.emptyView.isHidden = true
                self.AdditionTableView.isHidden = false
            }
            
        }
    }
    
}
