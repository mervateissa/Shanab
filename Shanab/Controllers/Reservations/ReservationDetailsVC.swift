//
//  ReservationDetailsVC.swift
//  Shanab
//
//  Created by Macbook on 6/3/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit

class ReservationDetailsVC: UIViewController {
    @IBOutlet weak var dateLB: CustomLabel!
    @IBOutlet weak var timeLB: CustomLabel!
    @IBOutlet weak var numberLB: UILabel!
    @IBOutlet weak var depositLB: UILabel!
    @IBOutlet weak var canclingFeesLB: UILabel!
    @IBOutlet weak var sessionLB: CustomLabel!
    var id = Int()
    var ReservationDetails = [DetailsDataClass]()
    private let ReservationDetailsVCPresenter = ResevationDetailsPresenter(services: Services())
    override func viewDidLoad() {
        super.viewDidLoad()
        ReservationDetailsVCPresenter.setReservationDetailsViewDelegate(ReservationDetailsViewDelegate: self)
        ReservationDetailsVCPresenter.showIndicator()
        ReservationDetailsVCPresenter.postReservationDetailsResult(id: id)
        
        
    }
}
extension ReservationDetailsVC: ReservationDetailsViewDelegate {
    func ReservationDetailsResult(_ error: Error?, _ details: DetailsDataClass?) {
        if let lists = details {
            let ReservationDetails = details
            self.ReservationDetails = [lists]
            self.dateLB.text = ReservationDetails?.date ?? ""
            self.numberLB.text = details?.numberOfPersons
            self.timeLB.text = details?.time
            self.canclingFeesLB.text = "\(details?.cancelation)"
        }
    }
    
    
}
