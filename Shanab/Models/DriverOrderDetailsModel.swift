//
//  DriverOrderDetailsModel.swift
//  Shanab
//
//  Created by Macbook on 6/28/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import Foundation
struct DriverOrderDetalilsModelJSON: Codable {
    var status: Bool?
    var data: DriverDetailsDataClass?
}

// MARK: - DataClass
struct DriverDetailsDataClass: Codable {
    var orders: [DriverOrder]?
}

// MARK: - Order
struct DriverOrder: Codable {
    var id, clientID, driverID: Int?
    var currency: String?
    var total: Int?
    var status, lat, long: String?
    var quantity, rate: Int?
    var createdAt, updatedAt: String?
    var client: Client?
    var orderDetail: [OrderDetail]?

    enum CodingKeys: String, CodingKey {
        case id
        case clientID = "client_id"
        case driverID = "driver_id"
        case currency, total, status, lat, long, quantity, rate
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case client
        case orderDetail = "order_detail"
    }
}

