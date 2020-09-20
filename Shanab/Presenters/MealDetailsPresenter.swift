//
//  MealDetailsPresenter.swift
//  Shanab
//
//  Created by Macbook on 7/2/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import Foundation
import Foundation
import SVProgressHUD
protocol MealsDetailsViewDelegate: class {
    func RestaurantMealsResult(_ error: Error?, _ meals: [RestaurantMeal]?)
     func RestaurantDetailsResult(_ error: Error?, _ details: RestaurantDetail?)
    func FavoriteResult(_ error: Error?, _ result: SuccessError_Model?)
    func RemoveFavorite(_ error: Error?, _ result: SuccessError_Model?)
}
    class MealsDetailPresenter {
    private let services: Services
    private weak var MealsDetailsViewDelegate: MealsDetailsViewDelegate?
    init(services: Services) {
        self.services = services
    }
    func setMealsDetailsViewDelegate(MealsDetailsViewDelegate: MealsDetailsViewDelegate) {
        self.MealsDetailsViewDelegate = MealsDetailsViewDelegate
    }
    func showIndicator() {
        SVProgressHUD.show()
    }
    func dismissIndicator() {
        SVProgressHUD.dismiss()
    }
    func getCategoreyList() {
    }
   
    func postRestaurantMeals(restaurant_id: Int, type: String, category_id: Int) {
        services.postRestaurantMeals(restaurant_id: restaurant_id, type: type, category_id: category_id) {[weak self] (_ error: Error?, _ meals: [RestaurantMeal]?) in
            self?.MealsDetailsViewDelegate?.RestaurantMealsResult(error, meals)
            self?.dismissIndicator()
        }
    }
    func postCreateFavorite(item_id: Int, item_type: String) {
        services.postCreateFavorite(item_id: item_id, item_type: item_type) { [weak self] (error: Error?, result: SuccessError_Model?) in
            self?.MealsDetailsViewDelegate?.FavoriteResult(error, result)
            self?.dismissIndicator()
        }
    }
    func postRemoveFavorite(item_id: Int, item_type: String) {
        services.postRemoveFavorite(item_id: item_id, item_type: item_type) { [weak self] (error: Error?, result: SuccessError_Model?) in
            self?.MealsDetailsViewDelegate?.RemoveFavorite(error, result)
            self?.dismissIndicator()
        }
    }
        func postRestaurantDetails(restaurant_id: Int) {
            services.postRestaurantDetails(restaurant_id: restaurant_id) {[weak self] (error: Error?,  details: RestaurantDetail?) in
                self?.MealsDetailsViewDelegate?.RestaurantDetailsResult(error, details)
                self?.dismissIndicator()
            }
        }
}
