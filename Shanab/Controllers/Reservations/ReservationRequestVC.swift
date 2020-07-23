//
//  ReservationRequestVC.swift
//  Shanab
//
//  Created by Macbook on 3/29/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit
import DropDown
import Clocket
class ReservationRequestVC: UIViewController {
    @IBOutlet weak var clock: Clocket!
    @IBOutlet weak var outing: UIButton!
    @IBOutlet weak var inDoor: UIButton!
    @IBOutlet weak var dateTF: UITextField!
    @IBOutlet weak var timeTF: UITextField!
    @IBOutlet weak var numberCollectionView: UICollectionView!
    @IBOutlet weak var ListOfNumbers: UIButton!
    var resturant_id = Int()
    let NmberListDropDown = DropDown()
    fileprivate let cellIdentifier = "ReservationCell"
    var list_type = Int()
    let NumbersArr = ["6", "7", "8", "10", "11", "12", "13", "14", "15"]
    private let CreateResevationVCPresenter = CreateReservationPresenter(services: Services())
    var numberArr = [ReservationModel]() {
        didSet {
            DispatchQueue.main.async {
                self.numberCollectionView.reloadData()
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        SetupNmberListDropDown()
        clock.displayRealTime = true
        clock.startClock()
        numberCollectionView.delegate = self
        numberCollectionView.dataSource = self
        numberCollectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        CreateResevationVCPresenter.setCreateReservationViewDelegate(CreateReservationViewDelegate: self)
        CreateResevationVCPresenter.showIndicator()
        
    }
    func SetupNmberListDropDown() {
        NmberListDropDown.anchorView = ListOfNumbers
        NmberListDropDown.bottomOffset = CGPoint(x: 0, y: NmberListDropDown.anchorView?.plainView.bounds.height ?? 0 + 50)
        NmberListDropDown.dataSource = NumbersArr
        NmberListDropDown.selectionAction = {
            [weak self] (index, item) in
            self?.ListOfNumbers.setTitleColor(#colorLiteral(red: 0.9195484519, green: 0.2682709396, blue: 0.21753335, alpha: 1), for: .normal)
            self?.ListOfNumbers.setTitle(item, for: .normal)
            
        }
        NmberListDropDown.direction = .any
        NmberListDropDown.width = self.view.frame.width * 0.25
    }
    @IBAction func inDoor(_ sender: UIButton) {
        inDoor.backgroundColor = #colorLiteral(red: 0.8121929765, green: 0.2939046025, blue: 0.2674312294, alpha: 1)
        self.inDoor.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
    }
    
    @IBAction func session(_ sender: UIButton) {
        outing.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.outing.setTitleColor(#colorLiteral(red: 0.8121929765, green: 0.2939046025, blue: 0.2674312294, alpha: 1), for: .normal)
        
        
    }
    @IBAction func NumberListBN(_ sender: UIButton) {
        NmberListDropDown.show()
    }
    @IBAction func paymentGatewayBn(_ sender: UIButton) {
        guard let sb = UIStoryboard(name: "PaymentGetWay", bundle: nil).instantiateViewController(withIdentifier: "PaymentGatewayVC") as? NumberListPopUp else {return}
        sb.modalPresentationStyle = .overCurrentContext
        sb.modalTransitionStyle = .crossDissolve
        self.present(sb, animated: true, completion: nil)
    }
    
    
    @IBAction func orderDate(_ sender: UIButton) {
        guard let Details = UIStoryboard(name: "Sections", bundle: nil).instantiateViewController(withIdentifier: "OrderDateVC") as? OrderDateVC else { return }
        self.navigationController?.pushViewController(Details, animated: true)
        
    }
    
    func SelectionAction(indexPath: IndexPath) {
        for i in 0..<numberArr.count {
            if i == indexPath.row {
                self.numberArr[i].NumberSelected = true
            } else {
                self.numberArr[i].NumberSelected = false
            }
        }
    }
    
}
extension ReservationRequestVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? ReservationCell else {return UICollectionViewCell()}
        cell.config(selectionNumber: numberArr[indexPath.row].reservationNumber, selected: numberArr[indexPath.row].NumberSelected)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
extension ReservationRequestVC: CreateReservationViewDelegate {
    func CreateReservationResult(_ error: Error?, _ result: SuccessError_Model?) {
        if let resultMsg = result {
            if resultMsg.successMessage != "" {
                displayMessage(title: "", message: resultMsg.successMessage , status: .success, forController: self)
            } else if resultMsg.restaurant_id  != [""] {
                displayMessage(title: "", message: resultMsg.restaurant_id[0], status: .error, forController: self)
            } else if resultMsg.number_of_persons != [""] {
                displayMessage(title: "", message: resultMsg.number_of_persons[0], status: .error, forController: self)
            } else if resultMsg.date != [""] {
                displayMessage(title: "", message: resultMsg.date[0], status: .error, forController: self)
            } else if resultMsg.time != [""] {
                displayMessage(title: "", message: resultMsg.time[0], status: .error, forController: self)
            }
            
        }
    }
}

