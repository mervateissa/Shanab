//
//  FavoritMealsPresernter.swift
//  Shanab
//
//  Created by Macbook on 7/1/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import Foundation
import SVProgressHUD
protocol FavoriteMealsViewDelegate: class {
    func UserFavoriteMealssResult(_ error: Error?, _ favoriteList: [Favorites]?)
    }
    class UserFavoritesMealsPresenter {
        private let services: Services
        private weak var FavoriteMealsViewDelegate: FavoriteMealsViewDelegate?
        init(services: Services) {
            self.services = services
        }
        func setFavoriteMealsViewDelegate(FavoriteMealsViewDelegate: FavoriteMealsViewDelegate) {
            self.FavoriteMealsViewDelegate = FavoriteMealsViewDelegate
        }
        func showIndicator() {
            SVProgressHUD.show()
        }
        func dismissIndicator() {
            SVProgressHUD.dismiss()
        }
        func postFavoriteGet(item_type: String) {
            services.PostfavorieGet(item_type: item_type) {[weak self] (_ error: Error?, _ favoriteList: [Favorites]?) in
                self?.FavoriteMealsViewDelegate?.UserFavoriteMealssResult(error, favoriteList)
                self?.dismissIndicator()
            }
        }
    }
