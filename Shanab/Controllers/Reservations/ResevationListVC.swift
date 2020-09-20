//
//  ResevationListVC.swift
//  Shanab
//
//  Created by Macbook on 3/31/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit

class ResevationListVC: UIViewController {
    @IBOutlet weak var cancelReservation: UIButton!
    @IBOutlet weak var reservationListButton: UIButton!
    private let ReservationListVCPresenter = ReservationListPresenter(services: Services())
    @IBOutlet weak var reservationListTableView: UITableView!
    var list_type = 1
    var id = Int()
    var ResevationList = [reservationList]() {
        didSet {
            DispatchQueue.main.async {
                    self.reservationListTableView.reloadData()
                }
        }
    }
    fileprivate let cellIdentifier = "ReservationListCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reservationListTableView.delegate = self
        reservationListTableView.dataSource = self
        reservationListTableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        ReservationListVCPresenter.setReservationListViewDelegate(ReservationListViewDelegate: self)
        
    }
    
    @IBAction func ReservationListBN(_ sender: Any) {
        self.reservationListButton.backgroundColor = #colorLiteral(red: 0.9195484519, green: 0.2682709396, blue: 0.21753335, alpha: 1)
        self.cancelReservation.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.cancelReservation.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        ReservationListVCPresenter.showIndicator()
        ReservationListVCPresenter.postReservationget(cancelation: 0)
    }
    @IBAction func CanclingReservationBN(_ sender: Any) {
        self.reservationListButton.backgroundColor = #colorLiteral(red: 0.992049396, green: 0.9922187924, blue: 0.9920386672, alpha: 1)
        self.cancelReservation.backgroundColor = #colorLiteral(red: 0.9195484519, green: 0.2682709396, blue: 0.21753335, alpha: 1)
        self.reservationListButton.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        ReservationListVCPresenter.showIndicator()
        ReservationListVCPresenter.postReservationget(cancelation: 1)
    }
    @IBAction func cart(_ sender: Any) {
        guard let details = UIStoryboard(name: "Cart", bundle: nil).instantiateViewController(withIdentifier: "CartVC") as? CartVC else { return }
               self.navigationController?.pushViewController(details, animated: true)
    }
    
    @IBAction func menu(_ sender: Any) {
        self.setupSideMenu()
    }
}
extension ResevationListVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ResevationList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ReservationListCell else {return UITableViewCell()}
        if "lang".localized == "ar"  {
            if ResevationList[indexPath.row].cancelation == 1 {
                let restaurant = ResevationList[indexPath.row].restaurant ?? Restaurant()
                cell.config(orderName: restaurant.nameAr ?? "" , date: ResevationList[indexPath.row].date ?? "", status: "الملغية", imagePath: restaurant.image ?? "")
            } else {
                let restaurant = ResevationList[indexPath.row].restaurant ?? Restaurant()
                cell.config(orderName: restaurant.nameAr ?? "" , date: ResevationList[indexPath.row].date ?? "", status: "تم حجز طاولتك بنجاح", imagePath: restaurant.image ?? "")
            }
        } else {
            if ResevationList[indexPath.row].cancelation == 1{
                let restaurant = ResevationList[indexPath.row].restaurant ?? Restaurant()
                cell.config(orderName: restaurant.nameEn ?? "" , date: ResevationList[indexPath.row].date ?? "", status: "Cancel", imagePath: restaurant.image ?? "")
            } else {
                let restaurant = ResevationList[indexPath.row].restaurant ?? Restaurant()
                cell.config(orderName: restaurant.nameEn ?? "" , date: ResevationList[indexPath.row].date ?? "", status: "Successful Reservation", imagePath: restaurant.image ?? "")
            }
        }
        
        
        cell.Cancel = {
            
             guard let Details = UIStoryboard(name: "PopUps", bundle: nil).instantiateViewController(withIdentifier: "ReservationCancelltionVC") as? ReservationCancelltionVC else { return }
                Details.id = self.ResevationList[indexPath.row].id ?? 0
              self.navigationController?.pushViewController(Details, animated: true)
           
            
        }
        cell.goToDetails = {
            guard let Details = UIStoryboard(name: "Reservation", bundle: nil).instantiateViewController(withIdentifier: "ReservationDetailsVC") as? ReservationDetailsVC else { return }
            Details.id = self.ResevationList[indexPath.row].id ?? 0
            self.navigationController?.pushViewController(Details, animated: true)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        200
    }
    
    
}
extension ResevationListVC: ReservationListViewDelegate {
    func CancelReservationResult(_ error: Error?, _ reservation: SuccessError_Model?) {
        if let resultMsg = reservation {
            if resultMsg.successMessage != "" {
                displayMessage(title: "", message: resultMsg.successMessage, status: .success, forController: self)
            } else if resultMsg.id != [""] {
                displayMessage(title: "", message: resultMsg.id[0], status: .error, forController: self)
            }
        }
    }
    
    func ReservationListResult(_ error: Error?, _ list: [reservationList]?) {
        if let lists = list {
            self.ResevationList = lists.reversed()
        }
    }
    
    
}
