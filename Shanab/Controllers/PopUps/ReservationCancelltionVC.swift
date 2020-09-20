//
//  ReservationCancelltionVC.swift
//  Shanab
//
//  Created by Macbook on 7/12/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit

class ReservationCancelltionVC: UIViewController {
   private let CancelReservationVCPresenter = CancelReservationPresenter(services: Services())
    var list = [reservationList]()
    var id = Int()
    override func viewDidLoad() {
        super.viewDidLoad()
        CancelReservationVCPresenter.setCancelReservationViewDelegate(CancelReservationViewDelegate: self)
       
    }
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func confirm(_ sender: Any) {
        CancelReservationVCPresenter.showIndicator()
        CancelReservationVCPresenter.postCancelReservation(id: id )
    }
    
}
extension  ReservationCancelltionVC: CancelReservationViewDelegate {
    func CancelReservationResult(_ error: Error?, _ reservation: SuccessError_Model?) {
         if let resultMsg = reservation {
                   if resultMsg.successMessage != "" {
                       displayMessage(title: "Done", message: resultMsg.successMessage, status: .success, forController: self)
                   } else if resultMsg.id != [""] {
                       displayMessage(title: "", message: resultMsg.id[0], status: .error, forController: self)
                   }
               }
    }
    
    
}
