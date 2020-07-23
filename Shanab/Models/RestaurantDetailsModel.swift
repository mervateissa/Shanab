//
//  RestaurantDetailsModel.swift
//  Shanab
//
//  Created by Macbook on 4/14/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import Foundation
struct RestaurantDetailsModelJSON: Codable {
    var status: Bool?
    var data: RestaurantDetailsDataClass?
}

// MARK: - DataClass
struct RestaurantDetailsDataClass: Codable {
    var restaurantDetail: RestaurantDetail?
}

// MARK: - RestaurantDetail
struct RestaurantDetail: Codable {
    var id, userID, hasDelivery: Int?
    var nameAr, nameEn: String?
    var rate, deliveryTime: Int?
    var longitude, latitude, address, status: String?
    var image: String?
    var openDate, closeDate, createdAt, updatedAt: String?
    var category: [AllCategory]?
    var favorite: [RestaurantsFavorite]?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case hasDelivery = "has_delivery"
        case nameAr = "name_ar"
        case nameEn = "name_en"
        case rate
        case deliveryTime = "delivery_time"
        case longitude, latitude, address, status, image
        case openDate = "open_date"
        case closeDate = "close_date"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case category, favorite
    }
}

// MARK: - Category
struct AllCategory: Codable {
    var id, restaurantID: Int?
    var nameAr, nameEn: String?
    var image: String?
    var createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case restaurantID = "restaurant_id"
        case nameAr = "name_ar"
        case nameEn = "name_en"
        case image
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - Favorite
struct RestaurantsFavorite: Codable {
    var id, itemID: Int?
    var itemType: String?
    var clientID: Int?
    var deviceToken, createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case itemID = "item_id"
        case itemType = "item_type"
        case clientID = "client_id"
        case deviceToken = "device_token"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
