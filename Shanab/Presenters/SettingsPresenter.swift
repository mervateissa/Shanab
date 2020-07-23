//
//  RestaurantMealsPresenter.swift
//  Shanab
//
//  Created by Macbook on 4/16/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import Foundation
import SVProgressHUD
protocol SettingsViewDelegate: class {

}
class SettingsPresenter {
    private let services: Services
    private weak var RestaurantMealsViewDelegate: SettingsViewDelegate?
    init(services: Services) {
        self.services = services
    }
    func setRestaurantMealsViewDelegate(RestaurantMealsViewDelegate: SettingsViewDelegate) {
        self.RestaurantMealsViewDelegate = RestaurantMealsViewDelegate
    }
    func showIndicator() {
        SVProgressHUD.show()
    }
    func dismissIndicator() {
        SVProgressHUD.dismiss()
    }
   
}
