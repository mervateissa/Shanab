//
//  UserOrderDetailsVC.swift
//  Shanab
//
//  Created by Macbook on 7/1/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit

class UserOrderDetailsVC: UIViewController {
    private let UserOrderDetailsVCPresenter = UserOrderDetailsPresenter(services: Services())
    @IBOutlet weak var totalPriceLB: UILabel!
    @IBOutlet weak var fees: UILabel!
    @IBOutlet weak var orderPrice: UILabel!
    @IBOutlet weak var detailsTableView: UITableView!
    fileprivate let cellIdentifier = "OrderReceiptCell"
    var status = String()
    var id = Int()
    var details = [OrderDetail]() {
        didSet {
            DispatchQueue.main.async {
                self.detailsTableView.reloadData()
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        detailsTableView.delegate = self
        detailsTableView.dataSource = self
        detailsTableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier); UserOrderDetailsVCPresenter.setUserOrderDetailsViewDelegate(UserOrderDetailsViewDelegate: self)
        UserOrderDetailsVCPresenter.showIndicator()
        UserOrderDetailsVCPresenter.postUserOrderDetails(id: id, status: status)
        
        
    }
    
    
    @IBAction func Dismiss(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
extension UserOrderDetailsVC: UserOrderDetailsViewDelegate {
    func UserOrderDetailsResult(_ error: Error?, _ result: [DriverOrder]?) {
        if let detail = result {
            self.details = detail[0].orderDetail ?? [OrderDetail]()
            self.details = self.details.reversed()
        }
        
    }
    
    
}
extension UserOrderDetailsVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        details.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? OrderReceiptCell else {return UITableViewCell()}
        let meal = details[indexPath.row].meal ?? Meal()
        cell.config(name: meal.nameAr ?? "" , number: 0 , price: 0, options: self.details[indexPath.row].option ?? [Option]() )
        return cell
    }
    
}
