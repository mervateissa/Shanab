//
//  RestaurantDetailsPresenter.swift
//  Shanab
//
//  Created by Macbook on 4/14/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import Foundation
import SVProgressHUD
protocol RestaurantDetailsViewDelegate: class {
    func RestaurantDetailsResult(_ error: Error?, _ details: RestaurantDetail?)
    func RestaurantMealsResult(_ error: Error?, _ meals: [RestaurantMeal]?)
    func FavoriteResult(_ error: Error?, _ result: SuccessError_Model?)
    func RemoveFavorite(_ error: Error?, _ result: SuccessError_Model?)
}
class RestaurantDetailPresenter {
    private let services: Services
    private weak var RestaurantDetailsViewDelegate: RestaurantDetailsViewDelegate?
    init(services: Services) {
        self.services = services
    }
    func setRestaurantDetailsViewDelegate(RestaurantDetailsViewDelegate: RestaurantDetailsViewDelegate) {
        self.RestaurantDetailsViewDelegate = RestaurantDetailsViewDelegate
    }
    func showIndicator() {
        SVProgressHUD.show()
    }
    func dismissIndicator() {
        SVProgressHUD.dismiss()
    }
    func getCategoreyList() {
    }
    func postRestaurantDetails(restaurant_id: Int) {
        services.postRestaurantDetails(restaurant_id: restaurant_id) {[weak self] (error: Error?,  details: RestaurantDetail?) in
            self?.RestaurantDetailsViewDelegate?.RestaurantDetailsResult(error, details)
            self?.dismissIndicator()
        }
    }
    func postRestaurantMeals(restaurant_id: Int, type: String, category_id: Int) {
        services.postRestaurantMeals(restaurant_id: restaurant_id, type: type, category_id: category_id) {[weak self] (_ error: Error?, _ meals: [RestaurantMeal]?) in
            self?.RestaurantDetailsViewDelegate?.RestaurantMealsResult(error, meals)
            self?.dismissIndicator()
        }
    }
    func postCreateFavorite(item_id: Int, item_type: String) {
        services.postCreateFavorite(item_id: item_id, item_type: item_type) { [weak self] (error: Error?, result: SuccessError_Model?) in
            self?.RestaurantDetailsViewDelegate?.FavoriteResult(error, result)
            self?.dismissIndicator()
        }
    }
    func postRemoveFavorite(item_id: Int, item_type: String) {
        services.postRemoveFavorite(item_id: item_id, item_type: item_type) { [weak self] (error: Error?, result: SuccessError_Model?) in
            self?.RestaurantDetailsViewDelegate?.RemoveFavorite(error, result)
            self?.dismissIndicator()
        }
    }
}
