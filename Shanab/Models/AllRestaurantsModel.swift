//
//  AllRestaurantsModel.swift
//  Shanab
//
//  Created by Macbook on 4/13/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import Foundation
struct AllRestaurantsModelJSON: Codable {
    var status: Bool?
    var data: AllRestaurantsDataClass?
}

// MARK: - DataClass
struct AllRestaurantsDataClass: Codable {
    var restaurants: [Restaurant]?
}

// MARK: - Restaurant
struct Restaurant: Codable {
    var id: Int?
    var nameEn: String?
    var updatedAt: String?
    var hasDelivery: Int?
    var createdAt: String?
    var openDate: String?
    var userID: Int?
    var nameAr: String?
    var reservation: String?
    var deliveryTime: Int?
    var type: String?
    var status: String?
    var minimum: Int?
    var documents: String?
    var rate: Int?
    var latitude: String?
    var logo: String?
    var deliveryFee: Int?
    var address: String?
    var image: String?
    var closeDate: String?
    var isAvailable: Int?
    var longitude: String?
    var points: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case nameEn = "name_en"
        case updatedAt = "updated_at"
        case hasDelivery = "has_delivery"
        case createdAt = "created_at"
        case openDate = "open_date"
        case userID = "user_id"
        case nameAr = "name_ar"
        case reservation
        case deliveryTime = "delivery_time"
        case type, status, minimum, documents, rate, latitude, logo
        case deliveryFee = "delivery_fee"
        case address, image
        case closeDate = "close_date"
        case isAvailable = "is_available"
        case longitude, points
    }
}

