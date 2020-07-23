//
//  ReservationListPresenter.swift
//  Shanab
//
//  Created by Macbook on 5/28/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import Foundation
import SVProgressHUD
protocol ReservationListViewDelegate: class {
    func ReservationListResult(_ error: Error?, _ list: [reservationList]?)
    func CancelReservationResult(_ error: Error?, _ reservation: SuccessError_Model?)
}
class ReservationListPresenter {
    private let services: Services
    private weak var ReservationListViewDelegate: ReservationListViewDelegate?
    init(services: Services) {
        self.services = services
    }
    func setReservationListViewDelegate(ReservationListViewDelegate: ReservationListViewDelegate) {
        self.ReservationListViewDelegate = ReservationListViewDelegate
    }
    func showIndicator() {
           SVProgressHUD.show()
       }
       func dismissIndicator() {
           SVProgressHUD.dismiss()
       }
    func postReservationget(cancelation: Int) {
        services.postReservationsget(cancelation: cancelation) { [weak self](error: Error?, list: [reservationList]?) in
            self?.ReservationListViewDelegate?.ReservationListResult(error, list)
            self?.dismissIndicator()
        }
    }
    func postCancelReservation(id: Int) {
        services.postCancelReservation(id: id) {[weak self] (error: Error?, reservation: SuccessError_Model?) in
            self?.ReservationListViewDelegate?.CancelReservationResult(error, reservation)
            self?.dismissIndicator()
        }
    }
}
