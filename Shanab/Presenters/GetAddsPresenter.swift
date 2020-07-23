//
//  GetAddsPresenter.swift
//  Shanab
//
//  Created by Macbook on 4/13/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import Foundation
import SVProgressHUD
protocol GetAddsViewDelegate: class {
    func getAddsResult(_ error: Error?, _ result: [Add]?)
    func CatgeoriesResult( _ error: Error?, _ catgeory: [Category]?)
    func getAllRestaurantsResult(_ error: Error?, _ restaurants: [Restaurant]?)
}
class GetAddsPresenter {
    private let services: Services
    private weak var GetAddsViewDelegate: GetAddsViewDelegate?
    init(services: Services) {
        self.services = services
    }
    func setGetAddsViewDelegate(GetAddsViewDelegate: GetAddsViewDelegate) {
        self.GetAddsViewDelegate = GetAddsViewDelegate
    }
    func showIndicator() {
        SVProgressHUD.show()
    }
    func dismissIndicator() {
        SVProgressHUD.dismiss()
    }
    func getCategoreyList() {
    }
    func getAdds(){
        services.getAdds { [weak self](error: Error?,
            result: [Add]?) in
            self?.GetAddsViewDelegate?.getAddsResult(error, result)
            self?.dismissIndicator()
        }
    }
    func getCatgeories() {
        services.getAllCatgeories { [weak self] (_ error: Error?, _ catgeory: [Category]?) in
            self?.GetAddsViewDelegate?.CatgeoriesResult(error, catgeory)
            self?.dismissIndicator()
        }
        
    }
    func getAllRestaurants(type: [String]) {
        services.getAllRestaurants(type: type) {[weak self] (error: Error?, restaurants: [Restaurant]?) in
            self?.GetAddsViewDelegate?.getAllRestaurantsResult(error, restaurants)
            self?.dismissIndicator()
        }
    }
}
