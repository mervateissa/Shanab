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
    var orders: [orderList]?
}
// MARK: - Order
struct orderList: Codable {
    var id, clientID: Int?
    var driverID: Int?
    var addressID: Int?
    var currency: String?
    var total: Double?
    var status: String?
    var lat, long: String?
    var quantity, rate: Int?
    var message: String?
    var createdAt, updatedAt: String?
    var orderDetail: [OrderDetail]?
    var address: AddressClass?

    enum CodingKeys: String, CodingKey {
        case id
        case clientID = "client_id"
        case driverID = "driver_id"
        case addressID = "address_id"
        case currency, total, status, lat, long, quantity, rate, message
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case orderDetail = "order_detail"
        case address
    }
}

// MARK: - AddressClass
struct AddressClass: Codable {
    var createdAt: String?
    var clientID: Int?
    var city: Area?
    var building, floor, cityID: Int?
    var area: Area?
    var id, countryID: Int?
    var long: Double?
    var isDefault: Int?
    var lat: Double?
    var updatedAt: String?
    var country: Area?
    var apartment, areaID: Int?
    var address: String?

    enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case clientID = "client_id"
        case city, building, floor
        case cityID = "city_id"
        case area, id
        case countryID = "country_id"
        case long
        case isDefault = "is_default"
        case lat
        case updatedAt = "updated_at"
        case country, apartment
        case areaID = "area_id"
        case address
    }
}

// MARK: - Area
struct Area: Codable {
    var countryID: Int?
    var updatedAt: String?
    var nameEn: String?
    var createdAt: String?
    var nameAr: String?
    var id, cityID: Int?

    enum CodingKeys: String, CodingKey {
        case countryID = "country_id"
        case updatedAt = "updated_at"
        case nameEn = "name_en"
        case createdAt = "created_at"
        case nameAr = "name_ar"
        case id
        case cityID = "city_id"
    }
}


// MARK: - OrderDetail
struct OrderDetail: Codable {
   var id, orderID, mealID: Int?
    var status: String?
    var quantity: Int?
    var price: Double?
    var offerID: Int?
    var restaurantID: Int?
    var message: String?
    var createdAt, updatedAt: String?
    var option: [Option]?
    var meal: Meal?
    var restaurant: Restaurant?

    enum CodingKeys: String, CodingKey {
       case id
        case orderID = "order_id"
        case mealID = "meal_id"
        case status, quantity, price
        case offerID = "offer_id"
        case restaurantID = "restaurant_id"
        case message
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case option, meal, restaurant
    }
}

// MARK: - Meal
struct Meal: Codable {
    var id, restaurantID, categoryID, restaurantCategoryID: Int?
    var offerID: Int?
    var nameAr: String?
    var nameEn: String?
    var descriptionAr, descriptionEn: String?
    var points, rate: Int?
    var image: String?
    var status: String?
    var createdAt, updatedAt: String?
    var price: [Price]?
    var restaurant: Restaurant?
    var offer: Offer?
    var option: [Options]?

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
        case price, restaurant, offer, option
    }
}



// MARK: - OfferClass
struct OfferClass: Codable {
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


// MARK: - Price
struct Price: Codable {
    var id, currencyID, mealID: Int?
    var optionID: Int?
    var price: Double?
    var createdAt, updatedAt: String?
    var currency: CurrencyClass?

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






// MARK: - Option
struct Option: Codable {
    var id, orderDetailID, optionID: Int?
       var createdAt, updatedAt: String?
       var options: Options?

    enum CodingKeys: String, CodingKey {
        case id
        case orderDetailID = "order_detail_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case optionID = "option_id"
        case options
    }
}

// MARK: - Options
struct Options: Codable {
    var createdAt, updatedAt: String?
    var nameAr: String?
    var collectionID: Int?
    var price: [Price]?
    var id: Int?
    var nameEn: String?
    var selected: Bool?

    enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case nameAr = "name_ar"
        case collectionID = "collection_id"
        case price, id
        case nameEn = "name_en"
        case selected
    }
}


