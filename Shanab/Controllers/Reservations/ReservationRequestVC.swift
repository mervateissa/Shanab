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
    //    @IBOutlet weak var clock: Clocket!
    @IBOutlet weak var outing: UIButton!
    @IBOutlet weak var AmOutlet: UIButton!
    @IBOutlet weak var pmOutlet: UIButton!
    @IBOutlet weak var inDoor: UIButton!
    @IBOutlet weak var sessionLB: UILabel!
    @IBOutlet weak var dateTF: UITextField!
    @IBOutlet weak var timeTF: UITextField!
    @IBOutlet weak var numberCollectionView: UICollectionView!
    @IBOutlet weak var ListOfNumbers: UIButton!
    var resturant_id = Int()
    private var DatePicker: UIDatePicker?
    private var timePicker: UIDatePicker?
    let NmberListDropDown = DropDown()
    fileprivate let cellIdentifier = "ReservationCell"
    var list_type = Int()
    var selectedCount = String()
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
        CreateResevationVCPresenter.setCreateReservationViewDelegate(CreateReservationViewDelegate: self)
        let loc = Locale(identifier: "en")
        var timePicker = UIDatePicker()
        timePicker.locale = loc
        timePicker.datePickerMode = .time
        timeTF.inputView = timePicker
        timePicker.addTarget(self, action: #selector(timeChanged(TimePicker:)), for: .valueChanged)
        numberArr = [
            ReservationModel(number: 1, id: "1", selected: false),
            ReservationModel(number: 2, id: "2", selected: false),
            ReservationModel(number: 3, id: "3", selected: false),
            ReservationModel(number: 4, id: "4", selected: false),
            ReservationModel(number: 5, id: "5", selected: false)
           
        ]
        SetupNmberListDropDown()
        numberCollectionView.delegate = self
        numberCollectionView.dataSource = self
        numberCollectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        
    }
    func SetupNmberListDropDown() {
        NmberListDropDown.anchorView = ListOfNumbers
        NmberListDropDown.bottomOffset = CGPoint(x: 0, y: NmberListDropDown.anchorView?.plainView.bounds.height ?? 0 + 50)
        NmberListDropDown.dataSource = NumbersArr
        NmberListDropDown.selectionAction = {
            [weak self] (index, item) in
            self?.ListOfNumbers.setTitleColor(#colorLiteral(red: 0.9195484519, green: 0.2682709396, blue: 0.21753335, alpha: 1), for: .normal)
            self?.ListOfNumbers.setTitle(item, for: .normal)
            self?.selectedCount = item
            
        }
        NmberListDropDown.direction = .any
        NmberListDropDown.width = self.view.frame.width * 0.25
    }
    @objc func timeChanged(TimePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:MM:SS"
        timeTF.text = dateFormatter.string(from: TimePicker.date)
        self.DatePicker?.datePickerMode = .time
        //        view.endEditing(true)
    }
    @IBAction func inDoor(_ sender: UIButton) {
        inDoor.backgroundColor = #colorLiteral(red: 0.9195484519, green: 0.2682709396, blue: 0.21753335, alpha: 1)
        outing.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.inDoor.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        self.inDoor.setTitleColor(#colorLiteral(red: 0.9195484519, green: 0.2682709396, blue: 0.21753335, alpha: 1), for: .selected)
    }
    
    @IBAction func session(_ sender: UIButton) {
        outing.backgroundColor = #colorLiteral(red: 0.9195484519, green: 0.2682709396, blue: 0.21753335, alpha: 1)
        inDoor.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.outing.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        self.outing.setTitleColor(#colorLiteral(red: 0.9195484519, green: 0.2682709396, blue: 0.21753335, alpha: 1), for: .selected)
        
    }
    
    @IBAction func AmButtonPressed(_ sender: UIButton) {
        AmOutlet.backgroundColor = #colorLiteral(red: 0.9195484519, green: 0.2682709396, blue: 0.21753335, alpha: 1)
        pmOutlet.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.AmOutlet.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        self.AmOutlet.setTitleColor(#colorLiteral(red: 0.9195484519, green: 0.2682709396, blue: 0.21753335, alpha: 1), for: .selected)
    }
    
    @IBAction func pmButtonPressed(_ sender: UIButton) {
        pmOutlet.backgroundColor = #colorLiteral(red: 0.9195484519, green: 0.2682709396, blue: 0.21753335, alpha: 1)
        AmOutlet.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.pmOutlet.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        self.pmOutlet.setTitleColor(#colorLiteral(red: 0.9195484519, green: 0.2682709396, blue: 0.21753335, alpha: 1), for: .selected)
        
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
    
    @IBAction func cart(_ sender: Any) {
        guard let details = UIStoryboard(name: "Cart", bundle: nil).instantiateViewController(withIdentifier: "CartVC") as? CartVC else { return }
               self.navigationController?.pushViewController(details, animated: true)
    }
    
    @IBAction func menu(_ sender: Any) {
        self.setupSideMenu()
    }
    @IBAction func cancelReservation(_ sender: UIButton) {
        guard let sb = UIStoryboard(name: "PopUps", bundle: nil).instantiateViewController(withIdentifier: "ReservationCancelltionVC") as? ReservationCancelltionVC else {return}
        self.navigationController?.pushViewController(sb, animated: true)
    }
    @IBAction func confirm(_ sender: Any) {
        if (Singletone.instance.appUserType) != .Customer {
                   if "lang".localized == "ar" {
                       displayMessage(title: "", message: "لا يمكنك عمل طلب إلا في حالة التسجيل كمستخدم", status: .error, forController: self)
                   } else {
                       displayMessage(title: "", message: "You can't Confirm order except you are a user", status: .error, forController: self)
                   }
               } else {
                   let longitude = Constants.long
                   let latitude = Constants.lat
                   if Helper.getApiToken() == nil {
                       let sb = UIStoryboard(name: "PopUps", bundle: nil).instantiateViewController(withIdentifier: "LoginPopupVC")
                       sb.modalPresentationStyle = .overCurrentContext
                       sb.modalTransitionStyle = .crossDissolve
                       self.present(sb, animated: true, completion: nil)
                   } else {
                        CreateResevationVCPresenter.showIndicator()
                              CreateResevationVCPresenter.postCreateReservation(restaurant_id: resturant_id, number_of_persons: Int(selectedCount) ?? 0, date: dateTF.text ?? "", time: timeTF.text ?? "")
                    }
            }
    }
    @IBAction func orderDate(_ sender: UIButton) {
        guard let Details = UIStoryboard(name: "Sections", bundle: nil).instantiateViewController(withIdentifier: "OrderDateVC") as? OrderDateVC else { return }
        Details.selectedDate = { selectedDate in
            self.dateTF.text = selectedDate
        }
        self.navigationController?.pushViewController(Details, animated: true)
    }
}
extension ReservationRequestVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? ReservationCell else {return UICollectionViewCell()}
        cell.config(selectionNumber: numberArr[indexPath.row].reservationNumber, selected: numberArr[indexPath.row].NumberSelected)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        func SelectionAction(indexPath: IndexPath) {
            for i in 0..<numberArr.count{
                if i == indexPath.row {
                    self.numberArr[i].NumberSelected = true
                } else {
                    self.numberArr[i].NumberSelected = false
                }
            }
            self.numberCollectionView.reloadData()
        }
        
        SelectionAction(indexPath: indexPath)
        selectedCount = numberArr[indexPath.row].numberId
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(numberArr.count)
    }
//    
//        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//            return CGSize(width: 20, height: 20)
//        }
}
extension ReservationRequestVC: CreateReservationViewDelegate {
    func CreateReservationResult(_ error: Error?, _ result: SuccessError_Model?) {
        if let resultMsg = result {
            if resultMsg.successMessage != "" {
                displayMessage(title: "done", message: resultMsg.successMessage , status: .success, forController: self)
                print(resultMsg.successMessage)
                guard let sb = UIStoryboard(name: "PopUps", bundle: nil).instantiateViewController(withIdentifier: "ConfirmationPopup") as? ConfirmationPopup else {return}
                       sb.modalPresentationStyle = .overCurrentContext
                       sb.modalTransitionStyle = .crossDissolve
                       self.present(sb, animated: true, completion: nil)
                
            } else if !resultMsg.restaurant_id.isEmpty, resultMsg.restaurant_id  != [""] {
                displayMessage(title: "", message: resultMsg.restaurant_id[0], status: .error, forController: self)
            } else if !resultMsg.number_of_persons.isEmpty, resultMsg.number_of_persons != [""] {
                displayMessage(title: "", message: resultMsg.number_of_persons[0], status: .error, forController: self)
            } else if !resultMsg.date.isEmpty, resultMsg.date != [""] {
                displayMessage(title: "", message: resultMsg.date[0], status: .error, forController: self)
            } else if !resultMsg.time.isEmpty, resultMsg.time != [""] {
                displayMessage(title: "", message: resultMsg.time[0], status: .error, forController: self)
            }
            
        }
    }
    
}

