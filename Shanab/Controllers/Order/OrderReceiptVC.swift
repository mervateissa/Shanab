//
//  OrderReceiptVC.swift
//  Shanab
//
//  Created by Macbook on 3/31/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit
import Cosmos
class OrderReceiptVC: UIViewController {
    private let DriverOrderDetailsVCPresenter = DriverOrderDetailsPresenter(services: Services())
    @IBOutlet weak var customerPic: UIImageView!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var OnWayStatusLB: UILabel!
    @IBOutlet weak var CompletedStatusLB: UILabel!
    @IBOutlet weak var ArrivedStatusLB: UILabel!
    @IBOutlet weak var OnWayBn: UIButton!
    @IBOutlet weak var arrivedBn: UIButton!
    @IBOutlet weak var completedBn: UIButton!
    @IBOutlet weak var mapImage: UIImageView!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var parperStatusBn: UIButton!
    @IBOutlet weak var PerparingStatusLB: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var orderReceiptTableView: UITableView!
    @IBOutlet weak var fees: UILabel!
    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var cosmos: CosmosView!
    @IBOutlet weak var orderPrice: UILabel!
    @IBOutlet weak var name: UILabel!
    var id = Int()
    var details = [OrderDetail]() {
        didSet {
            DispatchQueue.main.async {
                self.orderReceiptTableView.reloadData()
            }
        }
    }
    fileprivate let cellIdentifier = "OrderReceiptCell"
    override func viewDidLoad() {
        super.viewDidLoad()
        self.gradientView.setGradientBackground(colorOne: UIColor.red, colorTwo: UIColor.magenta)
        orderReceiptTableView.delegate = self
        orderReceiptTableView.dataSource = self
        orderReceiptTableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        customerPic.setRounded()
        DriverOrderDetailsVCPresenter.setDriverOrderDetailsViewDelegate(DriverOrderDetailsViewDelegate: self)
        DriverOrderDetailsVCPresenter.showIndicator()
                DriverOrderDetailsVCPresenter.getDriverOrderDetails(id: id)
        
        
    }
    
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
extension OrderReceiptVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return details.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? OrderReceiptCell else {return UITableViewCell()}
        let meal = details[indexPath.row].meal ?? Meal()
        cell.config(name: meal.nameAr ?? "" , number: 0 , price: 0, options: self.details[indexPath.row].option ?? [Option]() )
        return cell
    }
    
    
}
extension OrderReceiptVC: DriverOrderDetailsViewDelegate {
    func DriverOrderDetailsResult(_ error: Error?, _ details: [DriverOrder]?) {
        if let detail = details {
            self.details = detail[0].orderDetail ?? [OrderDetail]()
            self.details = self.details.reversed()
        }
        
    }
    
    func DriverChangeStatusResult(_ error: Error?, _ result: SuccessError_Model?) {
        if let status = result {
            if status.successMessage != "" {
                displayMessage(title: "", message: status.successMessage, status: .success, forController: self)
                DriverOrderDetailsVCPresenter.showIndicator()
                DriverOrderDetailsVCPresenter.DriverChangeStatus(id: id)
              
            } else if status.id != [""] {
                displayMessage(title: "", message: status.id[0], status: .error, forController: self)
            }
        }
    }
    
    
}

