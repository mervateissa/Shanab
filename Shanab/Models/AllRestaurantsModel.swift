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
    var id, userID, hasDelivery: Int?
    var nameAr: String?
    var nameEn: String?
    var rate: Int?
    var longitude, latitude, address: String?
    var status: String?
    var image: String?
    var openDate, closeDate: String?
    var createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case hasDelivery = "has_delivery"
        case nameAr = "name_ar"
        case nameEn = "name_en"
        case rate, longitude, latitude, address, status, image
        case openDate = "open_date"
        case closeDate = "close_date"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

