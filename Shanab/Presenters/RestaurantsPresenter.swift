//
//  RestaurantsPresenter.swift
//  Shanab
//
//  Created by Macbook on 4/13/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import Foundation
import SVProgressHUD
protocol RestaurantsViewDelegate: class {
    func getAllRestaurantsResult(_ error: Error?, _ restaurants: [Restaurant]?)
   
}
class RestaurantsPresenter {
    private let services: Services
    private weak var RestaurantsViewDelegate: RestaurantsViewDelegate?
    init(services: Services) {
        self.services = services
    }
    func setRestaurantsViewDelegate( RestaurantsViewDelegate: RestaurantsViewDelegate) {
        self.RestaurantsViewDelegate = RestaurantsViewDelegate
    }
    func showIndicator() {
           SVProgressHUD.show()
       }
       func dismissIndicator() {
           SVProgressHUD.dismiss()
       }
       func getCategoreyList() {
}
    func getAllRestaurants(type: [String]) {
        services.getAllRestaurants(type: type) {[weak self] (error: Error?, restaurants: [Restaurant]?) in
            self?.RestaurantsViewDelegate?.getAllRestaurantsResult(error, restaurants)
            self?.dismissIndicator()
        }
    }
   
}
