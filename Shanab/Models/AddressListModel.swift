//
//  AddressListModel.swift
//  Shanab
//
//  Created by Macbook on 20/07/2020.
//  Copyright © 2020 Dtag. All rights reserved.
//

import Foundation
struct AddressesListModelJSON: Codable {
    var status: Bool?
    var data: AddressesDataClass?
}

// MARK: - DataClass
struct AddressesDataClass: Codable {
    var address: [Address]?
}

// MARK: - Address
struct Address: Codable {
    var id, clientID, lat, long: Int?
    var isDefault, building, floor, apartment: Int?
    var address: String?
    var countryID, cityID, areaID: Int?
    var createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case clientID = "client_id"
        case lat, long
        case isDefault = "is_default"
        case building, floor, apartment, address
        case countryID = "country_id"
        case cityID = "city_id"
        case areaID = "area_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
