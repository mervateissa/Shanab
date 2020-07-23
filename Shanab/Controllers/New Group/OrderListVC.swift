//
//  OrderList.swift
//  Shanab
//
//  Created by Macbook on 3/23/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit
import DropDown
class OrderListVC: UIViewController {
    private let UserListVCPresenter = UserListPresenter(services: Services())
    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var orderType: UIButton!
    @IBOutlet weak var emptyView: UIView!
    let orderTypsDropDown = DropDown()
    fileprivate let cellIdentifier = "ListCell"
    var type = "Parpare"
    let TypesArr = ["Parpare", "OnWay", "Arrived", "completed"]
    var list = [OrderList](){
        didSet {
            DispatchQueue.main.async {
                self.listTableView.reloadData()
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        listTableView.delegate = self
        listTableView.dataSource = self
        listTableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        UserListVCPresenter.setUserListViewDelegate(UserListViewDelegate: self)
        listTableView.rowHeight = UITableView.automaticDimension
               listTableView.estimatedRowHeight = UITableView.automaticDimension
        UserListVCPresenter.showIndicator()
        UserListVCPresenter.postUserGetList(status: ["Parpare"])
        SetuporderTypesDropDown()
        
    }
    func SetuporderTypesDropDown() {
        orderTypsDropDown.anchorView = orderType
        orderTypsDropDown.bottomOffset = CGPoint(x: 0, y: orderTypsDropDown.anchorView?.plainView.bounds.height ?? 0 + 50)
        orderTypsDropDown.dataSource = TypesArr
        orderTypsDropDown.selectionAction = {
            [weak self] (index, item) in
            self?.orderType.setTitleColor(#colorLiteral(red: 0.8121929765, green: 0.2939046025, blue: 0.2674312294, alpha: 1), for: .normal)
            self?.orderType.setTitle("\(item.capitalized) Orders", for: .normal)
            self?.type = self?.TypesArr[index] ?? ""
            
            self?.UserListVCPresenter.showIndicator()
            self?.UserListVCPresenter.postUserGetList(status: [self?.type ?? ""])
            
        }
        
        
        orderTypsDropDown.direction = .any
        orderTypsDropDown.width = self.view.frame.width * 1
    }
    
    
    @IBAction func orderType(_ sender: UIButton) {
        orderTypsDropDown.show()
        
    }
    @IBAction func sideMenu(_ sender: UIBarButtonItem) {
        self.setupSideMenu()
    }
    
}
extension OrderListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ListCell else { return UITableViewCell()}
        cell.config(date: list[indexPath.row].createdAt ?? "", status: list[indexPath.row].status ?? "")
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let Details = UIStoryboard(name: "Details", bundle: nil).instantiateViewController(withIdentifier: "UserOrderDetailsVC") as? UserOrderDetailsVC else { return }
         Details.id = list[indexPath.row].id ?? 0
        Details.status = list[indexPath.row].status ?? ""
        self.navigationController?.pushViewController(Details, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        200
    }
    
    
    
}
extension OrderListVC: UserListViewDelegate {
    func UserListResult(_ error: Error?, _ list: [OrderList]?) {
        if let lists = list {
            self.list = lists.reversed()
            if self.list.count == 0 {
                self.emptyView.isHidden = false
                self.listTableView.isHidden = true
            } else {
                self.emptyView.isHidden = true
                self.listTableView.isHidden = false
            }
        }
        
    }
}
