//
//  UserListModel.swift
//  Shanab
//
//  Created by Macbook on 6/2/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import Foundation
struct UserListModelJSON: Codable {
    var status: Bool?
    var data: UserListDataClass?
}

// MARK: - DataClass
struct UserListDataClass: Codable {
    var orders: [OrderList]?
}

// MARK: - Order
struct OrderList: Codable {
    var id, clientID, driverID: Int?
    var currency: String?
    var total: Int?
    var status, lat, long: String?
    var quantity, rate: Int?
    var createdAt, updatedAt: String?
    var orderDetail: [OrderDetail]?

    enum CodingKeys: String, CodingKey {
        case id
        case clientID = "client_id"
        case driverID = "driver_id"
        case currency, total, status, lat, long, quantity, rate
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case orderDetail = "order_detail"
    }
}


// MARK: - OrderDetail
struct OrderDetail: Codable {
    var id, orderID, mealID: Int?
    var status: String?
    var quantity: Int?
    var createdAt, updatedAt: String?
    var option: [Option]?
    var meal: Meal?

    enum CodingKeys: String, CodingKey {
        case id
        case orderID = "order_id"
        case mealID = "meal_id"
        case status, quantity
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case option, meal
    }
}

// MARK: - Meal
struct Meal: Codable {
    var id, restaurantID, categoryID, restaurantCategoryID: Int?
    var offerID: Int?
    var nameAr, nameEn, descriptionAr, descriptionEn: String?
    var points, rate: Int?
    var image: String?
    var status, createdAt, updatedAt: String?
    var price: [Int]?
    var restaurant: Restaurant?

    enum CodingKeys: String, CodingKey {
        case id
        case restaurantID = "restaurant_id"
        case categoryID = "category_id"
        case restaurantCategoryID = "restaurant_category_id"
        case offerID = "offer_id"
        case nameAr = "name_ar"
        case nameEn = "name_en"
        case descriptionAr = "description_ar"
        case descriptionEn = "description_en"
        case points, rate, image, status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case price, restaurant
    }
}

// MARK: - Restaurant

// MARK: - Option
struct Option: Codable {
    var id, orderDetailID, optionID: Int?
    var createdAt, updatedAt: String?
    var options: Options?

    enum CodingKeys: String, CodingKey {
        case id
        case orderDetailID = "order_detail_id"
        case optionID = "option_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case options
    }
}


// MARK: - Options
struct Options: Codable {
    var id: Int?
    var nameAr: String?
    var nameEn: String?
    var collectionID: Int?
    var createdAt, updatedAt: String?
    var price: [Price]?

    enum CodingKeys: String, CodingKey {
        case id
        case nameAr = "name_ar"
        case nameEn = "name_en"
        case collectionID = "collection_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case price
    }
}



// MARK: - Price
struct Price: Codable {
    var id, currencyID, mealID, optionID: Int?
    var price: Double?
    var createdAt, updatedAt: String?
    var currency: Currency?

    enum CodingKeys: String, CodingKey {
        case id
        case currencyID = "currency_id"
        case mealID = "meal_id"
        case optionID = "option_id"
        case price
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case currency
    }
}




