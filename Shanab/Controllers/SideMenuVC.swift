//
//  SideMenuVC.swift
//  Shanab
//
//  Created by Macbook on 3/24/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit
class SideMenuVC: UIViewController {
    @IBOutlet weak var signIn: UIButton!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var editBN: UIButton!
    var id = Int()
    @IBOutlet weak var SignOut: UIButton!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var SideMenuTableView: UITableView!
    private let SideMenuVCPresenter = SideMenuPresenter(services: Services())
    fileprivate let cellIdentifier = "SideMenuCell"
    var sideMenuArr = [SideMenuModel]() {
        didSet {
            DispatchQueue.main.async {
                self.SideMenuTableView.reloadData()
            }
        }
    }
    let token = Helper.getApiToken() ?? ""
    let user = Helper.getUserRole() ?? ""
    override func viewDidLoad() {
        profilePic.setRounded()
        super.viewDidLoad()
        SideMenuTableView.dataSource = self
        SideMenuTableView.delegate = self
        SideMenuTableView.rowHeight = UITableView.automaticDimension
                      SideMenuTableView.estimatedRowHeight = UITableView.automaticDimension
        SideMenuTableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        SideMenuVCPresenter.setSideMenuViewDelegate(SideMenuViewDelegate: self)
        if (Helper.getApiToken() ?? "") != "" {
            self.signIn.isHidden = true
            
            
        } else {
            self.SignOut.isHidden = true
            profilePic.isHidden = true
            name.isHidden = true
            editBN.isHidden = true
            
            
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if token != "" {
            if user == "customer" {
                SideMenuVCPresenter.getUserProfile()
            } else {
                SideMenuVCPresenter.getDriverProfile()
                
            }
            
            if user == "customer" {
                self.sideMenuArr = [
                    SideMenuModel(name: "Home".localized,id: "home", selected: false,sideImage: #imageLiteral(resourceName: "home")),
                    SideMenuModel(name: "Sections".localized, id: "Sections", selected: false, sideImage: #imageLiteral(resourceName: "burger")),
                    SideMenuModel(name: "Cart".localized, id: "Cart", selected: false,sideImage: #imageLiteral(resourceName: "cart (1)-1")),
                    SideMenuModel(name: "Reservations".localized, id: "Reservations", selected: false, sideImage: #imageLiteral(resourceName: "reservation2")),
                    SideMenuModel(name: "Order List".localized, id: "OrderList", selected: false, sideImage: #imageLiteral(resourceName: "order-food-1")),
                    SideMenuModel(name: "Profile".localized, id: "Profile", selected: false,sideImage: #imageLiteral(resourceName: "ic_assignment_ind_24px")),
                    SideMenuModel(name: "Favorit Restaurants".localized, id: "Favorites", selected: false, sideImage: #imageLiteral(resourceName: "heart")),
                    SideMenuModel(name: "Favorite Meals".localized, id: "FavoriteMeals", selected: false, sideImage: #imageLiteral(resourceName: "heart-1")),
                    SideMenuModel(name: "ContactUs".localized, id: "ContactUs", selected: false,sideImage: #imageLiteral(resourceName: "contactUs")),
                    SideMenuModel(name: "TermsAndConditions".localized, id: "TermsAndConditions", selected: false, sideImage: #imageLiteral(resourceName: "terms")),
                    SideMenuModel(name: "Setting".localized, id: "Setting", selected: false, sideImage: #imageLiteral(resourceName: "burger"))
                    
                ]
            } else {
                self.sideMenuArr = [
                    SideMenuModel(name: "Home".localized,id: "home", selected: false,sideImage: #imageLiteral(resourceName: "home")),
                    SideMenuModel(name: "Sections".localized, id: "Sections", selected: false, sideImage: #imageLiteral(resourceName: "burger")),
                    SideMenuModel(name: "Cart".localized, id: "Cart", selected: false,sideImage: #imageLiteral(resourceName: "cart (1)")),
                    SideMenuModel(name: "Reservations".localized, id: "Reservations", selected: false, sideImage: #imageLiteral(resourceName: "reservation2")),
                    SideMenuModel(name: "Order List".localized, id: "OrderList", selected: false, sideImage: #imageLiteral(resourceName: "order-food-1")),
                    SideMenuModel(name: "Profile".localized, id: "Profile", selected: false,sideImage: #imageLiteral(resourceName: "ic_assignment_ind_24px")),
                    SideMenuModel(name: "Favorit Restaurants".localized, id: "Favorites", selected: false, sideImage: #imageLiteral(resourceName: "heart")),
                    SideMenuModel(name: "Favorite Meals".localized, id: "FavoriteMeals", selected: false, sideImage: #imageLiteral(resourceName: "heart-1")),
                    SideMenuModel(name: "ContactUs".localized, id: "ContactUs", selected: false,sideImage: #imageLiteral(resourceName: "contactUs")),
                    SideMenuModel(name: "TermsAndConditions".localized, id: "TermsAndConditions", selected: false, sideImage: #imageLiteral(resourceName: "terms"))
                    
                ]
            }
            
        } else {
            self.sideMenuArr = [
                SideMenuModel(name: "Home".localized, id: "home", selected: false, sideImage: #imageLiteral(resourceName: "home")),
                SideMenuModel(name: "Order List".localized, id: "OrderList", selected: false, sideImage: #imageLiteral(resourceName: "terms")),
                SideMenuModel(name: "AboutUs".localized, id: "ContactUs", selected: false,sideImage: #imageLiteral(resourceName: "cridateCard")),
                SideMenuModel(name: "TermsAndConditions".localized, id: "TermsAndConditions" , selected: false, sideImage: #imageLiteral(resourceName: "terms"))]
        }
        
    }
    
    
    @IBAction func editProfileBn(_ sender: UIButton) {
        guard let sb = UIStoryboard(name: "Profile", bundle: nil).instantiateViewController(withIdentifier: "CustomerProfileVC") as? CustomerProfileVC else {return}
        self.navigationController?.pushViewController(sb, animated: true)
        
    }
    @IBAction func LogOut(_ sender: UIButton) {
        //
        switch Singletone.instance.appUserType {
        case .Customer:
            Services.postUserSetToken(type: "ios", device_token: "") { (error: Error?, result: SuccessError_Model?) in
                if let resultM = result {
                    if resultM.successMessage != "" {
                        displayMessage(title: "", message: resultM.successMessage, status: .success, forController: self)
                        Helper.LogOutUser()
                        self.pushSideMenu(StoryboardName: "Home", ForController: "HomeVC")
                    }
                }
                
            }
        case .Driver:
            Services.postDriverSetToken(type: "ios", device_token: "") { (error: Error?, result: SuccessError_Model?) in
                if let resultM = result {
                    if resultM.successMessage != "" {
                        displayMessage(title: "", message: resultM.successMessage, status: .success, forController: self)
                        Helper.LogOutUser()
                        self.pushSideMenu(StoryboardName: "Home", ForController: "HomeVC")
                    }
                }
                
            }
        default:
            break
        }
        
        
    }
    
    @IBAction func login(_ sender: UIButton) {
        pushSideMenu(StoryboardName:"Authentications", ForController: "LoginVC")
        
    }
    
    func selectedCell(indexPath: IndexPath) {
        switch sideMenuArr[indexPath.row].sideMenuId {
        case "home":
            guard let window = UIApplication.shared.keyWindow else { return }
            let sb = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HomeTabBar")
            window.rootViewController = sb
            UIView.transition(with: window, duration: 0.5, options: .curveEaseInOut, animations: nil, completion: nil)
            //pushSideMenu(StoryboardName: "Home", ForController: "HomeTabBar")
        case "Sections":
            pushSideMenu(StoryboardName: "Orders", ForController: "SectionsPageVC")
        case "Cart":
            pushSideMenu(StoryboardName: "Cart", ForController: "CartVC")
        case "OrderList":
            pushSideMenu(StoryboardName: "Orders", ForController: "OrderListVC")
        case "Profile":
            pushSideMenu(StoryboardName: "Profile", ForController: "CustomerProfileVC")
        case "Reservations":
            pushSideMenu(StoryboardName: "Reservation", ForController: "ResevationListVC")
        case "Favorites":
            pushSideMenu(StoryboardName: "Orders", ForController: "FavoritesVC")
        case "FavoriteMeals":
            pushSideMenu(StoryboardName: "Orders", ForController: "FavoriteMealsVC")
        case "ContactUs":
            pushSideMenu(StoryboardName: "AboutApp", ForController: "ContactUsVC")
        case "TermsAndConditions":
            pushSideMenu(StoryboardName: "AboutApp", ForController: "TermsAndConditionsVC")
        case "Sitting":
            pushSideMenu(StoryboardName: "AboutApp", ForController: "SettingVC")
            
        default:
            break
        }
        
    }
    func pushSideMenu(StoryboardName name: String,ForController identifier: String) {
        let main = UIStoryboard(name: name, bundle: nil).instantiateViewController(withIdentifier: identifier)
        
        self.navigationController?.pushViewController(main, animated: true)
    }
}
extension SideMenuVC: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sideMenuArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SideMenuCell else {return UITableViewCell()}
        let sideImage = sideMenuArr[indexPath.row].sideMenuImage
        cell.config(name: sideMenuArr[indexPath.row].sideMenuName, selected: sideMenuArr[indexPath.row].sideMenuSelected, imagePath: sideImage)
        cell.selectedBackgroundView?.backgroundColor = .clear
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        for i in 0..<sideMenuArr.count {
            if i == indexPath.row {
                sideMenuArr[i].sideMenuSelected = true
            } else {
                sideMenuArr[i].sideMenuSelected = false
            }
        }
        SideMenuTableView.reloadData()
        selectedCell(indexPath: indexPath)
    }
    
    
}
extension SideMenuVC: SideMenuViewDelegate {
    func getDriverProfileResult(_ error: Error?, _ result: User?) {
        if let profile = result {
            self.name.text = profile.nameAr ?? ""
            if let image = profile.image {
                guard let url = URL(string: BASE_URL + "/" + image) else { return }
                self.profilePic.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "shanab loading"))
            }
        }
    }
    
    
    func getProfileResult(_ error: Error?, _ result: User?) {
        if user == "customer" {
            if let profile = result {
                self.name.text = profile.nameAr ?? ""
                if let image = profile.image {
                    guard let url = URL(string: BASE_URL + "/" + image) else { return }
                    self.profilePic.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "shanab loading"))
                }
            } else {
                if let profile = result {
                    self.name.text = profile.nameAr ?? ""
                    if let image = profile.image {
                        guard let url = URL(string: BASE_URL + "/" + image) else { return }
                        self.profilePic.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "logo-1"))
                    }
                }
            }
        }
        
    }
    
}


