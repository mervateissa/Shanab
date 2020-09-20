//
//  OrderReceiptVC.swift
//  Shanab
//
//  Created by Macbook on 3/31/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit
import Cosmos
import MapKit
class OrderReceiptVC: UIViewController {
    private let DriverOrderDetailsVCPresenter = DriverOrderDetailsPresenter(services: Services())
    @IBOutlet weak var customerPic: UIImageView!
    @IBOutlet weak var MapKit: MKMapView!
    @IBOutlet weak var completedImageStatus: UIImageView!
    @IBOutlet weak var onwayStatusImage: UIImageView!
    @IBOutlet weak var arrivedStatusImage: UIImageView!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var newIStatusmage: UIImageView!
    @IBOutlet weak var viewGrdian: UIView!
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
    var totalOrderPrice: Double = 0.0
    var id = Int()
    var details = [OrderDetail]() {
        didSet {
            DispatchQueue.main.async {
                self.orderReceiptTableView.reloadData()
            }
        }
    }
    var orderPrices = [Order]()
    fileprivate let cellIdentifier = "OrderReceiptCell"
    override func viewDidLoad() {
        super.viewDidLoad()
        self.address.text = UserDefaults.standard.string(forKey: "Address") ?? ""
        self.viewGrdian.setGradientBackground(colorOne: UIColor.red, colorTwo: UIColor.darkText)
        viewGrdian.layer.cornerRadius = 25
        viewGrdian.clipsToBounds = true
        MapKit.layer.cornerRadius = 20
        MapKit.clipsToBounds = true
        orderReceiptTableView.delegate = self
        orderReceiptTableView.dataSource = self
        orderReceiptTableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        customerPic.setRounded()
        DriverOrderDetailsVCPresenter.setDriverOrderDetailsViewDelegate(DriverOrderDetailsViewDelegate: self)
        DriverOrderDetailsVCPresenter.showIndicator()
        DriverOrderDetailsVCPresenter.getDriverOrderDetails(id: id)
        DriverOrderDetailsVCPresenter.DriverChangeStatus(id: id)
        DriverOrderDetailsVCPresenter.getDriverProfile()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        self.address.text = UserDefaults.standard.string(forKey: "Address") ?? ""
    }
    @IBAction func locationMap(_ sender: Any) {
        guard let Details = UIStoryboard(name: "Location", bundle: nil).instantiateViewController(withIdentifier: "LocationVC") as? LocationVC else { return }
        Details.view_controller = "orderInfo"
        self.navigationController?.pushViewController(Details, animated: true)
    }
    @IBAction func menu(_ sender: Any) {
        self.setupSideMenu()
    }
    
    @IBAction func cart(_ sender: Any) {
        guard let details = UIStoryboard(name: "Cart", bundle: nil).instantiateViewController(withIdentifier: "CartVC") as? CartVC else { return }
        self.navigationController?.pushViewController(details, animated: true)
    }
    @IBAction func newStatusBN(_ sender: Any) {
        
    }
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func onWayStatus(_ sender: Any) {
        DriverOrderDetailsVCPresenter.DriverChangeStatus(id: id)
        self.OnWayBn.isEnabled = false
        self.parperStatusBn.isEnabled = false
        self.completedBn.isEnabled = true
        self.arrivedBn.isEnabled = true
        self.onwayStatusImage.image = #imageLiteral(resourceName: "icons8-sync")
    }
    @IBAction func arrivedBN(_ sender: Any) {
        DriverOrderDetailsVCPresenter.DriverChangeStatus(id: id)
        self.arrivedBn.isEnabled = false
        self.parperStatusBn.isEnabled = false
        self.completedBn.isEnabled = true
        self.OnWayBn.isEnabled = false
        self.arrivedStatusImage.image = #imageLiteral(resourceName: "icons8-sync")
        
    }
    @IBAction func completedBN(_ sender: Any) {
        DriverOrderDetailsVCPresenter.DriverChangeStatus(id: id)
        self.completedBn.isEnabled = false
        self.parperStatusBn.isEnabled = false
        self.completedBn.isEnabled = true
        self.arrivedBn.isEnabled = false
        self.completedImageStatus.image = #imageLiteral(resourceName: "icons8-sync")
        
        
    }
    
}
extension OrderReceiptVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return details.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? OrderReceiptCell else {return UITableViewCell()}
        let meal = details[indexPath.row].meal ?? Meal()
        let price = Double(details[indexPath.row].quantity ?? 0)
        if "lang".localized == "ar"{
            cell.config(name: meal.nameAr ?? "" , number: details[indexPath.row].quantity ?? 0 , price: Int(details[indexPath.row].price ?? 0.0), options: self.details[indexPath.row].option ?? [Option]() )
            cell.price.text = "\(price.rounded(toPlaces: 2))"
            totalOrderPrice += price
            
            if indexPath.row == details.count - 1 {
                total.text = "\(totalOrderPrice.rounded(toPlaces: 2))"
            }
            return cell
        } else {
            cell.config(name: meal.nameEn ?? "" , number: details[indexPath.row].quantity ?? 0 , price: Int(details[indexPath.row].price ?? 0), options: self.details[indexPath.row].option ?? [Option]() )
            return cell
        }
    }
}
extension OrderReceiptVC: DriverOrderDetailsViewDelegate {
    func getDriverProfileResult(_ error: Error?, _ result: User?) {
        if let profile = result {
            self.phone.text = profile.phone ?? ""
            if "lang".localized == "ar" {
                self.name.text = profile.nameAr ?? ""
            } else {
                self.name.text = profile.nameEn ?? ""
            }
            
            if let image = profile.image {
                guard let url = URL(string: image) else { return }
                self.customerPic.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "logo-1"))
            }
        }
    }
    
    
    func calculateTotalPrice() {
        var price: Double = 0.0
        self.orderPrices.forEach { (order) in
            price += order.price
            self.orderPrice.text = "\(price)"
            self.fees.text = "\(50)"
            self.total.text = "\(price + 50)"
        }
        print(price)
    }
    
    
    func DriverOrderDetailsResult(_ error: Error?, _ details: [DriverOrder]?) {
        if let detail = details {
            self.details = detail[0].orderDetail ?? [OrderDetail]()
            self.details = self.details.reversed()
            
            self.details.forEach {
                orderPrices.append(Order(price: $0.price ?? -1.0))
            }
            self.calculateTotalPrice()
            
        }
        
    }
    
    func DriverChangeStatusResult(_ error: Error?, _ result: SuccessError_Model?) {
        if let status = result {
            if status.successMessage != "" {
                displayMessage(title: "Done", message: status.successMessage, status: .success, forController: self)
                DriverOrderDetailsVCPresenter.showIndicator()
                DriverOrderDetailsVCPresenter.DriverChangeStatus(id: id)
                
            } else if status.id != [""] {
                displayMessage(title: "", message: status.id[0], status: .error, forController: self)
            }
        }
    }
    
    
}

class Order {
    var price: Double
    
    init(price: Double) {
        self.price = price
    }
}
