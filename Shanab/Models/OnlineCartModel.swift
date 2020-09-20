//
//  OnlineCartModel.swift
//  Shanab
//
//  Created by Macbook on 04/08/2020.
//  Copyright © 2020 Dtag. All rights reserved.
//

import Foundation
struct OnlineCartModelJSON: Codable {
    var status: Bool?
    var data: OnlinetDataClass?
}

// MARK: - DataClass
struct OnlinetDataClass: Codable {
    var cart: [onlineCart]?
}

struct onlineCart: Codable {
    var id, mealID, clientID: Int?
    var message: String?
    var quantity: Int?
    var createdAt, updatedAt: String?
    var meal: Meal?
    var optionsContainer: [OptionsContainer]?

    enum CodingKeys: String, CodingKey {
        case id
        case mealID = "meal_id"
        case clientID = "client_id"
        case message, quantity
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case meal
        case optionsContainer = "options_container"
    }
}

// MARK: - Meal
//struct Meal: Codable {
//    var id, restaurantID, categoryID, restaurantCategoryID: Int?
//    var offerID: Int?
//    var nameAr, nameEn, descriptionAr, descriptionEn: String?
//    var points, rate: Int?
//    var image: String?
//    var status, createdAt, updatedAt: String?
//    var price: [Price]?
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case restaurantID = "restaurant_id"
//        case categoryID = "category_id"
//        case restaurantCategoryID = "restaurant_category_id"
//        case offerID = "offer_id"
//        case nameAr = "name_ar"
//        case nameEn = "name_en"
//        case descriptionAr = "description_ar"
//        case descriptionEn = "description_en"
//        case points, rate, image, status
//        case createdAt = "created_at"
//        case updatedAt = "updated_at"
//        case price
//    }
//}

// MARK: - Price
//struct Price: Codable {
//    var id, currencyID, mealID, optionID: Int?
//    var price: Double?
//    var createdAt, updatedAt: String?
//    var currency: Currency?
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case currencyID = "currency_id"
//        case mealID = "meal_id"
//        case optionID = "option_id"
//        case price
//        case createdAt = "created_at"
//        case updatedAt = "updated_at"
//        case currency
//    }
//}



// MARK: - OptionsContainer
struct OptionsContainer: Codable {
    var id, collectionOptionID, cartID: Int?
    var createdAt, updatedAt: String?
    var options: Options?

    enum CodingKeys: String, CodingKey {
        case id
        case collectionOptionID = "collection_option_id"
        case cartID = "cart_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case options
    }
}

// MARK: - Options
//struct Options: Codable {
//    var id: Int?
//    var nameAr, nameEn: String?
//    var collectionID: Int?
//    var createdAt, updatedAt: String?
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case nameAr = "name_ar"
//        case nameEn = "name_en"
//        case collectionID = "collection_id"
//        case createdAt = "created_at"
//        case updatedAt = "updated_at"
//    }
//}







// MARK: - Offer
struct Offer: Codable {
   var startDate: String?
    var discountType: String?
    var updatedAt: String?
    var nameAr: String?
    var createdAt: String?
    var endDate: String?
    var id, restaurantID, discount: Int?
    var nameEn: String?

    enum CodingKeys: String, CodingKey {
        case startDate = "start_date"
        case discountType = "discount_type"
        case updatedAt = "updated_at"
        case nameAr = "name_ar"
        case createdAt = "created_at"
        case endDate = "end_date"
        case id
        case restaurantID = "restaurant_id"
        case discount
        case nameEn = "name_en"
    }
}

// MARK: - CurrencyClass
struct CurrencyClass: Codable {
    var id: Int?
    var nameAr: String?
    var nameEn: String?

}




