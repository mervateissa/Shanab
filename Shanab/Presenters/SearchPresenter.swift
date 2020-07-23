//
//  SearchPresenter.swift
//  Shanab
//
//  Created by Macbook on 6/29/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import Foundation
import SVProgressHUD
protocol SearchViewDelegate: class {
    func MealSearchResult(_ error: Error?, _ result: [Collection]?)
    func RestaurantSearchResult(_ error: Error?, _ restaurantResult: [SearchResult]?)
}
class SearchPresenter {
    private let services: Services
    private weak var SearchViewDelegate: SearchViewDelegate?
    init(services: Services) {
        self.services = services
    }
    func setSearchViewDelegate (SearchViewDelegate: SearchViewDelegate) {
        self.SearchViewDelegate = SearchViewDelegate
    }
    func showIndicator() {
        SVProgressHUD.show()
    }
    func dismissIndicator() {
        SVProgressHUD.dismiss()
    }
    func postMealSearch(word: String) {
        services.postMealSearch(word: word) {[weak self] (error: Error?, result: [Collection]?) in
            self?.SearchViewDelegate?.MealSearchResult(error, result)
            self?.dismissIndicator()
        }
    }
    func postRestaurantSearch(word: String) {
        services.postSearchRestauran(word: word) {[weak self] (error: Error?, result: [SearchResult]?) in
            self?.SearchViewDelegate?.RestaurantSearchResult(error, result)
            self?.dismissIndicator()
        }
    }
}
